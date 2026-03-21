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



`timescale 1ps / 1ps

module alt_e25_adapter #(
    parameter SYNOPT_READY_LATENCY = 0,
    parameter WIDTH = 64,
    parameter WORDS = 1,
    parameter TARGET_CHIP = 5,
    parameter RXERRWIDTH = 6,
    parameter RXSTATUSWIDTH  = 3,
    parameter SYNOPT_TSTAMP_FP_WIDTH = 4,
    parameter SYNOPT_ENABLE_PTP = 1'b0
)(
 
  // TX
  input tx_mac_sclr,
  input tx_clk_mac,            // MAC + PCS clock -390.625Mhz

  input rx_mac_sclr,
  input rx_clk_mac,            // MAC + PCS clock -390.625Mhz

  input  [WORDS*WIDTH-1:0]   tx_usr_data,
  input  [2:0]               tx_usr_eop_empty, 
  input                      tx_usr_sop,
  input                      tx_usr_eop,
  output                     tx_usr_ready,
  input                      tx_usr_valid,
  input                      tx_usr_error,

  output [WORDS*WIDTH-1:0]   tx_mac_data,
  output                     tx_mac_sop,
  output                     tx_mac_eop,
  output [2:0]               tx_mac_eop_empty,
  output                     tx_mac_error,
  output                     tx_mac_valid,
  input                      tx_mac_ready,
  
  output [WORDS*WIDTH-1:0]   rx_usr_data,
  output [2:0]               rx_usr_eop_empty,
  output                     rx_usr_sop,
  output                     rx_usr_eop,
  output                     rx_usr_valid,
  output [RXERRWIDTH-1:0]    rx_usr_error,
  output [RXSTATUSWIDTH-1:0] rx_usr_status,

  input  [WORDS*WIDTH-1:0]   rx_mac_data,
  input                      rx_mac_sop,
  input                      rx_mac_eop,
  input  [2:0]               rx_mac_eop_empty,
  input  [RXERRWIDTH-1:0]    rx_mac_error, 
  input  [RXSTATUSWIDTH-1:0] rx_mac_status,
  input                      rx_mac_valid,

  input                               tx_usr_egress_timestamp_request_valid,
  input [SYNOPT_TSTAMP_FP_WIDTH-1:0]  tx_usr_egress_timestamp_request_fingerprint,
  input                               tx_usr_etstamp_ins_ctrl_timestamp_insert,
  input                               tx_usr_etstamp_ins_ctrl_timestamp_format,
  input                               tx_usr_etstamp_ins_ctrl_residence_time_update,
  input [95:0]                        tx_usr_etstamp_ins_ctrl_ingress_timestamp_96b,
  input [63:0]                        tx_usr_etstamp_ins_ctrl_ingress_timestamp_64b,
  input                               tx_usr_etstamp_ins_ctrl_residence_time_calc_format,
  input                               tx_usr_etstamp_ins_ctrl_checksum_zero,
  input                               tx_usr_etstamp_ins_ctrl_checksum_correct,
  input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_timestamp,
  input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_correction_field,
  input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_checksum_field,
  input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_checksum_correction,
  input                               tx_usr_egress_asymmetry_update,

  output                              tx_mac_egress_timestamp_request_valid,
  output [SYNOPT_TSTAMP_FP_WIDTH-1:0] tx_mac_egress_timestamp_request_fingerprint,
  output                              tx_mac_etstamp_ins_ctrl_timestamp_insert,
  output                              tx_mac_etstamp_ins_ctrl_timestamp_format,
  output                              tx_mac_etstamp_ins_ctrl_residence_time_update,
  output [95:0]                       tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b,
  output [63:0]                       tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b,
  output                              tx_mac_etstamp_ins_ctrl_residence_time_calc_format,
  output                              tx_mac_etstamp_ins_ctrl_checksum_zero,
  output                              tx_mac_etstamp_ins_ctrl_checksum_correct,
  output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_timestamp,
  output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_correction_field,
  output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_checksum_field,
  output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_checksum_correction,
  output                              tx_mac_egress_asymmetry_update
);

generate if (SYNOPT_READY_LATENCY!=0) begin : g_lat3
alt_e25_wide_l1if_tx tx_ast (
    .sclr               (tx_mac_sclr),            // i
    .clk                (tx_clk_mac),          // i
    .tx_usr_d           (tx_usr_data),             // i
    .tx_usr_sop         (tx_usr_sop),           // i
    .tx_usr_eop         (tx_usr_eop),           // i
    .tx_usr_eop_empty   (tx_usr_eop_empty),     // i
    .tx_usr_valid       (tx_usr_valid),         // i
    .tx_usr_error       (tx_usr_error),         // i
    .tx_usr_ready       (tx_usr_ready),         // o
    .tx_usr_egress_timestamp_request_valid              (tx_usr_egress_timestamp_request_valid),              //i
    .tx_usr_egress_timestamp_request_fingerprint        (tx_usr_egress_timestamp_request_fingerprint),        //i
    .tx_usr_etstamp_ins_ctrl_timestamp_insert           (tx_usr_etstamp_ins_ctrl_timestamp_insert),           //i
    .tx_usr_etstamp_ins_ctrl_timestamp_format           (tx_usr_etstamp_ins_ctrl_timestamp_format),           //i
    .tx_usr_etstamp_ins_ctrl_residence_time_update      (tx_usr_etstamp_ins_ctrl_residence_time_update),      //i
    .tx_usr_etstamp_ins_ctrl_ingress_timestamp_96b      (tx_usr_etstamp_ins_ctrl_ingress_timestamp_96b),      //i
    .tx_usr_etstamp_ins_ctrl_ingress_timestamp_64b      (tx_usr_etstamp_ins_ctrl_ingress_timestamp_64b),      //i
    .tx_usr_etstamp_ins_ctrl_residence_time_calc_format (tx_usr_etstamp_ins_ctrl_residence_time_calc_format), //i
    .tx_usr_etstamp_ins_ctrl_checksum_zero              (tx_usr_etstamp_ins_ctrl_checksum_zero),              //i
    .tx_usr_etstamp_ins_ctrl_checksum_correct           (tx_usr_etstamp_ins_ctrl_checksum_correct),           //i
    .tx_usr_etstamp_ins_ctrl_offset_timestamp           (tx_usr_etstamp_ins_ctrl_offset_timestamp),           //i
    .tx_usr_etstamp_ins_ctrl_offset_correction_field    (tx_usr_etstamp_ins_ctrl_offset_correction_field),    //i
    .tx_usr_etstamp_ins_ctrl_offset_checksum_field      (tx_usr_etstamp_ins_ctrl_offset_checksum_field),      //i
    .tx_usr_etstamp_ins_ctrl_offset_checksum_correction (tx_usr_etstamp_ins_ctrl_offset_checksum_correction), //i
    .tx_usr_egress_asymmetry_update(tx_usr_egress_asymmetry_update),    
    .tx_mac_dout        (tx_mac_data),        // o
    .tx_mac_valid       (tx_mac_valid),
    .tx_mac_sop         (tx_mac_sop),           // o
    .tx_mac_eop         (tx_mac_eop),           // o
    .tx_mac_eop_empty   (tx_mac_eop_empty),     // o
    .tx_mac_error       (tx_mac_error),         // o
    .tx_mac_ready       (tx_mac_ready),          // i
    .tx_mac_egress_timestamp_request_valid              (tx_mac_egress_timestamp_request_valid),              //o
    .tx_mac_egress_timestamp_request_fingerprint        (tx_mac_egress_timestamp_request_fingerprint),        //o
    .tx_mac_etstamp_ins_ctrl_timestamp_insert           (tx_mac_etstamp_ins_ctrl_timestamp_insert),           //o
    .tx_mac_etstamp_ins_ctrl_timestamp_format           (tx_mac_etstamp_ins_ctrl_timestamp_format),           //o
    .tx_mac_etstamp_ins_ctrl_residence_time_update      (tx_mac_etstamp_ins_ctrl_residence_time_update),      //o
    .tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b      (tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b),      //o
    .tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b      (tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b),      //o
    .tx_mac_etstamp_ins_ctrl_residence_time_calc_format (tx_mac_etstamp_ins_ctrl_residence_time_calc_format), //o
    .tx_mac_etstamp_ins_ctrl_checksum_zero              (tx_mac_etstamp_ins_ctrl_checksum_zero),              //o
    .tx_mac_etstamp_ins_ctrl_checksum_correct           (tx_mac_etstamp_ins_ctrl_checksum_correct),           //o
    .tx_mac_etstamp_ins_ctrl_offset_timestamp           (tx_mac_etstamp_ins_ctrl_offset_timestamp),           //o
    .tx_mac_etstamp_ins_ctrl_offset_correction_field    (tx_mac_etstamp_ins_ctrl_offset_correction_field),    //o
    .tx_mac_etstamp_ins_ctrl_offset_checksum_field      (tx_mac_etstamp_ins_ctrl_offset_checksum_field),      //o
    .tx_mac_etstamp_ins_ctrl_offset_checksum_correction (tx_mac_etstamp_ins_ctrl_offset_checksum_correction), //o
    .tx_mac_egress_asymmetry_update                     (tx_mac_egress_asymmetry_update)                      //o
); 
    defparam tx_ast.SYNOPT_READY_LATENCY = SYNOPT_READY_LATENCY;
    defparam tx_ast.WORDS = WORDS;
    defparam tx_ast.WIDTH = WIDTH;
    defparam tx_ast.TARGET_CHIP = TARGET_CHIP;
    defparam tx_ast.SYNOPT_TSTAMP_FP_WIDTH = SYNOPT_TSTAMP_FP_WIDTH;
    defparam tx_ast.SYNOPT_ENABLE_PTP = SYNOPT_ENABLE_PTP;
end else begin : g_lat0
  assign tx_mac_data = tx_usr_data;
  assign tx_mac_sop = tx_usr_sop;
  assign tx_mac_eop = tx_usr_eop;
  assign tx_mac_eop_empty= tx_usr_eop_empty;
  assign tx_mac_error = tx_usr_error;
  assign tx_mac_valid = tx_usr_valid;

  assign tx_usr_ready = tx_mac_ready;

  assign tx_mac_egress_timestamp_request_valid = tx_usr_egress_timestamp_request_valid;
  assign tx_mac_egress_timestamp_request_fingerprint = tx_usr_egress_timestamp_request_fingerprint;
  assign tx_mac_etstamp_ins_ctrl_timestamp_insert = tx_usr_etstamp_ins_ctrl_timestamp_insert;
  assign tx_mac_etstamp_ins_ctrl_timestamp_format = tx_usr_etstamp_ins_ctrl_timestamp_format;
  assign tx_mac_etstamp_ins_ctrl_residence_time_update = tx_usr_etstamp_ins_ctrl_residence_time_update;
  assign tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b = tx_usr_etstamp_ins_ctrl_ingress_timestamp_96b;
  assign tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b = tx_usr_etstamp_ins_ctrl_ingress_timestamp_64b;
  assign tx_mac_etstamp_ins_ctrl_residence_time_calc_format = tx_usr_etstamp_ins_ctrl_residence_time_calc_format;
  assign tx_mac_etstamp_ins_ctrl_checksum_zero = tx_usr_etstamp_ins_ctrl_checksum_zero;
  assign tx_mac_etstamp_ins_ctrl_checksum_correct = tx_usr_etstamp_ins_ctrl_checksum_correct;
  assign tx_mac_etstamp_ins_ctrl_offset_timestamp = tx_usr_etstamp_ins_ctrl_offset_timestamp;
  assign tx_mac_etstamp_ins_ctrl_offset_correction_field = tx_usr_etstamp_ins_ctrl_offset_correction_field;
  assign tx_mac_etstamp_ins_ctrl_offset_checksum_field = tx_usr_etstamp_ins_ctrl_offset_checksum_field;
  assign tx_mac_etstamp_ins_ctrl_offset_checksum_correction = tx_usr_etstamp_ins_ctrl_offset_checksum_correction;
  assign tx_mac_egress_asymmetry_update = tx_usr_egress_asymmetry_update;
end
endgenerate

`ifdef RX_ADAPTER
alt_e25_wide_l1if_rx_mux rx_ast (
    .sclr             (rx_mac_sclr),           //i
    .clk              (rx_clk_mac),      // i
    .rx_usr_dout      (rx_usr_data),     // o
    .rx_usr_valid     (rx_usr_valid),
    .rx_usr_sop       (rx_usr_sop),       // o
    .rx_usr_eop       (rx_usr_eop),       // o
    .rx_usr_eop_empty (rx_usr_eop_empty),     // o
    .rx_usr_sideband  ({rx_usr_status, rx_usr_error}),     // o
    .rx_mac_d         (rx_mac_data),         // i
    .rx_mac_sop       (rx_mac_sop),       // i
    .rx_mac_eop       (rx_mac_eop),       // i
    .rx_mac_eop_empty (rx_mac_eop_empty), // i
    .rx_mac_sideband  ({rx_mac_status,rx_mac_error}),     // i
    .rx_mac_valid     (rx_mac_valid)      // i
); // module rx_ast 
    defparam rx_ast.WORDS = WORDS;
    defparam rx_ast.WIDTH = WIDTH;
    defparam rx_ast.TARGET_CHIP = TARGET_CHIP;
    defparam rx_ast.RXSIDEBANDWIDTH = RXSTATUSWIDTH + RXERRWIDTH;
`else
  assign rx_usr_data = rx_mac_data;
  assign rx_usr_sop = rx_mac_sop;
  assign rx_usr_eop = rx_mac_eop;
  assign rx_usr_eop_empty = rx_mac_eop_empty;
  assign rx_usr_error = rx_mac_error;
  assign rx_usr_valid = rx_mac_valid;
  assign rx_usr_status = rx_mac_status;

`endif

endmodule
