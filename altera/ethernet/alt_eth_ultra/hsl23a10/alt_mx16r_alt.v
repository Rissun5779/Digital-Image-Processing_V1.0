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

// baeckler - 07-20-2012
// five registered 4:1 MUX stacked to build 16:1
// alternate combination pattern

// DESCRIPTION
// 
//  
// This is logically equivalent to mx16r.v A permutation is applied to the data and select inputs to change
// the loading of the select signals and the way data bits are grouped into the first stage of 4:1 MUXing.
// 



// CONFIDENCE
// This muxing component has very little state.  Problems should be clearly visible in simulation.
// 

module alt_mx16r_alt #(
	parameter WIDTH = 16
)(
	input clk,
	input [16*WIDTH-1:0] din,
	input [3:0] sel,
	output [WIDTH-1:0] dout
);

wire [4*WIDTH-1:0] mid_dout;
wire [16*WIDTH-1:0] din_alt;

genvar i;
generate
	for (i=0; i<16; i=i+1) begin : lp0
		localparam mod_i = {i[1],i[2],i[3],i[0]};
		assign din_alt[(i+1)*WIDTH-1:i*WIDTH] = 
			din[(mod_i+1)*WIDTH-1:mod_i*WIDTH];
	end
endgenerate
wire [3:0] sel_alt = {sel[1],sel[2],sel[3],sel[0]};

alt_mx16r m (
	.clk(clk),
	.din(din_alt),
	.sel(sel_alt),
	.dout(dout)
);
defparam m .WIDTH = WIDTH;


endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_mx16r_alt.v
// BENCHMARK INFO :  Uses helper file :  alt_mx16r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx4r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 82
// BENCHMARK INFO :  Total pins : 277
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  81                 
// BENCHMARK INFO :  ALMs : 81 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.020 ns, From alt_mx16r:m|mid_sel[1], To alt_mx16r:m|alt_mx4r:m|dout_r[4]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.994 ns, From alt_mx16r:m|mid_sel[1], To alt_mx16r:m|alt_mx4r:m|dout_r[4]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.655 ns, From alt_mx16r:m|mid_sel[1], To alt_mx16r:m|alt_mx4r:m|dout_r[10]}
