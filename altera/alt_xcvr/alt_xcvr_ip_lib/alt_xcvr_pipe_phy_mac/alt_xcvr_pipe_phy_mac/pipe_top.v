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


/* Top.sv
Details:
  Wires together three sub sections: a data handler, a mac and a phy.  The inputs
  and output to this module will include resets, clocks and the serial input and
  serial output.  It uses parameters to handle serial data input and output to
  accomodate for the various bonding variations and parallel data width.

Submodules and hierarchy:
Top.sv
  data_handle_top.v
    data_generator.v
      prbs_generator.v
      walking_one_generator.v
      counter_generator.v
      parallel_data_packager.v
    data_checker.v
      prbs_checker.v
      walking_one_verifier.v
      counter_verifier.v
      data_unpacker.v
        parallel_data_deskew.v
  mac_top.v
    ltssm_top.v
    ltssm_control_signal.v
    ltssm_adapter.v
  pipe_top.v
    native_phy.v
    pll.v
    reset_controller.v
*/

module pipe_top #(
  parameter mac_control       = "ltssm",  // ltssm, manual
  parameter max_rate          = "gen2",   // gen1, gen2, gen3
  parameter lanes             = 1,        // 1, 2, 4, 8
  parameter pld_if_dw         = 16,       // 8, 16, 32
  parameter words_pld_if      = 2,
  parameter cdr_refclk        = "100Mhz", // 100Mhz, 125Mhz
  parameter data_pattern      = "walking_one",   // prbs, counter, hw, lf, walking_one,checkerboard
  parameter fast_sim          = "true",   // true, false
  parameter phy_control       = "mac",    // mac, top
  parameter compliance        = "false"   // true, false
) 
(
  //Input signals from the testbench such as clocks and resets
  input                                  core_clk,
  input                                  core_ref_clk,
  input                                  core_reset,

  //Input control signals from the top level
  input                                  core_tx_detectrx,  //change fomr core to pld or top
  input                                  core_tx_elecidle,  //avmm and CSR
  input                                  core_tx_swing,     //top avalon port do both csr + phy
  input                                  core_rx_polarity,
  input  [1:0]                           core_rx_preset_hint,
  input  [1:0]                           core_powerdown,
  input  [1:0]                           core_rate,
  input  [1:0]                           core_tx_margin,
  input  [17:0]                          core_tx_deemphasis,

  //Output status signals from the phy
  input  [lanes-1:0]                     phy_status,

  //Output from PHY MAC to XCVR
  output [lanes*pld_if_dw -1:0]          data_tx_data,
  output [lanes*words_pld_if-1:0]        data_tx_datak,
  output [lanes-1:0]                     data_tx_data_valid,
  output [lanes-1:0]                     data_tx_blk_start,
  output [2*lanes-1:0]                   data_tx_sync_hdr,
  output [lanes-1:0]                     mac_tx_detectrx,
  output [lanes*words_pld_if-1:0]        mac_tx_elecidle,
  output [lanes*words_pld_if-1:0]        mac_compliance,
  output [lanes-1:0]                     mac_rx_polarity,
  output [lanes*2-1:0]                   mac_powerdown,
  output [lanes*2-1:0]                   mac_rate,

  //Input from XCVR to PHY MAC
  input  [lanes-1:0]                     pipe_pclk,
  input  [lanes*words_pld_if-1:0]        phy_rx_syncstatus,
  input  [lanes*pld_if_dw -1:0]          phy_rx_data,
  input  [lanes*words_pld_if-1:0]        phy_rx_datak,
  input  [lanes-1:0]                     phy_rx_valid,
  input  [lanes*2-1:0]                   phy_rx_sync_hdr,
  input  [lanes-1:0]                     phy_rx_blk_start,
  input  [lanes-1:0]                     phy_rx_data_valid,
  input  [lanes-1:0]                     phy_rx_elecidle,
  input  [lanes*3-1:0]                   phy_rx_status,
 
  //output from the data generator TO TB
  output                                 data_rx_infer_elecidle,
  output [1:0]                           data_end_ts,

  //output to the testbench from the MAC TO TB
  output                                 test_complete,
  output                                 ltssm_tx_elecidle,
  output                                 ltssm_tx_detectrx,
  output [1:0]                           ltssm_rate,
  output [1:0]                           ltssm_powerdown,
  output [3:0]                           ltssm_state,
  output [lanes-1:0]                     data_errors,

  //Manual control
  input                                  manual_control
);


//wires for outputs from the data handler to the various blocks
wire                          data_end_packet;
wire [lanes-1:0]              data_rx_polarity;

//Wires for outputs from the mac to the various blocks
wire                          pclk;
wire                          mac_send_data;         
wire                          mac_ltssm_recovery;
wire [1:0]                    mac_send_ts;
wire [lanes-1:0]              mac_tx_elecidle_int;
wire [lanes-1:0]              mac_tx_swing;
wire [lanes*2-1:0]            mac_rx_preset_hint;
wire [lanes*2-1:0]            mac_tx_margin;
wire [lanes*18-1:0]           mac_tx_deemphasis;

//integers and genvars
integer i;

//assigns for output
assign mac_compliance     = {lanes*words_pld_if{1'b0}};
assign mac_tx_elecidle    = {words_pld_if{mac_tx_elecidle_int}};
assign ltssm_rate         = mac_rate[1:0];
assign ltssm_powerdown    = mac_powerdown[1:0];
assign ltssm_tx_elecidle  = mac_tx_elecidle_int[0];
assign ltssm_tx_detectrx  = mac_tx_detectrx[0];
assign pclk               = pipe_pclk[lanes/2];

//Handles data to and from the phy.  Will manage lane skew, pattern generation
//data valid and will manage tranining sequences between the Mac and PHY 
pipe_data_top #(
  .max_rate                      (max_rate),
  .lanes                         (lanes),
  .fast_sim                      (fast_sim),
  .pld_if_dw                     (pld_if_dw),
  .pattern                       (data_pattern),
  .words_pld_if                  (words_pld_if)
) data_handler (
  //generic inputs
  .pclk                          (pclk),
  .reset                         (core_reset),

  //inputs from the MAC
  .ltssm_recovery                (mac_ltssm_recovery),
  .send_data                     (mac_send_data),
  .send_ts                       (mac_send_ts),
  
  //Data Inputs from the PHY
  .rate                          (mac_rate),
  .rx_data_in                    (phy_rx_data),
  .rx_datak                      (phy_rx_datak),
  .rx_sync_hdr                   (phy_rx_sync_hdr),
  .rx_blk_start                  (phy_rx_blk_start),
  .rx_data_valid                 (phy_rx_data_valid),
  .rx_valid                      (phy_rx_valid),
  .rx_syncstatus                 (phy_rx_syncstatus),

  //Data Outputs to the PHY
  .tx_data_out                   (data_tx_data),
  .tx_datak                      (data_tx_datak),
  .tx_sync_hdr                   (data_tx_sync_hdr),
  .tx_blk_start                  (data_tx_blk_start),
  .tx_data_valid                 (data_tx_data_valid),
  .polarity                      (data_rx_polarity),

  //Data Outputs to the MAC
  .rx_infer_elecidle             (data_rx_infer_elecidle),
  .end_ts                        (data_end_ts),
  .end_packet                    (data_end_packet),
  .errors                        (data_errors)
);

//Performs the various LTSSM sequences to train the link, and assert and check
//various control signals for loopback,
pipe_mac_top #(
  .mode                          (mac_control),  
  .max_rate                      (max_rate),
  .lanes                         (lanes),
  .phy_control                   (phy_control),
  .pld_if_dw                     (pld_if_dw),
  .fast_sim                      (fast_sim),
  .compliance                    (compliance)
) mac_top (
  //input signals
  .pclk                          (pclk),
  .reset                         (core_reset),
  .incr_state                    (manual_control),

  //input signals from data generator
  .in_infer_elecidle             (data_rx_infer_elecidle),
  .in_ts_complete                (data_end_ts),
  .in_data_complete              (data_end_packet),
  .in_data_polarity              (data_rx_polarity),

  //input signals from the top for unit-test like functionality
  .top_tx_detectrx               (core_tx_detectrx),
  .top_tx_elecidle               (core_tx_elecidle),
  .top_tx_swing                  (core_tx_swing),
  .top_rx_polarity               (core_rx_polarity),
  .top_rx_preset_hint            (core_rx_preset_hint),
  .top_powerdown                 (core_powerdown),
  .top_rate                      (core_rate),
  .top_tx_margin                 (core_tx_margin),
  .top_tx_deemphasis             (core_tx_deemphasis),

  //input signals from phy
  .phy_phy_status                (phy_status),
  .phy_rx_elecidle               (phy_rx_elecidle),
  .phy_data_valid                (phy_rx_valid),
  .phy_rx_status                 (phy_rx_status),

  //output to data generator
  .out_ltssm_recovery            (mac_ltssm_recovery),
  .out_send_data                 (mac_send_data),
  .out_send_ts                   (mac_send_ts),

  //output to the phy
  .phy_tx_detectrx               (mac_tx_detectrx),
  .phy_tx_elecidle               (mac_tx_elecidle_int),
  .phy_tx_swing                  (),
  .phy_rx_polarity               (mac_rx_polarity),
  .phy_rx_preset_hint            (),
  .phy_powerdown                 (mac_powerdown),
  .phy_rate                      (mac_rate),
  .phy_tx_margin                 (),
  .phy_tx_deemphasis             (),

  //output to the testbench
  .ltssm_state                   (ltssm_state),
  .test_complete                 (test_complete)
);

endmodule
