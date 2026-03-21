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
// baeckler - 05-20-2013
// latency 2

// DESCRIPTION
// 
// This is a 2 tick pipelined LUT comparator for comparing a 32 bit number to a constant.
// 



// CONFIDENCE
// This is a small equality circuit.  Any problems should be easily spotted in simulation.
// 

module alt_eq_32_const #(
	parameter TARGET_CHIP = 5,
	parameter VAL = 32'h1234
)(
	input clk,
	input [31:0] din,
	output match
);

genvar i;

wire [5:0] subeq;
generate 
	for (i=0; i<5; i=i+1) begin : lp
		alt_eq_6_const eq (
			.din(din[(i+1)*6-1:i*6]),
			.match(subeq[i])
		);
		defparam eq .TARGET_CHIP = TARGET_CHIP;
		defparam eq .VAL = VAL[(i+1)*6-1:i*6];
	end
endgenerate
assign subeq[5] = (din[31:30] == VAL[31:30]) ? 1'b1 : 1'b0;

reg [5:0] subeq_r = 6'b0;
always @(posedge clk) subeq_r <= subeq;

alt_and_r ar (
	.clk(clk),
	.din(subeq_r),
	.dout(match)
);
defparam ar .WIDTH = 6;

endmodule


// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_eq_32_const.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_6_const.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_and_r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 7
// BENCHMARK INFO :  Total pins : 34
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  8                  
// BENCHMARK INFO :  ALMs : 7 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.367 ns, From subeq_r[5], To alt_and_r:ar|dout_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.456 ns, From subeq_r[0], To alt_and_r:ar|dout_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.457 ns, From subeq_r[0], To alt_and_r:ar|dout_r}
