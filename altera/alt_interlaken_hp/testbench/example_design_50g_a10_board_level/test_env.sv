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


`timescale 1ns/1ps
module test_env #(
  parameter NUM_LANES          = 12,
  parameter W_BUNDLE_TO_XCVR   = 70,
  parameter W_BUNDLE_FROM_XCVR = 46,
  parameter NUM_SIXPACKS       = 2,
  parameter RXFIFO_ADDR_WIDTH  = 12,
  parameter CALENDAR_PAGES     = 1,
  parameter LOG_CALENDAR_PAGES = 1,
  parameter RX_PKTMOD_ONLY     = 1,
  parameter TX_PKTMOD_ONLY     = 1,
  parameter INCLUDE_TEMP_SENSE = 1'b1,
  parameter MM_CLK_KHZ         = 20'd100000,
  parameter MM_CLK_MHZ         = 28'd100000000,
  parameter USR_CLK_FREQ       = "300.0 MHz",
  parameter MM_CLK_FREQ        = "100.0 MHz",
  parameter INTERNAL_WORDS     = 8,
  parameter LOG_INTE_WORDS     = (INTERNAL_WORDS == 8) ? 4 : 3,
  parameter SIM_FAKE_JTAG      = 1'b0,
  parameter CNTR_BITS          = 20,   // regulate reset delay, 6 for sim, 20 for hardware
  parameter METALEN            = 2048,
  parameter USE_RECO_CTRL      = 1
) (
  input                               clk50,
  input                               pll_ref_clk,
 
  input                               usr_pb_reset_n,

  input  [NUM_LANES-1:0]              rx_pin,
  output [NUM_LANES-1:0]              tx_pin,

  output                              tx_fc_clk,
  output                              tx_fc_data,
  output                              tx_fc_sync,

  input                               rx_fc_clk,
  input                               rx_fc_data,
  input                               rx_fc_sync

);

  wire   [31:0]                       jtag_mm_address;
  wire                                jtag_mm_write;
  wire   [31:0]                       jtag_mm_writedata;
  wire                                jtag_mm_waitrequest;
  wire                                jtag_mm_read;
  wire   [31:0]                       jtag_mm_readdata;
  wire                                jtag_mm_readdatavalid;

  wire   [15:0]                       core_mm_address;
  wire                                core_mm_write;
  wire   [31:0]                       core_mm_writedata;
  wire                                core_mm_read;
  wire   [31:0]                       core_mm_readdata;
  wire                                core_mm_readdatavalid;

  wire   [15:0]                       test_mm_address;
  wire                                test_mm_write;
  wire   [31:0]                       test_mm_writedata;
  wire                                test_mm_read;
  wire   [31:0]                       test_mm_readdata;
  wire                                test_mm_readdatavalid;

  wire     [W_BUNDLE_TO_XCVR*(NUM_LANES+NUM_SIXPACKS)-1:0] reconfig_to_xcvr;
  wire   [W_BUNDLE_FROM_XCVR*(NUM_LANES+NUM_SIXPACKS)-1:0] reconfig_from_xcvr;


  wire   [64*INTERNAL_WORDS-1:0]      itx_din_words;
  wire   [LOG_INTE_WORDS-1:0]         itx_num_valid;
  wire   [7:0]                        itx_chan;
  wire                                itx_sop;
  wire   [3:0]                        itx_eopbits;
  wire                                itx_sob;
  wire                                itx_eob;
  wire   [CALENDAR_PAGES*16-1:0]      itx_calendar;
  wire                                itx_ready;
  wire                                itx_hungry;
  wire                                itx_overflow;
  wire                                itx_underflow;

  wire   [NUM_LANES-1:0]              sync_locked;
  wire   [NUM_LANES-1:0]              word_locked;
  wire                                rx_lanes_aligned;
  wire                                tx_lanes_aligned;

  wire   [64*INTERNAL_WORDS-1:0]      irx_dout_words;
  wire   [LOG_INTE_WORDS-1:0]         irx_num_valid0;
  wire   [LOG_INTE_WORDS-1:0]         irx_num_valid1;
  wire                                irx_sop;
  wire                                irx_sob;
  wire                                irx_eob;
  wire   [7:0]                        irx_chan;
  wire   [3:0]                        irx_eopbits;
  wire   [CALENDAR_PAGES*16-1:0]      irx_calendar;
  wire                                irx_overflow;

  wire                                rdc_overflow;
  wire                                rg_overflow;
  wire   [RXFIFO_ADDR_WIDTH-1:0]      rxfifo_fill_level;

  wire                                 sop_cntr_inc;
  wire                                 eop_cntr_inc;

  wire                                 crc24_err;
  wire  [NUM_LANES-1:0]                crc32_err;
  wire                                 clk_tx_common;
  wire                                 srst_tx_common;
  wire                                 clk_rx_common;
  wire                                 srst_rx_common;
  wire                                 tx_mac_srst;
  wire                                 rx_mac_srst;
  wire                                 tx_usr_srst;
  wire                                 rx_usr_srst;

  wire                                 mm_clk_alive;
  wire                                 mm_clk;
  wire                                 usr_clk;
  wire                                 usr_rst;

  wire                                 reconfig_done_d;
  wire                                 sys_pll_locked;
  wire                                 pll_srv_rst;
  wire                                 sys_pll_rst_en;
  wire                                 sys_pll_rst_req;

  wire                                 reconfig_reset;

  test_host #(
    .NUM_LANES          (NUM_LANES),
    .TX_PKTMOD_ONLY     (TX_PKTMOD_ONLY),
    .SIM_FAKE_JTAG      (SIM_FAKE_JTAG)
  ) test_host (
    .clk                   (mm_clk_alive),
    .rst                   (reconfig_reset),

    .usr_pb_reset_n        (usr_pb_reset_n),

    .jtag_mm_address       (jtag_mm_address),
    .jtag_mm_write         (jtag_mm_write),
    .jtag_mm_writedata     (jtag_mm_writedata),
    .jtag_mm_waitrequest   (jtag_mm_waitrequest),
    .jtag_mm_read          (jtag_mm_read),
    .jtag_mm_readdata      (jtag_mm_readdata),
    .jtag_mm_readdatavalid (jtag_mm_readdatavalid)
  );

  test_infra #(
    .NUM_LANES          (NUM_LANES),
    .CNTR_BITS          (CNTR_BITS),
    .W_BUNDLE_TO_XCVR   (W_BUNDLE_TO_XCVR),
    .W_BUNDLE_FROM_XCVR (W_BUNDLE_FROM_XCVR),
    .NUM_SIXPACKS       (NUM_SIXPACKS),
    .USR_CLK_FREQ       (USR_CLK_FREQ),
    .MM_CLK_FREQ        (MM_CLK_FREQ),
    .USE_RECO_CTRL      (USE_RECO_CTRL)
  ) test_infra (
    .clk50                 (clk50),
    
    .usr_pb_reset_n        (usr_pb_reset_n),

    .mm_clk_alive          (mm_clk_alive),
    .mm_clk                (mm_clk),
    .reconfig_reset        (reconfig_reset),
    .usr_clk               (usr_clk),
    .usr_rst               (usr_rst),

    .reconfig_done_d       (reconfig_done_d),
    .sys_pll_locked        (sys_pll_locked),
    .pll_srv_rst           (pll_srv_rst),
    .sys_pll_rst_en        (sys_pll_rst_en),
    .sys_pll_rst_req       (sys_pll_rst_req),

    .reconfig_to_xcvr      (reconfig_to_xcvr),
    .reconfig_from_xcvr    (reconfig_from_xcvr),

    .jtag_mm_address       (jtag_mm_address),
    .jtag_mm_write         (jtag_mm_write),
    .jtag_mm_writedata     (jtag_mm_writedata),
    .jtag_mm_waitrequest   (jtag_mm_waitrequest),
    .jtag_mm_read          (jtag_mm_read),
    .jtag_mm_readdata      (jtag_mm_readdata),
    .jtag_mm_readdatavalid (jtag_mm_readdatavalid),

    .core_mm_address       (core_mm_address),
    .core_mm_write         (core_mm_write),
    .core_mm_writedata     (core_mm_writedata),
    .core_mm_read          (core_mm_read),
    .core_mm_readdata      (core_mm_readdata),
    .core_mm_readdatavalid (core_mm_readdatavalid),

    .test_mm_address       (test_mm_address),
    .test_mm_write         (test_mm_write),
    .test_mm_writedata     (test_mm_writedata),
    .test_mm_read          (test_mm_read),
    .test_mm_readdata      (test_mm_readdata),
    .test_mm_readdatavalid (test_mm_readdatavalid)
  );

  test_agent #(
    .NUM_LANES          (NUM_LANES),
	.TX_PKTMOD_ONLY     (TX_PKTMOD_ONLY),
    .SIM_FAKE_JTAG      (SIM_FAKE_JTAG),
    .RXFIFO_ADDR_WIDTH  (RXFIFO_ADDR_WIDTH),
    .INTERNAL_WORDS     (INTERNAL_WORDS),
    .CALENDAR_PAGES     (CALENDAR_PAGES),

    .USR_CLK_FREQ       (USR_CLK_FREQ)
  ) test_agent (
   // clock & reset misc
    .usr_clk           (usr_clk),
    .usr_rst_n         (~usr_rst),
    .reconfig_done_d   (reconfig_done_d),
    .sys_pll_locked    (sys_pll_locked),
    .pll_srv_rst       (pll_srv_rst),
    .sys_pll_rst_en    (sys_pll_rst_en),
    .sys_pll_rst_req   (sys_pll_rst_req),

   // Host interface
    .mm_clk            (mm_clk_alive),
    .mm_rst            (reconfig_reset),
    .mm_address        (test_mm_address),
    .mm_write          (test_mm_write),
    .mm_writedata      (test_mm_writedata),
    .mm_read           (test_mm_read),
    .mm_readdata       (test_mm_readdata),
    .mm_readdatavalid  (test_mm_readdatavalid),

    .sync_locked       (sync_locked),
    .word_locked       (word_locked),
    .rx_lanes_aligned  (rx_lanes_aligned),
    .tx_lanes_aligned  (tx_lanes_aligned),

    .itx_din_words     (itx_din_words),
    .itx_num_valid     (itx_num_valid),
    .itx_chan          (itx_chan),
    .itx_sop           (itx_sop),
    .itx_eopbits       (itx_eopbits),
    .itx_sob           (itx_sob),
    .itx_eob           (itx_eob),
    .itx_calendar      (itx_calendar),
    .itx_ready         (itx_ready),
    .itx_hungry        (itx_hungry),
    .itx_overflow      (itx_overflow),
    .itx_underflow     (itx_underflow),
    .crc24_err         (crc24_err),
    .crc32_err         (crc32_err),
    .clk_tx_common     (clk_tx_common),
    .srst_tx_common    (srst_tx_common),
    .clk_rx_common     (clk_rx_common),
    .srst_rx_common    (srst_rx_common),
    .tx_mac_srst       (tx_mac_srst),
    .rx_mac_srst       (rx_mac_srst),
    .tx_usr_srst       (tx_usr_srst),
    .rx_usr_srst       (rx_usr_srst),

    .irx_dout_words    (irx_dout_words),
    .irx_num_valid0    (irx_num_valid0),
    .irx_num_valid1    (irx_num_valid1),
    .irx_sop           (irx_sop),
    .irx_sob           (irx_sob),
    .irx_eob           (irx_eob),
    .irx_chan          (irx_chan),
    .irx_eopbits       (irx_eopbits),
    .irx_calendar      (irx_calendar),
    .irx_overflow      (irx_overflow),
    .rdc_overflow      (rdc_overflow),
    .rg_overflow       (rg_overflow),
    .rxfifo_fill_level (rxfifo_fill_level),

    .sop_cntr_inc      (sop_cntr_inc),
    .eop_cntr_inc      (eop_cntr_inc)
  );

  test_dut #(
    .W_BUNDLE_TO_XCVR   (W_BUNDLE_TO_XCVR),
    .W_BUNDLE_FROM_XCVR (W_BUNDLE_FROM_XCVR),
    .NUM_SIXPACKS       (NUM_SIXPACKS),
    .RXFIFO_ADDR_WIDTH  (RXFIFO_ADDR_WIDTH),
    .CNTR_BITS          (CNTR_BITS),
    .NUM_LANES          (NUM_LANES),
    .CALENDAR_PAGES     (CALENDAR_PAGES),
    .TX_PKTMOD_ONLY     (TX_PKTMOD_ONLY),
    .RX_PKTMOD_ONLY     (RX_PKTMOD_ONLY),
    .LOG_CALENDAR_PAGES (LOG_CALENDAR_PAGES),
    .INCLUDE_TEMP_SENSE (INCLUDE_TEMP_SENSE),
    .METALEN            (METALEN),
    .MM_CLK_KHZ         (MM_CLK_KHZ),
    .MM_CLK_MHZ         (MM_CLK_MHZ),
    .INTERNAL_WORDS     (INTERNAL_WORDS)
  ) test_dut (
    .tx_usr_clk         (usr_clk),
    .rx_usr_clk         (usr_clk),
    .reset_n            (~usr_rst),
    .pll_ref_clk        (pll_ref_clk),
    .rx_pin             (rx_pin),
    .tx_pin             (tx_pin),

    .sync_locked        (sync_locked),
    .word_locked        (word_locked),
    .rx_lanes_aligned   (rx_lanes_aligned),
    .tx_lanes_aligned   (tx_lanes_aligned),

    .itx_din_words      (itx_din_words),
    .itx_num_valid      (itx_num_valid),
    .itx_chan           (itx_chan),
    .itx_sop            (itx_sop),
    .itx_eopbits        (itx_eopbits),
    .itx_sob            (itx_sob),
    .itx_eob            (itx_eob),
    .itx_calendar       (itx_calendar),

    .burst_max_in       (4'h4),
    .burst_short_in     (4'h2),
    .burst_min_in       (4'h2),

    .itx_ready          (itx_ready),
    .itx_hungry         (itx_hungry),
    .itx_overflow       (itx_overflow),
    .itx_underflow      (itx_underflow),
    .crc24_err          (crc24_err),
    .crc32_err          (crc32_err),
    .clk_tx_common      (clk_tx_common),
    .srst_tx_common     (srst_tx_common),
    .clk_rx_common      (clk_rx_common),
    .srst_rx_common     (srst_rx_common),
    .tx_mac_srst        (tx_mac_srst),
    .rx_mac_srst        (rx_mac_srst),
    .tx_usr_srst        (tx_usr_srst),
    .rx_usr_srst        (rx_usr_srst),

    .irx_dout_words     (irx_dout_words),
    .irx_num_valid0     (irx_num_valid0),
    .irx_num_valid1     (irx_num_valid1),
    .irx_sop            (irx_sop),
    .irx_sob            (irx_sob),
    .irx_eob            (irx_eob),
    .irx_chan           (irx_chan),
    .irx_eopbits        (irx_eopbits),

    .irx_calendar       (irx_calendar),

    .irx_overflow       (irx_overflow),
    .rdc_overflow       (rdc_overflow),
    .rg_overflow        (rg_overflow),
    .rxfifo_fill_level  (rxfifo_fill_level),

    .tx_fc_clk          (tx_fc_clk),
    .tx_fc_data         (tx_fc_data),
    .tx_fc_sync         (tx_fc_sync),

    .rx_fc_clk          (rx_fc_clk),
    .rx_fc_data         (rx_fc_data),
    .rx_fc_sync         (rx_fc_sync),

    .mm_clk             (mm_clk),
    .mm_read            (core_mm_read),
    .mm_write           (core_mm_write),
    .mm_addr            (core_mm_address),
    .mm_rdata           (core_mm_readdata),
    .mm_rdata_valid     (core_mm_readdatavalid),
    .mm_wdata           (core_mm_writedata),

    .sop_cntr_inc       (sop_cntr_inc),
    .eop_cntr_inc       (eop_cntr_inc),

    .reconfig_to_xcvr   (reconfig_to_xcvr),
    .reconfig_from_xcvr (reconfig_from_xcvr)

  );

endmodule
