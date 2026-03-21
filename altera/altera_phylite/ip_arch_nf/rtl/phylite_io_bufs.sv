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




///////////////////////////////////////////////////////////////////////////////
// IO Buffer wrapper of 20nm PHYLite component.
//
///////////////////////////////////////////////////////////////////////////////
module phylite_io_bufs #(
	parameter integer NUM_GROUPS                               = 1,
	parameter string  GROUP_PIN_TYPE                    [0:17] = '{"BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR"},
	parameter integer GROUP_PIN_WIDTH                   [0:17] = '{9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9},
	parameter integer GROUP_USE_OUTPUT_STROBE           [0:17] = '{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	parameter integer GROUP_USE_INTERNAL_CAPTURE_STROBE [0:17] = '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	parameter integer GROUP_USE_SEPARATE_STROBES        [0:17] = '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	parameter string  GROUP_DATA_CONFIG               [0:17] = '{"SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED"},
	parameter string  GROUP_STROBE_CONFIG               [0:17] = '{"SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED"}
	) (
	// Lane
	input  [47:0] data_oe    [0:NUM_GROUPS-1],
	input  [47:0] data_out   [0:NUM_GROUPS-1],
	output [47:0] data_in    [0:NUM_GROUPS-1],
	input  [47:0] oct_enable [0:NUM_GROUPS-1],

	// I/Os
	output [GROUP_PIN_WIDTH[0] - 1 : 0] group_0_data_out     ,
	input  [GROUP_PIN_WIDTH[0] - 1 : 0] group_0_data_in      ,
	inout  [GROUP_PIN_WIDTH[0] - 1 : 0] group_0_data_io      ,
	output [GROUP_PIN_WIDTH[0] - 1 : 0] group_0_data_out_n     ,
	input  [GROUP_PIN_WIDTH[0] - 1 : 0] group_0_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[0] - 1 : 0] group_0_data_io_n      ,
	input                               group_0_strobe_in    ,
	input                               group_0_strobe_in_n  ,
	output                              group_0_strobe_out   ,
	output                              group_0_strobe_out_n ,
	inout                               group_0_strobe_io    ,
	inout                               group_0_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[1] - 1 : 0] group_1_data_out     ,
	input  [GROUP_PIN_WIDTH[1] - 1 : 0] group_1_data_in      ,
	inout  [GROUP_PIN_WIDTH[1] - 1 : 0] group_1_data_io      ,
	output [GROUP_PIN_WIDTH[1] - 1 : 0] group_1_data_out_n     ,
	input  [GROUP_PIN_WIDTH[1] - 1 : 0] group_1_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[1] - 1 : 0] group_1_data_io_n      ,
	input                               group_1_strobe_in    ,
	input                               group_1_strobe_in_n  ,
	output                              group_1_strobe_out   ,
	output                              group_1_strobe_out_n ,
	inout                               group_1_strobe_io    ,
	inout                               group_1_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[2] - 1 : 0] group_2_data_out     ,
	input  [GROUP_PIN_WIDTH[2] - 1 : 0] group_2_data_in      ,
	inout  [GROUP_PIN_WIDTH[2] - 1 : 0] group_2_data_io      ,
	output [GROUP_PIN_WIDTH[2] - 1 : 0] group_2_data_out_n     ,
	input  [GROUP_PIN_WIDTH[2] - 1 : 0] group_2_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[2] - 1 : 0] group_2_data_io_n      ,
	input                               group_2_strobe_in    ,
	input                               group_2_strobe_in_n  ,
	output                              group_2_strobe_out   ,
	output                              group_2_strobe_out_n ,
	inout                               group_2_strobe_io    ,
	inout                               group_2_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[3] - 1 : 0] group_3_data_out     ,
	input  [GROUP_PIN_WIDTH[3] - 1 : 0] group_3_data_in      ,
	inout  [GROUP_PIN_WIDTH[3] - 1 : 0] group_3_data_io      ,
	output [GROUP_PIN_WIDTH[3] - 1 : 0] group_3_data_out_n     ,
	input  [GROUP_PIN_WIDTH[3] - 1 : 0] group_3_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[3] - 1 : 0] group_3_data_io_n      ,
	input                               group_3_strobe_in    ,
	input                               group_3_strobe_in_n  ,
	output                              group_3_strobe_out   ,
	output                              group_3_strobe_out_n ,
	inout                               group_3_strobe_io    ,
	inout                               group_3_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[4] - 1 : 0] group_4_data_out     ,
	input  [GROUP_PIN_WIDTH[4] - 1 : 0] group_4_data_in      ,
	inout  [GROUP_PIN_WIDTH[4] - 1 : 0] group_4_data_io      ,
	output [GROUP_PIN_WIDTH[4] - 1 : 0] group_4_data_out_n     ,
	input  [GROUP_PIN_WIDTH[4] - 1 : 0] group_4_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[4] - 1 : 0] group_4_data_io_n      ,
	input                               group_4_strobe_in    ,
	input                               group_4_strobe_in_n  ,
	output                              group_4_strobe_out   ,
	output                              group_4_strobe_out_n ,
	inout                               group_4_strobe_io    ,
	inout                               group_4_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[5] - 1 : 0] group_5_data_out     ,
	input  [GROUP_PIN_WIDTH[5] - 1 : 0] group_5_data_in      ,
	inout  [GROUP_PIN_WIDTH[5] - 1 : 0] group_5_data_io      ,
	output [GROUP_PIN_WIDTH[5] - 1 : 0] group_5_data_out_n     ,
	input  [GROUP_PIN_WIDTH[5] - 1 : 0] group_5_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[5] - 1 : 0] group_5_data_io_n      ,
	input                               group_5_strobe_in    ,
	input                               group_5_strobe_in_n  ,
	output                              group_5_strobe_out   ,
	output                              group_5_strobe_out_n ,
	inout                               group_5_strobe_io    ,
	inout                               group_5_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[6] - 1 : 0] group_6_data_out     ,
	input  [GROUP_PIN_WIDTH[6] - 1 : 0] group_6_data_in      ,
	inout  [GROUP_PIN_WIDTH[6] - 1 : 0] group_6_data_io      ,
	output [GROUP_PIN_WIDTH[6] - 1 : 0] group_6_data_out_n     ,
	input  [GROUP_PIN_WIDTH[6] - 1 : 0] group_6_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[6] - 1 : 0] group_6_data_io_n      ,
	input                               group_6_strobe_in    ,
	input                               group_6_strobe_in_n  ,
	output                              group_6_strobe_out   ,
	output                              group_6_strobe_out_n ,
	inout                               group_6_strobe_io    ,
	inout                               group_6_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[7] - 1 : 0] group_7_data_out     ,
	input  [GROUP_PIN_WIDTH[7] - 1 : 0] group_7_data_in      ,
	inout  [GROUP_PIN_WIDTH[7] - 1 : 0] group_7_data_io      ,
	output [GROUP_PIN_WIDTH[7] - 1 : 0] group_7_data_out_n     ,
	input  [GROUP_PIN_WIDTH[7] - 1 : 0] group_7_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[7] - 1 : 0] group_7_data_io_n      ,
	input                               group_7_strobe_in    ,
	input                               group_7_strobe_in_n  ,
	output                              group_7_strobe_out   ,
	output                              group_7_strobe_out_n ,
	inout                               group_7_strobe_io    ,
	inout                               group_7_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[8] - 1 : 0] group_8_data_out     ,
	input  [GROUP_PIN_WIDTH[8] - 1 : 0] group_8_data_in      ,
	inout  [GROUP_PIN_WIDTH[8] - 1 : 0] group_8_data_io      ,
	output [GROUP_PIN_WIDTH[8] - 1 : 0] group_8_data_out_n     ,
	input  [GROUP_PIN_WIDTH[8] - 1 : 0] group_8_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[8] - 1 : 0] group_8_data_io_n      ,
	input                               group_8_strobe_in    ,
	input                               group_8_strobe_in_n  ,
	output                              group_8_strobe_out   ,
	output                              group_8_strobe_out_n ,
	inout                               group_8_strobe_io    ,
	inout                               group_8_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[9] - 1 : 0] group_9_data_out     ,
	input  [GROUP_PIN_WIDTH[9] - 1 : 0] group_9_data_in      ,
	inout  [GROUP_PIN_WIDTH[9] - 1 : 0] group_9_data_io      ,
	output [GROUP_PIN_WIDTH[9] - 1 : 0] group_9_data_out_n     ,
	input  [GROUP_PIN_WIDTH[9] - 1 : 0] group_9_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[9] - 1 : 0] group_9_data_io_n      ,
	input                               group_9_strobe_in    ,
	input                               group_9_strobe_in_n  ,
	output                              group_9_strobe_out   ,
	output                              group_9_strobe_out_n ,
	inout                               group_9_strobe_io    ,
	inout                               group_9_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[10] - 1 : 0] group_10_data_out     ,
	input  [GROUP_PIN_WIDTH[10] - 1 : 0] group_10_data_in      ,
	inout  [GROUP_PIN_WIDTH[10] - 1 : 0] group_10_data_io      ,
	output [GROUP_PIN_WIDTH[10] - 1 : 0] group_10_data_out_n     ,
	input  [GROUP_PIN_WIDTH[10] - 1 : 0] group_10_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[10] - 1 : 0] group_10_data_io_n      ,
	input                                group_10_strobe_in    ,
	input                                group_10_strobe_in_n  ,
	output                               group_10_strobe_out   ,
	output                               group_10_strobe_out_n ,
	inout                                group_10_strobe_io    ,
	inout                                group_10_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[11] - 1 : 0] group_11_data_out     ,
	input  [GROUP_PIN_WIDTH[11] - 1 : 0] group_11_data_in      ,
	inout  [GROUP_PIN_WIDTH[11] - 1 : 0] group_11_data_io      ,
	output [GROUP_PIN_WIDTH[11] - 1 : 0] group_11_data_out_n     ,
	input  [GROUP_PIN_WIDTH[11] - 1 : 0] group_11_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[11] - 1 : 0] group_11_data_io_n      ,
	input                                group_11_strobe_in    ,
	input                                group_11_strobe_in_n  ,
	output                               group_11_strobe_out   ,
	output                               group_11_strobe_out_n ,
	inout                                group_11_strobe_io    ,
	inout                                group_11_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[12] - 1 : 0] group_12_data_out     ,
	input  [GROUP_PIN_WIDTH[12] - 1 : 0] group_12_data_in      ,
	inout  [GROUP_PIN_WIDTH[12] - 1 : 0] group_12_data_io      ,
	output [GROUP_PIN_WIDTH[12] - 1 : 0] group_12_data_out_n     ,
	input  [GROUP_PIN_WIDTH[12] - 1 : 0] group_12_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[12] - 1 : 0] group_12_data_io_n      ,
	input                                group_12_strobe_in    ,
	input                                group_12_strobe_in_n  ,
	output                               group_12_strobe_out   ,
	output                               group_12_strobe_out_n ,
	inout                                group_12_strobe_io    ,
	inout                                group_12_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[13] - 1 : 0] group_13_data_out     ,
	input  [GROUP_PIN_WIDTH[13] - 1 : 0] group_13_data_in      ,
	inout  [GROUP_PIN_WIDTH[13] - 1 : 0] group_13_data_io      ,
	output [GROUP_PIN_WIDTH[13] - 1 : 0] group_13_data_out_n     ,
	input  [GROUP_PIN_WIDTH[13] - 1 : 0] group_13_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[13] - 1 : 0] group_13_data_io_n      ,
	input                                group_13_strobe_in    ,
	input                                group_13_strobe_in_n  ,
	output                               group_13_strobe_out   ,
	output                               group_13_strobe_out_n ,
	inout                                group_13_strobe_io    ,
	inout                                group_13_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[14] - 1 : 0] group_14_data_out     ,
	input  [GROUP_PIN_WIDTH[14] - 1 : 0] group_14_data_in      ,
	inout  [GROUP_PIN_WIDTH[14] - 1 : 0] group_14_data_io      ,
	output [GROUP_PIN_WIDTH[14] - 1 : 0] group_14_data_out_n     ,
	input  [GROUP_PIN_WIDTH[14] - 1 : 0] group_14_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[14] - 1 : 0] group_14_data_io_n      ,
	input                                group_14_strobe_in    ,
	input                                group_14_strobe_in_n  ,
	output                               group_14_strobe_out   ,
	output                               group_14_strobe_out_n ,
	inout                                group_14_strobe_io    ,
	inout                                group_14_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[15] - 1 : 0] group_15_data_out     ,
	input  [GROUP_PIN_WIDTH[15] - 1 : 0] group_15_data_in      ,
	inout  [GROUP_PIN_WIDTH[15] - 1 : 0] group_15_data_io      ,
	output [GROUP_PIN_WIDTH[15] - 1 : 0] group_15_data_out_n     ,
	input  [GROUP_PIN_WIDTH[15] - 1 : 0] group_15_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[15] - 1 : 0] group_15_data_io_n      ,
	input                                group_15_strobe_in    ,
	input                                group_15_strobe_in_n  ,
	output                               group_15_strobe_out   ,
	output                               group_15_strobe_out_n ,
	inout                                group_15_strobe_io    ,
	inout                                group_15_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[16] - 1 : 0] group_16_data_out     ,
	input  [GROUP_PIN_WIDTH[16] - 1 : 0] group_16_data_in      ,
	inout  [GROUP_PIN_WIDTH[16] - 1 : 0] group_16_data_io      ,
	output [GROUP_PIN_WIDTH[16] - 1 : 0] group_16_data_out_n     ,
	input  [GROUP_PIN_WIDTH[16] - 1 : 0] group_16_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[16] - 1 : 0] group_16_data_io_n      ,
	input                                group_16_strobe_in    ,
	input                                group_16_strobe_in_n  ,
	output                               group_16_strobe_out   ,
	output                               group_16_strobe_out_n ,
	inout                                group_16_strobe_io    ,
	inout                                group_16_strobe_io_n  ,

	output [GROUP_PIN_WIDTH[17] - 1 : 0] group_17_data_out     ,
	input  [GROUP_PIN_WIDTH[17] - 1 : 0] group_17_data_in      ,
	inout  [GROUP_PIN_WIDTH[17] - 1 : 0] group_17_data_io      ,
	output [GROUP_PIN_WIDTH[17] - 1 : 0] group_17_data_out_n     ,
	input  [GROUP_PIN_WIDTH[17] - 1 : 0] group_17_data_in_n      ,
	inout  [GROUP_PIN_WIDTH[17] - 1 : 0] group_17_data_io_n      ,
	input                                group_17_strobe_in    ,
	input                                group_17_strobe_in_n  ,
	output                               group_17_strobe_out   ,
	output                               group_17_strobe_out_n ,
	inout                                group_17_strobe_io    ,
	inout                                group_17_strobe_io_n  

	);
	timeunit 1ns;
	timeprecision 1ns;


	////////////////////////////////////////////////////////////////////////////
	// Wire Declarations
	////////////////////////////////////////////////////////////////////////////
	wire [47 : 0] group_data_out     	[0:17];
	wire [47 : 0] group_data_in      	[0:17];
	wire [47 : 0] group_data_out_n     	[0:17];
	wire [47 : 0] group_data_in_n    	[0:17];
	wire          group_strobe_in    	[0:17];
	wire          group_strobe_in_n  	[0:17];
	wire          group_strobe_out   	[0:17];
	wire          group_strobe_out_n 	[0:17];
	
	////////////////////////////////////////////////////////////////////////////
	// Assign Group I/Os to internal arrays
	////////////////////////////////////////////////////////////////////////////
	generate
		if (GROUP_PIN_TYPE[0] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[0] == 0) begin
			assign group_0_strobe_io                                   = group_strobe_out      [0]                            ;
			assign group_0_strobe_io_n                                 = group_strobe_out_n    [0]                            ;

			assign group_strobe_in     [0]                             = group_0_strobe_io                                    ;
			assign group_strobe_in_n   [0]                             = group_0_strobe_io_n                                  ;

			assign group_0_strobe_out                                  = 1'b0                      ;
			assign group_0_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_0_strobe_io                                   = 1'b0                      ;
			assign group_0_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [0]                             = group_0_strobe_in                                    ;
			assign group_strobe_in_n   [0]                             = group_0_strobe_in_n                                  ;

			assign group_0_strobe_out                                  = group_strobe_out      [0]                            ;
			assign group_0_strobe_out_n                                = group_strobe_out_n    [0]                            ;			
		end
		if (GROUP_PIN_TYPE[0] == "BIDIR") begin
			assign group_0_data_io                                     = group_data_out        [0][GROUP_PIN_WIDTH[0] - 1 : 0];
			assign group_data_in       [0][GROUP_PIN_WIDTH[0] - 1 : 0] = group_0_data_io                                      ;
			assign group_0_data_out                                    = {GROUP_PIN_WIDTH[0]{1'b0}};
		end else begin
			assign group_0_data_io                                     = {GROUP_PIN_WIDTH[0]{1'b0}};
			assign group_data_in       [0][GROUP_PIN_WIDTH[0] - 1 : 0] = group_0_data_in                                      ;
			assign group_0_data_out                                    = group_data_out        [0][GROUP_PIN_WIDTH[0] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[1] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[1] == 0) begin
			assign group_1_strobe_io                                   = group_strobe_out      [1]                            ;
			assign group_1_strobe_io_n                                 = group_strobe_out_n    [1]                            ;

			assign group_strobe_in     [1]                             = group_1_strobe_io                                    ;
			assign group_strobe_in_n   [1]                             = group_1_strobe_io_n                                  ;

			assign group_1_strobe_out                                  = 1'b0                      ;
			assign group_1_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_1_strobe_io                                   = 1'b0                      ;
			assign group_1_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [1]                             = group_1_strobe_in                                    ;
			assign group_strobe_in_n   [1]                             = group_1_strobe_in_n                                  ;

			assign group_1_strobe_out                                  = group_strobe_out      [1]                            ;
			assign group_1_strobe_out_n                                = group_strobe_out_n    [1]                            ;			
		end
		if (GROUP_PIN_TYPE[1] == "BIDIR") begin
			assign group_1_data_io                                     = group_data_out        [1][GROUP_PIN_WIDTH[1] - 1 : 0];
			assign group_data_in       [1][GROUP_PIN_WIDTH[1] - 1 : 0] = group_1_data_io                                      ;
			assign group_1_data_out                                    = {GROUP_PIN_WIDTH[1]{1'b0}};
		end else begin
			assign group_1_data_io                                     = {GROUP_PIN_WIDTH[1]{1'b0}};
			assign group_data_in       [1][GROUP_PIN_WIDTH[1] - 1 : 0] = group_1_data_in                                      ;
			assign group_1_data_out                                    = group_data_out        [1][GROUP_PIN_WIDTH[1] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[2] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[2] == 0) begin
			assign group_2_strobe_io                                   = group_strobe_out      [2]                            ;
			assign group_2_strobe_io_n                                 = group_strobe_out_n    [2]                            ;

			assign group_strobe_in     [2]                             = group_2_strobe_io                                    ;
			assign group_strobe_in_n   [2]                             = group_2_strobe_io_n                                  ;

			assign group_2_strobe_out                                  = 1'b0                      ;
			assign group_2_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_2_strobe_io                                   = 1'b0                      ;
			assign group_2_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [2]                             = group_2_strobe_in                                    ;
			assign group_strobe_in_n   [2]                             = group_2_strobe_in_n                                  ;

			assign group_2_strobe_out                                  = group_strobe_out      [2]                            ;
			assign group_2_strobe_out_n                                = group_strobe_out_n    [2]                            ;			
		end
		if (GROUP_PIN_TYPE[2] == "BIDIR") begin
			assign group_2_data_io                                     = group_data_out        [2][GROUP_PIN_WIDTH[2] - 1 : 0];
			assign group_data_in       [2][GROUP_PIN_WIDTH[2] - 1 : 0] = group_2_data_io                                      ;
			assign group_2_data_out                                    = {GROUP_PIN_WIDTH[2]{1'b0}};
		end else begin
			assign group_2_data_io                                     = {GROUP_PIN_WIDTH[2]{1'b0}};
			assign group_data_in       [2][GROUP_PIN_WIDTH[2] - 1 : 0] = group_2_data_in                                      ;
			assign group_2_data_out                                    = group_data_out        [2][GROUP_PIN_WIDTH[2] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[3] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[3] == 0) begin
			assign group_3_strobe_io                                   = group_strobe_out      [3]                            ;
			assign group_3_strobe_io_n                                 = group_strobe_out_n    [3]                            ;

			assign group_strobe_in     [3]                             = group_3_strobe_io                                    ;
			assign group_strobe_in_n   [3]                             = group_3_strobe_io_n                                  ;

			assign group_3_strobe_out                                  = 1'b0                      ;
			assign group_3_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_3_strobe_io                                   = 1'b0                      ;
			assign group_3_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [3]                             = group_3_strobe_in                                    ;
			assign group_strobe_in_n   [3]                             = group_3_strobe_in_n                                  ;

			assign group_3_strobe_out                                  = group_strobe_out      [3]                            ;
			assign group_3_strobe_out_n                                = group_strobe_out_n    [3]                            ;			
		end
		if (GROUP_PIN_TYPE[3] == "BIDIR") begin
			assign group_3_data_io                                     = group_data_out        [3][GROUP_PIN_WIDTH[3] - 1 : 0];
			assign group_data_in       [3][GROUP_PIN_WIDTH[3] - 1 : 0] = group_3_data_io                                      ;
			assign group_3_data_out                                    = {GROUP_PIN_WIDTH[3]{1'b0}};
		end else begin
			assign group_3_data_io                                     = {GROUP_PIN_WIDTH[3]{1'b0}};
			assign group_data_in       [3][GROUP_PIN_WIDTH[3] - 1 : 0] = group_3_data_in                                      ;
			assign group_3_data_out                                    = group_data_out        [3][GROUP_PIN_WIDTH[3] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[4] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[4] == 0) begin
			assign group_4_strobe_io                                   = group_strobe_out      [4]                            ;
			assign group_4_strobe_io_n                                 = group_strobe_out_n    [4]                            ;

			assign group_strobe_in     [4]                             = group_4_strobe_io                                    ;
			assign group_strobe_in_n   [4]                             = group_4_strobe_io_n                                  ;

			assign group_4_strobe_out                                  = 1'b0                      ;
			assign group_4_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_4_strobe_io                                   = 1'b0                      ;
			assign group_4_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [4]                             = group_4_strobe_in                                    ;
			assign group_strobe_in_n   [4]                             = group_4_strobe_in_n                                  ;

			assign group_4_strobe_out                                  = group_strobe_out      [4]                            ;
			assign group_4_strobe_out_n                                = group_strobe_out_n    [4]                            ;			
		end
		if (GROUP_PIN_TYPE[4] == "BIDIR") begin
			assign group_4_data_io                                     = group_data_out        [4][GROUP_PIN_WIDTH[4] - 1 : 0];
			assign group_data_in       [4][GROUP_PIN_WIDTH[4] - 1 : 0] = group_4_data_io                                      ;
			assign group_4_data_out                                    = {GROUP_PIN_WIDTH[4]{1'b0}};
		end else begin
			assign group_4_data_io                                     = {GROUP_PIN_WIDTH[4]{1'b0}};
			assign group_data_in       [4][GROUP_PIN_WIDTH[4] - 1 : 0] = group_4_data_in                                      ;
			assign group_4_data_out                                    = group_data_out        [4][GROUP_PIN_WIDTH[4] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[5] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[5] == 0) begin
			assign group_5_strobe_io                                   = group_strobe_out      [5]                            ;
			assign group_5_strobe_io_n                                 = group_strobe_out_n    [5]                            ;

			assign group_strobe_in     [5]                             = group_5_strobe_io                                    ;
			assign group_strobe_in_n   [5]                             = group_5_strobe_io_n                                  ;

			assign group_5_strobe_out                                  = 1'b0                      ;
			assign group_5_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_5_strobe_io                                   = 1'b0                      ;
			assign group_5_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [5]                             = group_5_strobe_in                                    ;
			assign group_strobe_in_n   [5]                             = group_5_strobe_in_n                                  ;

			assign group_5_strobe_out                                  = group_strobe_out      [5]                            ;
			assign group_5_strobe_out_n                                = group_strobe_out_n    [5]                            ;			
		end
		if (GROUP_PIN_TYPE[5] == "BIDIR") begin
			assign group_5_data_io                                     = group_data_out        [5][GROUP_PIN_WIDTH[5] - 1 : 0];
			assign group_data_in       [5][GROUP_PIN_WIDTH[5] - 1 : 0] = group_5_data_io                                      ;
			assign group_5_data_out                                    = {GROUP_PIN_WIDTH[5]{1'b0}};
		end else begin
			assign group_5_data_io                                     = {GROUP_PIN_WIDTH[5]{1'b0}};
			assign group_data_in       [5][GROUP_PIN_WIDTH[5] - 1 : 0] = group_5_data_in                                      ;
			assign group_5_data_out                                    = group_data_out        [5][GROUP_PIN_WIDTH[5] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[6] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[6] == 0) begin
			assign group_6_strobe_io                                   = group_strobe_out      [6]                            ;
			assign group_6_strobe_io_n                                 = group_strobe_out_n    [6]                            ;

			assign group_strobe_in     [6]                             = group_6_strobe_io                                    ;
			assign group_strobe_in_n   [6]                             = group_6_strobe_io_n                                  ;

			assign group_6_strobe_out                                  = 1'b0                      ;
			assign group_6_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_6_strobe_io                                   = 1'b0                      ;
			assign group_6_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [6]                             = group_6_strobe_in                                    ;
			assign group_strobe_in_n   [6]                             = group_6_strobe_in_n                                  ;

			assign group_6_strobe_out                                  = group_strobe_out      [6]                            ;
			assign group_6_strobe_out_n                                = group_strobe_out_n    [6]                            ;			
		end
		if (GROUP_PIN_TYPE[6] == "BIDIR") begin
			assign group_6_data_io                                     = group_data_out        [6][GROUP_PIN_WIDTH[6] - 1 : 0];
			assign group_data_in       [6][GROUP_PIN_WIDTH[6] - 1 : 0] = group_6_data_io                                      ;
			assign group_6_data_out                                    = {GROUP_PIN_WIDTH[6]{1'b0}};
		end else begin
			assign group_6_data_io                                     = {GROUP_PIN_WIDTH[6]{1'b0}};
			assign group_data_in       [6][GROUP_PIN_WIDTH[6] - 1 : 0] = group_6_data_in                                      ;
			assign group_6_data_out                                    = group_data_out        [6][GROUP_PIN_WIDTH[6] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[7] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[7] == 0) begin
			assign group_7_strobe_io                                   = group_strobe_out      [7]                            ;
			assign group_7_strobe_io_n                                 = group_strobe_out_n    [7]                            ;

			assign group_strobe_in     [7]                             = group_7_strobe_io                                    ;
			assign group_strobe_in_n   [7]                             = group_7_strobe_io_n                                  ;

			assign group_7_strobe_out                                  = 1'b0                      ;
			assign group_7_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_7_strobe_io                                   = 1'b0                      ;
			assign group_7_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [7]                             = group_7_strobe_in                                    ;
			assign group_strobe_in_n   [7]                             = group_7_strobe_in_n                                  ;

			assign group_7_strobe_out                                  = group_strobe_out      [7]                            ;
			assign group_7_strobe_out_n                                = group_strobe_out_n    [7]                            ;			
		end
		if (GROUP_PIN_TYPE[7] == "BIDIR") begin
			assign group_7_data_io                                     = group_data_out        [7][GROUP_PIN_WIDTH[7] - 1 : 0];
			assign group_data_in       [7][GROUP_PIN_WIDTH[7] - 1 : 0] = group_7_data_io                                      ;
			assign group_7_data_out                                    = {GROUP_PIN_WIDTH[7]{1'b0}};
		end else begin
			assign group_7_data_io                                     = {GROUP_PIN_WIDTH[7]{1'b0}};
			assign group_data_in       [7][GROUP_PIN_WIDTH[7] - 1 : 0] = group_7_data_in                                      ;
			assign group_7_data_out                                    = group_data_out        [7][GROUP_PIN_WIDTH[7] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[8] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[8] == 0) begin
			assign group_8_strobe_io                                   = group_strobe_out      [8]                            ;
			assign group_8_strobe_io_n                                 = group_strobe_out_n    [8]                            ;

			assign group_strobe_in     [8]                             = group_8_strobe_io                                    ;
			assign group_strobe_in_n   [8]                             = group_8_strobe_io_n                                  ;

			assign group_8_strobe_out                                  = 1'b0                      ;
			assign group_8_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_8_strobe_io                                   = 1'b0                      ;
			assign group_8_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [8]                             = group_8_strobe_in                                    ;
			assign group_strobe_in_n   [8]                             = group_8_strobe_in_n                                  ;

			assign group_8_strobe_out                                  = group_strobe_out      [8]                            ;
			assign group_8_strobe_out_n                                = group_strobe_out_n    [8]                            ;			
		end
		if (GROUP_PIN_TYPE[8] == "BIDIR") begin
			assign group_8_data_io                                     = group_data_out        [8][GROUP_PIN_WIDTH[8] - 1 : 0];
			assign group_data_in       [8][GROUP_PIN_WIDTH[8] - 1 : 0] = group_8_data_io                                      ;
			assign group_8_data_out                                    = {GROUP_PIN_WIDTH[8]{1'b0}};
		end else begin
			assign group_8_data_io                                     = {GROUP_PIN_WIDTH[8]{1'b0}};
			assign group_data_in       [8][GROUP_PIN_WIDTH[8] - 1 : 0] = group_8_data_in                                      ;
			assign group_8_data_out                                    = group_data_out        [8][GROUP_PIN_WIDTH[8] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[9] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[9] == 0) begin
			assign group_9_strobe_io                                   = group_strobe_out      [9]                            ;
			assign group_9_strobe_io_n                                 = group_strobe_out_n    [9]                            ;

			assign group_strobe_in     [9]                             = group_9_strobe_io                                    ;
			assign group_strobe_in_n   [9]                             = group_9_strobe_io_n                                  ;

			assign group_9_strobe_out                                  = 1'b0                      ;
			assign group_9_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_9_strobe_io                                   = 1'b0                      ;
			assign group_9_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [9]                             = group_9_strobe_in                                    ;
			assign group_strobe_in_n   [9]                             = group_9_strobe_in_n                                  ;

			assign group_9_strobe_out                                  = group_strobe_out      [9]                            ;
			assign group_9_strobe_out_n                                = group_strobe_out_n    [9]                            ;			
		end
		if (GROUP_PIN_TYPE[9] == "BIDIR") begin
			assign group_9_data_io                                     = group_data_out        [9][GROUP_PIN_WIDTH[9] - 1 : 0];
			assign group_data_in       [9][GROUP_PIN_WIDTH[9] - 1 : 0] = group_9_data_io                                      ;
			assign group_9_data_out                                    = {GROUP_PIN_WIDTH[9]{1'b0}};
		end else begin
			assign group_9_data_io                                     = {GROUP_PIN_WIDTH[9]{1'b0}};
			assign group_data_in       [9][GROUP_PIN_WIDTH[9] - 1 : 0] = group_9_data_in                                      ;
			assign group_9_data_out                                    = group_data_out        [9][GROUP_PIN_WIDTH[9] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[10] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[10] == 0) begin
			assign group_10_strobe_io                                   = group_strobe_out      [10]                            ;
			assign group_10_strobe_io_n                                 = group_strobe_out_n    [10]                            ;

			assign group_strobe_in     [10]                             = group_10_strobe_io                                    ;
			assign group_strobe_in_n   [10]                             = group_10_strobe_io_n                                  ;

			assign group_10_strobe_out                                  = 1'b0                      ;
			assign group_10_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_10_strobe_io                                   = 1'b0                      ;
			assign group_10_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [10]                             = group_10_strobe_in                                    ;
			assign group_strobe_in_n   [10]                             = group_10_strobe_in_n                                  ;

			assign group_10_strobe_out                                  = group_strobe_out      [10]                            ;
			assign group_10_strobe_out_n                                = group_strobe_out_n    [10]                            ;			
		end
		if (GROUP_PIN_TYPE[10] == "BIDIR") begin
			assign group_10_data_io                                     = group_data_out        [10][GROUP_PIN_WIDTH[10] - 1 : 0];
			assign group_data_in       [10][GROUP_PIN_WIDTH[10] - 1 : 0] = group_10_data_io                                      ;
			assign group_10_data_out                                    = {GROUP_PIN_WIDTH[10]{1'b0}};
		end else begin
			assign group_10_data_io                                     = {GROUP_PIN_WIDTH[10]{1'b0}};
			assign group_data_in       [10][GROUP_PIN_WIDTH[10] - 1 : 0] = group_10_data_in                                      ;
			assign group_10_data_out                                    = group_data_out        [10][GROUP_PIN_WIDTH[10] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[11] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[11] == 0) begin
			assign group_11_strobe_io                                   = group_strobe_out      [11]                            ;
			assign group_11_strobe_io_n                                 = group_strobe_out_n    [11]                            ;

			assign group_strobe_in     [11]                             = group_11_strobe_io                                    ;
			assign group_strobe_in_n   [11]                             = group_11_strobe_io_n                                  ;

			assign group_11_strobe_out                                  = 1'b0                      ;
			assign group_11_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_11_strobe_io                                   = 1'b0                      ;
			assign group_11_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [11]                             = group_11_strobe_in                                    ;
			assign group_strobe_in_n   [11]                             = group_11_strobe_in_n                                  ;

			assign group_11_strobe_out                                  = group_strobe_out      [11]                            ;
			assign group_11_strobe_out_n                                = group_strobe_out_n    [11]                            ;			
		end
		if (GROUP_PIN_TYPE[11] == "BIDIR") begin
			assign group_11_data_io                                     = group_data_out        [11][GROUP_PIN_WIDTH[11] - 1 : 0];
			assign group_data_in       [11][GROUP_PIN_WIDTH[11] - 1 : 0] = group_11_data_io                                      ;
			assign group_11_data_out                                    = {GROUP_PIN_WIDTH[11]{1'b0}};
		end else begin
			assign group_11_data_io                                     = {GROUP_PIN_WIDTH[11]{1'b0}};
			assign group_data_in       [11][GROUP_PIN_WIDTH[11] - 1 : 0] = group_11_data_in                                      ;
			assign group_11_data_out                                    = group_data_out        [11][GROUP_PIN_WIDTH[11] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[12] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[12] == 0) begin
			assign group_12_strobe_io                                   = group_strobe_out      [12]                            ;
			assign group_12_strobe_io_n                                 = group_strobe_out_n    [12]                            ;

			assign group_strobe_in     [12]                             = group_12_strobe_io                                    ;
			assign group_strobe_in_n   [12]                             = group_12_strobe_io_n                                  ;

			assign group_12_strobe_out                                  = 1'b0                      ;
			assign group_12_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_12_strobe_io                                   = 1'b0                      ;
			assign group_12_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [12]                             = group_12_strobe_in                                    ;
			assign group_strobe_in_n   [12]                             = group_12_strobe_in_n                                  ;

			assign group_12_strobe_out                                  = group_strobe_out      [12]                            ;
			assign group_12_strobe_out_n                                = group_strobe_out_n    [12]                            ;			
		end
		if (GROUP_PIN_TYPE[12] == "BIDIR") begin
			assign group_12_data_io                                     = group_data_out        [12][GROUP_PIN_WIDTH[12] - 1 : 0];
			assign group_data_in       [12][GROUP_PIN_WIDTH[12] - 1 : 0] = group_12_data_io                                      ;
			assign group_12_data_out                                    = {GROUP_PIN_WIDTH[12]{1'b0}};
		end else begin
			assign group_12_data_io                                     = {GROUP_PIN_WIDTH[12]{1'b0}};
			assign group_data_in       [12][GROUP_PIN_WIDTH[12] - 1 : 0] = group_12_data_in                                      ;
			assign group_12_data_out                                    = group_data_out        [12][GROUP_PIN_WIDTH[12] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[13] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[13] == 0) begin
			assign group_13_strobe_io                                   = group_strobe_out      [13]                            ;
			assign group_13_strobe_io_n                                 = group_strobe_out_n    [13]                            ;

			assign group_strobe_in     [13]                             = group_13_strobe_io                                    ;
			assign group_strobe_in_n   [13]                             = group_13_strobe_io_n                                  ;

			assign group_13_strobe_out                                  = 1'b0                      ;
			assign group_13_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_13_strobe_io                                   = 1'b0                      ;
			assign group_13_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [13]                             = group_13_strobe_in                                    ;
			assign group_strobe_in_n   [13]                             = group_13_strobe_in_n                                  ;

			assign group_13_strobe_out                                  = group_strobe_out      [13]                            ;
			assign group_13_strobe_out_n                                = group_strobe_out_n    [13]                            ;			
		end
		if (GROUP_PIN_TYPE[13] == "BIDIR") begin
			assign group_13_data_io                                     = group_data_out        [13][GROUP_PIN_WIDTH[13] - 1 : 0];
			assign group_data_in       [13][GROUP_PIN_WIDTH[13] - 1 : 0] = group_13_data_io                                      ;
			assign group_13_data_out                                    = {GROUP_PIN_WIDTH[13]{1'b0}};
		end else begin
			assign group_13_data_io                                     = {GROUP_PIN_WIDTH[13]{1'b0}};
			assign group_data_in       [13][GROUP_PIN_WIDTH[13] - 1 : 0] = group_13_data_in                                      ;
			assign group_13_data_out                                    = group_data_out        [13][GROUP_PIN_WIDTH[13] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[14] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[14] == 0) begin
			assign group_14_strobe_io                                   = group_strobe_out      [14]                            ;
			assign group_14_strobe_io_n                                 = group_strobe_out_n    [14]                            ;

			assign group_strobe_in     [14]                             = group_14_strobe_io                                    ;
			assign group_strobe_in_n   [14]                             = group_14_strobe_io_n                                  ;

			assign group_14_strobe_out                                  = 1'b0                      ;
			assign group_14_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_14_strobe_io                                   = 1'b0                      ;
			assign group_14_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [14]                             = group_14_strobe_in                                    ;
			assign group_strobe_in_n   [14]                             = group_14_strobe_in_n                                  ;

			assign group_14_strobe_out                                  = group_strobe_out      [14]                            ;
			assign group_14_strobe_out_n                                = group_strobe_out_n    [14]                            ;			
		end
		if (GROUP_PIN_TYPE[14] == "BIDIR") begin
			assign group_14_data_io                                     = group_data_out        [14][GROUP_PIN_WIDTH[14] - 1 : 0];
			assign group_data_in       [14][GROUP_PIN_WIDTH[14] - 1 : 0] = group_14_data_io                                      ;
			assign group_14_data_out                                    = {GROUP_PIN_WIDTH[14]{1'b0}};
		end else begin
			assign group_14_data_io                                     = {GROUP_PIN_WIDTH[14]{1'b0}};
			assign group_data_in       [14][GROUP_PIN_WIDTH[14] - 1 : 0] = group_14_data_in                                      ;
			assign group_14_data_out                                    = group_data_out        [14][GROUP_PIN_WIDTH[14] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[15] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[15] == 0) begin
			assign group_15_strobe_io                                   = group_strobe_out      [15]                            ;
			assign group_15_strobe_io_n                                 = group_strobe_out_n    [15]                            ;

			assign group_strobe_in     [15]                             = group_15_strobe_io                                    ;
			assign group_strobe_in_n   [15]                             = group_15_strobe_io_n                                  ;

			assign group_15_strobe_out                                  = 1'b0                      ;
			assign group_15_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_15_strobe_io                                   = 1'b0                      ;
			assign group_15_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [15]                             = group_15_strobe_in                                    ;
			assign group_strobe_in_n   [15]                             = group_15_strobe_in_n                                  ;

			assign group_15_strobe_out                                  = group_strobe_out      [15]                            ;
			assign group_15_strobe_out_n                                = group_strobe_out_n    [15]                            ;			
		end
		if (GROUP_PIN_TYPE[15] == "BIDIR") begin
			assign group_15_data_io                                     = group_data_out        [15][GROUP_PIN_WIDTH[15] - 1 : 0];
			assign group_data_in       [15][GROUP_PIN_WIDTH[15] - 1 : 0] = group_15_data_io                                      ;
			assign group_15_data_out                                    = {GROUP_PIN_WIDTH[15]{1'b0}};
		end else begin
			assign group_15_data_io                                     = {GROUP_PIN_WIDTH[15]{1'b0}};
			assign group_data_in       [15][GROUP_PIN_WIDTH[15] - 1 : 0] = group_15_data_in                                      ;
			assign group_15_data_out                                    = group_data_out        [15][GROUP_PIN_WIDTH[15] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[16] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[16] == 0) begin
			assign group_16_strobe_io                                   = group_strobe_out      [16]                            ;
			assign group_16_strobe_io_n                                 = group_strobe_out_n    [16]                            ;

			assign group_strobe_in     [16]                             = group_16_strobe_io                                    ;
			assign group_strobe_in_n   [16]                             = group_16_strobe_io_n                                  ;

			assign group_16_strobe_out                                  = 1'b0                      ;
			assign group_16_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_16_strobe_io                                   = 1'b0                      ;
			assign group_16_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [16]                             = group_16_strobe_in                                    ;
			assign group_strobe_in_n   [16]                             = group_16_strobe_in_n                                  ;

			assign group_16_strobe_out                                  = group_strobe_out      [16]                            ;
			assign group_16_strobe_out_n                                = group_strobe_out_n    [16]                            ;			
		end
		if (GROUP_PIN_TYPE[16] == "BIDIR") begin
			assign group_16_data_io                                     = group_data_out        [16][GROUP_PIN_WIDTH[16] - 1 : 0];
			assign group_data_in       [16][GROUP_PIN_WIDTH[16] - 1 : 0] = group_16_data_io                                      ;
			assign group_16_data_out                                    = {GROUP_PIN_WIDTH[16]{1'b0}};
		end else begin
			assign group_16_data_io                                     = {GROUP_PIN_WIDTH[16]{1'b0}};
			assign group_data_in       [16][GROUP_PIN_WIDTH[16] - 1 : 0] = group_16_data_in                                      ;
			assign group_16_data_out                                    = group_data_out        [16][GROUP_PIN_WIDTH[16] - 1 : 0];
		end
		
		if (GROUP_PIN_TYPE[17] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[17] == 0) begin
			assign group_17_strobe_io                                   = group_strobe_out      [17]                            ;
			assign group_17_strobe_io_n                                 = group_strobe_out_n    [17]                            ;

			assign group_strobe_in     [17]                             = group_17_strobe_io                                    ;
			assign group_strobe_in_n   [17]                             = group_17_strobe_io_n                                  ;

			assign group_17_strobe_out                                  = 1'b0                      ;
			assign group_17_strobe_out_n                                = 1'b0                      ;
		end else begin
			assign group_17_strobe_io                                   = 1'b0                      ;
			assign group_17_strobe_io_n                                 = 1'b0                      ;

			assign group_strobe_in     [17]                             = group_17_strobe_in                                    ;
			assign group_strobe_in_n   [17]                             = group_17_strobe_in_n                                  ;

			assign group_17_strobe_out                                  = group_strobe_out      [17]                            ;
			assign group_17_strobe_out_n                                = group_strobe_out_n    [17]                            ;			
		end
		if (GROUP_PIN_TYPE[17] == "BIDIR") begin
			assign group_17_data_io                                     = group_data_out        [17][GROUP_PIN_WIDTH[17] - 1 : 0];
			assign group_data_in       [17][GROUP_PIN_WIDTH[17] - 1 : 0] = group_17_data_io                                      ;
			assign group_17_data_out                                    = {GROUP_PIN_WIDTH[17]{1'b0}};
		end else begin
			assign group_17_data_io                                     = {GROUP_PIN_WIDTH[17]{1'b0}};
			assign group_data_in       [17][GROUP_PIN_WIDTH[17] - 1 : 0] = group_17_data_in                                      ;
			assign group_17_data_out                                    = group_data_out        [17][GROUP_PIN_WIDTH[17] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[0] == "BIDIR") begin
			assign group_0_data_io_n                                     = group_data_out_n        [0][GROUP_PIN_WIDTH[0] - 1 : 0];
			assign group_data_in_n       [0][GROUP_PIN_WIDTH[0] - 1 : 0] = group_0_data_io_n                                      ;
			assign group_0_data_out_n                                    = {GROUP_PIN_WIDTH[0]{1'b0}};
		end else begin
			assign group_0_data_io_n                                     = {GROUP_PIN_WIDTH[0]{1'b0}};
			assign group_data_in_n       [0][GROUP_PIN_WIDTH[0] - 1 : 0] = group_0_data_in_n                                      ;
			assign group_0_data_out_n                                    = group_data_out_n        [0][GROUP_PIN_WIDTH[0] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[1] == "BIDIR") begin
			assign group_1_data_io_n                                     = group_data_out_n        [1][GROUP_PIN_WIDTH[1] - 1 : 0];
			assign group_data_in_n       [1][GROUP_PIN_WIDTH[1] - 1 : 0] = group_1_data_io_n                                      ;
			assign group_1_data_out_n                                    = {GROUP_PIN_WIDTH[1]{1'b0}};
		end else begin
			assign group_1_data_io_n                                     = {GROUP_PIN_WIDTH[1]{1'b0}};
			assign group_data_in_n       [1][GROUP_PIN_WIDTH[1] - 1 : 0] = group_1_data_in_n                                      ;
			assign group_1_data_out_n                                    = group_data_out_n        [1][GROUP_PIN_WIDTH[1] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[2] == "BIDIR") begin
			assign group_2_data_io_n                                     = group_data_out_n        [2][GROUP_PIN_WIDTH[2] - 1 : 0];
			assign group_data_in_n       [2][GROUP_PIN_WIDTH[2] - 1 : 0] = group_2_data_io_n                                      ;
			assign group_2_data_out_n                                    = {GROUP_PIN_WIDTH[2]{1'b0}};
		end else begin
			assign group_2_data_io_n                                     = {GROUP_PIN_WIDTH[2]{1'b0}};
			assign group_data_in_n       [2][GROUP_PIN_WIDTH[2] - 1 : 0] = group_2_data_in_n                                      ;
			assign group_2_data_out_n                                    = group_data_out_n        [2][GROUP_PIN_WIDTH[2] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[3] == "BIDIR") begin
			assign group_3_data_io_n                                     = group_data_out_n        [3][GROUP_PIN_WIDTH[3] - 1 : 0];
			assign group_data_in_n       [3][GROUP_PIN_WIDTH[3] - 1 : 0] = group_3_data_io_n                                      ;
			assign group_3_data_out_n                                    = {GROUP_PIN_WIDTH[3]{1'b0}};
		end else begin
			assign group_3_data_io_n                                     = {GROUP_PIN_WIDTH[3]{1'b0}};
			assign group_data_in_n       [3][GROUP_PIN_WIDTH[3] - 1 : 0] = group_3_data_in_n                                      ;
			assign group_3_data_out_n                                    = group_data_out_n        [3][GROUP_PIN_WIDTH[3] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[4] == "BIDIR") begin
			assign group_4_data_io_n                                     = group_data_out_n        [4][GROUP_PIN_WIDTH[4] - 1 : 0];
			assign group_data_in_n       [4][GROUP_PIN_WIDTH[4] - 1 : 0] = group_4_data_io_n                                      ;
			assign group_4_data_out_n                                    = {GROUP_PIN_WIDTH[4]{1'b0}};
		end else begin
			assign group_4_data_io_n                                     = {GROUP_PIN_WIDTH[4]{1'b0}};
			assign group_data_in_n       [4][GROUP_PIN_WIDTH[4] - 1 : 0] = group_4_data_in_n                                      ;
			assign group_4_data_out_n                                    = group_data_out_n        [4][GROUP_PIN_WIDTH[4] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[5] == "BIDIR") begin
			assign group_5_data_io_n                                     = group_data_out_n        [5][GROUP_PIN_WIDTH[5] - 1 : 0];
			assign group_data_in_n       [5][GROUP_PIN_WIDTH[5] - 1 : 0] = group_5_data_io_n                                      ;
			assign group_5_data_out_n                                    = {GROUP_PIN_WIDTH[5]{1'b0}};
		end else begin
			assign group_5_data_io_n                                     = {GROUP_PIN_WIDTH[5]{1'b0}};
			assign group_data_in_n       [5][GROUP_PIN_WIDTH[5] - 1 : 0] = group_5_data_in_n                                      ;
			assign group_5_data_out_n                                    = group_data_out_n        [5][GROUP_PIN_WIDTH[5] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[6] == "BIDIR") begin
			assign group_6_data_io_n                                     = group_data_out_n        [6][GROUP_PIN_WIDTH[6] - 1 : 0];
			assign group_data_in_n       [6][GROUP_PIN_WIDTH[6] - 1 : 0] = group_6_data_io_n                                      ;
			assign group_6_data_out_n                                    = {GROUP_PIN_WIDTH[6]{1'b0}};
		end else begin
			assign group_6_data_io_n                                     = {GROUP_PIN_WIDTH[6]{1'b0}};
			assign group_data_in_n       [6][GROUP_PIN_WIDTH[6] - 1 : 0] = group_6_data_in_n                                      ;
			assign group_6_data_out_n                                    = group_data_out_n        [6][GROUP_PIN_WIDTH[6] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[7] == "BIDIR") begin
			assign group_7_data_io_n                                     = group_data_out_n        [7][GROUP_PIN_WIDTH[7] - 1 : 0];
			assign group_data_in_n       [7][GROUP_PIN_WIDTH[7] - 1 : 0] = group_7_data_io_n                                      ;
			assign group_7_data_out_n                                    = {GROUP_PIN_WIDTH[7]{1'b0}};
		end else begin
			assign group_7_data_io_n                                     = {GROUP_PIN_WIDTH[7]{1'b0}};
			assign group_data_in_n       [7][GROUP_PIN_WIDTH[7] - 1 : 0] = group_7_data_in_n                                      ;
			assign group_7_data_out_n                                    = group_data_out_n        [7][GROUP_PIN_WIDTH[7] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[8] == "BIDIR") begin
			assign group_8_data_io_n                                     = group_data_out_n        [8][GROUP_PIN_WIDTH[8] - 1 : 0];
			assign group_data_in_n       [8][GROUP_PIN_WIDTH[8] - 1 : 0] = group_8_data_io_n                                      ;
			assign group_8_data_out_n                                    = {GROUP_PIN_WIDTH[8]{1'b0}};
		end else begin
			assign group_8_data_io_n                                     = {GROUP_PIN_WIDTH[8]{1'b0}};
			assign group_data_in_n       [8][GROUP_PIN_WIDTH[8] - 1 : 0] = group_8_data_in_n                                      ;
			assign group_8_data_out_n                                    = group_data_out_n        [8][GROUP_PIN_WIDTH[8] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[9] == "BIDIR") begin
			assign group_9_data_io_n                                     = group_data_out_n        [9][GROUP_PIN_WIDTH[9] - 1 : 0];
			assign group_data_in_n       [9][GROUP_PIN_WIDTH[9] - 1 : 0] = group_9_data_io_n                                      ;
			assign group_9_data_out_n                                    = {GROUP_PIN_WIDTH[9]{1'b0}};
		end else begin
			assign group_9_data_io_n                                     = {GROUP_PIN_WIDTH[9]{1'b0}};
			assign group_data_in_n       [9][GROUP_PIN_WIDTH[9] - 1 : 0] = group_9_data_in_n                                      ;
			assign group_9_data_out_n                                    = group_data_out_n        [9][GROUP_PIN_WIDTH[9] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[10] == "BIDIR") begin
			assign group_10_data_io_n                                     = group_data_out_n        [10][GROUP_PIN_WIDTH[10] - 1 : 0];
			assign group_data_in_n       [10][GROUP_PIN_WIDTH[10] - 1 : 0] = group_10_data_io_n                                      ;
			assign group_10_data_out_n                                    = {GROUP_PIN_WIDTH[10]{1'b0}};
		end else begin
			assign group_10_data_io_n                                     = {GROUP_PIN_WIDTH[10]{1'b0}};
			assign group_data_in_n       [10][GROUP_PIN_WIDTH[10] - 1 : 0] = group_10_data_in_n                                      ;
			assign group_10_data_out_n                                    = group_data_out_n        [10][GROUP_PIN_WIDTH[10] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[11] == "BIDIR") begin
			assign group_11_data_io_n                                     = group_data_out_n        [11][GROUP_PIN_WIDTH[11] - 1 : 0];
			assign group_data_in_n       [11][GROUP_PIN_WIDTH[11] - 1 : 0] = group_11_data_io_n                                      ;
			assign group_11_data_out_n                                    = {GROUP_PIN_WIDTH[11]{1'b0}};
		end else begin
			assign group_11_data_io_n                                     = {GROUP_PIN_WIDTH[11]{1'b0}};
			assign group_data_in_n       [11][GROUP_PIN_WIDTH[11] - 1 : 0] = group_11_data_in_n                                      ;
			assign group_11_data_out_n                                    = group_data_out_n        [11][GROUP_PIN_WIDTH[11] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[12] == "BIDIR") begin
			assign group_12_data_io_n                                     = group_data_out_n        [12][GROUP_PIN_WIDTH[12] - 1 : 0];
			assign group_data_in_n       [12][GROUP_PIN_WIDTH[12] - 1 : 0] = group_12_data_io_n                                      ;
			assign group_12_data_out_n                                    = {GROUP_PIN_WIDTH[12]{1'b0}};
		end else begin
			assign group_12_data_io_n                                     = {GROUP_PIN_WIDTH[12]{1'b0}};
			assign group_data_in_n       [12][GROUP_PIN_WIDTH[12] - 1 : 0] = group_12_data_in_n                                      ;
			assign group_12_data_out_n                                    = group_data_out_n        [12][GROUP_PIN_WIDTH[12] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[13] == "BIDIR") begin
			assign group_13_data_io_n                                     = group_data_out_n        [13][GROUP_PIN_WIDTH[13] - 1 : 0];
			assign group_data_in_n       [13][GROUP_PIN_WIDTH[13] - 1 : 0] = group_13_data_io_n                                      ;
			assign group_13_data_out_n                                    = {GROUP_PIN_WIDTH[13]{1'b0}};
		end else begin
			assign group_13_data_io_n                                     = {GROUP_PIN_WIDTH[13]{1'b0}};
			assign group_data_in_n       [13][GROUP_PIN_WIDTH[13] - 1 : 0] = group_13_data_in_n                                      ;
			assign group_13_data_out_n                                    = group_data_out_n        [13][GROUP_PIN_WIDTH[13] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[14] == "BIDIR") begin
			assign group_14_data_io_n                                     = group_data_out_n        [14][GROUP_PIN_WIDTH[14] - 1 : 0];
			assign group_data_in_n       [14][GROUP_PIN_WIDTH[14] - 1 : 0] = group_14_data_io_n                                      ;
			assign group_14_data_out_n                                    = {GROUP_PIN_WIDTH[14]{1'b0}};
		end else begin
			assign group_14_data_io_n                                     = {GROUP_PIN_WIDTH[14]{1'b0}};
			assign group_data_in_n       [14][GROUP_PIN_WIDTH[14] - 1 : 0] = group_14_data_in_n                                      ;
			assign group_14_data_out_n                                    = group_data_out_n        [14][GROUP_PIN_WIDTH[14] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[15] == "BIDIR") begin
			assign group_15_data_io_n                                     = group_data_out_n        [15][GROUP_PIN_WIDTH[15] - 1 : 0];
			assign group_data_in_n       [15][GROUP_PIN_WIDTH[15] - 1 : 0] = group_15_data_io_n                                      ;
			assign group_15_data_out_n                                    = {GROUP_PIN_WIDTH[15]{1'b0}};
		end else begin
			assign group_15_data_io_n                                     = {GROUP_PIN_WIDTH[15]{1'b0}};
			assign group_data_in_n       [15][GROUP_PIN_WIDTH[15] - 1 : 0] = group_15_data_in_n                                      ;
			assign group_15_data_out_n                                    = group_data_out_n        [15][GROUP_PIN_WIDTH[15] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[16] == "BIDIR") begin
			assign group_16_data_io_n                                     = group_data_out_n        [16][GROUP_PIN_WIDTH[16] - 1 : 0];
			assign group_data_in_n       [16][GROUP_PIN_WIDTH[16] - 1 : 0] = group_16_data_io_n                                      ;
			assign group_16_data_out_n                                    = {GROUP_PIN_WIDTH[16]{1'b0}};
		end else begin
			assign group_16_data_io_n                                     = {GROUP_PIN_WIDTH[16]{1'b0}};
			assign group_data_in_n       [16][GROUP_PIN_WIDTH[16] - 1 : 0] = group_16_data_in_n                                      ;
			assign group_16_data_out_n                                    = group_data_out_n        [16][GROUP_PIN_WIDTH[16] - 1 : 0];
		end

		if (GROUP_PIN_TYPE[17] == "BIDIR") begin
			assign group_17_data_io_n                                     = group_data_out_n        [17][GROUP_PIN_WIDTH[17] - 1 : 0];
			assign group_data_in_n       [17][GROUP_PIN_WIDTH[17] - 1 : 0] = group_17_data_io_n                                      ;
			assign group_17_data_out_n                                    = {GROUP_PIN_WIDTH[17]{1'b0}};
		end else begin
			assign group_17_data_io_n                                     = {GROUP_PIN_WIDTH[17]{1'b0}};
			assign group_data_in_n       [17][GROUP_PIN_WIDTH[17] - 1 : 0] = group_17_data_in_n                                      ;
			assign group_17_data_out_n                                    = group_data_out_n        [17][GROUP_PIN_WIDTH[17] - 1 : 0];
		end


	endgenerate

	////////////////////////////////////////////////////////////////////////////
	// Instantiate data buffers
	////////////////////////////////////////////////////////////////////////////
	generate
		genvar grp_num, pin_idx;
		for (grp_num = 0; grp_num < 18; grp_num = grp_num + 1) begin : data_io_buf_gen_grp
			localparam STR_OFFSET = (((GROUP_PIN_TYPE[grp_num] == "OUTPUT") && (GROUP_USE_OUTPUT_STROBE[grp_num] == 0))                                                     ? 0 :
			                          ((GROUP_PIN_TYPE[grp_num] == "INPUT") && (GROUP_USE_INTERNAL_CAPTURE_STROBE[grp_num] == 1))                                            ? 0 :
			                          ((GROUP_PIN_TYPE[grp_num] == "BIDIR") && (GROUP_USE_INTERNAL_CAPTURE_STROBE[grp_num] == 1) && (GROUP_USE_OUTPUT_STROBE[grp_num] == 0)) ? 0 :
						   (GROUP_STROBE_CONFIG[grp_num] == "SINGLE_ENDED")                                                                                      ? 1 : 
			                                                                                                                                                                   2 )
			                         * ((GROUP_USE_SEPARATE_STROBES[grp_num] == 1) ? 2 : 1);
						 
			localparam OS_P_INDEX = 0;
			localparam OS_N_INDEX = 1;
			localparam LANE_OFFSET = ( STR_OFFSET == 1 && GROUP_DATA_CONFIG[grp_num] == "DIFF") ? 1 : 0;
			localparam DATA_OFFSET = (GROUP_DATA_CONFIG[grp_num] == "DIFF") ?  (LANE_OFFSET + STR_OFFSET) : STR_OFFSET;

			if (grp_num < NUM_GROUPS) begin
				if (GROUP_PIN_TYPE[grp_num] == "OUTPUT" || GROUP_PIN_TYPE[grp_num] == "BIDIR") begin
					if (GROUP_DATA_CONFIG[grp_num] == "SGL_ENDED") begin
						for (pin_idx = 0; pin_idx < GROUP_PIN_WIDTH[grp_num]; pin_idx = pin_idx + 1) begin : data_io_obuf_gen
							twentynm_io_obuf u_data_buf (
								.i                         (data_out[grp_num][pin_idx + DATA_OFFSET]  ),
								.oe                        (data_oe [grp_num][pin_idx + DATA_OFFSET]  ),
								.o                         (group_data_out[grp_num][pin_idx]          ),
								.obar                      (),
								.dynamicterminationcontrol (oct_enable[grp_num][pin_idx + DATA_OFFSET]),
								.seriesterminationcontrol  (),
								.parallelterminationcontrol()
							);
						end 
						assign group_data_out_n[grp_num]	= 1'b0;
					end else begin
						for (pin_idx = 0; pin_idx < GROUP_PIN_WIDTH[grp_num]; pin_idx = pin_idx + 1) begin : data_io_diff_obuf_gen
							localparam DIFF_PIN_IDX = 2 * pin_idx;
							wire [0 : 0] pd2buf_data_out ;
							wire [0 : 0] pd2buf_data_out_n;
							wire [0 : 0] pd2buf_data_out_oe;
							wire [0 : 0] pd2buf_data_out_n_oe;
							wire [0 : 0] pd2buf_data_dtc;
							wire [0 : 0] pd2buf_data_dtc_n;

							twentynm_pseudo_diff_out #(
								.feedthrough("true")
							) u_pseudo_diff_data_out(
								.i        (data_out  [grp_num][DIFF_PIN_IDX + DATA_OFFSET + OS_P_INDEX]),
								.oein     (data_oe   [grp_num][DIFF_PIN_IDX + DATA_OFFSET + OS_P_INDEX]),
								.dtcin    (oct_enable[grp_num][DIFF_PIN_IDX + DATA_OFFSET + OS_P_INDEX]),
								.ibar     (data_out  [grp_num][DIFF_PIN_IDX + DATA_OFFSET + OS_N_INDEX]),
								.oebin    (data_oe   [grp_num][DIFF_PIN_IDX + DATA_OFFSET + OS_N_INDEX]),
								.dtcbarin (oct_enable[grp_num][DIFF_PIN_IDX + DATA_OFFSET + OS_N_INDEX]),
								
								.o        (pd2buf_data_out	),
								.obar     (pd2buf_data_out_n	),
								.oeout    (pd2buf_data_out_oe	),
								.oebout   (pd2buf_data_out_n_oe	),
								.dtc      (pd2buf_data_dtc   	),
								.dtcbar   (pd2buf_data_dtc_n	)
							);
							
							twentynm_io_obuf u_data_obuf (
								.i                         (pd2buf_data_out				),
								.oe                        (pd2buf_data_out_oe				),
								.o                         (group_data_out	[grp_num][pin_idx]	),
								.dynamicterminationcontrol (pd2buf_data_dtc				),
								.seriesterminationcontrol  (),
								.parallelterminationcontrol()
							);
							twentynm_io_obuf u_data_n_obuf (
								.i                         (pd2buf_data_out_n				),
								.oe                        (pd2buf_data_out_n_oe			),
								.o                         (group_data_out_n	[grp_num][pin_idx]	),
								.dynamicterminationcontrol (pd2buf_data_dtc_n 				),
								.seriesterminationcontrol  (),
								.parallelterminationcontrol()
							);
						
						end
					end
					localparam MAX_WIDTH = 47+1;
					assign group_data_out_n	[grp_num][47 : GROUP_PIN_WIDTH[grp_num]]={(MAX_WIDTH-GROUP_PIN_WIDTH[grp_num]){1'b0}};						
				end else begin
					assign group_data_out[grp_num] 	= {GROUP_PIN_WIDTH[grp_num]{1'b0}};
					assign group_data_out_n[grp_num]	= 1'b0;
				end
				
				if (GROUP_PIN_TYPE[grp_num] == "INPUT" || GROUP_PIN_TYPE[grp_num] == "BIDIR") begin
					for (pin_idx = 0; pin_idx < GROUP_PIN_WIDTH[grp_num]; pin_idx = pin_idx + 1) begin : data_io_ibuf_gen
						if (GROUP_DATA_CONFIG[grp_num] == "DIFF") begin
							if (GROUP_PIN_TYPE[grp_num] == "INPUT") begin
								twentynm_io_ibuf #(
									.differential_mode("true")
								) u_data_ibuf (
									.i                         (group_data_in  	[grp_num][pin_idx]   			),
									.ibar                      (group_data_in_n	[grp_num][pin_idx]   			),
									.dynamicterminationcontrol (oct_enable       	[grp_num][pin_idx + DATA_OFFSET]	),
									.o                         (data_in		[grp_num][(2 * pin_idx) + DATA_OFFSET]	),
									.seriesterminationcontrol  (),
									.parallelterminationcontrol()
								);
							end else begin
								twentynm_io_ibuf #(
									.differential_mode("true")
								) u_data_ibuf (
									.i                         (group_data_in  	[grp_num][pin_idx]   			),
									.ibar                      (group_data_in_n	[grp_num][pin_idx]   			),
									.o                         (data_in		[grp_num][(2 * pin_idx) + DATA_OFFSET]	),
									.dynamicterminationcontrol (),
									.seriesterminationcontrol  (),
									.parallelterminationcontrol()
								);
							end
							
						end else begin						
							twentynm_io_ibuf u_twentynm_io_ibuf(
								.i                         (group_data_in	[grp_num][pin_idx]           	),
								.dynamicterminationcontrol (oct_enable		[grp_num][pin_idx + DATA_OFFSET]),
								.o                         (data_in		[grp_num][pin_idx + DATA_OFFSET]),
								.ibar                      (),
								.seriesterminationcontrol  (),
								.parallelterminationcontrol()
							);
						end
					end 
					
				end else begin
					assign data_in[grp_num][GROUP_PIN_WIDTH[grp_num] + DATA_OFFSET - 1 : DATA_OFFSET] = {GROUP_PIN_WIDTH[grp_num]{1'b0}};
				end
			end else begin 
				assign group_data_out[grp_num] = {GROUP_PIN_WIDTH[grp_num]{1'b0}};
				assign group_data_out_n	[grp_num]=1'b0;
			end
		end 
		
	endgenerate

	////////////////////////////////////////////////////////////////////////////
	// Instantiate strobe buffers
	////////////////////////////////////////////////////////////////////////////
	generate
		genvar s_grp_num;
		for(s_grp_num = 0; s_grp_num < NUM_GROUPS; s_grp_num = s_grp_num + 1) begin : strobe_io_buf_gen
			localparam DATA_OFFSET = (((GROUP_PIN_TYPE[s_grp_num] == "OUTPUT") && (GROUP_USE_OUTPUT_STROBE[s_grp_num] == 0))                                                       ? 0 :
			                          ((GROUP_PIN_TYPE[s_grp_num] == "INPUT") && (GROUP_USE_INTERNAL_CAPTURE_STROBE[s_grp_num] == 1))                                              ? 0 :
			                          ((GROUP_PIN_TYPE[s_grp_num] == "BIDIR") && (GROUP_USE_INTERNAL_CAPTURE_STROBE[s_grp_num] == 1) && (GROUP_USE_OUTPUT_STROBE[s_grp_num] == 0)) ? 0 :
						   (GROUP_STROBE_CONFIG[s_grp_num] == "SINGLE_ENDED")                                                                                          ? 1 : 
			                                                                                                                                                                         2 )
			                         * ((GROUP_USE_SEPARATE_STROBES[s_grp_num] == 1) ? 2 : 1);
			
			if ((GROUP_PIN_TYPE[s_grp_num] == "OUTPUT" || GROUP_PIN_TYPE[s_grp_num] == "BIDIR") && (GROUP_USE_OUTPUT_STROBE[s_grp_num] == 1 || GROUP_USE_INTERNAL_CAPTURE_STROBE[s_grp_num] == 0)) begin
				if ((DATA_OFFSET == 2 || DATA_OFFSET == 4) && GROUP_STROBE_CONFIG[s_grp_num] == "DIFFERENTIAL") begin
					localparam OS_P_INDEX = (DATA_OFFSET == 2) ? 0 : 2;
					localparam OS_N_INDEX = (DATA_OFFSET == 2) ? 1 : 3;

					wire pd2buf_strobe_out;
					wire pd2buf_strobe_out_n;
					wire pd2buf_strobe_out_oe;
					wire pd2buf_strobe_out_n_oe;
					wire pd2buf_dtc;
					wire pd2buf_dtc_n;

					twentynm_pseudo_diff_out #(
						.feedthrough("true")
						) u_twentynm_pseudo_diff_out(
						.i        (data_out  [s_grp_num][OS_P_INDEX]),
						.oein     (data_oe   [s_grp_num][OS_P_INDEX]),
						.dtcin    (oct_enable[s_grp_num][OS_P_INDEX]),
						.ibar     (data_out  [s_grp_num][OS_N_INDEX]),
						.oebin    (data_oe   [s_grp_num][OS_N_INDEX]),
						.dtcbarin (oct_enable[s_grp_num][OS_N_INDEX]),

						.o        (pd2buf_strobe_out                ),
						.obar     (pd2buf_strobe_out_n              ),
						.oeout    (pd2buf_strobe_out_oe             ),
						.oebout   (pd2buf_strobe_out_n_oe           ),
						.dtc      (pd2buf_dtc                       ),
						.dtcbar   (pd2buf_dtc_n                     )
					);

					twentynm_io_obuf u_strobe_obuf (
						.i                         (pd2buf_strobe_out          ),
						.oe                        (pd2buf_strobe_out_oe       ),
						.o                         (group_strobe_out[s_grp_num]),
						.dynamicterminationcontrol (pd2buf_dtc                 ),
						.seriesterminationcontrol  (),
						.parallelterminationcontrol()
					);
					twentynm_io_obuf u_strobe_n_obuf (
						.i                         (pd2buf_strobe_out_n          ),
						.oe                        (pd2buf_strobe_out_n_oe       ),
						.o                         (group_strobe_out_n[s_grp_num]),
						.dynamicterminationcontrol (pd2buf_dtc_n                 ),
						.seriesterminationcontrol  (),
						.parallelterminationcontrol()
					);
				end else if ((DATA_OFFSET == 2 || DATA_OFFSET == 4) && GROUP_STROBE_CONFIG[s_grp_num] == "COMPLEMENTARY") begin
					localparam OS_P_INDEX = (DATA_OFFSET == 2) ? 0 : 2;
					localparam OS_N_INDEX = (DATA_OFFSET == 2) ? 1 : 3;

					if (GROUP_PIN_TYPE[s_grp_num] == "BIDIR" && GROUP_USE_SEPARATE_STROBES[s_grp_num] == 0) begin
						twentynm_io_obuf u_strobe_obuf (
							.i                         (data_out        [s_grp_num][OS_P_INDEX]),
							.oe                        (data_oe         [s_grp_num][OS_P_INDEX]),
							.o                         (group_strobe_out[s_grp_num]            ),
							.dynamicterminationcontrol (oct_enable      [s_grp_num][OS_P_INDEX]),
							.seriesterminationcontrol  (),
							.parallelterminationcontrol()
						);
						twentynm_io_obuf u_strobe_n_obuf (
							.i                         (data_out          [s_grp_num][OS_N_INDEX]),
							.oe                        (data_oe           [s_grp_num][OS_N_INDEX]),
							.o                         (group_strobe_out_n[s_grp_num]            ),
							.dynamicterminationcontrol (oct_enable        [s_grp_num][OS_N_INDEX]),
							.seriesterminationcontrol  (),
							.parallelterminationcontrol()
						);
					end else begin
						wire pd2buf_strobe_out;
						wire pd2buf_strobe_out_n;
						wire pd2buf_strobe_out_oe;
						wire pd2buf_strobe_out_n_oe;
						wire pd2buf_dtc;
						wire pd2buf_dtc_n;

						twentynm_pseudo_diff_out #(
							.feedthrough("true")
							) u_twentynm_pseudo_diff_out(
							.i        (data_out  [s_grp_num][OS_P_INDEX]),
							.oein     (data_oe   [s_grp_num][OS_P_INDEX]),
							.dtcin    (oct_enable[s_grp_num][OS_P_INDEX]),
							.ibar     (data_out  [s_grp_num][OS_N_INDEX]),
							.oebin    (data_oe   [s_grp_num][OS_N_INDEX]),
							.dtcbarin (oct_enable[s_grp_num][OS_N_INDEX]),

							.o        (pd2buf_strobe_out                ),
							.obar     (pd2buf_strobe_out_n              ),
							.oeout    (pd2buf_strobe_out_oe             ),
							.oebout   (pd2buf_strobe_out_n_oe           ),
							.dtc      (pd2buf_dtc                       ),
							.dtcbar   (pd2buf_dtc_n                     )
						);

						twentynm_io_obuf u_strobe_obuf (
							.i                         (pd2buf_strobe_out          ),
							.oe                        (pd2buf_strobe_out_oe       ),
							.o                         (group_strobe_out[s_grp_num]),
							.dynamicterminationcontrol (pd2buf_dtc                 ),
							.seriesterminationcontrol  (),
							.parallelterminationcontrol()
						);
						twentynm_io_obuf u_strobe_n_obuf (
							.i                         (pd2buf_strobe_out_n          ),
							.oe                        (pd2buf_strobe_out_n_oe       ),
							.o                         (group_strobe_out_n[s_grp_num]),
							.dynamicterminationcontrol (pd2buf_dtc_n                 ),
							.seriesterminationcontrol  (),
							.parallelterminationcontrol()
						);
					end
				end else if ((DATA_OFFSET == 1) || (DATA_OFFSET == 2 && GROUP_STROBE_CONFIG[s_grp_num] == "SINGLE_ENDED")) begin
					localparam OS_INDEX = (DATA_OFFSET == 1) ? 0 : 1;

					twentynm_io_obuf u_strobe_obuf (
						.i                         (data_out        [s_grp_num][OS_INDEX]),
						.oe                        (data_oe         [s_grp_num][OS_INDEX]),
						.o                         (group_strobe_out[s_grp_num]          ),
						.dynamicterminationcontrol (oct_enable      [s_grp_num][OS_INDEX]),
						.seriesterminationcontrol  (),
						.parallelterminationcontrol()
					);
					assign group_strobe_out_n[s_grp_num] = 1'bz;
				end else begin 
					assign group_strobe_out  [s_grp_num] = 1'bz;
					assign group_strobe_out_n[s_grp_num] = 1'bz;
				end
			end else begin
				assign group_strobe_out  [s_grp_num] = 1'bz;
				assign group_strobe_out_n[s_grp_num] = 1'bz;
			end

			if ((GROUP_PIN_TYPE[s_grp_num] == "INPUT" || GROUP_PIN_TYPE[s_grp_num] == "BIDIR") && GROUP_USE_INTERNAL_CAPTURE_STROBE[s_grp_num] == 0) begin
				if ((DATA_OFFSET == 2 || DATA_OFFSET == 4) && GROUP_STROBE_CONFIG[s_grp_num] == "DIFFERENTIAL") begin

					twentynm_io_ibuf #(
						.differential_mode("true")
					) u_strobe_ibuf (
						.i                         (group_strobe_in  [s_grp_num]   ),
						.ibar                      (group_strobe_in_n[s_grp_num]   ),
						.o                         (data_in          [s_grp_num][0]),
						.dynamicterminationcontrol (oct_enable       [s_grp_num][0]),
						.seriesterminationcontrol  (),
						.parallelterminationcontrol()
					);
					assign data_in[s_grp_num][1] = 1'b0;
				end else if ((DATA_OFFSET == 2 || DATA_OFFSET == 4) && GROUP_STROBE_CONFIG[s_grp_num] == "COMPLEMENTARY") begin

					twentynm_io_ibuf u_strobe_ibuf (
						.i                         (group_strobe_in  [s_grp_num]   ),
						.o                         (data_in          [s_grp_num][0]),
						.dynamicterminationcontrol (oct_enable       [s_grp_num][0]),
						.seriesterminationcontrol  (),
						.parallelterminationcontrol()
					);
					twentynm_io_ibuf u_strobe_n_ibuf (
						.i                         (group_strobe_in_n[s_grp_num]   ),
						.o                         (data_in          [s_grp_num][1]),
						.dynamicterminationcontrol (oct_enable       [s_grp_num][1]),
						.seriesterminationcontrol  (),
						.parallelterminationcontrol()
					);
				end else if ((DATA_OFFSET == 1) || (DATA_OFFSET == 2 && GROUP_STROBE_CONFIG[s_grp_num] == "SINGLE_ENDED")) begin

					twentynm_io_ibuf u_twentynm_io_ibuf(
						.i                         (group_strobe_in[s_grp_num]   ),
						.o                         (data_in        [s_grp_num][0]),
						.dynamicterminationcontrol (oct_enable     [s_grp_num][0]),
						.seriesterminationcontrol  (),
						.parallelterminationcontrol()
					);
				end
			end else begin
				if (DATA_OFFSET > 0 && GROUP_USE_INTERNAL_CAPTURE_STROBE[s_grp_num] == 0) begin
					assign data_in[s_grp_num][DATA_OFFSET - 1 : 0] = {DATA_OFFSET{1'b0}};
				end
			end

		end 
		localparam MAX_GROUPS = 17+1;		
		for(s_grp_num = NUM_GROUPS; s_grp_num < MAX_GROUPS; s_grp_num = s_grp_num + 1) begin : strobe_init
			assign group_strobe_out[s_grp_num] = 1'b0;
			assign group_strobe_out_n[s_grp_num] = 1'b0;
		end		
	endgenerate

endmodule

