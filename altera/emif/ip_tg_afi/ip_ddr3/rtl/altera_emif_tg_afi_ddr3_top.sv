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
// Top-level wrapper of Example DDR3 AFI Traffic Generator
//
// To conform to the rest of EMIF, the interfaces of a memory controller must:
//    Expose one AFI interface
//    Accept one afi_reset_n interface
//    Accept one afi_clk interface
//    Accept one afi_half_clk interface
//    Expose one tg_status interface
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_tg_afi_ddr3_top # (
   parameter PROTOCOL_ENUM                           = "",
   parameter USER_CLK_RATIO                          = 1,
   parameter MEM_DATA_MASK_EN                        = 1,
   parameter MEM_NUM_OF_LOGICAL_RANKS                = 1,
   parameter MEM_DDR3_TCL                            = 1,
   parameter MEM_DDR3_WTCL                           = 1,
   parameter MEM_DDR3_CTRL_CFG_READ_ODT_CHIP         = 16'b0,
   parameter MEM_DDR3_CTRL_CFG_WRITE_ODT_CHIP        = 16'b0,
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
) /* synthesis dont_merge syn_preserve = 1 */;
   timeunit 1ps;
   timeprecision 1ps;

   // Calculate the log_2 of the input value
   function automatic integer log2;
      input integer value;
      begin
         value = value >> 1;
         for (log2 = 0; value > 0; log2 = log2 + 1)
            value = value >> 1;
      end
   endfunction

   // Returns the maximum of two numbers
   function automatic integer max;
      input integer a;
      input integer b;
      begin
         max = (a > b) ? a : b;
      end
   endfunction

   // Below is used to override the user selection for DENY_RECAL_REQUEST for synthesis
   // synthesis read_comments_as_HDL on
   // `define DISABLE_DENY_RECAL_REQUEST_FOR_SYNTH TRUE
   // synthesis read_comments_as_HDL off   

   `ifdef DISABLE_DENY_RECAL_REQUEST_FOR_SYNTH
     localparam DENY_RECAL_REQUEST_AFT_SYNTH_OVRD  = 0;
   `else
     localparam DENY_RECAL_REQUEST_AFT_SYNTH_OVRD  = DENY_RECAL_REQUEST;
   `endif


   localparam PORT_MEM_ADDR_WIDTH = PORT_AFI_ADDR_WIDTH / USER_CLK_RATIO;       // Number of address pins
   localparam PORT_MEM_BA_WIDTH   = PORT_AFI_BA_WIDTH / USER_CLK_RATIO;         // Number of bank-address pins
   localparam WDATA_BITS_PER_DM   = PORT_AFI_WDATA_WIDTH / PORT_AFI_DM_WIDTH;   // AFI symbol size

   localparam MEM_BURST_LENGTH   = 8;                                           // Words per memory burst
   localparam MEM_CYCS_PER_BURST = MEM_BURST_LENGTH / 2;                        // How long a read/write burst takes in memory cycles
   localparam AFI_CYCS_PER_BURST = MEM_CYCS_PER_BURST / USER_CLK_RATIO;         // How long a read/write burst takes in AFI cycles

   // How long to wait for tRCD - this is set sufficiently large for any config.
   // A real controller obviously should keep this to minimal based on memory.
   // AFI wait cycles = 2^(val-1)+1
   localparam TRCD_COUNTER_WIDTH = 5;

   // How long to wait for tRP - this is set sufficiently large for any memory.
   // A real controller obviously should keep this to minimal based on memory.
   // AFI wait cycles = 2^(val-1)+1
   localparam TRP_COUNTER_WIDTH = 5;

   // How long to wait for tWTR - this is set sufficiently large for any config.
   // A real controller obviously should keep this to minimal based on memory.
   // AFI wait cycles = 2^(val-1)+1
   localparam TWTR_COUNTER_WIDTH = 5;

   // Inner loop iterations.
   // loops = 2^(val-1)
   localparam LOOP_COUNTER_WIDTH = 5;

   // Controls the number of recal requests
   // loops = 2^(val-1)+1
   localparam RECAL_LOOP_COUNTER_WIDTH = 1;

   // Controls how long to wait for recalibration request
   // wait cycles = 2^(val-1)+1
   localparam RECAL_TIMEOUT_COUNTER_WIDTH = 32;

   // Controls how long to wait for valid read data
   // wait cycles = 2^(val-1)+1
   localparam READ_TIMEOUT_COUNTER_WIDTH = 6;

   // Number of memory cycles ODT is asserted 1 during a BL8 write
   localparam ODT_WRITE_PERIOD_MEM_CYCS = 6;

   // Number of memory cycles between write command and ODT assertion
   localparam WRITE_TO_ODT_MEM_CYCS = 0;

   // Number of memory cycles ODT is asserted 1 during a BL8 read
   localparam ODT_READ_PERIOD_MEM_CYCS = 6;

   // Number of memory cycles between read command and ODT assertion
   localparam READ_TO_ODT_MEM_CYCS = MEM_DDR3_TCL - MEM_DDR3_WTCL;

   // AFI cycle and timeslot between write command and first ODT assertion
   localparam WRITE_TO_ODT_FIRST_AFI_CYC  = WRITE_TO_ODT_MEM_CYCS / USER_CLK_RATIO;
   localparam WRITE_TO_ODT_FIRST_TIMESLOT = WRITE_TO_ODT_MEM_CYCS % USER_CLK_RATIO;

   // AFI cycle and timeslot between write command and last ODT assertion
   localparam WRITE_TO_ODT_LAST_AFI_CYC   = (WRITE_TO_ODT_MEM_CYCS + ODT_WRITE_PERIOD_MEM_CYCS - 1) / USER_CLK_RATIO;
   localparam WRITE_TO_ODT_LAST_TIMESLOT  = (WRITE_TO_ODT_MEM_CYCS + ODT_WRITE_PERIOD_MEM_CYCS - 1) % USER_CLK_RATIO;

   // AFI cycle and timeslot between read command and first ODT assertion
   localparam READ_TO_ODT_FIRST_AFI_CYC  = READ_TO_ODT_MEM_CYCS / USER_CLK_RATIO;
   localparam READ_TO_ODT_FIRST_TIMESLOT = READ_TO_ODT_MEM_CYCS % USER_CLK_RATIO;

   // AFI cycle and timeslot between read command and last ODT assertion
   localparam READ_TO_ODT_LAST_AFI_CYC   = (READ_TO_ODT_MEM_CYCS + ODT_READ_PERIOD_MEM_CYCS - 1) / USER_CLK_RATIO;
   localparam READ_TO_ODT_LAST_TIMESLOT  = (READ_TO_ODT_MEM_CYCS + ODT_READ_PERIOD_MEM_CYCS - 1) % USER_CLK_RATIO;

   // Width of counter to keep track of ODT assertion state
   localparam ODT_COUNTER_WIDTH = log2(max(WRITE_TO_ODT_LAST_AFI_CYC, READ_TO_ODT_LAST_AFI_CYC)) + 1;

   // Number of ODT/CS pins
   localparam MEM_ODT_WIDTH  = (PORT_AFI_ODT_WIDTH / USER_CLK_RATIO);
   localparam MEM_CS_N_WIDTH = (PORT_AFI_CS_N_WIDTH / USER_CLK_RATIO);

   enum {
      INIT,                          // Reset state
      ISSUE_ACTIVATE,                // Activate row
      WAIT_TRCD,                     // Wait for row activation
      PRE_ISSUE_WRITE_0,             // 1 AFI cycle before issuing write command
      ISSUE_WRITE_0,                 // Write command
      WAIT_WLAT_0,                   // Wait for write latency
      ISSUE_DQS_PREAMBLE_0,          // Send out DQS preamble
      WRITE_DATA_0,                  // Write data X, no data mask
      WAIT_TWTR_0,                   // Wait for tWTR
      PRE_ISSUE_READ_0,              // 1 AFI cycle before issuing read command
      ISSUE_READ_0,                  // Read command
      WAIT_READ_0,                   // Wait until read data coming back, and compare
      PRE_ISSUE_WRITE_1,             // 1 AFI cycle before issuing write command
      ISSUE_WRITE_1,                 // Write command to same location
      WAIT_WLAT_1,                   // Wait for write latency
      ISSUE_DQS_PREAMBLE_1,          // Send out DQS preamble
      WRITE_DATA_1,                  // Write data ~X, with data mask
      WAIT_TWTR_1,                   // Wait for tWTR
      PRE_ISSUE_READ_1,              // 1 AFI cycle before issuing read command
      ISSUE_READ_1,                  // Read command
      WAIT_READ_1,                   // Wait until read data coming back, and compare
      ISSUE_PRECHARGE,               // Issue precharge to deactivate row
      WAIT_TRP,                      // Wait for the row deactivation
      NEXT_LOOP,                     // Move on to next iteration with new data and address
      NEXT_RECAL_LOOP,               // Move on to the next outer loop iteration with recalibration
      WAIT_RECAL,                    // Initiate and wait for recalibration to occur
      CHECK_PNF,                     // Check PNF to determine pass/fail
      DONE_PASSED,                   // Passed!
      DONE_FAILED,                   // Failed!
      DONE_TIMEOUT                   // Time out!
   } state;

   typedef enum {
      ODT_IDLE,                      // No read/write command
      ODT_WRITE_PREASSERT,           // A write command was issued but ODT can't be asserted yet
      ODT_WRITE_FIRST,               // First AFI cycle where ODT is asserted for write
      ODT_WRITE_MID,                 // Subsequent AFI cycles after ODT_WRITE_FIRST
      ODT_WRITE_LAST,                // Last AFI cycle where ODT is asserted for wirte
      ODT_READ_PREASSERT,            // A read command was issued but ODT can't be asserted yet
      ODT_READ_FIRST,                // First AFI cycle where ODT is asserted for read
      ODT_READ_MID,                  // Subsequent AFI cycles after ODT_READ_START
      ODT_READ_LAST                  // Last AFI cycle where ODT is asserted for read
   } ODT_STATE;

   logic                                               afi_cal_req_c;
   logic                                               afi_cal_success_r;
   logic                                               afi_cal_fail_r;
   logic [PORT_AFI_WLAT_WIDTH-1:0]                     afi_wlat_r;
   logic [PORT_AFI_PAR_WIDTH-1:0]                      afi_par_c;
   logic [PORT_AFI_ADDR_WIDTH-1:0]                     afi_addr_c;
   logic [PORT_AFI_BA_WIDTH-1:0]                       afi_ba_c;
   logic [PORT_AFI_CS_N_WIDTH-1:0]                     afi_cs_n_c;
   logic [PORT_AFI_ODT_WIDTH-1:0]                      afi_odt_c;
   logic [PORT_AFI_RAS_N_WIDTH-1:0]                    afi_ras_n_c;
   logic [PORT_AFI_CAS_N_WIDTH-1:0]                    afi_cas_n_c;
   logic [PORT_AFI_WE_N_WIDTH-1:0]                     afi_we_n_c;
   logic [PORT_AFI_DM_WIDTH-1:0]                       afi_dm_c;
   logic [PORT_AFI_DQS_BURST_WIDTH-1:0]                afi_dqs_burst_c;
   logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]              afi_wdata_valid_c;
   logic [PORT_AFI_WDATA_WIDTH-1:0]                    afi_wdata_c;
   logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]            afi_rdata_en_full_c;
   logic [PORT_AFI_RDATA_WIDTH-1:0]                    afi_rdata_r;
   logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]              afi_rdata_valid_r;
   logic [PORT_AFI_RRANK_WIDTH-1:0]                    afi_rrank_c;
   logic [PORT_AFI_WRANK_WIDTH-1:0]                    afi_wrank_c;

   logic [PORT_MEM_ADDR_WIDTH-1:0]                     afi_addr_t0;
   logic [PORT_MEM_BA_WIDTH-1:0]                       afi_ba_t0;
   logic [USER_CLK_RATIO-1:0]                          asserted_afi_cmd_n;
   logic                                               assert_preamble_dqs_burst;
   logic                                               assert_full_dqs_burst;
   logic [USER_CLK_RATIO-1:0]                          preamble_afi_dqs_burst;
   logic [PORT_AFI_WRANK_WIDTH-1:0]                    preamble_afi_wrank;
   logic [PORT_AFI_DM_WIDTH-1:0]                       asserted_afi_dm;
   logic [PORT_AFI_WLAT_WIDTH-1:0]                     wlat_counter;
   logic [1:0]                                         rburst_counter;
   logic [1:0]                                         wburst_counter;
   logic [TRCD_COUNTER_WIDTH-1:0]                      trcd_counter;
   logic [TRP_COUNTER_WIDTH-1:0]                       trp_counter;
   logic [TWTR_COUNTER_WIDTH-1:0]                      twtr_counter;
   logic [READ_TIMEOUT_COUNTER_WIDTH-1:0]              read_timeout_counter;
   logic [RECAL_TIMEOUT_COUNTER_WIDTH-1:0]             recal_timeout_counter;

   ODT_STATE                                           odt_state;
   logic [ODT_COUNTER_WIDTH-1:0]                       odt_counter;

   (* altera_attribute = {"-name MAX_FANOUT 10"}*)
   logic [LOOP_COUNTER_WIDTH-1:0]                      loop_counter;

   logic [1:0]                                         active_cs_n;
   logic [1:0]                                         active_logical_rank;
   logic [MEM_NUM_OF_LOGICAL_RANKS-1:0]                active_logical_rank_one_hot;
   logic [RECAL_LOOP_COUNTER_WIDTH-1:0]                recal_loop_counter;
   logic [AFI_CYCS_PER_BURST-1:0]                      rd_en_token_shift_reg;
   logic [PORT_AFI_WDATA_WIDTH-1:0]                    write_0_pattern;
   logic [PORT_AFI_WDATA_WIDTH-1:0]                    write_1_pattern;

   logic [PORT_AFI_RDATA_WIDTH-1:0]                    pnf_per_bit;
   logic [PORT_AFI_RDATA_WIDTH-1:0]                    pnf_per_bit_persist;
   logic [PORT_AFI_RDATA_WIDTH-1:0]                    pnf_per_bit_persist_r;

   // Assert commands at timeslot 0 (i.e. aligned access)
   assign asserted_afi_cmd_n = { {(USER_CLK_RATIO - 1){1'b1}}                        , 1'b0        };
   assign afi_addr_c         = { {(PORT_AFI_ADDR_WIDTH - PORT_MEM_ADDR_WIDTH){1'b0}} , afi_addr_t0 };
   assign afi_ba_c           = { {(PORT_AFI_BA_WIDTH - PORT_MEM_BA_WIDTH){1'b0}}     , afi_ba_t0   };

   // Signal to indicate when to issue output DQS premable
   assign assert_preamble_dqs_burst = (
      (state == ISSUE_WRITE_0 && afi_wlat_r == 1) ||
      (state == ISSUE_WRITE_1 && afi_wlat_r == 1) ||
      (state == ISSUE_DQS_PREAMBLE_0) ||
      (state == ISSUE_DQS_PREAMBLE_1));

   // Signal to indicate when to assert output DQS fully
   assign assert_full_dqs_burst = (state == WRITE_DATA_0 || state == WRITE_DATA_1);

   // For aligned writes, DQS burst preamble is asserted at the last time slot
   assign preamble_afi_dqs_burst = { 1'b1, {(USER_CLK_RATIO-1){1'b0}} };
   assign preamble_afi_wrank     = { active_logical_rank_one_hot, {(PORT_AFI_WRANK_WIDTH - MEM_NUM_OF_LOGICAL_RANKS){1'b0}} };

   // Generate simplistic data patterns
   assign write_0_pattern = {(PORT_AFI_WDATA_WIDTH / 8){~loop_counter[3:0], loop_counter[3:0]}};
   generate
      genvar i, j;

      if (MEM_DATA_MASK_EN) begin : use_dm
         for (i = 0; i < PORT_AFI_DM_WIDTH; ++i) begin : afi_dm_idx
            // Generate data mask
            assign asserted_afi_dm[i] = loop_counter[0] ^ i[0];

            // Generate expected read data when the write is partially masked
            for (j = i * WDATA_BITS_PER_DM; j < (i + 1) * WDATA_BITS_PER_DM; ++j) begin : wdata_idx
               assign write_1_pattern[j] = asserted_afi_dm[i] ? write_0_pattern[j] : ~write_0_pattern[j];
            end
         end
      end else begin
         assign asserted_afi_dm = '0;
         assign write_1_pattern = ~write_0_pattern;
      end
   endgenerate

   // Generate row/col address
   //    No auto-precharge
   //    Burst-chop mode assumed off
   //    Address[2:0] == 3'b000 to adhere to burst boundary when used as column address
   assign afi_addr_t0 = (
      state == ISSUE_ACTIVATE ||
      state == ISSUE_WRITE_0 ||
      state == ISSUE_READ_0 ||
      state == ISSUE_WRITE_1 ||
      state == ISSUE_READ_1 ||
      state == ISSUE_PRECHARGE
      ) ? {{(PORT_MEM_ADDR_WIDTH - LOOP_COUNTER_WIDTH - 3){1'b0}}, loop_counter, 3'b000} : '0;

   // Generate bank-address
   assign afi_ba_t0 = (
      state == ISSUE_ACTIVATE ||
      state == ISSUE_WRITE_0 ||
      state == ISSUE_READ_0 ||
      state == ISSUE_WRITE_1 ||
      state == ISSUE_READ_1 ||
      state == ISSUE_PRECHARGE
      ) ? loop_counter[PORT_MEM_BA_WIDTH-1:0] : '0;

   // Generate CS#
   generate
      genvar cs_n_t;
      genvar cs_n_i;

      // Determine which cs_n pin to use for issuing commands
      if (MEM_NUM_OF_LOGICAL_RANKS == 1) begin
         assign active_cs_n         = 2'b00;
         assign active_logical_rank = 2'b00;
      end else if (MEM_CS_N_WIDTH / MEM_NUM_OF_LOGICAL_RANKS == 2) begin
         assign active_cs_n         = loop_counter[0] ? 2'b00 : 2'b10;
         assign active_logical_rank = loop_counter[0] ? 2'b00 : 2'b01;
      end else begin
         assign active_cs_n         = loop_counter[log2(MEM_NUM_OF_LOGICAL_RANKS-1):0];
         assign active_logical_rank = loop_counter[log2(MEM_NUM_OF_LOGICAL_RANKS-1):0];
      end

      for (cs_n_i = 0; cs_n_i < MEM_CS_N_WIDTH; ++cs_n_i) begin: gen_cs_n_i
         // Generate signal for one chip select pin for all time slots
         logic [USER_CLK_RATIO-1:0] cs_n_i_pin;
         always_comb
         begin
            if ( state == ISSUE_ACTIVATE || state == ISSUE_PRECHARGE ||
                 state == ISSUE_WRITE_0 || state == ISSUE_WRITE_1 ||
                 state == ISSUE_READ_0 || state == ISSUE_READ_1 )
            begin
               if (cs_n_i % (MEM_CS_N_WIDTH / MEM_NUM_OF_LOGICAL_RANKS) == 0) begin
                  // This cs_n is used to access a rank
                  cs_n_i_pin = (active_cs_n == cs_n_i) ? {'1, 1'b0} : '1;
               end else begin
                  // This cs_n is used for RDIMM programming only
                  cs_n_i_pin = '1;
               end
            end else begin
               // Not issuing command.
               cs_n_i_pin = '1;
            end
         end

         // Assign to full bus based on timeslots
         for (cs_n_t = 0; cs_n_t < USER_CLK_RATIO; ++cs_n_t) begin : gen_cs_n_timeslot
            assign afi_cs_n_c[cs_n_t * MEM_CS_N_WIDTH + cs_n_i] = cs_n_i_pin[cs_n_t];
         end
      end
   endgenerate

   // Generate ODT
   generate
      genvar odt_t;
      genvar odt_i;

      for (odt_i = 0; odt_i < MEM_ODT_WIDTH; ++odt_i) begin : gen_odt_i

         // Generate signal for current ODT pin
         logic [USER_CLK_RATIO-1:0] odt_i_pin;
         logic odt_en;

         always_comb
         begin
            odt_i_pin = '0;
            odt_en = '0;

            // Generate based on ODT timing parameters and current ODT state
            case (odt_state)
               ODT_IDLE:
                  odt_i_pin = '0;
               ODT_WRITE_PREASSERT:
                  odt_i_pin = '0;
               ODT_WRITE_FIRST:
                  if (WRITE_TO_ODT_FIRST_AFI_CYC == WRITE_TO_ODT_LAST_AFI_CYC) begin
                     // The "max" below is only necessary to workaround simulator elaboration-time range checking.
                     // When this IF branch is taken, the "last" timeslot is guaranteed to be >= the "first" timeslot
                     // and so the "max" is a nop.
                     odt_i_pin[max(WRITE_TO_ODT_LAST_TIMESLOT,WRITE_TO_ODT_FIRST_TIMESLOT):WRITE_TO_ODT_FIRST_TIMESLOT] = '1;
                  end else begin
                     odt_i_pin[USER_CLK_RATIO-1:WRITE_TO_ODT_FIRST_TIMESLOT] = '1;
                  end
               ODT_WRITE_MID:
                  odt_i_pin = '1;
               ODT_WRITE_LAST:
                  odt_i_pin[WRITE_TO_ODT_LAST_TIMESLOT:0] = '1;
               ODT_READ_PREASSERT:
                  odt_i_pin = '0;
               ODT_READ_FIRST:
                  if (READ_TO_ODT_FIRST_AFI_CYC == READ_TO_ODT_LAST_AFI_CYC) begin
                     // The "max" below is only necessary to workaround simulator elaboration-time range checking.
                     // When this IF branch is taken, the "last" timeslot is guaranteed to be >= the "first" timeslot
                     // and so the "max" is a nop.
                     odt_i_pin[max(READ_TO_ODT_LAST_TIMESLOT,READ_TO_ODT_FIRST_TIMESLOT):READ_TO_ODT_FIRST_TIMESLOT] = '1;
                  end else begin
                     odt_i_pin[USER_CLK_RATIO-1:READ_TO_ODT_FIRST_TIMESLOT] = '1;
                  end
               ODT_READ_MID:
                  odt_i_pin = '1;
               ODT_READ_LAST:
                  odt_i_pin[READ_TO_ODT_LAST_TIMESLOT:0] = '1;
            endcase

            // Lookup and apply ODT assertion mask for the current pin based on the active chip select
            if (odt_state == ODT_WRITE_FIRST || odt_state == ODT_WRITE_MID || odt_state == ODT_WRITE_LAST)
            begin
               odt_en = active_cs_n == 2'b00 ? MEM_DDR3_CTRL_CFG_WRITE_ODT_CHIP[0  + odt_i] : (
                        active_cs_n == 2'b01 ? MEM_DDR3_CTRL_CFG_WRITE_ODT_CHIP[4  + odt_i] : (
                        active_cs_n == 2'b10 ? MEM_DDR3_CTRL_CFG_WRITE_ODT_CHIP[8  + odt_i] : (
                                               MEM_DDR3_CTRL_CFG_WRITE_ODT_CHIP[12 + odt_i] )));
            end
            else if (odt_state == ODT_READ_FIRST || odt_state == ODT_READ_MID || odt_state == ODT_READ_LAST)
            begin
               odt_en = active_cs_n == 2'b00 ? MEM_DDR3_CTRL_CFG_READ_ODT_CHIP[0  + odt_i] : (
                        active_cs_n == 2'b01 ? MEM_DDR3_CTRL_CFG_READ_ODT_CHIP[4  + odt_i] : (
                        active_cs_n == 2'b10 ? MEM_DDR3_CTRL_CFG_READ_ODT_CHIP[8  + odt_i] : (
                                               MEM_DDR3_CTRL_CFG_READ_ODT_CHIP[12 + odt_i] )));
            end
            odt_i_pin &= {USER_CLK_RATIO{odt_en}};
         end

         // Assign to full bus based on timeslots
         for (odt_t = 0; odt_t < USER_CLK_RATIO; ++odt_t) begin : gen_odt_timeslot
            assign afi_odt_c[odt_t * MEM_ODT_WIDTH + odt_i] = odt_i_pin[odt_t];
         end
      end
   endgenerate

   // Generate RAS#
   assign afi_ras_n_c = (
      state == ISSUE_ACTIVATE ||
      state == ISSUE_PRECHARGE
      ) ? asserted_afi_cmd_n : '1;

   // Generate CAS#
   assign afi_cas_n_c = (
      state == ISSUE_WRITE_0 ||
      state == ISSUE_READ_0 ||
      state == ISSUE_WRITE_1 ||
      state == ISSUE_READ_1
      ) ? asserted_afi_cmd_n : '1;

   // Generate WE#
   assign afi_we_n_c = (
      state == ISSUE_WRITE_0 ||
      state == ISSUE_WRITE_1 ||
      state == ISSUE_PRECHARGE
      ) ? asserted_afi_cmd_n : '1;

   //  Generate DQS-burst
   assign afi_dqs_burst_c = assert_preamble_dqs_burst ? preamble_afi_dqs_burst : (
                            assert_full_dqs_burst ? '1 : '0);

   //  Generate write data valid
   assign afi_wdata_valid_c = (
      state == WRITE_DATA_0 ||
      state == WRITE_DATA_1)
      ? '1 : '0;

   //  Generate write data
   assign afi_wdata_c = (
      state == WRITE_DATA_0 ? write_0_pattern : (
      state == WRITE_DATA_1 ? ~write_0_pattern :
                              '0 ));

   //  Generate write data enable
   assign afi_dm_c = (
      state == WRITE_DATA_0 ? '0 : (
      state == WRITE_DATA_1 ? asserted_afi_dm :
                              '0 ));

   //  Generate read data enable
   assign afi_rdata_en_full_c = {PORT_AFI_RDATA_EN_FULL_WIDTH{rd_en_token_shift_reg[0]}};

   //  Generate read data enable
   assign afi_rst_n = {PORT_AFI_RST_N_WIDTH{1'b1}};
   assign afi_cke   = {PORT_AFI_CKE_WIDTH{1'b1}};

   //  Generate cal request signal
   assign afi_cal_req_c = (state == WAIT_RECAL) ? 1'b1 : 1'b0;

   //  Generate status signals
   assign traffic_gen_pass    = (state == DONE_PASSED)  ? 1'b1 : 1'b0;
   assign traffic_gen_fail    = (state == DONE_FAILED)  ? 1'b1 : 1'b0;
   assign traffic_gen_timeout = (state == DONE_TIMEOUT) ? 1'b1 : 1'b0;

   ////////////////////////////////////////////////////////////////////
   // Counters management
   ////////////////////////////////////////////////////////////////////
   always_ff @(posedge afi_clk, negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         wlat_counter          <= '0;
         rburst_counter        <= '0;
         wburst_counter        <= '0;
         trcd_counter          <= '0;
         trp_counter           <= '0;
         twtr_counter          <= '0;
         loop_counter          <= '0;
         rd_en_token_shift_reg <= '0;
         read_timeout_counter  <= '0;
         recal_loop_counter    <= '0;
         recal_timeout_counter <= '0;
         odt_counter           <= '0;

      end else begin
         if (state == WAIT_WLAT_0 || state == WAIT_WLAT_1)
            wlat_counter <= wlat_counter - 1'b1;
         else
            wlat_counter <= afi_wlat_r - 2'b11;

         if (state == WRITE_DATA_0 || state == WRITE_DATA_1)
            wburst_counter <= wburst_counter - 1'b1;
         else
            wburst_counter <= AFI_CYCS_PER_BURST[1:0] - 1'b1;

         if ((state == WAIT_READ_0 || state == WAIT_READ_1) && afi_rdata_valid_r[0])
            rburst_counter <= rburst_counter - 1'b1;
         else
            rburst_counter <= AFI_CYCS_PER_BURST[1:0] - 1'b1;

         if (state == WAIT_TRCD)
            trcd_counter <= trcd_counter + 1'b1;
         else
            trcd_counter <= '0;

         if (state == WAIT_TRP)
            trp_counter <= trp_counter + 1'b1;
         else
            trp_counter <= '0;

         if (state == WAIT_TWTR_0 || state == WAIT_TWTR_1)
            twtr_counter <= twtr_counter + 1'b1;
         else
            twtr_counter <= '0;

         if (state == WAIT_READ_0 || state == WAIT_READ_1)
            read_timeout_counter <= read_timeout_counter + 1'b1;
         else
            read_timeout_counter <= '0;

         if (state == WAIT_RECAL)
            recal_timeout_counter <= recal_timeout_counter + 1'b1;
         else
            recal_timeout_counter <= '0;

         if (state == NEXT_LOOP)
            loop_counter <= loop_counter + 1'b1;
         else if (state == NEXT_RECAL_LOOP)
            loop_counter <= '0;

         if (state == NEXT_RECAL_LOOP)
            recal_loop_counter <= recal_loop_counter + 1'b1;

         if (state == PRE_ISSUE_READ_0 || state == PRE_ISSUE_READ_1)
            rd_en_token_shift_reg <= {AFI_CYCS_PER_BURST{1'b1}};
         else
            rd_en_token_shift_reg <= (AFI_CYCS_PER_BURST == 1) ? 1'b0 : (rd_en_token_shift_reg >> 1);

         if (odt_state == ODT_IDLE)
            odt_counter <= '0;
         else
            odt_counter <= odt_counter + 1'b1;
      end
   end

   ////////////////////////////////////////////////////////////////////
   // ODT state machine
   ////////////////////////////////////////////////////////////////////
   always_ff @(posedge afi_clk, negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         odt_state <= ODT_IDLE;
      end else begin
         case (odt_state)
            ODT_IDLE:
               if (state == PRE_ISSUE_WRITE_0 || state == PRE_ISSUE_WRITE_1) begin
                  if (WRITE_TO_ODT_FIRST_AFI_CYC == 0)
                     odt_state <= ODT_WRITE_FIRST;
                  else
                     odt_state <= ODT_WRITE_PREASSERT;
               end else if (state == PRE_ISSUE_READ_0 || state == PRE_ISSUE_READ_1) begin
                  if (READ_TO_ODT_FIRST_AFI_CYC == 0)
                     odt_state <= ODT_READ_FIRST;
                  else
                     odt_state <= ODT_READ_PREASSERT;
               end
            ODT_WRITE_PREASSERT:
               if (odt_counter == WRITE_TO_ODT_FIRST_AFI_CYC - 1)
                  odt_state <= ODT_WRITE_FIRST;
            ODT_WRITE_FIRST:
               if (WRITE_TO_ODT_FIRST_AFI_CYC == WRITE_TO_ODT_LAST_AFI_CYC)
                  odt_state <= ODT_IDLE;
               else if (WRITE_TO_ODT_LAST_AFI_CYC == WRITE_TO_ODT_FIRST_AFI_CYC + 1)
                  odt_state <= ODT_WRITE_LAST;
               else
                  odt_state <= ODT_WRITE_MID;
            ODT_WRITE_MID:
               if (odt_counter == WRITE_TO_ODT_LAST_AFI_CYC - 1)
                  odt_state <= ODT_WRITE_LAST;
            ODT_WRITE_LAST:
               odt_state <= ODT_IDLE;

            ODT_READ_PREASSERT:
               if (odt_counter == READ_TO_ODT_FIRST_AFI_CYC - 1)
                  odt_state <= ODT_READ_FIRST;
            ODT_READ_FIRST:
               if (READ_TO_ODT_FIRST_AFI_CYC == READ_TO_ODT_LAST_AFI_CYC)
                  odt_state <= ODT_IDLE;
               else if (READ_TO_ODT_LAST_AFI_CYC == READ_TO_ODT_FIRST_AFI_CYC + 1)
                  odt_state <= ODT_READ_LAST;
               else
                  odt_state <= ODT_READ_MID;
            ODT_READ_MID:
               if (odt_counter == READ_TO_ODT_LAST_AFI_CYC - 1)
                  odt_state <= ODT_READ_LAST;
            ODT_READ_LAST:
               odt_state <= ODT_IDLE;
         endcase
      end
   end

   ////////////////////////////////////////////////////////////////////
   // Command-issue state machine
   ////////////////////////////////////////////////////////////////////
   always_ff @(posedge afi_clk, negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         state <= INIT;
         pnf_per_bit <= '1;
      end else begin
         case (state)
            INIT:
               if (afi_cal_success_r)
                  state <= ISSUE_ACTIVATE;
               else if (afi_cal_fail_r)
                  state <= DONE_FAILED;

            ISSUE_ACTIVATE:
               state <= WAIT_TRCD;

            WAIT_TRCD:
               if (trcd_counter[TRCD_COUNTER_WIDTH-1] == 1'b1)
                  state <= PRE_ISSUE_WRITE_0;

            PRE_ISSUE_WRITE_0:
                  state <= ISSUE_WRITE_0;

            ISSUE_WRITE_0:
               if (afi_wlat_r == 1)
                  state <= WRITE_DATA_0;
               else if (afi_wlat_r == 2)
                  state <= ISSUE_DQS_PREAMBLE_0;
               else
                  state <= WAIT_WLAT_0;

            WAIT_WLAT_0:
               if (wlat_counter == 0)
                  state <= ISSUE_DQS_PREAMBLE_0;

            ISSUE_DQS_PREAMBLE_0:
               state <= WRITE_DATA_0;

            WRITE_DATA_0:
               if (wburst_counter == 0)
                  state <= WAIT_TWTR_0;

            WAIT_TWTR_0:
               if (twtr_counter[TWTR_COUNTER_WIDTH-1] == 1'b1)
                  state <= PRE_ISSUE_READ_0;

            PRE_ISSUE_READ_0:
               state <= ISSUE_READ_0;

            ISSUE_READ_0:
               state <= WAIT_READ_0;

            WAIT_READ_0:
               if (afi_rdata_valid_r[0]) begin
                  pnf_per_bit <= ~(afi_rdata_r ^ write_0_pattern);
                  if (rburst_counter == 0)
                     state <= PRE_ISSUE_WRITE_1;
               end else if (read_timeout_counter[READ_TIMEOUT_COUNTER_WIDTH-1] == 1'b1) begin
                  state <= DONE_TIMEOUT;
               end

            PRE_ISSUE_WRITE_1:
               state <= ISSUE_WRITE_1;

            ISSUE_WRITE_1:
               if (afi_wlat_r == 1)
                  state <= WRITE_DATA_1;
               else if (afi_wlat_r == 2)
                  state <= ISSUE_DQS_PREAMBLE_1;
               else
                  state <= WAIT_WLAT_1;

            WAIT_WLAT_1:
               if (wlat_counter == 0)
                  state <= ISSUE_DQS_PREAMBLE_1;

            ISSUE_DQS_PREAMBLE_1:
               state <= WRITE_DATA_1;

            WRITE_DATA_1:
               if (wburst_counter == 0)
                  state <= WAIT_TWTR_1;

            WAIT_TWTR_1:
               if (twtr_counter[TWTR_COUNTER_WIDTH-1] == 1'b1)
                  state <= PRE_ISSUE_READ_1;

            PRE_ISSUE_READ_1:
               state <= ISSUE_READ_1;

            ISSUE_READ_1:
               state <= WAIT_READ_1;

            WAIT_READ_1:
               if (afi_rdata_valid_r[0]) begin
                  pnf_per_bit <= ~(afi_rdata_r ^ write_1_pattern);
                  if (rburst_counter == 0)
                     state <= ISSUE_PRECHARGE;
               end else if (read_timeout_counter[READ_TIMEOUT_COUNTER_WIDTH-1] == 1'b1) begin
                  state <= DONE_TIMEOUT;
               end

            ISSUE_PRECHARGE:
               state <= WAIT_TRP;

            WAIT_TRP:
               if (trp_counter[TRP_COUNTER_WIDTH-1] == 1'b1)
                  state <= NEXT_LOOP;

            NEXT_LOOP:
               if (loop_counter[LOOP_COUNTER_WIDTH-1] == 1'b1)
                  state <= NEXT_RECAL_LOOP;
               else
                  state <= ISSUE_ACTIVATE;

            NEXT_RECAL_LOOP:
               if (recal_loop_counter[RECAL_LOOP_COUNTER_WIDTH-1] == 1'b1)
                  state <= CHECK_PNF;
               else begin
                 if ( DENY_RECAL_REQUEST_AFT_SYNTH_OVRD==1 )
                   state <= INIT;
                 else
                   state <= WAIT_RECAL;
               end

            WAIT_RECAL:
               if (~afi_cal_success_r)
                  state <= INIT;
               else if (recal_timeout_counter[RECAL_TIMEOUT_COUNTER_WIDTH-1] == 1'b1)
                  state <= DONE_TIMEOUT;

            CHECK_PNF:
               if (&pnf_per_bit_persist_r)
                  state <= DONE_PASSED;
               else
                  state <= DONE_FAILED;

            DONE_PASSED:
               state <= DONE_PASSED;

            DONE_FAILED:
               state <= DONE_FAILED;

            DONE_TIMEOUT:
               state <= DONE_TIMEOUT;

            default:
               state <= INIT;
         endcase
      end
   end

   ////////////////////////////////////////////////////////////////////
   // Register transfers to PHY to ease timing closure
   ////////////////////////////////////////////////////////////////////
   always_ff @(posedge afi_clk, negedge afi_reset_n)
   begin
      if (!afi_reset_n) begin
         afi_cal_req           <= '0;
         afi_cal_success_r     <= '0;
         afi_cal_fail_r        <= '0;
         afi_wlat_r            <= '0;

         pnf_per_bit_persist   <= '1;
         pnf_per_bit_persist_r <= '1;
      end else begin
         afi_cal_req           <= afi_cal_req_c;
         afi_cal_success_r     <= afi_cal_success;
         afi_cal_fail_r        <= afi_cal_fail;
         afi_wlat_r            <= afi_wlat;

         pnf_per_bit_persist   <= pnf_per_bit_persist & pnf_per_bit;
         pnf_per_bit_persist_r <= pnf_per_bit_persist;
      end
   end

   always_ff @(posedge afi_clk)
   begin
      afi_addr          <= afi_addr_c;
      afi_ba            <= afi_ba_c;
      afi_cs_n          <= afi_cs_n_c;
      afi_odt           <= afi_odt_c;
      afi_ras_n         <= afi_ras_n_c;
      afi_cas_n         <= afi_cas_n_c;
      afi_we_n          <= afi_we_n_c;
      afi_dm            <= afi_dm_c;
      afi_dqs_burst     <= afi_dqs_burst_c;
      afi_wdata_valid   <= afi_wdata_valid_c;
      afi_wdata         <= afi_wdata_c;
      afi_rdata_en_full <= afi_rdata_en_full_c;
      afi_rdata_r       <= afi_rdata;
      afi_rdata_valid_r <= afi_rdata_valid;
      afi_par           <= afi_par_c;
      afi_rrank         <= afi_rrank_c;
      afi_wrank         <= afi_wrank_c;
   end

   // Generate parity bits
   generate
      genvar t;
      if (PORT_AFI_PAR_WIDTH != USER_CLK_RATIO) begin : no_ac_par
         assign afi_par_c = '0;
      end else begin : ac_par
         for (t = 0; t < USER_CLK_RATIO; ++t) begin : timeslot
            assign afi_par_c[t] = ^{afi_addr_c[PORT_MEM_ADDR_WIDTH * t +: PORT_MEM_ADDR_WIDTH],
                                    afi_ba_c[PORT_MEM_BA_WIDTH * t +: PORT_MEM_BA_WIDTH],
                                    afi_ras_n_c[t],
                                    afi_cas_n_c[t],
                                    afi_we_n_c[t]};
         end
      end
   endgenerate

   // AFI expects the rank switching signal to be one-hot encoded. For proper
   // shadow register switching, controller needs to one-hot encode which rank
   // is being read or write, for all the AFI time slots, into the afi_rrank
   // (if it's a read) or the afi_wrank (if it's a write) signal. The afi_rrank
   // signal must be asserted and deasserted following the timing of afi_rdata_en_full.
   // The afi_wrank signal must be asserted and deasserted following the timing of
   // afi_dqs_burst (for DDRx) or afi_wdata_valid (for non-DDRx).
   always_comb
   begin
      active_logical_rank_one_hot = '0;
      active_logical_rank_one_hot[active_logical_rank] = 1'b1;
   end

   assign afi_rrank_c = rd_en_token_shift_reg[0] ? {USER_CLK_RATIO{active_logical_rank_one_hot}} : '0;

   assign afi_wrank_c = assert_preamble_dqs_burst ? preamble_afi_wrank : (
                        assert_full_dqs_burst ? {USER_CLK_RATIO{active_logical_rank_one_hot}} : '0);

   ////////////////////////////////////////////////////////////////////
   // Terminate signals that are unused by the DDR3 AFI driver
   ////////////////////////////////////////////////////////////////////
   assign afi_ctl_refresh_done = '0;
   assign afi_ctl_long_idle = '0;
   assign afi_mps_req = '0;
   assign afi_bg = '0;
   assign afi_c = '0;
   assign afi_rm = '0;
   assign afi_act_n = '1;
   assign afi_ca = '0;
   assign afi_ref_n = '1;
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

`ifdef ALTERA_EMIF_ENABLE_ISSP
   localparam MAX_PROBE_WIDTH = 511;

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
      genvar k;
      for (k = 0; k < (PORT_AFI_RDATA_WIDTH + MAX_PROBE_WIDTH - 1) / MAX_PROBE_WIDTH; k = k + 1)
      begin : gen_pnf_width
         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             ("PNF0"),
            .probe_width             ((MAX_PROBE_WIDTH * (k+1)) > PORT_AFI_RDATA_WIDTH ? PORT_AFI_RDATA_WIDTH - (MAX_PROBE_WIDTH * k) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_pnf (
            .probe  (pnf_per_bit_persist_r[((MAX_PROBE_WIDTH * (k+1) - 1) < PORT_AFI_RDATA_WIDTH-1 ? (MAX_PROBE_WIDTH * (k+1) - 1) : PORT_AFI_RDATA_WIDTH-1) : (MAX_PROBE_WIDTH * k)])
         );
      end
   endgenerate
`endif
endmodule
