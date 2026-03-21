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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpcie_sc_dprio_seq #(
   parameter use_config_bypass_hwtcl = 0,
   parameter cseb_autonomous_hwtcl   = 0, //1: use CSEB during Autonomous mode
   parameter default_speed = 2'b11
)
(
   input   wire            pld_clk,
   input   wire            pld_reset_n,

   input   wire            reconfig_clk,
   input   wire            reconfig_reset_n,

   output  wire            hip_reconfig_clk/*synthesis noprune*/,
   output  wire            hip_reconfig_reset_n/*synthesis noprune*/,
   output  wire            hip_reconfig_write/*synthesis noprune*/,
   output  wire     [15:0] hip_reconfig_writedata/*synthesis noprune*/,
   output  wire    [1:0]   hip_reconfig_byteen/*synthesis noprune*/,
   output  wire     [9:0]  hip_reconfig_address/*synthesis noprune*/,
   output  wire            hip_reconfig_read/*synthesis noprune*/,
   input   wire    [15:0]  hip_reconfig_readdata/*synthesis noprune*/,

   // Target link speed
   input   wire            link_l0_i,
   input   wire [3 : 0]    tl_cfg_add_i,
   input   wire [31 : 0]   tl_cfg_ctl_i,
   input   wire [12:0]     cfglink2csrpld_i,
   input   wire            start_switch_i,
   output  wire [1:0]      app_target_link_speed_o,
   output  wire            app_dprio_done_o, //1 = Indicate DPRIO process is done
   output  wire            app_cseb_bit5_val_o,
   // Debug switch changes
   input   wire            test_mode_i

);


   //DPRIO INIT
   localparam IDLE = 3'h0;
   localparam SER  = 3'h1;
   localparam SEL  = 3'h2;
   localparam DELAY= 3'h3;
   localparam DONE = 3'h4;

   // DPRIO Control Address
   localparam DPRIO_CTRL_REG_2_TLS           = 10'h2;
   localparam DPRIO_CTRL_REG_111_CSEB        = 10'd111;
   localparam DPRIO_CTRL_REG_181_EN_SPD_CHG  = 10'd181;

   // DPRIO State Programming Sequence
   localparam DPRIO_IDLE         = 7'h1;
   localparam DISABLE_CSEB       = 7'h2;
   localparam EN_SPEED_CHG       = 7'h4;
   localparam WAIT_START_SWITCH  = 7'h8;
   localparam DBG_CSEB_SWITCH    = 7'h10;
   localparam DBG_SWITCH_DONE    = 7'h20;
   localparam DPRIO_DONE         = 7'h40;

   // Speed grade
   localparam GEN1_SPEED      = 2'h1;
   localparam GEN2_SPEED      = 2'h2;
   localparam GEN3_SPEED      = 2'h3;

   localparam MAX_DELAY       = 5'd16;
   //==============================
   // DPRIO progpramming sequence
   //==============================
   reg  [6:0]      seq_state;
   wire            disable_cseb_st;
   wire            dbg_cseb_switch_st;
   wire            dbg_switch_done_st;
   wire            en_speed_chg_st;

   //==============================
   // Other internal signals
   //==============================
   reg             app_dprio_start;
   wire [9:0]      app_dprio_address;
   wire [15:0]     app_dprio_wdata;
   wire            hip_dprio_done;
   wire            hip_dprio_rdvalid;
   reg             dprio_done_reconfig_clk;
   reg  [15:0]     app_dprio_rdata;
   wire [15:0]     cseb_wdata;
   //wire [15:0]     tls_wdata;
   wire [15:0]     en_speed_chg_wdata;

   // TLS
   reg [1:0]       target_link_speed;
   wire [1:0]      target_link_speed_sync;
   //reg [1:0]       program_tls;
   wire            link_l0;
   reg             link_l0_reg;
   wire            start_tls_p;
   wire            start_switch_p;

   wire            cseb_switch_en;
   wire [15:0]     dbg_cseb_wdata;
   reg             cseb_bit5_val;
   wire            dbg_corerdy_en_p;

   assign          cseb_switch_en = (use_config_bypass_hwtcl == 1)  & (cseb_autonomous_hwtcl == 1);

   //###############################################################
   //    DPRIO sequence:
   // 1. Set k_en_dir_speed_chg at bit 15 of out_hip_ctrl_182
   //    at addr = 181.
   // 2. Set k_cseb at bit[5] of out_hip_ctrl_112 at addr = 111
   //###############################################################

   always@( posedge reconfig_clk or negedge reconfig_reset_n) begin
      if( ~reconfig_reset_n ) begin
         seq_state         <= DPRIO_IDLE;
         app_dprio_start   <= 1'b0;
         dprio_done_reconfig_clk <= 1'b0;
      end else begin
         app_dprio_start         <= 1'b0;
         dprio_done_reconfig_clk <= 1'b0;

         case( seq_state )
            DPRIO_IDLE: begin
               app_dprio_start <= 1'b1;
               seq_state       <= EN_SPEED_CHG;
            end

            EN_SPEED_CHG: begin
               if (hip_dprio_done) begin
                  dprio_done_reconfig_clk <= 1'b1;
                  if (cseb_switch_en) begin
                     seq_state     <= WAIT_START_SWITCH;
                  end else begin
                     seq_state     <= DISABLE_CSEB;
                  end
               end
            end

            WAIT_START_SWITCH: begin
               if (start_switch_p) begin
                  app_dprio_start <= 1'b1;
                  seq_state       <= DISABLE_CSEB;
               end
            end

            DISABLE_CSEB: begin
               if (hip_dprio_done) begin
                  dprio_done_reconfig_clk <= 1'b1;
                  seq_state       <= test_mode_i ? DBG_CSEB_SWITCH : DPRIO_DONE;
               end
            end

            DBG_CSEB_SWITCH: begin
               if (start_switch_p) begin
                  app_dprio_start <= 1'b1;
                  seq_state      <= DBG_SWITCH_DONE;
               end
            end

            DBG_SWITCH_DONE: begin
               if (hip_dprio_done) begin
                  dprio_done_reconfig_clk <= 1'b1;
                  seq_state       <= test_mode_i ? DBG_CSEB_SWITCH : DPRIO_DONE;
               end
            end

            DPRIO_DONE: begin
               seq_state <= seq_state;
            end

            default: seq_state <= DPRIO_IDLE;
         endcase
      end
   end

   assign disable_cseb_st         = seq_state[1]; //DISABLE_CSEB
   assign en_speed_chg_st         = seq_state[2]; //EN_SPEED_CHG
   assign dbg_cseb_switch_st      = seq_state[4]; //DBG_CSEB_SWITCH
   assign dbg_switch_done_st      = seq_state[5]; //DBG_SWITCH_DONE

   assign tls_speed_st            = 1'b0; //TLS_SPEED => Not use for A10

   //###############################################################
   // Read Modified Write DPRIO controller
   //###############################################################
   altpcie_sc_dprio_rd_wr altpcie_sc_dprio_rd_wr (
      .reconfig_clk                   ( reconfig_clk                  ),
      .reconfig_reset_n            ( reconfig_reset_n           ),
      .app_dprio_start             ( app_dprio_start               ),
      .app_dprio_address           ( app_dprio_address     ),
      .app_dprio_wdata             ( app_dprio_wdata               ),
      .hip_reconfig_clk            ( hip_reconfig_clk           ),
      .hip_reconfig_reset_n     ( hip_reconfig_reset_n  ),
      .hip_reconfig_write               ( hip_reconfig_write            ),
      .hip_reconfig_writedata   ( hip_reconfig_writedata),
      .hip_reconfig_byteen              ( hip_reconfig_byteen   ),
      .hip_reconfig_address     ( hip_reconfig_address  ),
      .hip_reconfig_read                ( hip_reconfig_read             ),
      .hip_dprio_done              ( hip_dprio_done                ),
      .hip_dprio_rdvalid      ( hip_dprio_rdvalid     )
   );


   always@( posedge reconfig_clk) begin
      if (hip_dprio_rdvalid)
         app_dprio_rdata <= hip_reconfig_readdata;
   end
   //###############################################
   // Derive app_dprio_wdata and app_dprio_address
   //###############################################
   assign   app_dprio_address =  (disable_cseb_st | dbg_switch_done_st) ? DPRIO_CTRL_REG_111_CSEB :
                                 en_speed_chg_st ? DPRIO_CTRL_REG_181_EN_SPD_CHG : 10'h0;

   assign   app_dprio_wdata   = (disable_cseb_st | dbg_switch_done_st) ? cseb_wdata :
                                en_speed_chg_st ? en_speed_chg_wdata : 16'h0;

   //============================================================
   // Set k_cseb at bit [5] of DPRIO_CTRL_REG_111_CSEB
 //assign   cseb_wdata       = {app_dprio_rdata[15:6], 1'b1, app_dprio_rdata[4:0]};

   assign   cseb_wdata         = {app_dprio_rdata[15:11],
                                  1'b1,            //[10] k_temp_busy_crs
                                  app_dprio_rdata[9],
                                  1'b1,            //[8] Disable BAR check
                                  1'b1,            //[7] Disable tag Check
                                  1'b1,            //[6] CFBP Enable
                                  cseb_bit5_val,   //[5] Mode => 0=CSEB , 1=AVST
                                  app_dprio_rdata[4],
                                  1'b1,            //[3] Completion status with CRS
                                  app_dprio_rdata[2:0]};

   // Set k_en_speed_chg at bit 15 of DPRIO_CTRL_REG_181_EN_SPD_CHG
   assign   en_speed_chg_wdata = {1'b1, app_dprio_rdata[14:0]};

   // Modify k_gbl[45] and k_gbl[34] for expected target_link_speed
//   assign   tls_wdata = (program_tls == GEN1_SPEED) ? {app_dprio_rdata[15:14], 1'b0, app_dprio_rdata[12:3], 1'b0, app_dprio_rdata[1:0]} :
//                        (program_tls == GEN2_SPEED) ? {app_dprio_rdata[15:14], 1'b0, app_dprio_rdata[12:3], 1'b1, app_dprio_rdata[1:0]} :
//                        (program_tls == GEN3_SPEED) ? {app_dprio_rdata[15:14], 1'b1, app_dprio_rdata[12:3], 1'b0, app_dprio_rdata[1:0]} :
//                                                      {app_dprio_rdata[15:14], 1'b0, app_dprio_rdata[12:3], 1'b0, app_dprio_rdata[1:0]};

   //##################################################################
   // Output synchronizer from reconfig_clk to pld_clk domain
   //##################################################################
   altpcie_sc_lvlsync2
      #(
         .EN_PULSE_MODE (1'b1),
         .DWIDTH        (1),
         .ACTIVE_LEVEL  (1)  // 1: Active high; 0: Active low
      )
      hd_sync_pulse_app_dprio_done
      (
         .wr_clk      (reconfig_clk),
         .wr_rst_n    (reconfig_reset_n),
         .rd_clk      (pld_clk),
         .rd_rst_n    (pld_reset_n),
         .data_in     (dprio_done_reconfig_clk),
         .data_out    (app_dprio_done_o)
      );


   altpcie_sc_lvlsync2
      #(
         .EN_PULSE_MODE (1'b1),
         .DWIDTH        (1),
         .ACTIVE_LEVEL  (1)  // 1: Active high; 0: Active low
      )
      hd_sync_pulse_start_switch
      (
         .wr_clk      (pld_clk),
         .wr_rst_n    (pld_reset_n),
         .rd_clk      (reconfig_clk),
         .rd_rst_n    (reconfig_reset_n),
         .data_in     (start_switch_i),
         .data_out    (start_switch_p)
      );

   //###############################################
   // Target Link Speed
   //###############################################
   always @(posedge pld_clk or negedge pld_reset_n) begin
      if (~pld_reset_n)
         target_link_speed <= 2'b00;
      else if ( use_config_bypass_hwtcl )
         target_link_speed <=  cfglink2csrpld_i[1:0];
      else if ((tl_cfg_add_i == 4'h2))
         target_link_speed <=  tl_cfg_ctl_i[1:0];
   end

   assign app_target_link_speed_o  = target_link_speed;

   // Link in L0
   altpcie_sc_hip_vecsync2 #(
      .DWIDTH         ( 1 )                      // Sync Data input
   ) vecsync_l0 (
   // Inputs
      .wr_clk         ( pld_clk ),               // write clock
      .rd_clk         ( reconfig_clk ),          // read clock
      .wr_rst_n       ( pld_reset_n ),           // async write reset
      .rd_rst_n       ( reconfig_reset_n ),      // async read reset
      .data_in        ( link_l0_i),           // data in
      // Outputs
      .data_out       ( link_l0)                 // data out
   );

   always@( posedge reconfig_clk or negedge reconfig_reset_n ) begin
      if( ~reconfig_reset_n ) link_l0_reg <= 1'b0;
      else                    link_l0_reg <= link_l0;
   end


   //Toggle cseb_bit5_val for every request
   always@( posedge reconfig_clk or negedge reconfig_reset_n ) begin
      if( ~reconfig_reset_n )
         cseb_bit5_val <= 1'b1;
      else   if (start_switch_p & ((dbg_cseb_switch_st & test_mode_i)))
         cseb_bit5_val <= ~cseb_bit5_val;
   end
   assign app_cseb_bit5_val_o = cseb_bit5_val;


endmodule

