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


///////////////////////////////////////////////////////////////////////////////
// Top-level wrapper of Example RLD3 AFI Traffic Generator
//
// To conform to the rest of EMIF, the interfaces of a memory controller must:
//    Expose one AFI interface
//    Accept one afi_reset_n interface
//    Accept one afi_clk interface
//    Accept one afi_half_clk interface
//    Expose one tg_status interface
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_tg_afi_rld3_top # (
   parameter PROTOCOL_ENUM                           = "",
   parameter USER_CLK_RATIO                          = 1,
   parameter MRS_WRITE_PROTOCOL                      = 1,
   parameter MEM_BL                                  = 1,
   parameter MEM_DATA_MASK_EN                        = 1,
   parameter DENY_RECAL_REQUEST                      = 0,

   // Definition of port widths for "afi" interface
   //AUTOGEN_BEGIN: Definition of afi port widths
   parameter PORT_AFI_RLAT_WIDTH                     = 1,
   parameter PORT_AFI_WLAT_WIDTH                     = 1,
   parameter PORT_AFI_SEQ_BUSY_WIDTH                 = 1,
   parameter PORT_AFI_ADDR_WIDTH                     = 1,
   parameter PORT_AFI_BA_WIDTH                       = 1,
   parameter PORT_AFI_BG_WIDTH                       = 1,
   parameter PORT_AFI_C_WIDTH                        = 1,
   parameter PORT_AFI_CKE_WIDTH                      = 1,
   parameter PORT_AFI_CS_N_WIDTH                     = 1,
   parameter PORT_AFI_RM_WIDTH                       = 1,
   parameter PORT_AFI_ODT_WIDTH                      = 1,
   parameter PORT_AFI_RAS_N_WIDTH                    = 1,
   parameter PORT_AFI_CAS_N_WIDTH                    = 1,
   parameter PORT_AFI_WE_N_WIDTH                     = 1,
   parameter PORT_AFI_RST_N_WIDTH                    = 1,
   parameter PORT_AFI_ACT_N_WIDTH                    = 1,
   parameter PORT_AFI_PAR_WIDTH                      = 1,
   parameter PORT_AFI_CA_WIDTH                       = 1,
   parameter PORT_AFI_REF_N_WIDTH                    = 1,
   parameter PORT_AFI_WPS_N_WIDTH                    = 1,
   parameter PORT_AFI_RPS_N_WIDTH                    = 1,
   parameter PORT_AFI_DOFF_N_WIDTH                   = 1,
   parameter PORT_AFI_LD_N_WIDTH                     = 1,
   parameter PORT_AFI_RW_N_WIDTH                     = 1,
   parameter PORT_AFI_LBK0_N_WIDTH                   = 1,
   parameter PORT_AFI_LBK1_N_WIDTH                   = 1,
   parameter PORT_AFI_CFG_N_WIDTH                    = 1,
   parameter PORT_AFI_AP_WIDTH                       = 1,
   parameter PORT_AFI_AINV_WIDTH                     = 1,
   parameter PORT_AFI_DM_WIDTH                       = 1,
   parameter PORT_AFI_DM_N_WIDTH                     = 1,
   parameter PORT_AFI_BWS_N_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_DBI_N_WIDTH              = 1,
   parameter PORT_AFI_WDATA_DBI_N_WIDTH              = 1,
   parameter PORT_AFI_RDATA_DINV_WIDTH               = 1,
   parameter PORT_AFI_WDATA_DINV_WIDTH               = 1,
   parameter PORT_AFI_DQS_BURST_WIDTH                = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH              = 1,
   parameter PORT_AFI_WDATA_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH            = 1,
   parameter PORT_AFI_RDATA_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH              = 1,
   parameter PORT_AFI_RRANK_WIDTH                    = 1,
   parameter PORT_AFI_WRANK_WIDTH                    = 1,
   parameter PORT_AFI_ALERT_N_WIDTH                  = 1,
   parameter PORT_AFI_PE_N_WIDTH                     = 1

   // Definition of AFI setting parameters

) (
   // AFI reset
   input  logic                                               afi_reset_n,

   // AFI clock
   input  logic                                               afi_clk,

   // A clock that runs at half the frequency of afi_clk
   input  logic                                               afi_half_clk,

   // Ports for "afi" interface
   //AUTOGEN_BEGIN: Definition of afi ports
   input  logic                                               afi_cal_success,
   input  logic                                               afi_cal_fail,
   output logic                                               afi_cal_req,
   input  logic [PORT_AFI_RLAT_WIDTH-1:0]                     afi_rlat,
   input  logic [PORT_AFI_WLAT_WIDTH-1:0]                     afi_wlat,
   input  logic [PORT_AFI_SEQ_BUSY_WIDTH-1:0]                 afi_seq_busy,
   output logic                                               afi_ctl_refresh_done,
   output logic                                               afi_ctl_long_idle,
   output logic                                               afi_mps_req,
   input  logic                                               afi_mps_ack,
   output logic [PORT_AFI_ADDR_WIDTH-1:0]                     afi_addr,
   output logic [PORT_AFI_BA_WIDTH-1:0]                       afi_ba,
   output logic [PORT_AFI_BG_WIDTH-1:0]                       afi_bg,
   output logic [PORT_AFI_C_WIDTH-1:0]                        afi_c,
   output logic [PORT_AFI_CKE_WIDTH-1:0]                      afi_cke,
   output logic [PORT_AFI_CS_N_WIDTH-1:0]                     afi_cs_n,
   output logic [PORT_AFI_RM_WIDTH-1:0]                       afi_rm,
   output logic [PORT_AFI_ODT_WIDTH-1:0]                      afi_odt,
   output logic [PORT_AFI_RAS_N_WIDTH-1:0]                    afi_ras_n,
   output logic [PORT_AFI_CAS_N_WIDTH-1:0]                    afi_cas_n,
   output logic [PORT_AFI_WE_N_WIDTH-1:0]                     afi_we_n,
   output logic [PORT_AFI_RST_N_WIDTH-1:0]                    afi_rst_n,
   output logic [PORT_AFI_ACT_N_WIDTH-1:0]                    afi_act_n,
   output logic [PORT_AFI_PAR_WIDTH-1:0]                      afi_par,
   output logic [PORT_AFI_CA_WIDTH-1:0]                       afi_ca,
   output logic [PORT_AFI_REF_N_WIDTH-1:0]                    afi_ref_n,
   output logic [PORT_AFI_WPS_N_WIDTH-1:0]                    afi_wps_n,
   output logic [PORT_AFI_RPS_N_WIDTH-1:0]                    afi_rps_n,
   output logic [PORT_AFI_DOFF_N_WIDTH-1:0]                   afi_doff_n,
   output logic [PORT_AFI_LD_N_WIDTH-1:0]                     afi_ld_n,
   output logic [PORT_AFI_RW_N_WIDTH-1:0]                     afi_rw_n,
   output logic [PORT_AFI_LBK0_N_WIDTH-1:0]                   afi_lbk0_n,
   output logic [PORT_AFI_LBK1_N_WIDTH-1:0]                   afi_lbk1_n,
   output logic [PORT_AFI_CFG_N_WIDTH-1:0]                    afi_cfg_n,
   output logic [PORT_AFI_AP_WIDTH-1:0]                       afi_ap,
   output logic [PORT_AFI_AINV_WIDTH-1:0]                     afi_ainv,
   output logic [PORT_AFI_DM_WIDTH-1:0]                       afi_dm,
   output logic [PORT_AFI_DM_N_WIDTH-1:0]                     afi_dm_n,
   output logic [PORT_AFI_BWS_N_WIDTH-1:0]                    afi_bws_n,
   input  logic [PORT_AFI_RDATA_DBI_N_WIDTH-1:0]              afi_rdata_dbi_n,
   output logic [PORT_AFI_WDATA_DBI_N_WIDTH-1:0]              afi_wdata_dbi_n,
   input  logic [PORT_AFI_RDATA_DINV_WIDTH-1:0]               afi_rdata_dinv,
   output logic [PORT_AFI_WDATA_DINV_WIDTH-1:0]               afi_wdata_dinv,
   output logic [PORT_AFI_DQS_BURST_WIDTH-1:0]                afi_dqs_burst,
   output logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]              afi_wdata_valid,
   output logic [PORT_AFI_WDATA_WIDTH-1:0]                    afi_wdata,
   output logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]            afi_rdata_en_full,
   input  logic [PORT_AFI_RDATA_WIDTH-1:0]                    afi_rdata,
   input  logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]              afi_rdata_valid,
   output logic [PORT_AFI_RRANK_WIDTH-1:0]                    afi_rrank,
   output logic [PORT_AFI_WRANK_WIDTH-1:0]                    afi_wrank,
   input  logic [PORT_AFI_ALERT_N_WIDTH-1:0]                  afi_alert_n,
   input  logic [PORT_AFI_PE_N_WIDTH-1:0]                     afi_pe_n,

   // Ports for "tg_status" interfaces (auto-generated)
   output logic                                               traffic_gen_pass,
   output logic                                               traffic_gen_fail,
   output logic                                               traffic_gen_timeout
);
   timeunit 1ps;
   timeprecision 1ps;

   localparam MEM_IF_CS_WIDTH = PORT_AFI_CS_N_WIDTH / USER_CLK_RATIO ;

   localparam LOOP_COUNTER_WIDTH = USER_CLK_RATIO * 2;

   localparam CMD_COUNTER_WIDTH = (MRS_WRITE_PROTOCOL == 0) ? 3 : 1;

   localparam TRC_COUNTER_WIDTH = 3;

   localparam MAX_AFI_WLAT = 16;

   localparam MAX_AFI_RLAT = 16;

   localparam BANKS_PER_WRITE = 2**MRS_WRITE_PROTOCOL;

   localparam DQ_DDR_WIDTH = PORT_AFI_WDATA_WIDTH / USER_CLK_RATIO;

   localparam WDATA_BITS_PER_DM   = PORT_AFI_WDATA_WIDTH / PORT_AFI_DM_WIDTH;   // AFI symbol size
   localparam NUM_WDATA_GROUPS_PER_DM   = (PORT_AFI_WDATA_WIDTH / PORT_AFI_DM_WIDTH)/9;   // In RLD3 for x36 there are 2 x9 groups for each DM
   localparam DM_DDR_WIDTH = PORT_AFI_DM_WIDTH / USER_CLK_RATIO;

   wire force_error;
   assign force_error = 1'b0;

   enum {
      INIT_WRITE_OUTER_LOOP_COUNTER,
      INIT_WRITE_INNER_LOOP_COUNTER,
      ISSUE_WRITES,
      WAIT_WL,
      WRITE_WAIT_TRC,
      NEXT_WRITE_OUTER_LOOP,
      INIT_READ_OUTER_LOOP_COUNTER,
      INIT_READ_INNER_LOOP_COUNTER,
      ISSUE_READS,
      WAIT_RL,
      READ_DATA,
      READ_WAIT_TRC,
      NEXT_BANK_SET,
      NEXT_READ_OUTER_LOOP,
      START_DM_TEST,
      END_DM_TEST,
      FAILED,
      DONE
   } state;

   enum {
      DM_0,
      DM_ACTIVE
   } dm_state;

   reg [LOOP_COUNTER_WIDTH-1:0]         loop_counter;
   reg [CMD_COUNTER_WIDTH-1:0]          cmd_counter;
   reg [CMD_COUNTER_WIDTH-1:0]          wdata_counter;
   reg [MAX_AFI_RLAT-1:0]               rl_shifter;
   reg [MAX_AFI_WLAT-1:0]               wl_shifter;
   reg [TRC_COUNTER_WIDTH-1:0]          trc_counter;
   reg [3:0]                            bank_counter;
   reg                                  read_failed;
   reg [1:0]                            en;

   wire [PORT_AFI_BA_WIDTH-1:0]         afi_ba_int;
   wire [PORT_AFI_WDATA_WIDTH-1:0]      expected_afi_rdata;
   wire [PORT_AFI_WDATA_WIDTH-1:0]      masked_afi_rdata;
   reg  [PORT_AFI_WDATA_WIDTH-1:0]      expected_afi_rdata_r;
   reg  [PORT_AFI_WDATA_WIDTH-1:0]      masked_afi_rdata_r;
   reg  [3:0]                           rank_num;

   reg  [PORT_AFI_RDATA_VALID_WIDTH-1:0] afi_rdata_valid_r;
   reg  [PORT_AFI_RDATA_WIDTH-1:0]       afi_rdata_r;

`ifdef ALTERA_EMIF_ENABLE_ISSP
   reg [PORT_AFI_RDATA_WIDTH-1:0]       pnf_per_bit_persist;
`endif
   logic                                issp_reset_n;
   logic                                reset_n_int;

   always_ff @(posedge afi_clk, negedge reset_n_int)
   begin
      if (! reset_n_int) begin
        state <= INIT_WRITE_OUTER_LOOP_COUNTER;
        rank_num <= '0;
        traffic_gen_pass <= '0;
        traffic_gen_fail <= '0;
        traffic_gen_timeout <= '0;
      end else begin
         case(state)
            INIT_WRITE_OUTER_LOOP_COUNTER:
               if (rank_num == MEM_IF_CS_WIDTH) begin
                  state <= DONE;
               end else if (afi_cal_success) begin
                  state <= INIT_WRITE_INNER_LOOP_COUNTER;
               end else begin
               if (afi_cal_fail) begin
                  state <= FAILED;
               end
            end
            INIT_WRITE_INNER_LOOP_COUNTER:
               state <= ISSUE_WRITES;

            ISSUE_WRITES:
               if (cmd_counter == '1)
                  state <= WAIT_WL;

            WAIT_WL:
               if (wl_shifter == '0)
                  state <= WRITE_WAIT_TRC;

            WRITE_WAIT_TRC:
               if (trc_counter == '1)
                  if (loop_counter == 0)
                     state <= INIT_READ_OUTER_LOOP_COUNTER;
                  else
                     state <= NEXT_WRITE_OUTER_LOOP;

            NEXT_WRITE_OUTER_LOOP:
               state <= INIT_WRITE_INNER_LOOP_COUNTER;

            INIT_READ_OUTER_LOOP_COUNTER:
               state <= INIT_READ_INNER_LOOP_COUNTER;

            INIT_READ_INNER_LOOP_COUNTER:
               state <= ISSUE_READS;

            ISSUE_READS:
               if (cmd_counter == '1)
                  state <= WAIT_RL;

            WAIT_RL:
               if (read_failed)
                  state <= FAILED;
               else if (rl_shifter[0] == 1'b1)
                  state <= READ_WAIT_TRC;

            READ_WAIT_TRC:
               if (trc_counter == '1) begin
                  if (bank_counter > 0) begin
                     state <= NEXT_BANK_SET;
                  end else begin
                     if (loop_counter == 0) begin
                        if ( dm_state == DM_0 && (MEM_DATA_MASK_EN)) begin
                           state <= START_DM_TEST;
                        end else begin
                           rank_num <= rank_num + 1'b1;
                           state <= END_DM_TEST;
                        end
                     end else begin
                        state <= NEXT_READ_OUTER_LOOP;
                     end
                  end
               end

            NEXT_BANK_SET:
               state <= ISSUE_READS;

            NEXT_READ_OUTER_LOOP:
               state <= INIT_READ_INNER_LOOP_COUNTER;

            START_DM_TEST:
               state <= INIT_WRITE_OUTER_LOOP_COUNTER;

            END_DM_TEST:
               state <= INIT_WRITE_OUTER_LOOP_COUNTER;

            DONE:
               begin
               state <= (force_error ? FAILED : DONE);
               traffic_gen_pass <= '1;
               traffic_gen_fail <= '0;
               end
            FAILED:
               begin
               state <= FAILED;
               traffic_gen_pass <= '0;
               traffic_gen_fail <= '1;
               traffic_gen_timeout <= '1;
               end
            default:
               state <= INIT_WRITE_OUTER_LOOP_COUNTER;
         endcase
      end
   end

   always_ff @(posedge afi_clk, negedge reset_n_int)
   begin
      if (! reset_n_int) begin
         dm_state <= DM_0;
      end else begin
         case(dm_state)
            DM_0:
               if (state == START_DM_TEST) begin
                  dm_state <= DM_ACTIVE;
               end

            DM_ACTIVE:
               if (state == END_DM_TEST) begin
                  dm_state <= DM_0;
               end

            default:
               dm_state <= DM_0;
         endcase
      end
   end

   always_ff @(posedge afi_clk)
   begin
      if (state == INIT_WRITE_OUTER_LOOP_COUNTER || state == INIT_READ_OUTER_LOOP_COUNTER)
         loop_counter <= '1 - 1'b1;
      else if (state == NEXT_WRITE_OUTER_LOOP || state == NEXT_READ_OUTER_LOOP)
         loop_counter <= loop_counter - 1'b1;
   end

   always_ff @(posedge afi_clk)
   begin
      if (state == INIT_WRITE_INNER_LOOP_COUNTER || state == INIT_READ_INNER_LOOP_COUNTER)
         cmd_counter <= '0;
      else if (state == ISSUE_WRITES || state == ISSUE_READS)
         cmd_counter <= cmd_counter + 1'b1;
   end

   always_ff @(posedge afi_clk)
   begin
      if (state == INIT_WRITE_INNER_LOOP_COUNTER)
         wdata_counter <= '0;
      else if (wl_shifter[0] == 1'b1)
         wdata_counter <= wdata_counter + 1'b1;
   end

   always_ff @(posedge afi_clk, negedge reset_n_int)
   begin
      if (!reset_n_int)
         rl_shifter <= '0;
      else if (state == ISSUE_READS)
         rl_shifter <= {1'b1, {(MAX_AFI_RLAT-1){1'b0}}};
      else if (state == WAIT_RL)
         rl_shifter <= {1'b0, rl_shifter[MAX_AFI_RLAT-1:1]};
   end

   always_ff @(posedge afi_clk, negedge reset_n_int)
   begin
      if (!reset_n_int)
         wl_shifter <= '0;
      else begin
         wl_shifter <= {1'b0, wl_shifter[MAX_AFI_WLAT-1:1]};
      if (state == INIT_WRITE_INNER_LOOP_COUNTER || ( state == ISSUE_WRITES && cmd_counter != '1 ) )
            wl_shifter[afi_wlat] <= 1'b1;
      end
   end

   always_ff @(posedge afi_clk)
   begin
      if (state == WAIT_WL || state == WAIT_RL)
         trc_counter <= '0;
      else
         trc_counter <= trc_counter + 1'b1;
   end

   always_ff @(posedge afi_clk)
   begin
      if (state == INIT_WRITE_OUTER_LOOP_COUNTER)
         bank_counter <= '0;
      else if (state == INIT_READ_INNER_LOOP_COUNTER)
         bank_counter <= BANKS_PER_WRITE[3:0] - 1'b1;
      else if (state == NEXT_BANK_SET)
         bank_counter <= bank_counter - 1'b1;
   end


   wire [USER_CLK_RATIO*2-1:0] cmd;
   wire [USER_CLK_RATIO*2-1:0] cmd_data_en;

   reg [USER_CLK_RATIO-1:0] afi_cs_per_rank;
   wire [USER_CLK_RATIO-1:0] cmd_0 = cmd[USER_CLK_RATIO-1:0];
   wire [USER_CLK_RATIO-1:0] cmd_1 = cmd[USER_CLK_RATIO*2-1:USER_CLK_RATIO];

   wire [USER_CLK_RATIO-1:0] cmd_0_data_en = cmd_data_en[USER_CLK_RATIO-1:0];
   wire [USER_CLK_RATIO-1:0] cmd_1_data_en = cmd_data_en[USER_CLK_RATIO*2-1:USER_CLK_RATIO];

   wire issue_cmd_0 = (state == ISSUE_WRITES || state == ISSUE_READS) && (cmd_counter[0] == 1'b0);
   wire issue_cmd_1 = (state == ISSUE_WRITES || state == ISSUE_READS) && (cmd_counter[0] == 1'b1);

   wire [USER_CLK_RATIO-1:0] cmd_0_afi_wdata_valid;
   wire [USER_CLK_RATIO-1:0] cmd_1_afi_wdata_valid;

   wire [PORT_AFI_CS_N_WIDTH-1:0]  local_afi_cs_n;

   assign afi_ref_n = '1;
   assign afi_rst_n = '1;

   // Register Incoming Read Signals
   always_ff @(posedge afi_clk, negedge reset_n_int) begin
      if (! reset_n_int) begin
         afi_rdata_valid_r <= '0;
         afi_rdata_r <= '0;
      end else begin
         afi_rdata_valid_r <= afi_rdata_valid;
         afi_rdata_r <= afi_rdata;
      end
   end

   always_ff @(posedge afi_clk, negedge reset_n_int) begin
      if (! reset_n_int) begin
         afi_ba <= '0;
         afi_addr <= '0;
         afi_we_n <= '1;
         afi_cs_per_rank <= '1;
         afi_wdata_valid <= '0;
         afi_rdata_en_full <= '0;
      end else begin
         afi_ba <= afi_ba_int;

         afi_addr <= {USER_CLK_RATIO{ {((PORT_AFI_ADDR_WIDTH/USER_CLK_RATIO)-LOOP_COUNTER_WIDTH-CMD_COUNTER_WIDTH){1'b0}}, loop_counter, cmd_counter}};

         afi_cs_per_rank <= (issue_cmd_0 ? cmd_0 : (issue_cmd_1 ? cmd_1 : '1));

         if (state == ISSUE_WRITES)
            afi_we_n <= (cmd_counter[0] == 1'b0) ? cmd_0 : cmd_1;
         else
            afi_we_n <= '1;

         if (wl_shifter[0] == 1'b1)
            afi_wdata_valid <= (wdata_counter[0] == 1'b0) ? cmd_0_afi_wdata_valid : cmd_1_afi_wdata_valid;
         else
            afi_wdata_valid <= '0;

         if (state == ISSUE_READS) begin
            afi_rdata_en_full <= (cmd_counter[0] == 1'b0) ? cmd_0_data_en : cmd_1_data_en;
         end else begin
            afi_rdata_en_full <= '0;
         end
      end
   end

   generate
      genvar i, j;
      for (i = 0; i < USER_CLK_RATIO; i = i + 1)
      begin : gen_wdata_valid_loop_timeslot
         for (j = 0; j < USER_CLK_RATIO / USER_CLK_RATIO; j = j + 1)
         begin : gen_wdata_valid_loop_group
            assign cmd_0_afi_wdata_valid[i * (USER_CLK_RATIO / USER_CLK_RATIO) + j] = cmd_0_data_en[i];
            assign cmd_1_afi_wdata_valid[i * (USER_CLK_RATIO / USER_CLK_RATIO) + j] = cmd_1_data_en[i];
         end
      end
   endgenerate

   generate
      if ( MEM_IF_CS_WIDTH == 1 ) begin
         assign local_afi_cs_n = afi_cs_per_rank;
      end else if ( MEM_IF_CS_WIDTH == 2 ) begin
         assign local_afi_cs_n =(rank_num[3:0] == 4'b0000) ? { {(USER_CLK_RATIO){1'b1}} , afi_cs_per_rank } : (
                      (rank_num[3:0] == 4'b0001) ? {  afi_cs_per_rank , {(USER_CLK_RATIO){1'b1}} } : (
                                             '1));
      end else if ( MEM_IF_CS_WIDTH == 4 ) begin
         assign local_afi_cs_n =(rank_num[3:0] == 4'b0000) ? { {(USER_CLK_RATIO*3){1'b1}} , afi_cs_per_rank } : (
                      (rank_num[3:0] == 4'b0001) ? { {(USER_CLK_RATIO*2){1'b1}} , afi_cs_per_rank , {(USER_CLK_RATIO*1){1'b1}} } : (
                      (rank_num[3:0] == 4'b0010) ? { {(USER_CLK_RATIO*1){1'b1}} , afi_cs_per_rank , {(USER_CLK_RATIO*2){1'b1}} } : (
                      (rank_num[3:0] == 4'b0011) ? {  afi_cs_per_rank , {(USER_CLK_RATIO*3){1'b1}} } : (
                                             '1 ))));
      end else begin
         assign local_afi_cs_n = '1;
      end
   endgenerate

   generate
      genvar m,l;
      for (l = 0; l < USER_CLK_RATIO; l = l + 1)
      begin : reorder_afi_cs_n_in_correct_time_slot
         for (m = 0; m < MEM_IF_CS_WIDTH; m = m + 1)
         begin : reorder_afi_cs_n_in_correct_time_slot_2
            assign afi_cs_n[ MEM_IF_CS_WIDTH*l + m] = local_afi_cs_n[m*USER_CLK_RATIO + l];
         end
      end
   endgenerate

   generate
      if (USER_CLK_RATIO == 4) begin

         if (BANKS_PER_WRITE == 2) begin
            assign afi_ba_int = issue_cmd_0 ? {4'b1000+(bank_counter<<3), 4'b0100+(bank_counter<<3), 4'b0010+(bank_counter<<3), 4'b0001+(bank_counter<<3)} : (
                                issue_cmd_1 ? {4'b0101+(bank_counter<<3), 4'b0111+(bank_counter<<3), 4'b0110+(bank_counter<<3), 4'b0011+(bank_counter<<3)} : (
                                '0));
         end
         else if (BANKS_PER_WRITE == 4) begin
            assign afi_ba_int = issue_cmd_0 ? {4'b0000, 4'b0000+(bank_counter<<2), 4'b0000, 4'b0001+(bank_counter<<2)} : (
                                issue_cmd_1 ? {4'b0000, 4'b0011+(bank_counter<<2), 4'b0000, 4'b0010+(bank_counter<<2)} : (
                                '0));
         end
         else begin
            assign afi_ba_int = {cmd_counter[1:0], 2'b11, cmd_counter[1:0], 2'b10, cmd_counter[1:0], 2'b01, cmd_counter[1:0], 2'b00};
         end

         if (BANKS_PER_WRITE == 4) begin
            if (MEM_BL == 2) begin
               assign cmd         = (loop_counter[1:0] == 2'b00) ? 8'b10101010 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b10111011 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b11111110 : (
                                                                   8'b11101111 )));

               assign cmd_data_en = (loop_counter[1:0] == 2'b00) ? 8'b01010101 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b01000100 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b00000001 : (
                                                                   8'b00010000 )));
            end
            else if (MEM_BL == 4) begin
               assign cmd         = (loop_counter[1:0] == 2'b00) ? 8'b10101010 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b10111011 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b11111110 : (
                                                                   8'b11101111 )));

               assign cmd_data_en = (loop_counter[1:0] == 2'b00) ? 8'b11111111 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b11001100 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b00000011 : (
                                                                   8'b00110000 )));
            end
            else if (MEM_BL == 8) begin
               assign cmd         = (loop_counter[1:0] == 2'b00) ? 8'b11101110 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b11111011 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b11111011 : (
                                                                   8'b11111110 )));

               assign cmd_data_en = (loop_counter[1:0] == 2'b00) ? 8'b11111111 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b00111100 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b00111100 : (
                                                                   8'b00001111 )));
            end
         end
         else begin
            if (MEM_BL == 2) begin
               assign cmd         =  loop_counter[USER_CLK_RATIO*2-1:0];
               assign cmd_data_en = ~loop_counter[USER_CLK_RATIO*2-1:0];
            end
            else if (MEM_BL == 4) begin
               assign cmd         = (loop_counter[1:0] == 2'b00) ? 8'b10101010 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b11010101 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b10110110 : (
                                                                   8'b11101110 )));

               assign cmd_data_en = (loop_counter[1:0] == 2'b00) ? 8'b11111111 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b01111110 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b11011011 : (
                                                                   8'b00110011 )));
            end
            else if (MEM_BL == 8) begin
               assign cmd         = (loop_counter[1:0] == 2'b00) ? 8'b11101110 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b11111101 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b11111011 : (
                                                                   8'b11110111 )));

               assign cmd_data_en = (loop_counter[1:0] == 2'b00) ? 8'b11111111 : (
                                    (loop_counter[1:0] == 2'b01) ? 8'b00011110 : (
                                    (loop_counter[1:0] == 2'b10) ? 8'b00111100 : (
                                                                   8'b01111000 )));
            end
         end
      end
      else if (USER_CLK_RATIO == 2) begin

         if (BANKS_PER_WRITE == 2) begin
            assign afi_ba_int = issue_cmd_0 ? {4'b0010+(bank_counter<<3), 4'b0001+(bank_counter<<3)} : (
                                issue_cmd_1 ? {4'b0110+(bank_counter<<3), 4'b0011+(bank_counter<<3)} : (
                                '0));
         end
         else if (BANKS_PER_WRITE == 4) begin
            assign afi_ba_int = issue_cmd_0 ? {4'b0010+(bank_counter<<2), 4'b0001+(bank_counter<<2)} : (
                                issue_cmd_1 ? {4'b0000+(bank_counter<<2), 4'b0011+(bank_counter<<2)} : (
                                '0));
         end
         else begin
            assign afi_ba_int = {cmd_counter[2:0], 1'b1, cmd_counter[2:0], 1'b0};
         end

         if (MEM_BL == 2) begin
            assign cmd         =  loop_counter[USER_CLK_RATIO*2-1:0];
            assign cmd_data_en = ~loop_counter[USER_CLK_RATIO*2-1:0];
         end
         else if (MEM_BL == 4) begin
            assign cmd         = (loop_counter[1:0] == 2'b00) ? 4'b1010 : (
                                 (loop_counter[1:0] == 2'b01) ? 4'b1101 : (
                                 (loop_counter[1:0] == 2'b10) ? 4'b1011 : (
                                                                4'b1110 )));

            assign cmd_data_en = (loop_counter[1:0] == 2'b00) ? 4'b1111 : (
                                 (loop_counter[1:0] == 2'b01) ? 4'b0110 : (
                                 (loop_counter[1:0] == 2'b10) ? 4'b1100 : (
                                                                4'b0011 )));
         end
         else if (MEM_BL == 8) begin
            assign cmd         = (loop_counter[1:0] == 2'b00) ? 4'b1110 : (
                                 (loop_counter[1:0] == 2'b01) ? 4'b1110 : (
                                 (loop_counter[1:0] == 2'b10) ? 4'b1110 : (
                                                                4'b1110 )));

            assign cmd_data_en = (loop_counter[1:0] == 2'b00) ? 4'b1111 : (
                                 (loop_counter[1:0] == 2'b01) ? 4'b1111 : (
                                 (loop_counter[1:0] == 2'b10) ? 4'b1111 : (
                                                                4'b1111 )));
         end
      end
   endgenerate

   reg [LOOP_COUNTER_WIDTH-1:0]  wdata_pattern;
   reg [LOOP_COUNTER_WIDTH-1:0]  rdata_pattern;

   always_ff @(posedge afi_clk, negedge reset_n_int) begin
      if (! reset_n_int) begin
         wdata_pattern <= '0;
         rdata_pattern <= '0;
      end else begin
         if ((state == START_DM_TEST) || (state == END_DM_TEST) ) begin
            wdata_pattern <= '0;
            rdata_pattern <= '0;
         end else if (MRS_WRITE_PROTOCOL == 0) begin
            if (|afi_wdata_valid)
               wdata_pattern <= wdata_pattern + 1'b1;

            if (|afi_rdata_valid_r && afi_cal_success)
               rdata_pattern <= rdata_pattern + 1'b1;
         end else begin
            wdata_pattern <= loop_counter;
            rdata_pattern <= loop_counter;
         end
      end
   end

   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_wdata_pattern_1 = {((PORT_AFI_WDATA_WIDTH/4)/LOOP_COUNTER_WIDTH){wdata_pattern}};
   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_rdata_pattern_1 = {((PORT_AFI_WDATA_WIDTH/4)/LOOP_COUNTER_WIDTH){rdata_pattern}};
   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_wdata_pattern_2 = ~full_wdata_pattern_1;
   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_rdata_pattern_2 = ~full_rdata_pattern_1;
   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_wdata_pattern_3 = {((PORT_AFI_WDATA_WIDTH/4)/LOOP_COUNTER_WIDTH){wdata_pattern}};
   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_rdata_pattern_3 = {((PORT_AFI_WDATA_WIDTH/4)/LOOP_COUNTER_WIDTH){rdata_pattern}};
   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_wdata_pattern_4 = ~full_wdata_pattern_3;
   wire [PORT_AFI_WDATA_WIDTH/4-1:0] full_rdata_pattern_4 = ~full_rdata_pattern_3;
   wire [PORT_AFI_WDATA_WIDTH-1:0] full_wdata_pattern = {full_wdata_pattern_4 , full_wdata_pattern_3 , full_wdata_pattern_2 , full_wdata_pattern_1};
   wire [PORT_AFI_WDATA_WIDTH-1:0] full_rdata_pattern = {full_rdata_pattern_4 , full_rdata_pattern_3 , full_rdata_pattern_2 , full_rdata_pattern_1};
   wire [PORT_AFI_WDATA_WIDTH-1:0] full_rdata_pattern_with_dm;

   assign afi_wdata = (dm_state == DM_0) ? full_wdata_pattern : ~full_wdata_pattern;

   wire [PORT_AFI_DM_WIDTH-1:0] dm_data_pattern;
   generate
      genvar p, q, s;

      if (MEM_DATA_MASK_EN) begin : use_dm
         for (p = 0; p < PORT_AFI_DM_WIDTH; ++p) begin : afi_dm_idx
            // Generate data mask
            assign dm_data_pattern[p] = (dm_state == DM_0) ? '0 : loop_counter[0] ^ p[0];

            // Generate expected read data when the write is partially masked
            if (NUM_WDATA_GROUPS_PER_DM == 2) begin : x36_mode
               for (q = (p * WDATA_BITS_PER_DM) - (9 * (p%2)); q < ((p * WDATA_BITS_PER_DM) - (9 * (p%2))) + 9; ++q) begin : wdata_idx_9_0
                  assign full_rdata_pattern_with_dm[q] = (dm_state == DM_0) ? full_rdata_pattern[q] :
                                                         (dm_data_pattern[p] ? full_rdata_pattern[q] : ~full_rdata_pattern[q]);
               end
               for (q = (((p+1) * WDATA_BITS_PER_DM) - (9 * (p%2))); q < (((p+1) * WDATA_BITS_PER_DM) - (9 * (p%2))) + 9; ++q) begin : wdata_idx_27_18
                  assign full_rdata_pattern_with_dm[q] = (dm_state == DM_0) ? full_rdata_pattern[q] :
                                                         (dm_data_pattern[p] ? full_rdata_pattern[q] : ~full_rdata_pattern[q]);
               end
            end else begin
               for (q = p * WDATA_BITS_PER_DM; q < (p + 1) * WDATA_BITS_PER_DM; ++q) begin : wdata_idx
                  assign full_rdata_pattern_with_dm[q] = (dm_state == DM_0) ? full_rdata_pattern[q] :
                                                         (dm_data_pattern[p] ? full_rdata_pattern[q] : ~full_rdata_pattern[q]);
               end
            end
         end
      end else begin
         assign dm_data_pattern = '0;
         assign full_rdata_pattern_with_dm = full_rdata_pattern;
      end
   endgenerate

  generate
      genvar t;
      if (MEM_DATA_MASK_EN) begin
         for (t = 0; t < USER_CLK_RATIO; t = t + 1)
         begin : gen_dm
            assign afi_dm[DM_DDR_WIDTH*(t+1)-1:DM_DDR_WIDTH*t] = afi_wdata_valid[t] ?
               dm_data_pattern[DM_DDR_WIDTH*(t+1)-1:DM_DDR_WIDTH*t] : '0;
         end
      end else begin
         assign afi_dm = dm_data_pattern;
      end
   endgenerate

   generate
      genvar k;
      for (k = 0; k < USER_CLK_RATIO; k = k + 1)
      begin : gen_rdata_loop_timeslot
         assign expected_afi_rdata[DQ_DDR_WIDTH*(k+1)-1 : DQ_DDR_WIDTH*k] = afi_rdata_valid_r[k] ?
            full_rdata_pattern_with_dm[DQ_DDR_WIDTH*(k+1)-1 : DQ_DDR_WIDTH*k] : '0;

         assign masked_afi_rdata[DQ_DDR_WIDTH*(k+1)-1 : DQ_DDR_WIDTH*k] = afi_rdata_valid_r[k] ?
            afi_rdata_r[DQ_DDR_WIDTH*(k+1)-1 : DQ_DDR_WIDTH*k] : '0;

      end
   endgenerate

   always_ff @(posedge afi_clk)
   begin
	  expected_afi_rdata_r <= expected_afi_rdata;
	  masked_afi_rdata_r <= masked_afi_rdata;
   end

   always_ff @(posedge afi_clk, negedge reset_n_int)
   begin
      if (!reset_n_int) begin
         read_failed <= 1'b0;
      end else if ((expected_afi_rdata_r == masked_afi_rdata_r || (!afi_cal_success)) && (read_failed == 1'b0)) begin
         read_failed <= read_failed;
         // synthesis translate_off
          if ( expected_afi_rdata_r != 'b0 )
            $display("[%0t] Expected data %h : Read Data %h ", $time, expected_afi_rdata, masked_afi_rdata);
         // synthesis translate_on
      end else begin
         read_failed <= 1'b1;
      end
   end

 `ifdef ALTERA_EMIF_ENABLE_ISSP
    always_ff @(posedge afi_clk, negedge reset_n_int)
   begin
      if (!reset_n_int) begin
         pnf_per_bit_persist <= '1;
      end else if ((!afi_cal_success) && (read_failed == 1'b0)) begin
         pnf_per_bit_persist <= pnf_per_bit_persist;
      end else begin
         pnf_per_bit_persist <=  (~(expected_afi_rdata_r ^ masked_afi_rdata_r)) &  pnf_per_bit_persist ;
      end
   end
`endif
   // AFI expects the rank switching signal to be one-hot encoded, but is also able
   // to treat all-zeros as selecting shadow register set 0. Since this example
   // traffic generator can only access rank 0, we simply tie the rank switcing
   // signals to '0.  For proper shadow register switching, the traffic generator
   // should one-hot encode which rank is being read or write, for all the AFI
   // time slots, into the afi_rrank and afi_wrank signals. The afi_rrank signal must
   // be asserted and deasserted following the timing of afi_rdata_en_full. The
   // afi_wrank signal must be asserted and deasserted following the timing of
   // afi_dqs_burst (for DDRx) or afi_wdata_valid (for non-DDRx).
   assign afi_rrank = '0;
   assign afi_wrank = '0;

   assign afi_cal_req = '0;
   assign afi_ctl_refresh_done = '0;
   assign afi_ctl_long_idle = '0;
   assign afi_mps_req = '0;
   assign afi_bg = '0;
   assign afi_c = '0;
   assign afi_cke = '0;
   assign afi_rm = '0;
   assign afi_odt = '0;
   assign afi_ras_n = '1;
   assign afi_cas_n = '1;
   assign afi_act_n = '1;
   assign afi_par = '0;
   assign afi_ca = '0;
   assign afi_wps_n = '1;
   assign afi_rps_n = '1;
   assign afi_doff_n = '1;
   assign afi_ld_n = '1;
   assign afi_rw_n = '1;
   assign afi_lbk0_n = '1;
   assign afi_lbk1_n = '1;
   assign afi_cfg_n = '1;
   assign afi_ap = '0;
   assign afi_ainv = '0;
   assign afi_dm_n = '1;
   assign afi_bws_n = '0;
   assign afi_wdata_dbi_n = '1;
   assign afi_wdata_dinv = '0;
   assign afi_dqs_burst = '0;

`ifdef ALTERA_EMIF_ENABLE_ISSP
   localparam MAX_PROBE_WIDTH = 511;
   altsource_probe #(
      .sld_auto_instance_index ("YES"),
      .sld_instance_index      (0),
      .instance_id             ("TGR"),
      .probe_width             (0),
      .source_width            (1),
      .source_initial_value    ("1"),
      .enable_metastability    ("NO")
   ) tg_reset_n_issp (
      .source  (issp_reset_n)
   );

   altsource_probe #(
		.sld_auto_instance_index ("YES"),
		.sld_instance_index      (0),
		.instance_id             ("TGP"),
		.probe_width             (1),
		.source_width            (0),
		.source_initial_value    ("0"),
		.enable_metastability    ("NO")
	) tg_pass (
		.probe  (traffic_gen_pass)
	);

   altsource_probe #(
		.sld_auto_instance_index ("YES"),
		.sld_instance_index      (0),
		.instance_id             ("TGF"),
		.probe_width             (1),
		.source_width            (0),
		.source_initial_value    ("0"),
		.enable_metastability    ("NO")
	) tg_fail (
		.probe  (traffic_gen_fail)
	);

   altsource_probe #(
		.sld_auto_instance_index ("YES"),
		.sld_instance_index      (0),
		.instance_id             ("TGT"),
		.probe_width             (1),
		.source_width            (0),
		.source_initial_value    ("0"),
		.enable_metastability    ("NO")
	) tg_timeout (
		.probe  (traffic_gen_timeout)
	);

   generate
      genvar r;
      for (r = 0; r < (PORT_AFI_RDATA_WIDTH + MAX_PROBE_WIDTH - 1) / MAX_PROBE_WIDTH; r = r + 1)
      begin : gen_pnf_width
         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("PNF0"),
            .probe_width             ((MAX_PROBE_WIDTH * (r+1)) > PORT_AFI_RDATA_WIDTH ? PORT_AFI_RDATA_WIDTH - (MAX_PROBE_WIDTH * r) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_pnf (
            .probe  (pnf_per_bit_persist[((MAX_PROBE_WIDTH * (r+1) - 1) < PORT_AFI_RDATA_WIDTH-1 ? (MAX_PROBE_WIDTH * (r+1) - 1) : PORT_AFI_RDATA_WIDTH-1) : (MAX_PROBE_WIDTH * r)])
         );
      end
   endgenerate
`else
   assign issp_reset_n = 1'b1;
`endif

   assign reset_n_int = afi_reset_n & issp_reset_n;
endmodule

