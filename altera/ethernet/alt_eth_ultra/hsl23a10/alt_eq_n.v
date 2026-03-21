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


`timescale 1 ps / 1 ps
// Copyright 2013 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// 06-05-2013
// compare two N bit values - ? ticks
// if you know the bus width the specific width version probably has better decomposition
// if you don't know the bus width, use this

// DESCRIPTION
// 
// This is a pipelined equality comparator for variable width busses. The latency is also variable. The LUT
// depth should be 1. If you know the bus width ahead of time use the specific version to get hand made
// decomposition. If you don't know the bus width this is a good fallback position.
// 


module alt_eq_n #(
	parameter TARGET_CHIP = 5,
	parameter WIDTH = 18
)(
	input clk,
	input [WIDTH-1:0] din_a,
	input [WIDTH-1:0] din_b,
	output match
);

localparam PAD_WIDTH = WIDTH + 
		(((WIDTH % 3) == 1) ? 2 : 0) +
		(((WIDTH % 3) == 2) ? 1 : 0);
		 
wire [PAD_WIDTH-1:0] pad_a = {PAD_WIDTH{1'b0}} | din_a; 
wire [PAD_WIDTH-1:0] pad_b = {PAD_WIDTH{1'b0}} | din_b; 

localparam NUM_TRIPS = PAD_WIDTH / 3;

reg [NUM_TRIPS-1:0] mid = {NUM_TRIPS{1'b0}};

// combine in groups of 3 pair
genvar i;
generate 
	for (i=0; i<NUM_TRIPS; i=i+1) begin :lp
		wire eq_w;
		alt_eq_3 eq (
			.da(pad_a[(i+1)*3-1:i*3]),
			.db(pad_b[(i+1)*3-1:i*3]),
			.eq(eq_w)
		);
		defparam eq .TARGET_CHIP = TARGET_CHIP;

		always @(posedge clk) begin
			mid[i] <= eq_w;
		end
	end
endgenerate

// AND together partial matches
generate
	if (NUM_TRIPS == 1) begin
		assign match = mid[0];
	end
	else begin
		alt_and_r a0 (
			.clk(clk),
			.din(mid),
			.dout(match)
		);
		defparam a0 .WIDTH = NUM_TRIPS;
	end
endgenerate

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_eq_n.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_3.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_and_r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 7
// BENCHMARK INFO :  Total pins : 38
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  8                  
// BENCHMARK INFO :  ALMs : 8 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.365 ns, From mid[4], To alt_and_r:a0|dout_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.456 ns, From mid[0], To alt_and_r:a0|dout_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.458 ns, From mid[5], To alt_and_r:a0|dout_r}
