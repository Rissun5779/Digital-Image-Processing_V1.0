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
// Filename    : alt_xcvr_data_pattern_check_top.sv
//
// Description : The top module of Data Pattern Checker. For further 
// information, please see the FD
//
// Supported Patterns - PRBS 7, 9, 10, 15, 23, 31, Inverted PRBS patterns
// 							walking_pattern, counter

// Supported Data widths = Up to 128 bits
//
// Authors     : Baturay Turkmen
// Date        : June, 20, 2015
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_data_pattern_check_top #(
  parameter DATA_WIDTH           = 16,                 //1-128   
  parameter CHANNELS             = 1,                  //1-96
  parameter NUM_MATCHES_FOR_LOCK = 16,                 //4-64
  parameter UNLOCK               = 0,                  //{0 1}
  parameter ERROR_WIDTH          = 8,                  //4-32
  parameter PATTERN_ADDR_WIDTH   = 4,                  //4-32
  parameter AVMM_EN              = 0,                  //{0 1}
  
  parameter PRBS7                = 1,                  //{0 1}
  parameter PRBS9                = 1,                  //{0 1}
  parameter PRBS10               = 1,                  //{0 1}
  parameter PRBS15               = 1,                  //{0 1}
  parameter PRBS23               = 1,                  //{0 1}
  parameter PRBS31               = 1,                  //{0 1}
  parameter WALKING              = 1,                  //{0 1}
  parameter COUNTER              = 1,                  //{0 1}
  parameter INVERTED_PRBS        = 1,                  //{0 1}
  parameter EXTERNAL             = 1                   //{0 1}
)
(
  input  [CHANNELS-1:0]                        clk,
  input  [CHANNELS-1:0]                        reset,
  input  [CHANNELS-1:0]                        enable,
  input  [(CHANNELS * DATA_WIDTH)-1:0]         ext_data_pattern,
  input  [(CHANNELS * PATTERN_ADDR_WIDTH)-1:0] pattern,
  input  [(CHANNELS * DATA_WIDTH)-1:0]         data_in,
  
  output [CHANNELS-1:0]                        error_flag,
  output [CHANNELS-1:0]                        is_data_locked,
  
  //avmm inputs
  
  input [CHANNELS-1:0]                         avmm_clk,
  input [CHANNELS-1:0]                         avmm_reset,
  input [(CHANNELS * PATTERN_ADDR_WIDTH)-1:0]  avmm_address,
  input [(CHANNELS * 32)-1:0]                  avmm_writedata,
  input [CHANNELS-1:0]                         avmm_write,
  input [CHANNELS-1:0]                         avmm_read,
  
  //avmm outputs
  
  output [(CHANNELS * 32)-1:0]                 avmm_readdata,
  output [CHANNELS-1:0]                        avmm_waitrequest
);

 wire [DATA_WIDTH-1:0]  data_in_w         [CHANNELS-1:0];
 wire [31:0]            avmm_readdata_w   [CHANNELS-1:0];


//generates CHANNELS number of checker modules seperately, with unique independent inputs including clock and reset 
genvar i;
generate 
	for(i=0;i<CHANNELS;i=i+1) begin: patternGenerator
	
	   assign data_in_w[i] = data_in[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i];
	
		alt_xcvr_data_pattern_check #(
			.DATA_WIDTH           (DATA_WIDTH),
			.CHANNELS             (CHANNELS),
			.NUM_MATCHES_FOR_LOCK (NUM_MATCHES_FOR_LOCK),
			.UNLOCK               (UNLOCK),
			.ERROR_WIDTH          (ERROR_WIDTH),
			.PATTERN_ADDR_WIDTH   (PATTERN_ADDR_WIDTH),
			.AVMM_EN              (AVMM_EN),
			.PRBS7                (PRBS7),
			.PRBS9                (PRBS9),
			.PRBS10               (PRBS10),
			.PRBS15               (PRBS15),
			.PRBS23               (PRBS23),
			.PRBS31               (PRBS31),
			.WALKING              (WALKING),
			.COUNTER              (COUNTER),
			.INVERTED_PRBS        (INVERTED_PRBS),
			.EXTERNAL             (EXTERNAL)
		) alt_xcvr_data_pattern_check_inst (
			.clk                  (clk[i]),
			.reset                (reset[i]),
			.enable               (enable[i]),
			.ext_data_pattern     (ext_data_pattern[(DATA_WIDTH * (i+1)- 1):(DATA_WIDTH * i)]),
			.pattern              (pattern[(PATTERN_ADDR_WIDTH * (i+1) - 1):(PATTERN_ADDR_WIDTH * i)]),
			.data_in              (data_in_w[i]),
			
			.error_flag           (error_flag[i]),
			.is_data_locked       (is_data_locked[i]),
			
			
			//avmm input/output
			
			.avmm_clk          (avmm_clk[i]),
			.avmm_reset        (avmm_reset[i]),
			.avmm_address      (avmm_address[(PATTERN_ADDR_WIDTH*(i+1)-1):(PATTERN_ADDR_WIDTH*i)]),
			.avmm_writedata    (avmm_writedata[(32*(i+1)-1):(32*i)]),
			.avmm_write        (avmm_write[i]),
			.avmm_read         (avmm_read[i]),
			
			.avmm_readdata     (avmm_readdata_w[i]),
			.avmm_waitrequest  (avmm_waitrequest[i])	
			
		); 
		
	    assign avmm_readdata  [(32*(i+1)-1):(32*i)] = avmm_readdata_w[i];

	end

endgenerate

endmodule
