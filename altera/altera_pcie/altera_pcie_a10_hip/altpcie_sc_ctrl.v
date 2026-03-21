// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//============================
// Speed change control
//============================
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpcie_sc_ctrl #(
   parameter cseb_autonomous_hwtcl   = 1'b0,
   parameter use_config_bypass_hwtcl = 1'b0,
   parameter default_speed = 2'b11
) (
input   wire            clk,
input   wire            reset_n,
input   wire    [4:0]   ltssm,
input   wire            app_dprio_done_i,

input   wire            test_mode_i,
input   wire            test_sim_i,
input   wire            start_speed_chg_i,
input   wire            sc_retry_enable_i,
input   wire            dprio_mux_sel_i,
input   wire            app_speed_chg_en_i,
input   wire            app_cseb_switch_i,
input   wire    [1:0]   app_target_link_speed_i,
input   wire    [1:0]   current_speed_i,
input   wire            dbg_switch_en_i,
input   wire            app_cseb_bit5_val_i,
output  wire            test_in_9_o,
output  reg             hold_ltssm_rec_o,
output  wire            link_l0_o,
output  reg             start_switch_o
);

// State parameter
localparam IDLE               = 10'h1;
localparam WAIT_L0            = 10'h2;
localparam SET_TEST_IN        = 10'h4;
localparam DELAY_COUNT        = 10'h8;
localparam CLEAR_TEST_IN      = 10'h10;
localparam WAIT_4_RECLOCK     = 10'h20;
localparam WAIT_4_RECCFG      = 10'h40;
localparam WAIT_IN_RECLOCK    = 10'h80;
localparam WAIT_IN_RECCFG     = 10'h100;
localparam CSEB2AVST          = 10'h200;

localparam TEST_IN_MAX_DELAY  = 8'd32;
localparam REC_MAX_DELAY      = 8'd2;
localparam GEN1_SPEED         = 2'h1;
localparam MAX_RECLOCK_VAL    = 20'd100;
localparam MAX_CSEB_TIMEOUT   = 20'hfffff;

// State signals
wire      set_test_in_st;
wire      delay_count_st;
wire      clear_test_in_st;
wire      clear_hold_ltssm_rec;
wire      wait_4_reclock_st;
wire      wait_in_reclock_st, wait_4_tls_done_st, wait_in_reccfg_st;
wire      cseb2avst_st;

wire      clear_timer_cnt;
reg       test_in_9;
reg       app_cseb_bit5_val_r0, app_cseb_bit5_val;


//======================
// Local parameters
reg [9:0]       speed_chg_st;
reg [4:0]       ltssm_reg;
wire            link_in_rec;
wire            link_rec_cfg;
wire            link_l0;

reg [7:0]       dly_count;
wire            max_dly_count;
wire            speed_chg_req;
reg             app_speed_chg_en_r0, app_speed_chg_en_r1;
reg             app_cseb_switch_r,  app_cseb_switch_r1, app_cseb_switch_r2;
wire            cseb_switch_req;
reg [19:0]      timer_cnt;
wire [19:0]     cseb2avst_timeout;
wire            max_reclock_count;
wire            max_cseb2avst_cnt;
wire            cseb_switch_en;
reg             switch_done;     //1: Switching from CSEB to AVST is done
reg             sc_success;      //1: Attempt speed-change is successful
wire            uptrained_sc_en; // 1: Perform uptrained speed-change if current_speed is less than the TLS value
reg [1:0]       current_speed_r;
wire            start_dbg_switch_p;
reg             req_switch;


//=====================================================
assign          cseb_switch_en   = (use_config_bypass_hwtcl == 1)  & (cseb_autonomous_hwtcl == 1);
assign          uptrained_sc_en  = app_target_link_speed_i > current_speed_r;

//=====================================================
// State to control speed change sequence
// 1. Wait for DPRIO DONE programming and LTSSM = L0
// 2. Set test_in[9] = 1 and hold_ltssm_rec_o = 1
// 3. wait for 32 cycles
// 4. Clear test_in[9]
// 5. wait for LTSSM to enter Recovery
// 6. Clear hold_ltssm_rec_o
//=====================================================

always@( posedge clk) begin
   if( ~reset_n ) begin
      start_switch_o       <= 1'b0;
      sc_success           <= 1'b0;
      speed_chg_st         <= IDLE;
   end
   else begin

      start_switch_o       <= 1'b0;

      case( speed_chg_st )
         IDLE : begin
            if( (default_speed != GEN1_SPEED) & app_dprio_done_i) begin
               speed_chg_st <= WAIT_L0;
            end
         end

         WAIT_L0: begin
            // Auto retry if in config-bypass autonomous mode or speed-change is not successful. Only valid when in L0 and for uptraining only
            if (((cseb_switch_en & !switch_done) || (!sc_success & sc_retry_enable_i)) & link_l0 & uptrained_sc_en) begin
               speed_chg_st <= SET_TEST_IN;
            end else if (link_l0 & uptrained_sc_en) begin
               speed_chg_st <= SET_TEST_IN;
            end
         end

         SET_TEST_IN: begin
            speed_chg_st <= DELAY_COUNT;
         end

         DELAY_COUNT: begin
            if (max_dly_count)
               speed_chg_st <= CLEAR_TEST_IN;
         end

         CLEAR_TEST_IN: begin
            speed_chg_st <= WAIT_4_RECLOCK;
         end

         WAIT_4_RECLOCK: begin
            if (link_in_rec )
               speed_chg_st <= WAIT_IN_RECLOCK;
            else if (max_reclock_count) begin
               speed_chg_st <= WAIT_L0;
            end
         end

         WAIT_IN_RECLOCK: begin
            if (max_dly_count) begin
               speed_chg_st <= WAIT_4_RECCFG;
            end
         end

         WAIT_4_RECCFG: begin
            if (link_rec_cfg ) begin
               if (!switch_done | (req_switch & test_mode_i)) begin
                  start_switch_o <= 1'b1;
               end
               speed_chg_st   <= WAIT_IN_RECCFG;
            end
         end

         WAIT_IN_RECCFG: begin
            sc_success            <= 1'b1;
            if ((!switch_done | (req_switch & test_mode_i))  & app_dprio_done_i ) begin
               if (!app_cseb_bit5_val) begin  // If not in AVST yet, switch it
                  speed_chg_st    <= CSEB2AVST;
               end else begin
                  speed_chg_st    <= WAIT_L0;
               end
            end else if ((req_switch & test_mode_i) & !app_dprio_done_i) begin
               speed_chg_st    <= WAIT_IN_RECCFG;
            end else if (switch_done) begin
               speed_chg_st    <= WAIT_L0;
            end
         end

         CSEB2AVST: begin
            if (max_cseb2avst_cnt) begin
               start_switch_o  <= 1'b1;
               speed_chg_st    <= WAIT_IN_RECCFG;
            end
         end
      endcase
   end
end

// State outputs
assign set_test_in_st      = speed_chg_st[2];  //SET_TEST_IN
assign delay_count_st      = speed_chg_st[3];  //DELAY_COUNT
assign clear_test_in_st    = speed_chg_st[4];  //CLEAR_TEST_IN
assign wait_4_reclock_st   = speed_chg_st[5];  //WAIT_4_RECLOCK
assign wait_4_reccfg_st    = speed_chg_st[6];  //WAIT_4_RECCFG
assign wait_in_reclock_st  = speed_chg_st[7];  //WAIT_IN_RECLOCK
assign wait_in_reccfg_st   = speed_chg_st[8]; //WAIT_IN_RECCFG
assign cseb2avst_st        = speed_chg_st[9]; //CSEB2AVST

assign clear_hold_ltssm_rec=  wait_in_reclock_st & max_dly_count;
//=============================
// Data path
//======//======================================

// Register input
always@( posedge clk ) begin
   ltssm_reg       <= ltssm;
   current_speed_r <= current_speed_i;
end

assign link_l0        = (ltssm_reg == 5'hF);
assign link_in_rec    = (ltssm_reg == 5'hC);
assign link_rec_cfg   = (ltssm_reg == 5'hD);
assign link_l0_o      = link_l0;


//======================================
// Delay count
always@( posedge clk ) begin
   if( ~reset_n ) begin
      dly_count = 8'h0;
   end else if (max_dly_count) begin
      dly_count = 8'h0;
   end else if (delay_count_st | wait_in_reclock_st) begin
      dly_count = dly_count + 8'h1;
   end
end

assign max_dly_count = delay_count_st? (dly_count == TEST_IN_MAX_DELAY) : (dly_count == REC_MAX_DELAY);

//======================================
// Outputs

always@( posedge clk) begin
   if( ~reset_n )
      test_in_9   <= 1'b0;
   else if (set_test_in_st)
      test_in_9   <= 1'b1;
   else if (clear_test_in_st)
      test_in_9   <= 1'b0;
end

assign test_in_9_o = test_in_9;

always@( posedge clk ) begin
   if( ~reset_n )
      hold_ltssm_rec_o   <= 1'b0;
   else if (link_in_rec & wait_4_reclock_st)
      hold_ltssm_rec_o   <= 1'b1;
   else if (clear_hold_ltssm_rec)
      hold_ltssm_rec_o   <= 1'b0;
end



// Synchronize app_speed_chg_en_i to clk domain
always@( posedge clk ) begin
   if( ~reset_n ) begin
      app_speed_chg_en_r0     <= 1'b0;
      app_speed_chg_en_r1     <= 1'b0;

      app_cseb_bit5_val_r0    <= 1'b1;
      app_cseb_bit5_val       <= 1'b1;

   end else begin
      app_speed_chg_en_r0     <= app_speed_chg_en_i;
      app_speed_chg_en_r1     <= app_speed_chg_en_r0;

      app_cseb_bit5_val_r0    <= app_cseb_bit5_val_i;
      app_cseb_bit5_val       <= app_cseb_bit5_val_r0;
   end
end

assign speed_chg_req    = dprio_mux_sel_i ? start_speed_chg_i : app_speed_chg_en_r1;

//======================================
// Watch dog timer count
always@( posedge clk ) begin
   if( ~reset_n ) begin
      timer_cnt = 20'h0;
   end else if (clear_timer_cnt) begin
      timer_cnt = 20'h0;
   end else if (wait_4_reclock_st | cseb2avst_st) begin
      timer_cnt = timer_cnt + 20'h1;
   end
end

assign clear_timer_cnt     =  (wait_4_reclock_st  & (max_reclock_count | link_in_rec)) |
                              (cseb2avst_st & max_cseb2avst_cnt);

assign max_reclock_count = (timer_cnt == MAX_RECLOCK_VAL);
assign cseb2avst_timeout  = test_sim_i ? 20'h400 : MAX_CSEB_TIMEOUT;
assign max_cseb2avst_cnt = (timer_cnt == cseb2avst_timeout);

//======================================
// Testing switching logic
// Synchronize app_speed_chg_en_i to clk domain
always@( posedge clk ) begin
   if( ~reset_n ) begin
      app_cseb_switch_r    <= 1'b0;
      app_cseb_switch_r1   <= 1'b0;
      app_cseb_switch_r2   <= 1'b0;
   end else begin
      app_cseb_switch_r    <= cseb_switch_req;
      app_cseb_switch_r1   <= app_cseb_switch_r;
      app_cseb_switch_r2   <= app_cseb_switch_r1;
   end
end

assign cseb_switch_req  = dprio_mux_sel_i ? dbg_switch_en_i   : app_cseb_switch_i;

//Detect the raising edge of input after synchronization
assign start_dbg_switch_p = app_cseb_switch_r1 & !app_cseb_switch_r2;

always@( posedge clk ) begin
   if( ~reset_n )
      req_switch <= 1'b0;
   else if ((start_dbg_switch_p | (cseb2avst_st & max_cseb2avst_cnt)) & test_mode_i)
      req_switch <= 1'b1;
   else if (wait_in_reccfg_st & app_dprio_done_i)
      req_switch <= 1'b0;
end

//======================================
// Switch_done
always@( posedge clk ) begin
   if( ~reset_n )
      switch_done    <= 1'b0;
   else if (wait_in_reccfg_st & app_dprio_done_i & !switch_done)
      switch_done    <= 1'b1;
end

endmodule

