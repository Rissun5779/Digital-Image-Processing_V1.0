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
// Copyright 2012 Altera Corporation. All rights reserved.  
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

// 07-22-2012
// compare two 1152 bit values - how many ticks?  I think it is 6 ticks, 
// 3 for the 36 bit comparators and 3 more for the 32 bit AND

// DESCRIPTION
// 
// This is a pipelined equality comparator of two 1152 bit busses (16 words of 72 bits). The latency is 3
// ticks for the 36 bit comparator and 3 more for the 32 input AND gate for a total of 6 ticks.
// 


module alt_eq_1152 #(
	parameter TARGET_CHIP = 5
)(
	input clk,
	input [1151:0] din_a,
	input [1151:0] din_b,
	output match
);

wire [31:0] cmp;

genvar i;
generate 
for (i=0; i<32; i=i+1) begin :lp
	wire eq_w;
	alt_eq_36 eq (
		.clk(clk),
		.din_a(din_a[(i+1)*36-1:i*36]),
		.din_b(din_b[(i+1)*36-1:i*36]),
		.match(cmp[i])
	);
	defparam eq .TARGET_CHIP = TARGET_CHIP;	
end
endgenerate

alt_and_r ar (
	.clk(clk),
	.din(cmp),
	.dout(match)
);
defparam ar .WIDTH = 32;

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_eq_1152.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_36.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_18.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_3.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_and_r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 491
// BENCHMARK INFO :  Total pins : 2,306
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  492            
// BENCHMARK INFO :  ALMs : 247 / 427,200 ( < 1 % )
