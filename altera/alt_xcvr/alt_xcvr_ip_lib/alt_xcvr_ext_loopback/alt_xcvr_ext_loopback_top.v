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
// Filename    : alt_xcvr_ext_loopback
//
// Description : An external loop-back module
// Loops back tx_serial_data to rx_serial_data
//
// Limitation  : None
//
// Authors     : dunnikri
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_ext_loopback_top #(
  parameter CHANNELS = 1
) (
    input  wire [CHANNELS-1:0] tx_serial_data,
    output wire [CHANNELS-1:0] rx_serial_data
); 

assign rx_serial_data = tx_serial_data;

endmodule
