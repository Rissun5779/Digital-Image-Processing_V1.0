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

// 05-02-2012
// compare two 24 bit values - 3 ticks

// DESCRIPTION
// 
// This is a pipelined comparator for din_a != din_b on 24 bit busses.
// 


module alt_neq_24 #(
	parameter TARGET_CHIP = 5
)(
	input clk,
	input [23:0] din_a,
	input [23:0] din_b,
	output reg match
);

wire [1:0] cmp12;

genvar i;
generate 
for (i=0; i<2; i=i+1) begin :lp
	wire eq_w;
	alt_eq_12 eq (
		.clk(clk),
		.din_a(din_a[(i+1)*12-1:i*12]),
		.din_b(din_b[(i+1)*12-1:i*12]),
		.match(cmp12[i])
	);
	defparam eq .TARGET_CHIP = TARGET_CHIP;	
end
endgenerate

initial match = 1'b0;
always @(posedge clk) begin
	match <= ~&cmp12;
end

endmodule


// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_neq_24.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_12.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_3.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 11
// BENCHMARK INFO :  Total pins : 50
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  12                 
// BENCHMARK INFO :  ALMs : 13 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.438 ns, From alt_eq_12:lp[1].eq|match, To match~reg0}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.346 ns, From alt_eq_12:lp[0].eq|cmp3[0], To alt_eq_12:lp[0].eq|match}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.449 ns, From alt_eq_12:lp[1].eq|cmp3[0], To alt_eq_12:lp[1].eq|match}
