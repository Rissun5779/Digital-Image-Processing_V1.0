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
// Core to Periphery connections of 14nm PHYLite component.
//
///////////////////////////////////////////////////////////////////////////////
module phylite_c2p_conns #(
	parameter integer NUM_GROUPS                               = 1,
	parameter integer RATE_MULT                                = 4,
	parameter string  GROUP_PIN_TYPE                    [0:17] = '{"BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR", "BIDIR"},
	parameter string  GROUP_DDR_SDR_MODE                [0:17] = '{"DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR", "DDR"},
	parameter integer GROUP_PIN_WIDTH                   [0:17] = '{9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9},
	parameter integer GROUP_USE_OUTPUT_STROBE           [0:17] = '{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	parameter integer GROUP_USE_INTERNAL_CAPTURE_STROBE [0:17] = '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	parameter integer GROUP_USE_SEPARATE_STROBES        [0:17] = '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	parameter string  GROUP_STROBE_CONFIG               [0:17] = '{"SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED", "SINGLE_ENDED"},
	parameter string  GROUP_DATA_CONFIG                 [0:17] = '{"SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED", "SGL_ENDED"},
	parameter integer GROUP_PIN_OE_WIDTH                [0:17] = '{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
	parameter integer GROUP_PIN_DATA_WIDTH              [0:17] = '{8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8},
	parameter integer GROUP_STROBE_PIN_OE_WIDTH         [0:17] = '{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
	parameter integer GROUP_STROBE_PIN_DATA_WIDTH       [0:17] = '{8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8},
	parameter integer GROUP_OE_WIDTH                    [0:17] = '{36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36},
	parameter integer GROUP_DATA_WIDTH                  [0:17] = '{72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72},
	parameter integer GROUP_OUTPUT_STROBE_OE_WIDTH      [0:17] = '{4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
	parameter integer GROUP_OUTPUT_STROBE_DATA_WIDTH    [0:17] = '{8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8}
	) (
	input                  [GROUP_OE_WIDTH[0] - 1 : 0] group_0_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[0] - 1 : 0] group_0_data_from_core   ,
	output               [GROUP_DATA_WIDTH[0] - 1 : 0] group_0_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_0_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_0_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[0] - 1 : 0] group_0_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[0] - 1 : 0] group_0_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[1] - 1 : 0] group_1_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[1] - 1 : 0] group_1_data_from_core   ,
	output               [GROUP_DATA_WIDTH[1] - 1 : 0] group_1_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_1_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_1_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[1] - 1 : 0] group_1_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[1] - 1 : 0] group_1_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[2] - 1 : 0] group_2_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[2] - 1 : 0] group_2_data_from_core   ,
	output               [GROUP_DATA_WIDTH[2] - 1 : 0] group_2_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_2_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_2_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[2] - 1 : 0] group_2_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[2] - 1 : 0] group_2_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[3] - 1 : 0] group_3_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[3] - 1 : 0] group_3_data_from_core   ,
	output               [GROUP_DATA_WIDTH[3] - 1 : 0] group_3_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_3_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_3_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[3] - 1 : 0] group_3_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[3] - 1 : 0] group_3_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[4] - 1 : 0] group_4_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[4] - 1 : 0] group_4_data_from_core   ,
	output               [GROUP_DATA_WIDTH[4] - 1 : 0] group_4_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_4_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_4_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[4] - 1 : 0] group_4_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[4] - 1 : 0] group_4_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[5] - 1 : 0] group_5_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[5] - 1 : 0] group_5_data_from_core   ,
	output               [GROUP_DATA_WIDTH[5] - 1 : 0] group_5_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_5_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_5_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[5] - 1 : 0] group_5_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[5] - 1 : 0] group_5_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[6] - 1 : 0] group_6_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[6] - 1 : 0] group_6_data_from_core   ,
	output               [GROUP_DATA_WIDTH[6] - 1 : 0] group_6_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_6_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_6_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[6] - 1 : 0] group_6_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[6] - 1 : 0] group_6_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[7] - 1 : 0] group_7_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[7] - 1 : 0] group_7_data_from_core   ,
	output               [GROUP_DATA_WIDTH[7] - 1 : 0] group_7_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_7_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_7_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[7] - 1 : 0] group_7_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[7] - 1 : 0] group_7_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[8] - 1 : 0] group_8_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[8] - 1 : 0] group_8_data_from_core   ,
	output               [GROUP_DATA_WIDTH[8] - 1 : 0] group_8_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_8_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_8_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[8] - 1 : 0] group_8_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[8] - 1 : 0] group_8_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[9] - 1 : 0] group_9_oe_from_core     ,
	input                [GROUP_DATA_WIDTH[9] - 1 : 0] group_9_data_from_core   ,
	output               [GROUP_DATA_WIDTH[9] - 1 : 0] group_9_data_to_core     ,
	input                          [RATE_MULT - 1 : 0] group_9_rdata_en         ,
	output                         [RATE_MULT - 1 : 0] group_9_rdata_valid      ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[9] - 1 : 0] group_9_strobe_out_in    ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[9] - 1 : 0] group_9_strobe_out_en    ,
	
	input                  [GROUP_OE_WIDTH[10] - 1 : 0] group_10_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[10] - 1 : 0] group_10_data_from_core ,
	output               [GROUP_DATA_WIDTH[10] - 1 : 0] group_10_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_10_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_10_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[10] - 1 : 0] group_10_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[10] - 1 : 0] group_10_strobe_out_en  ,
	
	input                  [GROUP_OE_WIDTH[11] - 1 : 0] group_11_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[11] - 1 : 0] group_11_data_from_core ,
	output               [GROUP_DATA_WIDTH[11] - 1 : 0] group_11_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_11_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_11_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[11] - 1 : 0] group_11_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[11] - 1 : 0] group_11_strobe_out_en  ,

	input                  [GROUP_OE_WIDTH[12] - 1 : 0] group_12_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[12] - 1 : 0] group_12_data_from_core ,
	output               [GROUP_DATA_WIDTH[12] - 1 : 0] group_12_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_12_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_12_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[12] - 1 : 0] group_12_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[12] - 1 : 0] group_12_strobe_out_en  ,

	input                  [GROUP_OE_WIDTH[13] - 1 : 0] group_13_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[13] - 1 : 0] group_13_data_from_core ,
	output               [GROUP_DATA_WIDTH[13] - 1 : 0] group_13_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_13_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_13_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[13] - 1 : 0] group_13_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[13] - 1 : 0] group_13_strobe_out_en  ,

	input                  [GROUP_OE_WIDTH[14] - 1 : 0] group_14_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[14] - 1 : 0] group_14_data_from_core ,
	output               [GROUP_DATA_WIDTH[14] - 1 : 0] group_14_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_14_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_14_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[14] - 1 : 0] group_14_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[14] - 1 : 0] group_14_strobe_out_en  ,

	input                  [GROUP_OE_WIDTH[15] - 1 : 0] group_15_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[15] - 1 : 0] group_15_data_from_core ,
	output               [GROUP_DATA_WIDTH[15] - 1 : 0] group_15_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_15_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_15_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[15] - 1 : 0] group_15_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[15] - 1 : 0] group_15_strobe_out_en  ,

	input                  [GROUP_OE_WIDTH[16] - 1 : 0] group_16_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[16] - 1 : 0] group_16_data_from_core ,
	output               [GROUP_DATA_WIDTH[16] - 1 : 0] group_16_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_16_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_16_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[16] - 1 : 0] group_16_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[16] - 1 : 0] group_16_strobe_out_en  ,

	input                  [GROUP_OE_WIDTH[17] - 1 : 0] group_17_oe_from_core   ,
	input                [GROUP_DATA_WIDTH[17] - 1 : 0] group_17_data_from_core ,
	output               [GROUP_DATA_WIDTH[17] - 1 : 0] group_17_data_to_core   ,
	input                           [RATE_MULT - 1 : 0] group_17_rdata_en       ,
	output                          [RATE_MULT - 1 : 0] group_17_rdata_valid    ,
	input  [GROUP_OUTPUT_STROBE_DATA_WIDTH[17] - 1 : 0] group_17_strobe_out_in  ,
	input    [GROUP_OUTPUT_STROBE_OE_WIDTH[17] - 1 : 0] group_17_strobe_out_en  ,

	output [191:0] oe_from_core   [0:NUM_GROUPS-1],
	output [383:0] data_from_core [0:NUM_GROUPS-1],
	input  [383:0] data_to_core   [0:NUM_GROUPS-1],
	output   [3:0] rdata_en       [0:NUM_GROUPS-1],
	input    [3:0] rdata_valid    [0:NUM_GROUPS-1]
	);
	timeunit 1ns;
	timeprecision 1ns;

	////////////////////////////////////////////////////////////////////////////
	// Wire Declarations
	////////////////////////////////////////////////////////////////////////////
	wire [191:0] group_oe_from_core  [0:17];
	wire [383:0] group_data_from_core[0:17];
	wire [383:0] group_data_to_core  [0:17];
	wire   [3:0] group_rdata_en      [0:17];
	wire   [3:0] group_rdata_valid   [0:17];
	wire  [15:0] group_strobe_out_in [0:17];
	wire   [7:0] group_strobe_out_en [0:17];

	////////////////////////////////////////////////////////////////////////////
	// Assign core ports to internal arrays
	////////////////////////////////////////////////////////////////////////////
	assign group_oe_from_core  [0][GROUP_OE_WIDTH                [0] - 1 : 0]  = group_0_oe_from_core  ;
	assign group_data_from_core[0][GROUP_DATA_WIDTH              [0] - 1 : 0]  = group_0_data_from_core;
	assign group_strobe_out_in [0][GROUP_OUTPUT_STROBE_DATA_WIDTH[0] - 1 : 0]  = group_0_strobe_out_in ;
	assign group_strobe_out_en [0][GROUP_OUTPUT_STROBE_OE_WIDTH  [0] - 1 : 0]  = group_0_strobe_out_en ;
	assign group_rdata_en      [0][RATE_MULT - 1 : 0] = group_0_rdata_en;
	assign group_0_data_to_core = group_data_to_core[0][GROUP_DATA_WIDTH[0] - 1 : 0];
	assign group_0_rdata_valid  = group_rdata_valid [0][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [1][GROUP_OE_WIDTH                [1] - 1 : 0]  = group_1_oe_from_core  ;
	assign group_data_from_core[1][GROUP_DATA_WIDTH              [1] - 1 : 0]  = group_1_data_from_core;
	assign group_strobe_out_in [1][GROUP_OUTPUT_STROBE_DATA_WIDTH[1] - 1 : 0]  = group_1_strobe_out_in ;
	assign group_strobe_out_en [1][GROUP_OUTPUT_STROBE_OE_WIDTH  [1] - 1 : 0]  = group_1_strobe_out_en ;
	assign group_rdata_en      [1][RATE_MULT - 1 : 0] = group_1_rdata_en;
	assign group_1_data_to_core = group_data_to_core[1][GROUP_DATA_WIDTH[1] - 1 : 0];
	assign group_1_rdata_valid  = group_rdata_valid [1][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [2][GROUP_OE_WIDTH                [2] - 1 : 0]  = group_2_oe_from_core  ;
	assign group_data_from_core[2][GROUP_DATA_WIDTH              [2] - 1 : 0]  = group_2_data_from_core;
	assign group_strobe_out_in [2][GROUP_OUTPUT_STROBE_DATA_WIDTH[2] - 1 : 0]  = group_2_strobe_out_in ;
	assign group_strobe_out_en [2][GROUP_OUTPUT_STROBE_OE_WIDTH  [2] - 1 : 0]  = group_2_strobe_out_en ;
	assign group_rdata_en      [2][RATE_MULT - 1 : 0] = group_2_rdata_en;
	assign group_2_data_to_core = group_data_to_core[2][GROUP_DATA_WIDTH[2] - 1 : 0];
	assign group_2_rdata_valid  = group_rdata_valid [2][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [3][GROUP_OE_WIDTH                [3] - 1 : 0]  = group_3_oe_from_core  ;
	assign group_data_from_core[3][GROUP_DATA_WIDTH              [3] - 1 : 0]  = group_3_data_from_core;
	assign group_strobe_out_in [3][GROUP_OUTPUT_STROBE_DATA_WIDTH[3] - 1 : 0]  = group_3_strobe_out_in ;
	assign group_strobe_out_en [3][GROUP_OUTPUT_STROBE_OE_WIDTH  [3] - 1 : 0]  = group_3_strobe_out_en ;
	assign group_rdata_en      [3][RATE_MULT - 1 : 0] = group_3_rdata_en;
	assign group_3_data_to_core = group_data_to_core[3][GROUP_DATA_WIDTH[3] - 1 : 0];
	assign group_3_rdata_valid  = group_rdata_valid [3][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [4][GROUP_OE_WIDTH                [4] - 1 : 0]  = group_4_oe_from_core  ;
	assign group_data_from_core[4][GROUP_DATA_WIDTH              [4] - 1 : 0]  = group_4_data_from_core;
	assign group_strobe_out_in [4][GROUP_OUTPUT_STROBE_DATA_WIDTH[4] - 1 : 0]  = group_4_strobe_out_in ;
	assign group_strobe_out_en [4][GROUP_OUTPUT_STROBE_OE_WIDTH  [4] - 1 : 0]  = group_4_strobe_out_en ;
	assign group_rdata_en      [4][RATE_MULT - 1 : 0] = group_4_rdata_en;
	assign group_4_data_to_core = group_data_to_core[4][GROUP_DATA_WIDTH[4] - 1 : 0];
	assign group_4_rdata_valid  = group_rdata_valid [4][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [5][GROUP_OE_WIDTH                [5] - 1 : 0]  = group_5_oe_from_core  ;
	assign group_data_from_core[5][GROUP_DATA_WIDTH              [5] - 1 : 0]  = group_5_data_from_core;
	assign group_strobe_out_in [5][GROUP_OUTPUT_STROBE_DATA_WIDTH[5] - 1 : 0]  = group_5_strobe_out_in ;
	assign group_strobe_out_en [5][GROUP_OUTPUT_STROBE_OE_WIDTH  [5] - 1 : 0]  = group_5_strobe_out_en ;
	assign group_rdata_en      [5][RATE_MULT - 1 : 0] = group_5_rdata_en;
	assign group_5_data_to_core = group_data_to_core[5][GROUP_DATA_WIDTH[5] - 1 : 0];
	assign group_5_rdata_valid  = group_rdata_valid [5][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [6][GROUP_OE_WIDTH                [6] - 1 : 0]  = group_6_oe_from_core  ;
	assign group_data_from_core[6][GROUP_DATA_WIDTH              [6] - 1 : 0]  = group_6_data_from_core;
	assign group_strobe_out_in [6][GROUP_OUTPUT_STROBE_DATA_WIDTH[6] - 1 : 0]  = group_6_strobe_out_in ;
	assign group_strobe_out_en [6][GROUP_OUTPUT_STROBE_OE_WIDTH  [6] - 1 : 0]  = group_6_strobe_out_en ;
	assign group_rdata_en      [6][RATE_MULT - 1 : 0] = group_6_rdata_en;
	assign group_6_data_to_core = group_data_to_core[6][GROUP_DATA_WIDTH[6] - 1 : 0];
	assign group_6_rdata_valid  = group_rdata_valid [6][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [7][GROUP_OE_WIDTH                [7] - 1 : 0]  = group_7_oe_from_core  ;
	assign group_data_from_core[7][GROUP_DATA_WIDTH              [7] - 1 : 0]  = group_7_data_from_core;
	assign group_strobe_out_in [7][GROUP_OUTPUT_STROBE_DATA_WIDTH[7] - 1 : 0]  = group_7_strobe_out_in ;
	assign group_strobe_out_en [7][GROUP_OUTPUT_STROBE_OE_WIDTH  [7] - 1 : 0]  = group_7_strobe_out_en ;
	assign group_rdata_en      [7][RATE_MULT - 1 : 0] = group_7_rdata_en;
	assign group_7_data_to_core = group_data_to_core[7][GROUP_DATA_WIDTH[7] - 1 : 0];
	assign group_7_rdata_valid  = group_rdata_valid [7][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [8][GROUP_OE_WIDTH                [8] - 1 : 0]  = group_8_oe_from_core  ;
	assign group_data_from_core[8][GROUP_DATA_WIDTH              [8] - 1 : 0]  = group_8_data_from_core;
	assign group_strobe_out_in [8][GROUP_OUTPUT_STROBE_DATA_WIDTH[8] - 1 : 0]  = group_8_strobe_out_in ;
	assign group_strobe_out_en [8][GROUP_OUTPUT_STROBE_OE_WIDTH  [8] - 1 : 0]  = group_8_strobe_out_en ;
	assign group_rdata_en      [8][RATE_MULT - 1 : 0] = group_8_rdata_en;
	assign group_8_data_to_core = group_data_to_core[8][GROUP_DATA_WIDTH[8] - 1 : 0];
	assign group_8_rdata_valid  = group_rdata_valid [8][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [9][GROUP_OE_WIDTH                [9] - 1 : 0]  = group_9_oe_from_core  ;
	assign group_data_from_core[9][GROUP_DATA_WIDTH              [9] - 1 : 0]  = group_9_data_from_core;
	assign group_strobe_out_in [9][GROUP_OUTPUT_STROBE_DATA_WIDTH[9] - 1 : 0]  = group_9_strobe_out_in ;
	assign group_strobe_out_en [9][GROUP_OUTPUT_STROBE_OE_WIDTH  [9] - 1 : 0]  = group_9_strobe_out_en ;
	assign group_rdata_en      [9][RATE_MULT - 1 : 0] = group_9_rdata_en;
	assign group_9_data_to_core = group_data_to_core[9][GROUP_DATA_WIDTH[9] - 1 : 0];
	assign group_9_rdata_valid  = group_rdata_valid [9][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [10][GROUP_OE_WIDTH                [10] - 1 : 0]  = group_10_oe_from_core  ;
	assign group_data_from_core[10][GROUP_DATA_WIDTH              [10] - 1 : 0]  = group_10_data_from_core;
	assign group_strobe_out_in [10][GROUP_OUTPUT_STROBE_DATA_WIDTH[10] - 1 : 0]  = group_10_strobe_out_in ;
	assign group_strobe_out_en [10][GROUP_OUTPUT_STROBE_OE_WIDTH  [10] - 1 : 0]  = group_10_strobe_out_en ;
	assign group_rdata_en      [10][RATE_MULT - 1 : 0] = group_10_rdata_en;
	assign group_10_data_to_core = group_data_to_core[10][GROUP_DATA_WIDTH[10] - 1 : 0];
	assign group_10_rdata_valid  = group_rdata_valid [10][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [11][GROUP_OE_WIDTH                [11] - 1 : 0]  = group_11_oe_from_core  ;
	assign group_data_from_core[11][GROUP_DATA_WIDTH              [11] - 1 : 0]  = group_11_data_from_core;
	assign group_strobe_out_in [11][GROUP_OUTPUT_STROBE_DATA_WIDTH[11] - 1 : 0]  = group_11_strobe_out_in ;
	assign group_strobe_out_en [11][GROUP_OUTPUT_STROBE_OE_WIDTH  [11] - 1 : 0]  = group_11_strobe_out_en ;
	assign group_rdata_en      [11][RATE_MULT - 1 : 0] = group_11_rdata_en;
	assign group_11_data_to_core = group_data_to_core[11][GROUP_DATA_WIDTH[11] - 1 : 0];
	assign group_11_rdata_valid  = group_rdata_valid [11][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [12][GROUP_OE_WIDTH                [12] - 1 : 0]  = group_12_oe_from_core  ;
	assign group_data_from_core[12][GROUP_DATA_WIDTH              [12] - 1 : 0]  = group_12_data_from_core;
	assign group_strobe_out_in [12][GROUP_OUTPUT_STROBE_DATA_WIDTH[12] - 1 : 0]  = group_12_strobe_out_in ;
	assign group_strobe_out_en [12][GROUP_OUTPUT_STROBE_OE_WIDTH  [12] - 1 : 0]  = group_12_strobe_out_en ;
	assign group_rdata_en      [12][RATE_MULT - 1 : 0] = group_12_rdata_en;
	assign group_12_data_to_core = group_data_to_core[12][GROUP_DATA_WIDTH[12] - 1 : 0];
	assign group_12_rdata_valid  = group_rdata_valid [12][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [13][GROUP_OE_WIDTH                [13] - 1 : 0]  = group_13_oe_from_core  ;
	assign group_data_from_core[13][GROUP_DATA_WIDTH              [13] - 1 : 0]  = group_13_data_from_core;
	assign group_strobe_out_in [13][GROUP_OUTPUT_STROBE_DATA_WIDTH[13] - 1 : 0]  = group_13_strobe_out_in ;
	assign group_strobe_out_en [13][GROUP_OUTPUT_STROBE_OE_WIDTH  [13] - 1 : 0]  = group_13_strobe_out_en ;
	assign group_rdata_en      [13][RATE_MULT - 1 : 0] = group_13_rdata_en;
	assign group_13_data_to_core = group_data_to_core[13][GROUP_DATA_WIDTH[13] - 1 : 0];
	assign group_13_rdata_valid  = group_rdata_valid [13][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [14][GROUP_OE_WIDTH                [14] - 1 : 0]  = group_14_oe_from_core  ;
	assign group_data_from_core[14][GROUP_DATA_WIDTH              [14] - 1 : 0]  = group_14_data_from_core;
	assign group_strobe_out_in [14][GROUP_OUTPUT_STROBE_DATA_WIDTH[14] - 1 : 0]  = group_14_strobe_out_in ;
	assign group_strobe_out_en [14][GROUP_OUTPUT_STROBE_OE_WIDTH  [14] - 1 : 0]  = group_14_strobe_out_en ;
	assign group_rdata_en      [14][RATE_MULT - 1 : 0] = group_14_rdata_en;
	assign group_14_data_to_core = group_data_to_core[14][GROUP_DATA_WIDTH[14] - 1 : 0];
	assign group_14_rdata_valid  = group_rdata_valid [14][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [15][GROUP_OE_WIDTH                [15] - 1 : 0]  = group_15_oe_from_core  ;
	assign group_data_from_core[15][GROUP_DATA_WIDTH              [15] - 1 : 0]  = group_15_data_from_core;
	assign group_strobe_out_in [15][GROUP_OUTPUT_STROBE_DATA_WIDTH[15] - 1 : 0]  = group_15_strobe_out_in ;
	assign group_strobe_out_en [15][GROUP_OUTPUT_STROBE_OE_WIDTH  [15] - 1 : 0]  = group_15_strobe_out_en ;
	assign group_rdata_en      [15][RATE_MULT - 1 : 0] = group_15_rdata_en;
	assign group_15_data_to_core = group_data_to_core[15][GROUP_DATA_WIDTH[15] - 1 : 0];
	assign group_15_rdata_valid  = group_rdata_valid [15][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [16][GROUP_OE_WIDTH                [16] - 1 : 0]  = group_16_oe_from_core  ;
	assign group_data_from_core[16][GROUP_DATA_WIDTH              [16] - 1 : 0]  = group_16_data_from_core;
	assign group_strobe_out_in [16][GROUP_OUTPUT_STROBE_DATA_WIDTH[16] - 1 : 0]  = group_16_strobe_out_in ;
	assign group_strobe_out_en [16][GROUP_OUTPUT_STROBE_OE_WIDTH  [16] - 1 : 0]  = group_16_strobe_out_en ;
	assign group_rdata_en      [16][RATE_MULT - 1 : 0] = group_16_rdata_en;
	assign group_16_data_to_core = group_data_to_core[16][GROUP_DATA_WIDTH[16] - 1 : 0];
	assign group_16_rdata_valid  = group_rdata_valid [16][RATE_MULT - 1 : 0];

	assign group_oe_from_core  [17][GROUP_OE_WIDTH                [17] - 1 : 0]  = group_17_oe_from_core  ;
	assign group_data_from_core[17][GROUP_DATA_WIDTH              [17] - 1 : 0]  = group_17_data_from_core;
	assign group_strobe_out_in [17][GROUP_OUTPUT_STROBE_DATA_WIDTH[17] - 1 : 0]  = group_17_strobe_out_in ;
	assign group_strobe_out_en [17][GROUP_OUTPUT_STROBE_OE_WIDTH  [17] - 1 : 0]  = group_17_strobe_out_en ;
	assign group_rdata_en      [17][RATE_MULT - 1 : 0] = group_17_rdata_en;
	assign group_17_data_to_core = group_data_to_core[17][GROUP_DATA_WIDTH[17] - 1 : 0];
	assign group_17_rdata_valid  = group_rdata_valid [17][RATE_MULT - 1 : 0];

	////////////////////////////////////////////////////////////////////////////
	// Map core signals to periphery inputs
	// Lane ports are ordered {..,pin2,pin1,pin0} where pin0 = {...,timeslot1,timeslot0}
	// AFI bus (IP data_to/from_core) is ordered {...,time2,time1,time0} where time0 = {...,pin1,pin0}
	////////////////////////////////////////////////////////////////////////////
	generate
		genvar grp_num, timeslot, pin_idx, bit_idx;

		for (grp_num = 0; grp_num < 18; grp_num = grp_num + 1) begin : gen_grp_c2p_conns
			if (grp_num < NUM_GROUPS) begin
				localparam STRB_OFFSET = (((GROUP_PIN_TYPE[grp_num] == "OUTPUT") && (GROUP_USE_OUTPUT_STROBE[grp_num] == 0))                                                     ? 0 :
				                          ((GROUP_PIN_TYPE[grp_num] == "INPUT") && (GROUP_USE_INTERNAL_CAPTURE_STROBE[grp_num] == 1))                                            ? 0 :
				                          ((GROUP_PIN_TYPE[grp_num] == "BIDIR") && (GROUP_USE_INTERNAL_CAPTURE_STROBE[grp_num] == 1) && (GROUP_USE_OUTPUT_STROBE[grp_num] == 0)) ? 0 :
							   (GROUP_STROBE_CONFIG[grp_num] == "SINGLE_ENDED")                                                                                      ? 1 : 
				                                                                                                                                                                   2 )
				                         * ((GROUP_USE_SEPARATE_STROBES[grp_num] == 1) ? 2 : 1);
							 
				localparam LANE_OFFSET = ( STRB_OFFSET == 1 && GROUP_DATA_CONFIG[grp_num] == "DIFF") ? 1 : 0;
				localparam DATA_OFFSET = (GROUP_DATA_CONFIG[grp_num] == "DIFF") ?  (LANE_OFFSET + STRB_OFFSET) : STRB_OFFSET;
				localparam NUM_TIMESLOTS = (GROUP_DDR_SDR_MODE[grp_num] == "DDR") ? (RATE_MULT * 2) : RATE_MULT;

				// Write data from core
				if (GROUP_PIN_TYPE[grp_num] == "OUTPUT" || GROUP_PIN_TYPE[grp_num] == "BIDIR") begin
					if (GROUP_USE_OUTPUT_STROBE[grp_num] == 1) begin
						if (STRB_OFFSET == 4) begin
							assign oe_from_core  [grp_num][15:8]  = {2{{(4 - GROUP_STROBE_PIN_OE_WIDTH  [grp_num]){1'b0}}, group_strobe_out_en[grp_num][(GROUP_STROBE_PIN_OE_WIDTH  [grp_num]) - 1 : 0]}};
							assign data_from_core[grp_num][31:16] = { {(8 - GROUP_STROBE_PIN_DATA_WIDTH[grp_num]){1'b0}}, ~group_strobe_out_in[grp_num][(GROUP_STROBE_PIN_DATA_WIDTH[grp_num]) - 1 : 0], {(8 - GROUP_STROBE_PIN_DATA_WIDTH[grp_num]){1'b0}}, group_strobe_out_in[grp_num][(GROUP_STROBE_PIN_DATA_WIDTH[grp_num]) - 1 : 0]};
						end if (STRB_OFFSET == 2 && GROUP_STROBE_CONFIG[grp_num] == "SINGLE_ENDED") begin
							assign oe_from_core  [grp_num][7:4] = {{(4 - GROUP_STROBE_PIN_OE_WIDTH  [grp_num]){1'b0}}, group_strobe_out_en[grp_num][GROUP_STROBE_PIN_OE_WIDTH  [grp_num] - 1 : 0]};
							assign data_from_core[grp_num][15:8] = {{(8 - GROUP_STROBE_PIN_DATA_WIDTH[grp_num]){1'b0}}, group_strobe_out_in[grp_num][GROUP_STROBE_PIN_DATA_WIDTH[grp_num] - 1 : 0]};
						end else if (STRB_OFFSET == 2) begin
							assign oe_from_core  [grp_num][7:0]  = {2{{(4 - GROUP_STROBE_PIN_OE_WIDTH  [grp_num]){1'b0}}, group_strobe_out_en[grp_num][(GROUP_STROBE_PIN_OE_WIDTH  [grp_num]) - 1 : 0]}};
							assign data_from_core[grp_num][15:0] = { {(8 - GROUP_STROBE_PIN_DATA_WIDTH[grp_num]){1'b0}}, ~group_strobe_out_in[grp_num][(GROUP_STROBE_PIN_DATA_WIDTH[grp_num]) - 1 : 0], {(8 - GROUP_STROBE_PIN_DATA_WIDTH[grp_num]){1'b0}}, group_strobe_out_in[grp_num][(GROUP_STROBE_PIN_DATA_WIDTH[grp_num]) - 1 : 0]};
						end else if (STRB_OFFSET == 1) begin
							assign oe_from_core  [grp_num][3:0] = {{(4 - GROUP_STROBE_PIN_OE_WIDTH  [grp_num]){1'b0}}, group_strobe_out_en[grp_num][GROUP_STROBE_PIN_OE_WIDTH  [grp_num] - 1 : 0]};
							assign data_from_core[grp_num][7:0] = {{(8 - GROUP_STROBE_PIN_DATA_WIDTH[grp_num]){1'b0}}, group_strobe_out_in[grp_num][GROUP_STROBE_PIN_DATA_WIDTH[grp_num] - 1 : 0]};
						end
					end else if (STRB_OFFSET > 0) begin
						// Cannot have separate strobes without output strobe, so STRB_OFFSET is 1 or 2 here
						assign oe_from_core  [grp_num][(STRB_OFFSET * 4) - 1 : 0] = {(STRB_OFFSET * 4){1'b0}};
						assign data_from_core[grp_num][(STRB_OFFSET * 8) - 1 : 0] = {(STRB_OFFSET * 8){1'b0}};
					end

					// DATA
					for (timeslot = 0; timeslot < 8; timeslot = timeslot + 1) begin : gen_grp_data_timeslot_conns
						for (pin_idx = 0; pin_idx < (48 - DATA_OFFSET); pin_idx = pin_idx + 1) begin : gen_grp_data_pin_c2p_conns
							localparam OFFSET_PIN_IDX = pin_idx + DATA_OFFSET;
							localparam DIFF_OFFSET_PIN_IDX = (2 * pin_idx) + DATA_OFFSET;
							if ((pin_idx < GROUP_PIN_WIDTH[grp_num]) && (timeslot < NUM_TIMESLOTS)) begin
								if (GROUP_DATA_CONFIG[grp_num] == "SGL_ENDED") begin
									assign data_from_core[grp_num][(OFFSET_PIN_IDX * 8) + timeslot] = group_data_from_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx];
								end else begin
									assign data_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 8) + timeslot] = group_data_from_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx];
									assign data_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 8) + timeslot + 8] = ~group_data_from_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx];
								end
							end else if (pin_idx >= GROUP_PIN_WIDTH[grp_num]) begin
								if (GROUP_DATA_CONFIG[grp_num] == "SGL_ENDED") begin
									assign data_from_core[grp_num][(OFFSET_PIN_IDX * 8) + timeslot] = 1'b0;
								end else if (DIFF_OFFSET_PIN_IDX < 47) begin
									assign data_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 8) + timeslot] = 1'b0;
									assign data_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 8) + timeslot + 8] = 1'b0;
								end
							end
						end // gen_grp_data_pin_c2p_conns
					end // gen_grp_data_timeslot_conns

					// OE
					for (timeslot = 0; timeslot < 4; timeslot = timeslot + 1) begin : gen_grp_oe_timeslot_conns
						for (pin_idx = 0; pin_idx < (48 - DATA_OFFSET); pin_idx = pin_idx + 1) begin : gen_grp_oe_pin_c2p_conns
							localparam OFFSET_PIN_IDX = pin_idx + DATA_OFFSET;
							localparam DIFF_OFFSET_PIN_IDX = (2 * pin_idx) + DATA_OFFSET;
							if ((pin_idx < GROUP_PIN_WIDTH[grp_num]) && (timeslot < RATE_MULT)) begin
								if (GROUP_DATA_CONFIG[grp_num] == "SGL_ENDED") begin
									assign oe_from_core[grp_num][(OFFSET_PIN_IDX * 4) + timeslot] = group_oe_from_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx];
								end else begin
									assign oe_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 4) + timeslot] = group_oe_from_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx];
									assign oe_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 4) + timeslot + 4] = group_oe_from_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx];
								end
							end else if (pin_idx >= GROUP_PIN_WIDTH[grp_num]) begin
								if (GROUP_DATA_CONFIG[grp_num] == "SGL_ENDED") begin
									assign oe_from_core[grp_num][(OFFSET_PIN_IDX * 4) + timeslot] = 1'b0;
								end else if (DIFF_OFFSET_PIN_IDX < 47) begin
									assign oe_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 4) + timeslot] = 1'b0;
									assign oe_from_core[grp_num][(DIFF_OFFSET_PIN_IDX * 4) + timeslot + 4] = 1'b0;
								end
							end
						end // gen_grp_oe_pin_c2p_conns
					end // gen_grp_oe_timeslot_conns
				end else begin
					assign oe_from_core[grp_num]   = {192{1'b0}};
					assign data_from_core[grp_num] = {384{1'b0}};
				end

				// Read data to core
				if (GROUP_PIN_TYPE[grp_num] == "INPUT" || GROUP_PIN_TYPE[grp_num] == "BIDIR") begin
					for (timeslot = 0; timeslot < NUM_TIMESLOTS; timeslot = timeslot + 1) begin : gen_grp_timeslot_conns
						for (pin_idx = 0; pin_idx < GROUP_PIN_WIDTH[grp_num]; pin_idx = pin_idx + 1) begin : gen_grp_pin_c2p_conns
							localparam OFFSET_PIN_IDX = pin_idx + DATA_OFFSET;
							localparam DIFF_OFFSET_PIN_IDX = (2 * pin_idx) + DATA_OFFSET;
							if (GROUP_DDR_SDR_MODE[grp_num] == "DDR") begin
								if (GROUP_DATA_CONFIG[grp_num] == "SGL_ENDED") begin
									assign group_data_to_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx] = data_to_core[grp_num][(OFFSET_PIN_IDX * 8) + timeslot];
								end else begin
									assign group_data_to_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx] = data_to_core[grp_num][(DIFF_OFFSET_PIN_IDX * 8) + timeslot];
								end
							end else begin
								assign group_data_to_core[grp_num][(timeslot * GROUP_PIN_WIDTH[grp_num]) + pin_idx] = data_to_core[grp_num][(OFFSET_PIN_IDX * 8) + (timeslot * 2)]; // SDR data to core is on every other bit
							end
						end // gen_grp_pin_c2p_conns
					end // gen_grp_timeslot_conns
					assign group_data_to_core[grp_num][383:NUM_TIMESLOTS*GROUP_PIN_WIDTH[grp_num]] = {(384-NUM_TIMESLOTS*GROUP_PIN_WIDTH[grp_num]){1'b0}};
					assign rdata_en[grp_num][3 : 0] = {{(4 - RATE_MULT){1'b0}}, group_rdata_en[grp_num][RATE_MULT - 1 : 0]};
					assign group_rdata_valid[grp_num][RATE_MULT - 1 : 0] = rdata_valid[grp_num][RATE_MULT - 1 : 0];
				end else begin
					assign group_rdata_valid [grp_num][RATE_MULT - 1 : 0] = {RATE_MULT{1'b0}};
					assign group_data_to_core[grp_num] = {384{1'b0}};
				end
			end else begin
				assign group_data_to_core[grp_num] = {384{1'b0}};
				assign group_rdata_valid [grp_num][RATE_MULT - 1 : 0] = {RATE_MULT{1'b0}};
			end
		end // gen_grp_c2p_conns
	endgenerate

endmodule
