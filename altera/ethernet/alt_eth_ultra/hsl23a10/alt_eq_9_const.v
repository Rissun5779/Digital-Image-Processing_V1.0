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

`timescale 1 ps / 1 ps

// DESCRIPTION
// 
// This is a 3 cell two tick WYSIWYG implementation of comparing a 9 bit number to a constant.
// 



// CONFIDENCE
// This is a small equality circuit.  Any problems should be easily spotted in simulation.
// 

module alt_eq_9_const #(
	parameter TARGET_CHIP = 5,
	parameter VAL = 9'h1fe
)(
	input clk,
	input [8:0] din,
	output match
);

wire match0, match1;

alt_wys_lut w0 (
	.a(1'b0),
	.b(din[0]),
	.c(din[1]),
	.d(din[2]),
	.e(din[3]),
	.f(din[4]),
	.out (match0)
);
defparam w0 .TARGET_CHIP = TARGET_CHIP;
defparam w0 .MASK = 64'h0 | (64'b1 << {VAL[4:0],1'b0});

alt_wys_lut w1 (
	.a(1'b0),
	.b(1'b0),
	.c(din[5]),
	.d(din[6]),
	.e(din[7]),
	.f(din[8]),
	.out (match1)
);
defparam w1 .TARGET_CHIP = TARGET_CHIP;
defparam w1 .MASK = 64'h0 | (64'b1 << {VAL[8:5],2'b0});

reg match0_r = 1'b0;
reg match1_r = 1'b0;
reg match_r = 1'b0;
always @(posedge clk) begin
	match0_r <= match0;
	match1_r <= match1;
	match_r <= match0_r & match1_r;
end
assign match = match_r;

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_eq_9_const.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 3
// BENCHMARK INFO :  Total pins : 11
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  4                  
// BENCHMARK INFO :  ALMs : 3 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.541 ns, From match0_r, To match_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.559 ns, From match1_r, To match_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.551 ns, From match1_r, To match_r}
