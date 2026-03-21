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

module alt_e50_adapter #(
    parameter SYNOPT_READY_LATENCY = 0,
    parameter SYNOPT_PREAMBLE_PASS = 1'b0,
    parameter WIDTH = 64,
    parameter WORDS = 2,
    parameter TARGET_CHIP = 5,
    parameter RXERRWIDTH = 6,
    parameter RXSTATSWIDTH  = 41,
    parameter SIM_EMULATE = 1'b0
)(
 
  // TX
  input tx_mac_sclr,
  input tx_clk_mac,            // MAC + PCS clock -390.625Mhz

  input rx_mac_sclr,
  input rx_clk_mac,            // MAC + PCS clock -390.625Mhz

  input  [WIDTH-1:0]         tx_usr_preamble,
  input  [WORDS*WIDTH-1:0]   tx_usr_data,
  input  [3:0]               tx_usr_eop_empty, 
  input                      tx_usr_sop,
  input                      tx_usr_eop,
  output                     tx_usr_ready,
  input                      tx_usr_valid,
  input                      tx_usr_error,

  output [WIDTH-1:0]         tx_mac_preamble,
  output [WORDS*WIDTH-1:0]   tx_mac_data,
  output [WORDS-1:0]         tx_mac_sop,
  output [WORDS-1:0]         tx_mac_eop,
  output [WORDS*3-1:0]       tx_mac_eop_empty,
  output [WORDS-1:0]         tx_mac_idle,
  output [WORDS-1:0]         tx_mac_error,
  input                      tx_mac_ready,
  
  output [WORDS*WIDTH-1:0]   rx_usr_data,
  output [WIDTH-1:0]         rx_usr_preamble,
  output [3:0]               rx_usr_eop_empty,
  output                     rx_usr_sop,
  output                     rx_usr_eop,
  output                     rx_usr_valid,
  output [RXERRWIDTH-1:0]    rx_usr_error,
  output [RXSTATSWIDTH-1:0]  rx_usr_stats,

  input  [WORDS*WIDTH-1:0]   rx_mac_data,
  input  [WORDS-1:0]         rx_mac_sop,
  input  [WORDS-1:0]         rx_mac_idle,
  input  [WORDS-1:0]         rx_mac_prb,
  input  [WORDS-1:0]         rx_mac_eop,
  input  [WORDS*3-1:0]       rx_mac_eop_empty,
  input  [RXERRWIDTH-1:0]    rx_mac_error, 
  input  [RXSTATSWIDTH-1:0]  rx_mac_stats,
  input                      rx_mac_valid
);

// 2 lanes to 2 conversion ---------------------------------------------------
alt_e50_wide_l2if_rx_mux rx_ast (
    .sclr             (rx_mac_sclr),           //i
    .clk              (rx_clk_mac),      // i
    .rx_usr_dout      (rx_usr_data),     // o
    .rx_usr_preamble  (rx_usr_preamble),
    .rx_usr_valid     (rx_usr_valid),
    .rx_usr_sop       (rx_usr_sop),       // o
    .rx_usr_eop       (rx_usr_eop),       // o
    .rx_usr_eop_empty (rx_usr_eop_empty),     // o
    .rx_usr_sideband  ({rx_usr_stats, rx_usr_error}),     // o
    .rx_mac_d         (rx_mac_data),         // i
    .rx_mac_sop       (rx_mac_sop),       // i
    .rx_mac_idle      (rx_mac_idle),      // i
    .rx_mac_prb       (rx_mac_prb),      
    .rx_mac_eop       (rx_mac_eop),       // i
    .rx_mac_eop_empty (rx_mac_eop_empty), // i
    .rx_mac_sideband  ({rx_mac_stats,rx_mac_error}),     // i
    .rx_mac_valid     (rx_mac_valid)      // i
); // module rx_ast 
    defparam rx_ast.WORDS = WORDS;
    defparam rx_ast.WIDTH = WIDTH;
    defparam rx_ast.TARGET_CHIP = TARGET_CHIP;
    defparam rx_ast.RXSIDEBANDWIDTH = RXSTATSWIDTH + RXERRWIDTH;
    defparam rx_ast.SIM_EMULATE = SIM_EMULATE;
    defparam rx_ast.SYNOPT_PREAMBLE_PASS = SYNOPT_PREAMBLE_PASS;


    alt_e50_wide_l2if_tx tx_ast(
    .sclr               (tx_mac_sclr),            // i
    .clk                (tx_clk_mac),          // i
    .tx_usr_preamble    (tx_usr_preamble),             // i
    .tx_usr_d           (tx_usr_data),             // i
    .tx_usr_sop         (tx_usr_sop),           // i
    .tx_usr_eop         (tx_usr_eop),           // i
    .tx_usr_eop_empty   (tx_usr_eop_empty),     // i
    .tx_usr_valid       (tx_usr_valid),         // i
    .tx_usr_error       (tx_usr_error),         // i
    .tx_usr_ready       (tx_usr_ready),         // o
    .tx_mac_preamble    (tx_mac_preamble),      // o
    .tx_mac_dout        (tx_mac_data),        // o
    .tx_mac_sop         (tx_mac_sop),           // o
    .tx_mac_eop         (tx_mac_eop),           // o
    .tx_mac_eop_empty   (tx_mac_eop_empty),     // o
    .tx_mac_error       (tx_mac_error),         // o
    .tx_mac_idle        (tx_mac_idle),          // o
    .tx_mac_ready       (tx_mac_ready)          // i
); 
    defparam tx_ast.SYNOPT_READY_LATENCY = SYNOPT_READY_LATENCY;
    defparam tx_ast.SYNOPT_PREAMBLE_PASS = SYNOPT_PREAMBLE_PASS;
    defparam tx_ast.WORDS = WORDS;
    defparam tx_ast.WIDTH = WIDTH;
    defparam tx_ast .TARGET_CHIP = TARGET_CHIP;

endmodule
