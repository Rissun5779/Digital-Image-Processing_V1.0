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


// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

//-------------------------------------------------------------------
// Filename    : alt_xcvr_data_pattern_check_avmm_h.sv
//
// Description : The header file for the register interface module of Data Pattern Checker. For further 
// information, please see the FD
//
// Supported Number of Registers = Up to 16 registers with -- data width
//
// Authors     : Baturay Turkmen
// Date        : July, 6, 2015
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------


`timescale 1 ps/1 ps

package alt_xcvr_data_pattern_check_avmm_h;

  // localparams for the addresses of the avmm registers for the inputs of the data pattern generator
  
  // UNUSED ADDRESS
  localparam UNUSED_ADDRESS                = 4'b0000;
  
  // READ & WRITE
  localparam RESET_ADDRESS                 = 4'b0001;
  localparam ENABLE_ADDRESS                = 4'b0010;
  localparam PATTERN_ADDRESS               = 4'b0011;
  
  localparam EXT_DATA_PATTERN_ADDRESS0     = 4'b0100;
  localparam EXT_DATA_PATTERN_ADDRESS1     = 4'b0101;
  localparam EXT_DATA_PATTERN_ADDRESS2     = 4'b0110;
  localparam EXT_DATA_PATTERN_ADDRESS3     = 4'b0111;

  localparam DATA_IN_ADDRESS0              = 4'b1000;
  localparam DATA_IN_ADDRESS1              = 4'b1001;
  localparam DATA_IN_ADDRESS2              = 4'b1010;
  localparam DATA_IN_ADDRESS3              = 4'b1011;
  
  // READ ONLY
  localparam IS_DATA_LOCKED_ADDRESS        = 4'b1100;
  localparam NUM_DEALIGNMENT_ADDRESS       = 4'b1101;
  localparam NUM_ACCUMULATED_ERROR_ADDRESS = 4'b1110;  
  
  localparam REGISTER_CONTROL_OR_ADDRESS   = 4'b1111;
  
  
  // initial register values of read & write registers
  localparam RESET_INITIAL                 = 1'b0;
  localparam ENABLE_INITIAL                = 1'b1;
  localparam PATTERN_INITIAL               = 4'b0001;
  localparam EXT_DATA_PATTERN_INITIAL      = 32'd0;
  localparam DATA_IN_INITIAL               = 32'd0;  
  localparam REGISTER_CONTROL_OR_INITIAL   = 16'd0;  
  
  
endpackage

