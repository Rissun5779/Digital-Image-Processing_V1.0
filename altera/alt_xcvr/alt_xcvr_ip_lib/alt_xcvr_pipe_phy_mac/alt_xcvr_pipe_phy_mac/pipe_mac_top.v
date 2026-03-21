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


module pipe_mac_top #(
  parameter mode            = "auto",  // pipe_gen12, pipe_gen3
  parameter max_rate        = "gen2",
  parameter lanes           = 1,
  parameter phy_control     = "mac",
  parameter pld_if_dw       = 16,
  parameter fast_sim        = "true",
  parameter compliance      = "false"
) 
(
  //input signals
  input                 pclk,
  input                 reset,
  input                 incr_state,

  //input signals from data generator
  input                 in_infer_elecidle,
  input                 in_data_complete,
  input [1:0]           in_ts_complete,
  input [lanes-1:0]     in_data_polarity,

  //input signals from the top for unit-test like control
  input                 top_tx_detectrx,
  input                 top_tx_elecidle,
  input                 top_tx_swing,
  input                 top_rx_polarity,
  input [1:0]           top_rx_preset_hint,
  input [1:0]           top_powerdown,
  input [1:0]           top_rate,
  input [1:0]           top_tx_margin,
  input [17:0]          top_tx_deemphasis,

  //input signals from phy
  input [lanes-1:0]     phy_phy_status,
  input [lanes-1:0]     phy_rx_elecidle,
  input [lanes-1:0]     phy_data_valid,
  input [lanes*3-1:0]   phy_rx_status,

  //output to data generator
  output                out_ltssm_recovery,
  output                out_send_data,
  output [1:0]          out_send_ts,

  //output to the phy
  output [lanes-1:0]    phy_tx_detectrx,
  output [lanes-1:0]    phy_tx_elecidle,
  output [lanes-1:0]    phy_tx_swing,
  output [lanes-1:0]    phy_rx_polarity,
  output [lanes*2-1:0]  phy_rx_preset_hint,
  output [lanes*2-1:0]  phy_powerdown,
  output [lanes*2-1:0]  phy_rate,
  output [lanes*2-1:0]  phy_tx_margin,
  output [lanes*18-1:0] phy_tx_deemphasis,

  //output to the testbench
  output [3:0]          ltssm_state,
  output                test_complete
);

//wires to the master ltssm
wire              adp_polarity;
wire              adp_phy_status;
wire              adp_rx_elecidle;
wire              adp_data_valid;
wire              adp_rx_status;

//wires from the control signals to the signal converstion block
wire              adp_tx_detectrx;
wire              adp_tx_elecidle;
wire              adp_tx_swing;
wire              adp_rx_polarity;
wire [1:0]        adp_preset_hint;
wire [1:0]        adp_powerdown;
wire [1:0]        adp_rate;
wire [1:0]        adp_tx_margin;
wire [17:0]       adp_tx_deemphasis;
wire [3:0]        ltssm_comply_count;
wire [lanes-1:0]  phy_rx_elecidle_sync;

//assign out_ltssm_recovery = (ltssm_state >= 4'd8 && ltssm_state <= 4'd11);

//Synchronize the rx_elecidle signals
resync #(
  .SYNC_CHAIN_LENGTH (2),
  .WIDTH             (lanes),
  .SLOW_CLOCK        (0),
  .INIT_VALUE        (0)
) synch_rx_elecidle (
  .clk               (pclk),
  .reset             (reset),
  .d                 (phy_rx_elecidle),
  .q                 (phy_rx_elecidle_sync)
);

//manages and synchrnizes the various channel ltssm
pipe_ltssm_sm #(
  .mode                                          (mode),
  .max_rate                                      (max_rate),
  .pld_if_dw                                     (pld_if_dw),
  .fast_sim                                      (fast_sim),
  .compliance                                    (compliance)
) master_ltssm (
  //inputs signals
  .pclk                                          (pclk),
  .reset                                         (reset),

  //inputs signals from the converter block
  .rx_status                                     (adp_rx_status),
  .rx_elecidle                                   (adp_rx_elecidle),
  .phy_status                                    (adp_phy_status),
  .data_valid                                    (adp_data_valid),
  .ts_complete                                   (in_ts_complete),
  .data_complete                                 (in_data_complete),
  .polarity                                      (adp_polarity),

  //Input rate from the control signals
  .rate                                          (adp_rate),

  //esternal control input 
  .ext_control                                   (incr_state),

  //output state for the contrl status statemachine
  .rx_infer_elecidle                             (in_infer_elecidle),
  .recovery                                      (out_ltssm_recovery),
  .link_active                                   (test_complete),
  .state                                         (ltssm_state),
  .comply_count                                  (ltssm_comply_count)
);


//various statemachines for the ltssm on a channel-by-channel basis
pipe_ltssm_control_signal #(
  .max_rate                                      (max_rate)
) slave_ltssm(
  //input signals
  .pclk                                          (pclk),
  .reset                                         (reset),

  //input from the ltssm
  .state                                         (ltssm_state),
  .comply_count                                  (ltssm_comply_count),
  .detect_polarity                               (adp_polarity),
  
  //output control signals to the PHY
  .tx_detectrx                                   (adp_tx_detectrx),
  .tx_elecidle                                   (adp_tx_elecidle),
  .tx_swing                                      (adp_tx_swing),
  .rx_polarity                                   (adp_rx_polarity),
  .rx_preset_hint                                (adp_preset_hint),
  .powerdown                                     (adp_powerdown),
  .rate                                          (adp_rate),
  .tx_margin                                     (adp_tx_margin),
  .tx_deemphasis                                 (adp_tx_deemphasis),

  //outputs to the data generator
  .send_ts                                       (out_send_ts),
  .send_data                                     (out_send_data)
);

pipe_ltssm_adapter #(
  .max_rate                                      (max_rate),
  .lanes                                         (lanes),
  .phy_control                                   (phy_control)
) ss_translation (
  //input control signals
  .pclk                                          (pclk),
  .reset                                         (reset),

  //input control signals from the control block
  .cs_tx_detectrx                                (adp_tx_detectrx),
  .cs_tx_elecidle                                (adp_tx_elecidle),
  .cs_tx_swing                                   (adp_tx_swing),
  .cs_rx_polarity                                (adp_rx_polarity),
  .cs_preset_hint                                (adp_preset_hint),
  .cs_powerdown                                  (adp_powerdown),
  .cs_rate                                       (adp_rate),
  .cs_tx_margin                                  (adp_tx_margin),
  .cs_tx_deemphasis                              (adp_tx_deemphasis),

  //inputs signals from the top-level wrapper for unit-test like contro
  .top_tx_detectrx                                (top_tx_detectrx),
  .top_tx_elecidle                                (top_tx_elecidle),
  .top_tx_swing                                   (top_tx_swing),
  .top_rx_polarity                                (top_rx_polarity),
  .top_preset_hint                                (top_rx_preset_hint),
  .top_powerdown                                  (top_powerdown),
  .top_rate                                       (top_rate),
  .top_tx_margin                                  (top_tx_margin),
  .top_tx_deemphasis                              (top_tx_deemphasis),

  //input signals from the PHY
  .phy_phy_status                                (phy_phy_status),
  .phy_rx_elecidle                               (phy_rx_elecidle_sync),
  .phy_data_valid                                (phy_data_valid),
  .phy_rx_status                                 (phy_rx_status),

  //inputs signals from the Data Generator
  .ts_complete                                   (in_ts_complete),
  .data_polarity                                 (in_data_polarity),

  //output signals to the LTSSM
  .phy_status                                    (adp_phy_status),
  .rx_elecidle                                   (adp_rx_elecidle),
  .data_valid                                    (adp_data_valid),
  .rx_status                                     (adp_rx_status),
  .polarity                                      (adp_polarity),

  //output control signal to the PHY
  .phy_rx_polarity                               (phy_rx_polarity),
  .phy_tx_detectrx                               (phy_tx_detectrx),
  .phy_tx_elecidle                               (phy_tx_elecidle),
  .phy_tx_swing                                  (phy_tx_swing),
  .phy_rx_preset_hint                            (phy_rx_preset_hint),
  .phy_powerdown                                 (phy_powerdown),
  .phy_rate                                      (phy_rate),
  .phy_tx_margin                                 (phy_tx_margin),
  .phy_tx_deemphasis                             (phy_tx_deemphasis)
);


endmodule
