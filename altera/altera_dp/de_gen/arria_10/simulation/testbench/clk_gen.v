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


// *********************************************************************
//
// DisplayPort IP Simulation Example -- Clock Generation
// 
// Description
//
// This module generates the various clocks used in the test harness.
// The clocks are:
//   * clk162 & clk135 - The 162 MHz and 135 MHz XCVR reference clocks
//   * clk16           - The 16 MHz clock used for the AUX interface
//   * clk100          - A 100 MHz clock used for the aux_mgmt and
//                       xcvr_mgmt interfaces
//   * clk_tx_vid      - A 60 MHz clock used for the TX video interface
//   * clk_rx_vid      - A 60 MHz clock used for the RX video interface
//
// *********************************************************************

// synthesis translate_off
`timescale 1 ns / 1 ps
// synthesis translate_on
`default_nettype none

module clk_gen
    #(
        parameter clk_rx_vid_CLOCK_PERIOD = 60, // Mhz
        parameter clk_tx_vid_CLOCK_PERIOD = 60 // Mhz
    )
	(
	clk135,
	clk162,
	clk16,
	clk100,
	refclk,
	clk_tx_vid,
	clk_rx_vid
	);

output	clk135,
	clk162,
	clk16,
	clk100,
	refclk,
	clk_tx_vid,
	clk_rx_vid;

/***************************
 * Generate external clocks*
 ***************************/
localparam clk_1M_CLOCK_PERIOD = 0.01;
localparam clk_1M_HALF_CLOCK_PERIOD = 1000.000000/clk_1M_CLOCK_PERIOD/2;
reg clk_1M;
initial
  clk_1M = 0;
always
  #clk_1M_HALF_CLOCK_PERIOD clk_1M <= ~clk_1M;

localparam clk_135_CLOCK_PERIOD = 135;
localparam clk_135_HALF_CLOCK_PERIOD = 1000.000000/clk_135_CLOCK_PERIOD/2;
reg clk_135;
initial
  clk_135 = 0;
always
  #clk_135_HALF_CLOCK_PERIOD clk_135 <= ~clk_135;

localparam clk_162_CLOCK_PERIOD = 162;
localparam clk_162_HALF_CLOCK_PERIOD = 1000.000000/clk_162_CLOCK_PERIOD/2;
reg clk_162;
initial
  clk_162 = 0;
always
  #clk_162_HALF_CLOCK_PERIOD clk_162 <= ~clk_162;

localparam clk_16_CLOCK_PERIOD = 16;
localparam clk_16_HALF_CLOCK_PERIOD = 1000.000000/clk_16_CLOCK_PERIOD/2;
reg clk_16;
initial
  clk_16 = 0;
always
  #clk_16_HALF_CLOCK_PERIOD clk_16 <= ~clk_16;

localparam clk_cal_av_CLOCK_PERIOD = 100; // Mhz
localparam clk_cal_av_HALF_CLOCK_PERIOD = 1000.000000/clk_cal_av_CLOCK_PERIOD/2;
reg clk_cal_av;
initial
  clk_cal_av = 0;
always
  #clk_cal_av_HALF_CLOCK_PERIOD clk_cal_av <= ~clk_cal_av;

//localparam clk_tx_vid_CLOCK_PERIOD = 60; // Mhz
localparam clk_tx_vid_HALF_CLOCK_PERIOD = 1000.000000/clk_tx_vid_CLOCK_PERIOD/2;
reg clk_tx_vid;
initial
  clk_tx_vid = 0;
always
  #clk_tx_vid_HALF_CLOCK_PERIOD clk_tx_vid <= ~clk_tx_vid;

//localparam clk_rx_vid_CLOCK_PERIOD = 60; // Mhz
localparam clk_rx_vid_HALF_CLOCK_PERIOD = 1000.000000/clk_rx_vid_CLOCK_PERIOD/2;
reg clk_rx_vid;
initial
  clk_rx_vid = 0;
always
  #clk_rx_vid_HALF_CLOCK_PERIOD clk_rx_vid <= ~clk_rx_vid;

wire clk100=clk_cal_av;
wire clk135=clk_135;
wire clk162=clk_162;
wire clk16=clk_16;
wire refclk=clk_1M;

endmodule

`default_nettype wire
