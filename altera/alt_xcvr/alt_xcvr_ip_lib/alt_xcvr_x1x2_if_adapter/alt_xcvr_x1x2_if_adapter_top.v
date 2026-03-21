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


//-------------------------------------------------------------------
// Filename    : alt_xcvr_x1x2_if_adapter_top.v
//
// Description : simplified <-> unsimplified interface adapter for double transfer rate mode
//
// This module is used to map the data generator/checker's simplified data output/input to
// the native phy's unsimplified interface during double transfer rate mode
//
//
// Limitation  : Currently only supports PCS Direct mode. Will need to adjust mappings for Standard and Enhanced modes
//
// Authors     : calam
//
//
// Copyright (c) Altera Corporation 1997-2016
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_x1x2_if_adapter_top #(
    parameter BASIC_TX_FIFO_MODE_EN=0,
    parameter CHANNELS=1,
    parameter WIDTH=32
  ) (
    input  [CHANNELS-1:0]               tx_clkout,
    input  [CHANNELS-1:0]               tx_digitalreset,
    input  [CHANNELS-1:0]               tx_fifo_wr_en,
    input  [CHANNELS*WIDTH-1:0]         gen_data_out,
    output [CHANNELS*WIDTH-1:0]         check_data_in,
    output [CHANNELS*80-1:0]            tx_data,
    input  [CHANNELS*80-1:0]            rx_data
  );

  wire [CHANNELS-1:0] tx_fifo_wr_en_wire;

  genvar i;
  generate
    if (BASIC_TX_FIFO_MODE_EN)
      assign tx_fifo_wr_en_wire = tx_fifo_wr_en;
    else
      assign tx_fifo_wr_en_wire = {CHANNELS{1'b0}};
        
    for(i=0;i<CHANNELS;i=i+1) begin:gen_adapter

      alt_xcvr_x1x2_if_adapter #(
        .WIDTH(WIDTH)
       ) adapter_inst (
        .tx_clkout          (tx_clkout[i]),
        .tx_digitalreset    (tx_digitalreset[i]),
        .tx_fifo_wr_en      (tx_fifo_wr_en_wire[i]),
        .gen_data_out       (gen_data_out[WIDTH*i +: WIDTH]),
        .check_data_in      (check_data_in[WIDTH*i +: WIDTH]),
        .tx_data            (tx_data[80*i +: 80]),
        .rx_data            (rx_data[80*i +: 80])
      );

    end
  endgenerate // gen_adapter
endmodule // alt_xcvr_x1x2_if_adapter_top
