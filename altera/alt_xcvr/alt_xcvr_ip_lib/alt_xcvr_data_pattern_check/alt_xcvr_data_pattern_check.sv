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
// Filename    : alt_xcvr_data_pattern_check.sv
//
// Description : The Data Pattern Checker module that actually verifies the output pattern. For further 
// information, please see the FD
//
// Supported Patterns - PRBS 7, 9, 10, 15, 23, 31, Inverted PRBS patterns
// 							walking_pattern, counter

// Supported Data widths = Up to 128 bits
//
// Authors     : Baturay Turkmen
// Date        : July, 7, 2015
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------
module alt_xcvr_data_pattern_check #(
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
  input                           clk,
  input                           reset,
  input                           enable,
  input  [DATA_WIDTH-1:0]         ext_data_pattern,
  input  [PATTERN_ADDR_WIDTH-1:0] pattern,
  input  [DATA_WIDTH-1:0]         data_in,
  
  output                          error_flag,
  output                          is_data_locked,
  
  //avmm inputs
  
  input                           avmm_clk,
  input                           avmm_reset,
  input [PATTERN_ADDR_WIDTH-1:0]  avmm_address,
  input [31:0]                    avmm_writedata,
  input                           avmm_write,
  input                           avmm_read,
  
  //avmm outputs
  
  output [31:0]                   avmm_readdata,
  output                          avmm_waitrequest
  
);


//wires needed

  wire                          reset_mux_out;
  wire                          reset_synch_out;
  
  wire                          enable_mux_out;
  wire                          enable_synch_out;
  
  wire [PATTERN_ADDR_WIDTH-1:0] pattern_mux_out;
  wire [DATA_WIDTH-1:0]         ext_data_pattern_mux_out;
  wire [DATA_WIDTH-1:0]         data_in_mux_out;

  
  wire                          reset_avmm;
  wire                          enable_avmm;
  wire [PATTERN_ADDR_WIDTH-1:0] pattern_avmm;
  wire [DATA_WIDTH-1:0]         ext_data_pattern_avmm;
  wire [DATA_WIDTH-1:0]         data_in_avmm;

  wire [15:0]                   register_control_or_avmm;
  
  wire [ERROR_WIDTH-1:0]        num_accumulated_error;
  wire [ERROR_WIDTH-1:0]        num_dealignment;
  
  wire [ERROR_WIDTH-1:0]        num_accumulated_error_mux_out;
  wire [ERROR_WIDTH-1:0]        num_dealignment_mux_out;
  wire                          is_data_locked_mux_out;

  
//muxes to choose whether port or avmm inputs to feed the main module
generate
if(AVMM_EN) begin
  assign reset_mux_out             = (register_control_or_avmm[0])  ?  reset_avmm             :  reset;
  assign enable_mux_out            = (register_control_or_avmm[1])  ?  enable_avmm            :  enable;
  assign pattern_mux_out           = (register_control_or_avmm[2])  ?  pattern_avmm           :  pattern;
  assign ext_data_pattern_mux_out  = (register_control_or_avmm[3])  ?  ext_data_pattern_avmm  :  ext_data_pattern;
  assign data_in_mux_out           = (register_control_or_avmm[4])  ?  data_in_avmm           :  data_in;
end else begin
  assign reset_mux_out             =                                                             reset;
  assign enable_mux_out            =                                                             enable;
  assign pattern_mux_out           =                                                             pattern;
  assign ext_data_pattern_mux_out  =                                                             ext_data_pattern;
  assign data_in_mux_out           =                                                             data_in;
end
endgenerate
 
	 alt_xcvr_data_pattern_check_main #(
			.DATA_WIDTH           (DATA_WIDTH),
			.CHANNELS             (CHANNELS),
			.NUM_MATCHES_FOR_LOCK (NUM_MATCHES_FOR_LOCK),
			.UNLOCK               (UNLOCK),
			.ERROR_WIDTH          (ERROR_WIDTH),
			.PATTERN_ADDR_WIDTH   (PATTERN_ADDR_WIDTH),
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
	) alt_xcvr_data_pattern_check_main_inst
	(
	  .clk                      (clk),
	  .reset                    (reset_synch_out),
	  .enable                   (enable_synch_out),
	  .pattern                  (pattern_mux_out),
	  .ext_data_pattern         (ext_data_pattern_mux_out),
	  .data_in                  (data_in_mux_out),
	  
	  .is_data_locked           (is_data_locked),
	  .error_flag               (error_flag),
	  
	  .num_accumulated_error    (num_accumulated_error),
	  .num_dealignment          (num_dealignment)
	);
	
//synchronizer for enable signal	
	alt_xcvr_resync #( 
	  .WIDTH             (1),
     .INIT_VALUE        (0),
	  .SYNC_CHAIN_LENGTH (2),
	  .SLOW_CLOCK        (0)
	) enable_synch (
       .clk   (clk),
       .reset (reset),
       .d     (enable_mux_out),
       .q     (enable_synch_out)
  );

//synchronizer for reset signal	  
	alt_xcvr_resync #(
	  .WIDTH             (1),
	  .INIT_VALUE        (1),
	  .SYNC_CHAIN_LENGTH (2),
	  .SLOW_CLOCK        (0)	  
	) reset_synch (
       .clk   (clk),
       .reset (reset_mux_out),
       .d     (1'd0),
       .q     (reset_synch_out)
  );  
  
 //synchronizer for number of accumulated errors register	   
  	alt_xcvr_resync #(
	  .WIDTH             (ERROR_WIDTH),
	  .INIT_VALUE        (0),
	  .SYNC_CHAIN_LENGTH (2),
	  .SLOW_CLOCK        (0)	  
	) error_synch (
       .clk   (avmm_clk),
       .reset (reset_avmm),
       .d     (num_accumulated_error),
       .q     (num_accumulated_error_mux_out)
  );  
  
 //synchronizer for number of dealignments register	     
  	alt_xcvr_resync #(
	  .WIDTH             (ERROR_WIDTH),
	  .INIT_VALUE        (0),
	  .SYNC_CHAIN_LENGTH (2),
	  .SLOW_CLOCK        (0)	  
	) dealignment_synch (
       .clk   (avmm_clk),
       .reset (reset_avmm),
       .d     (num_dealignment),
       .q     (num_dealignment_mux_out)
  );  
 

 //synchronizer for is_data_locked output	    
  	alt_xcvr_resync #(
	  .WIDTH             (1),
	  .INIT_VALUE        (0),
	  .SYNC_CHAIN_LENGTH (2),
	  .SLOW_CLOCK        (0)	  
	) locked_synch (
       .clk   (avmm_clk),
       .reset (reset_avmm),
       .d     (is_data_locked),
       .q     (is_data_locked_mux_out)
  );  


	 alt_xcvr_data_pattern_check_avmm_csr #(
	  .DATA_WIDTH                 (DATA_WIDTH),
	  .ERROR_WIDTH                (ERROR_WIDTH),
	  .PATTERN_ADDR_WIDTH         (PATTERN_ADDR_WIDTH)
	) alt_xcvr_data_pattern_check_avmm_csr_inst
	(
	  // avmm signals
	  .avmm_clk                   (avmm_clk),
	  .avmm_reset                 (avmm_reset),
	  .avmm_address               (avmm_address),
	  .avmm_writedata             (avmm_writedata),
	  .avmm_write                 (avmm_write),
	  .avmm_read                  (avmm_read),
	  .avmm_readdata              (avmm_readdata),
	  .avmm_waitrequest           (avmm_waitrequest),
	  
	  //register outputs for the mux to choose as the inputs of the data pattern generator
	  
	  .num_dealignment_avmm       (num_dealignment_mux_out), 
     .num_accumulated_error_avmm (num_accumulated_error_mux_out),
     .is_data_locked_avmm        (is_data_locked_mux_out),
	  
	  .reset_avmm                 (reset_avmm),
	  .enable_avmm                (enable_avmm),
	  .pattern_avmm               (pattern_avmm),
	  .ext_data_pattern_avmm      (ext_data_pattern_avmm),
	  .data_in_avmm               (data_in_avmm),
	  
	  .register_control_or_avmm   (register_control_or_avmm) 
	);



endmodule
