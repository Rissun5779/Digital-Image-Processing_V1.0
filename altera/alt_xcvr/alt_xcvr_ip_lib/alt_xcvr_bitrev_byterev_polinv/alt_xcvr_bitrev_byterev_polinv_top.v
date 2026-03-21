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
// Filename    : alt_xcvr_bitrev_byterev_polinv_top.v
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

module alt_xcvr_bitrev_byterev_polinv_top #(
    parameter CHANNELS=1,
    parameter TX_POLINV_EN=0,
    parameter RX_BITREV_EN=0,
    parameter RX_BYTEREV_EN=0,
    parameter RX_POLINV_EN=0
  ) (
    output [CHANNELS-1:0]       tx_polinv,
    output [CHANNELS-1:0]       rx_std_bitrev_ena,
    output [CHANNELS-1:0]       rx_std_byterev_ena,
    output [CHANNELS-1:0]       rx_polinv
  );

  genvar i;
  generate
    for(i=0;i<CHANNELS;i=i+1) begin:gen_channel

      if (TX_POLINV_EN)   assign tx_polinv[i] = 1'b1;
      if (RX_BITREV_EN)   assign rx_std_bitrev_ena[i] = 1'b1;
      if (RX_BYTEREV_EN)  assign rx_std_byterev_ena[i] = 1'b1;
      if (RX_POLINV_EN)   assign rx_polinv[i] = 1'b1;

    end
  endgenerate // gen_channel
endmodule // alt_xcvr_bitrev_byterev_polinv_top
