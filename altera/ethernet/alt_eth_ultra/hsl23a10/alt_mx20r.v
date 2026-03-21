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

// baeckler - 08-20-2012
// five registered 4:1 MUX stacked with 5:1 to build 20:1

// DESCRIPTION
// 
// This is a registered 20:1 bus MUX composed from five copies of mx4r followed by a mx5r. It has a
// latency of 2 cycles and a LUT depth of one.
// 



// CONFIDENCE
// This muxing component has very little state.  Problems should be clearly visible in simulation.
// 

module alt_mx20r #(
	parameter WIDTH = 16
)(
	input clk,
	input [20*WIDTH-1:0] din,
	input [4:0] sel,
	output [WIDTH-1:0] dout
);

wire [5*WIDTH-1:0] mid_dout;

genvar i;
generate
for (i=0; i<5; i=i+1) begin : lp
	alt_mx4r m (
		.clk(clk),
		.din(din[(i+1)*4*WIDTH-1:i*4*WIDTH]),
		.sel(sel[1:0]),
		.dout(mid_dout[(i+1)*WIDTH-1:i*WIDTH])
	);
	defparam m .WIDTH = WIDTH;
end
endgenerate

reg [2:0] mid_sel = 3'b0 /* synthesis preserve */;
always @(posedge clk) mid_sel <= sel[4:2];

alt_mx5r m (
	.clk(clk),
	.din(mid_dout),
	.sel(mid_sel),
	.dout(dout)
);
defparam m .WIDTH = WIDTH;

endmodule


// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_mx20r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx4r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx5r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 99
// BENCHMARK INFO :  Total pins : 342
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  97             
// BENCHMARK INFO :  ALMs : 51 / 427,200 ( < 1 % )
