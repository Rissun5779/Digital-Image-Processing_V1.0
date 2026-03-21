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
// Filename    : alt_xcvr_prbs_check_topv
//
// Description : PRBS Checker
//
// Supported Patterns - 7, 10, 23, 31
// Supported Data widths = 8, 10, 16, 20, 32, 40, 64
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
module alt_xcvr_prbs_check_top #(
    parameter NUM_CYCLES_FOR_LOCK = 8'd31,		
    parameter PRBS_INITIAL_VALUE = 97,
    parameter DATA_WIDTH = 8,
    parameter PRBS = 23,
    parameter PIPELINE = 3,
    parameter CHANNELS=1
)(
    input  wire [DATA_WIDTH*CHANNELS-1:0] data_in, 
    output wire [CHANNELS-1:0] lock, 
    output      [CHANNELS-1:0] error_flag,
    input  wire [CHANNELS-1:0] clk, 
    input  wire [CHANNELS-1:0] reset,
    input  tri0 [CHANNELS-1:0] pause,
    input  wire [CHANNELS-1:0] start
);

    wire [DATA_WIDTH-1:0]        dataIn_w[CHANNELS-1:0];
    
    genvar i;
    generate 
        for(i=0;i<CHANNELS;i=i+1) begin: check
	        alt_xcvr_prbs_check #(
		        .PRBS_INITIAL_VALUE (PRBS_INITIAL_VALUE),
		        .DATA_WIDTH         (DATA_WIDTH),
		        .PRBS               (PRBS)
	        ) alt_xcvr_prbs_check_inst (
		        .clk          (clk[i]),
        		.nreset       (start),        
        		.pause        (pause[i]),        
                .errorFlag    (error_flag[i]),
                .lock         (lock[i]),
		        .dataIn       (dataIn_w[i])          
	        );

            assign dataIn_w[i] = data_in[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i];
        end


    endgenerate


endmodule
