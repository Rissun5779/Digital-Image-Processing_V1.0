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
// Filename    : alt_xcvr_alt_xcvr_prbs_gen_top.v
//
// Description : PRBS generator
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
module alt_xcvr_prbs_gen_top #(
    parameter PRBS_INITIAL_VALUE = 97,
    parameter DATA_WIDTH = 8,
    parameter PRBS = 23,
    parameter XAUI_PATTERN = 97,
    parameter CHANNELS=1
)(
    output [CHANNELS*DATA_WIDTH-1:0] dout,
    input [CHANNELS-1:0]        clk,
    input [CHANNELS-1:0]        start,
    input tri1 [CHANNELS-1:0] 	xaui_word_align,
    input [CHANNELS-1:0]	    reset,
    input [CHANNELS-1:0]        insert_error,
    input tri0 [CHANNELS-1:0]   pause
);

    wire [DATA_WIDTH-1:0]        dout_w[CHANNELS-1:0];
    
    genvar i;
    generate 
        for(i=0;i<CHANNELS;i=i+1) begin: prbs
	        alt_xcvr_prbs_gen #(
		        .PRBS_INITIAL_VALUE (PRBS_INITIAL_VALUE),
		        .DATA_WIDTH         (DATA_WIDTH),
		        .PRBS               (PRBS),
		        .XAUI_PATTERN       (XAUI_PATTERN)
	        ) alt_xcvr_prbs_gen_inst (
		        .clk          (clk[i]),          
        		.nreset       (start),        
		        .insert_error (insert_error[i]), 
        		.pause        (pause[i]),        
		        .dout         (dout_w[i])          
	        );

            assign dout[DATA_WIDTH*(i+1)-1:DATA_WIDTH*i] = dout_w[i];
        end


    endgenerate


endmodule
