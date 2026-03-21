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



module altera_emif_ctrl_qdr2 # (
   parameter   PROTOCOL_ENUM                          = "",
   parameter   USER_CLK_RATIO                         = 1,
   parameter   CTRL_BL                                = 4,
   parameter   CTRL_BWS_EN                            = 1,
   parameter   MAX_AFI_WLAT                           = 1,

   // AFI 4.0 INTERFACE PARAMETERS
   parameter   PORT_AFI_ADDR_WIDTH                    = 1,
   parameter   PORT_AFI_BWS_N_WIDTH                   = 1,
   parameter   PORT_AFI_RDATA_WIDTH                   = 1,
   parameter   PORT_AFI_WDATA_WIDTH                   = 1,
   parameter   PORT_AFI_WPS_N_WIDTH                   = 1,
   parameter   PORT_AFI_RPS_N_WIDTH                   = 1,
   parameter   PORT_AFI_RDATA_EN_FULL_WIDTH           = 1,
   parameter   PORT_AFI_RDATA_VALID_WIDTH             = 1,
   parameter   PORT_AFI_WDATA_VALID_WIDTH             = 1,
   parameter   PORT_AFI_WLAT_WIDTH                    = 1,
   
   // AVALON INTERFACE PARAMETERS
   parameter   PORT_CTRL_AMM_ADDRESS_WIDTH            = 1,
   parameter   PORT_CTRL_AMM_BCOUNT_WIDTH             = 1,
   parameter   PORT_CTRL_AMM_BYTEEN_WIDTH             = 1,
   parameter   PORT_CTRL_AMM_RDATA_WIDTH              = 1,
   parameter   PORT_CTRL_AMM_WDATA_WIDTH              = 1
) (
   // Clock and reset interface
   input    logic                                     afi_clk,
   input    logic                                     afi_reset_n,
   
   // Avalon data slave write interface
   output   logic                                     avl_w_ready,
   input    logic                                     avl_w_write_req,
   input    logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   avl_w_addr,
   input    logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]    avl_w_burstcount,
   input    logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]    avl_w_be,
   input    logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]     avl_w_wdata,

   // Avalon data slave read interface
   output   logic                                     avl_r_ready,
   input    logic                                     avl_r_read_req,
   input    logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]   avl_r_addr,
   input    logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]    avl_r_burstcount,
   output   logic                                     avl_r_rdata_valid,
   output   logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]     avl_r_rdata,

   // AFI 4.0 interface
   output   logic [PORT_AFI_ADDR_WIDTH-1:0]           afi_addr,
   output   logic [PORT_AFI_WPS_N_WIDTH-1:0]          afi_wps_n,
   output   logic [PORT_AFI_RPS_N_WIDTH-1:0]          afi_rps_n,
   output   logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]    afi_wdata_valid,
   output   logic [PORT_AFI_WDATA_WIDTH-1:0]          afi_wdata,
   output   logic [PORT_AFI_BWS_N_WIDTH-1:0]          afi_bws_n,
   output   logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]  afi_rdata_en_full,
   input    logic [PORT_AFI_RDATA_WIDTH-1:0]          afi_rdata,
   input    logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]    afi_rdata_valid,
   input    logic                                     afi_cal_success,
   input    logic                                     afi_cal_fail,
   input    logic [PORT_AFI_WLAT_WIDTH-1:0]           afi_wlat,

   // Status signals
   output   logic                                     local_init_done
);
   timeunit 1ps;
   timeprecision 1ps;

   //////////////////////////////////////////////////////////////////////////////
   // BEGIN LOCALPARAM SECTION

   // The number of resynchronized resets to create at this level
   localparam NUM_CONTROLLER_RESET           = 7;

   // END LOCALPARAM SECTION
   //////////////////////////////////////////////////////////////////////////////

   // Resynchronized reset signal
   wire   [NUM_CONTROLLER_RESET-1:0]         resync_afi_reset_n;

   // User interface module signals
   wire                                      data_if_write_req;
   wire                                      data_if_read_req;
   wire   [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]  data_if_write_addr;
   wire   [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]  data_if_read_addr;
   wire   [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]   data_if_be;
   wire   [PORT_CTRL_AMM_WDATA_WIDTH-1:0]    data_if_wdata;
   wire                                      data_if_rdata_valid;
   wire   [PORT_CTRL_AMM_RDATA_WIDTH-1:0]    data_if_rdata;

   // State machine command outputs
   wire                                      do_write;
   wire                                      do_read;
   wire                                      pop_req;
   
   // Register all AFI signals for timing closure
   logic [PORT_AFI_ADDR_WIDTH-1:0]           afi_addr_pre_r;
   logic [PORT_AFI_WPS_N_WIDTH-1:0]          afi_wps_n_pre_r;
   logic [PORT_AFI_RPS_N_WIDTH-1:0]          afi_rps_n_pre_r;
   logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]    afi_wdata_valid_pre_r;
   logic [PORT_AFI_WDATA_WIDTH-1:0]          afi_wdata_pre_r;
   logic [PORT_AFI_BWS_N_WIDTH-1:0]          afi_bws_n_pre_r;
   logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]  afi_rdata_en_full_pre_r;
   logic [PORT_AFI_ADDR_WIDTH-1:0]           afi_addr_r;
   logic [PORT_AFI_WPS_N_WIDTH-1:0]          afi_wps_n_r;
   logic [PORT_AFI_RPS_N_WIDTH-1:0]          afi_rps_n_r;
   logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]    afi_wdata_valid_r;
   logic [PORT_AFI_WDATA_WIDTH-1:0]          afi_wdata_r;
   logic [PORT_AFI_BWS_N_WIDTH-1:0]          afi_bws_n_r;
   logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]  afi_rdata_en_full_r;
   logic [PORT_AFI_RDATA_WIDTH-1:0]          afi_rdata_r;
   logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]    afi_rdata_valid_r;
   logic                                     afi_cal_success_r;
   logic                                     afi_cal_fail_r;
   logic [PORT_AFI_WLAT_WIDTH-1:0]           afi_wlat_r;
   
   // Create a synchronized version of the reset against the controller clock
   altera_emif_ctrl_reset_sync # (
      .NUM_RESET_OUTPUT (NUM_CONTROLLER_RESET)
   ) ureset_afi_clk (
      .reset_n          (afi_reset_n),
      .clk              (afi_clk),
      .reset_n_sync     (resync_afi_reset_n)
   );
   
   // Register all AFI signals for timing closure
   always @(posedge afi_clk or negedge resync_afi_reset_n[0])
   begin
      if (!resync_afi_reset_n[0]) begin
         afi_cal_success_r <= 1'b0;
         afi_cal_fail_r    <= 1'b0;
      end else begin
         afi_cal_success_r <= afi_cal_success;
         afi_cal_fail_r    <= afi_cal_fail;
      end
   end
   
   always @(posedge afi_clk)
   begin
      afi_addr_r          <= afi_addr_pre_r;
      afi_wps_n_r         <= afi_wps_n_pre_r;
      afi_rps_n_r         <= afi_rps_n_pre_r;
      afi_wdata_valid_r   <= afi_wdata_valid_pre_r;
      afi_wdata_r         <= afi_wdata_pre_r;
      afi_bws_n_r         <= afi_bws_n_pre_r;
      afi_rdata_en_full_r <= afi_rdata_en_full_pre_r;
      afi_rdata_r         <= afi_rdata;
      afi_rdata_valid_r   <= afi_rdata_valid;
      afi_wlat_r          <= afi_wlat;
   end
   
   assign afi_addr          = afi_addr_r;
   assign afi_wps_n         = afi_wps_n_r;
   assign afi_rps_n         = afi_rps_n_r;
   assign afi_wdata_valid   = afi_wdata_valid_r;
   assign afi_wdata         = afi_wdata_r;
   assign afi_bws_n         = afi_bws_n_r;
   assign afi_rdata_en_full = afi_rdata_en_full_r;
   
   
   // Avalon read interface module
   altera_emif_ctrl_data_if # (
      .PORT_CTRL_AMM_ADDRESS_WIDTH           (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH            (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_CTRL_AMM_BYTEEN_WIDTH            (PORT_CTRL_AMM_BYTEEN_WIDTH),
      .PORT_CTRL_AMM_DATA_WIDTH              (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_BEATADDER_WIDTH             (0),
      .CTRL_BE_EN                            (CTRL_BWS_EN),
      .CTRL_BL                               (1),
      .PROTOCOL_ENUM                         (PROTOCOL_ENUM)
   ) data_if_r (
      .clk                          (afi_clk),
      .reset_n                      (resync_afi_reset_n[1]),
      .init_complete                (afi_cal_success_r),
      .init_fail                    (afi_cal_fail_r),
      .local_init_done              (),
      .avl_ready                    (avl_r_ready),
      .avl_write_req                (1'b0),
      .avl_read_req                 (avl_r_read_req),
      .avl_addr                     (avl_r_addr),
      .avl_size                     (avl_r_burstcount),
      .avl_be                       ({PORT_CTRL_AMM_BYTEEN_WIDTH{1'b0}}),
      .avl_wdata                    ({PORT_CTRL_AMM_WDATA_WIDTH{1'b0}}),
      .avl_rdata_valid              (avl_r_rdata_valid),
      .avl_rdata                    (avl_r_rdata),
      .wdata_valid                  (),
      .wdata                        (),
      .be                           (),
      .cmd0_write_req               (),
      .cmd0_read_req                (),
      .cmd0_addr                    (),
      .cmd0_addr_can_merge          (),
      .cmd1_write_req               (),
      .cmd1_read_req                (data_if_read_req),
      .cmd1_addr                    (data_if_read_addr),
      .cmd1_addr_can_merge          (),
      .cmd1_wdata                   (),
      .cmd1_be                      (),
      .rdata_valid                  (data_if_rdata_valid),
      .rdata                        (data_if_rdata),
      .pop_req                      (pop_req));

   // Avalon write interface module
   altera_emif_ctrl_data_if # (
      .PORT_CTRL_AMM_ADDRESS_WIDTH           (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_BCOUNT_WIDTH            (PORT_CTRL_AMM_BCOUNT_WIDTH),
      .PORT_CTRL_AMM_BYTEEN_WIDTH            (PORT_CTRL_AMM_BYTEEN_WIDTH),
      .PORT_CTRL_AMM_DATA_WIDTH              (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_BEATADDER_WIDTH             (0),
      .CTRL_BE_EN                            (CTRL_BWS_EN),
      .CTRL_BL                               (1),
      .PROTOCOL_ENUM                         (PROTOCOL_ENUM)
   ) data_if_w (
      .clk                          (afi_clk),
      .reset_n                      (resync_afi_reset_n[2]),
      .init_complete                (afi_cal_success_r),
      .init_fail                    (afi_cal_fail_r),
      .local_init_done              (local_init_done),
      .avl_ready                    (avl_w_ready),
      .avl_write_req                (avl_w_write_req),
      .avl_read_req                 (1'b0),
      .avl_addr                     (avl_w_addr),
      .avl_size                     (avl_w_burstcount),
      .avl_be                       (avl_w_be),
      .avl_wdata                    (avl_w_wdata),
      .avl_rdata_valid              (),
      .avl_rdata                    (),
      .wdata_valid                  (),
      .wdata                        (),
      .be                           (),
      .cmd0_write_req               (),
      .cmd0_read_req                (),
      .cmd0_addr                    (),
      .cmd0_addr_can_merge          (),
      .cmd1_write_req               (data_if_write_req),
      .cmd1_read_req                (),
      .cmd1_addr                    (data_if_write_addr),
      .cmd1_addr_can_merge          (),
      .cmd1_wdata                   (data_if_wdata),
      .cmd1_be                      (data_if_be),
      .rdata_valid                  (1'b0),
      .rdata                        ({PORT_CTRL_AMM_RDATA_WIDTH{1'b0}}),
      .pop_req                      (do_write));

   // Main state machine
   altera_emif_ctrl_qdr2_fsm # (
      .USER_CLK_RATIO               (USER_CLK_RATIO),
      .CTRL_BL                      (CTRL_BL)
   ) fsm_r (
      .clk                          (afi_clk),
      .reset_n                      (resync_afi_reset_n[3]),
      .init_complete                (afi_cal_success_r),
      .init_fail                    (afi_cal_fail_r),
      .write_req                    (data_if_write_req),
      .read_req                     (data_if_read_req),
      .do_read                      (do_read),
      .do_write                     ());

   altera_emif_ctrl_qdr2_fsm # (
      .USER_CLK_RATIO               (USER_CLK_RATIO),
      .CTRL_BL                      (CTRL_BL)
   ) fsm_pop_req (
      .clk                          (afi_clk),
      .reset_n                      (resync_afi_reset_n[4]),
      .init_complete                (afi_cal_success_r),
      .init_fail                    (afi_cal_fail_r),
      .write_req                    (data_if_write_req),
      .read_req                     (data_if_read_req),
      .do_read                      (pop_req),
      .do_write                     ());
      
   altera_emif_ctrl_qdr2_fsm # (
      .USER_CLK_RATIO               (USER_CLK_RATIO),
      .CTRL_BL                      (CTRL_BL)
   ) fsm_w (
      .clk                          (afi_clk),
      .reset_n                      (resync_afi_reset_n[5]),
      .init_complete                (afi_cal_success_r),
      .init_fail                    (afi_cal_fail_r),
      .write_req                    (data_if_write_req),
      .read_req                     (data_if_read_req),
      .do_read                      (),
      .do_write                     (do_write));   

   // AFI 4.0 interface module
   altera_emif_ctrl_qdr2_afi # (
      .USER_CLK_RATIO               (USER_CLK_RATIO),
      .CTRL_BL                      (CTRL_BL),
      .CTRL_BWS_EN                  (CTRL_BWS_EN),
      .MAX_AFI_WLAT                 (MAX_AFI_WLAT),
      .PORT_CTRL_AMM_RDATA_WIDTH    (PORT_CTRL_AMM_RDATA_WIDTH),
      .PORT_CTRL_AMM_ADDRESS_WIDTH  (PORT_CTRL_AMM_ADDRESS_WIDTH),
      .PORT_CTRL_AMM_WDATA_WIDTH    (PORT_CTRL_AMM_WDATA_WIDTH),
      .PORT_CTRL_AMM_BYTEEN_WIDTH   (PORT_CTRL_AMM_BYTEEN_WIDTH),
      .PORT_AFI_ADDR_WIDTH          (PORT_AFI_ADDR_WIDTH),
      .PORT_AFI_BWS_N_WIDTH         (PORT_AFI_BWS_N_WIDTH),
      .PORT_AFI_RDATA_WIDTH         (PORT_AFI_RDATA_WIDTH),
      .PORT_AFI_WDATA_WIDTH         (PORT_AFI_WDATA_WIDTH),
      .PORT_AFI_WPS_N_WIDTH         (PORT_AFI_WPS_N_WIDTH),
      .PORT_AFI_RPS_N_WIDTH         (PORT_AFI_RPS_N_WIDTH),
      .PORT_AFI_RDATA_EN_FULL_WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH),
      .PORT_AFI_RDATA_VALID_WIDTH   (PORT_AFI_RDATA_VALID_WIDTH),
      .PORT_AFI_WDATA_VALID_WIDTH   (PORT_AFI_WDATA_VALID_WIDTH),
      .PORT_AFI_WLAT_WIDTH          (PORT_AFI_WLAT_WIDTH)
   ) afi (
      .clk                          (afi_clk),
      .reset_n                      (resync_afi_reset_n[6]),
      .do_write                     (do_write),
      .do_read                      (do_read),
      .write_addr                   (data_if_write_addr),
      .read_addr                    (data_if_read_addr),
      .be                           (data_if_be),
      .wdata                        (data_if_wdata),
      .rdata_valid                  (data_if_rdata_valid),
      .rdata                        (data_if_rdata),
      .afi_wlat                     (afi_wlat_r),
      .afi_addr                     (afi_addr_pre_r),
      .afi_wps_n                    (afi_wps_n_pre_r),
      .afi_rps_n                    (afi_rps_n_pre_r),
      .afi_wdata_valid              (afi_wdata_valid_pre_r),
      .afi_wdata                    (afi_wdata_pre_r),
      .afi_bws_n                    (afi_bws_n_pre_r),
      .afi_rdata_en_full            (afi_rdata_en_full_pre_r),
      .afi_rdata                    (afi_rdata_r),
      .afi_rdata_valid              (afi_rdata_valid_r)
   );

endmodule

