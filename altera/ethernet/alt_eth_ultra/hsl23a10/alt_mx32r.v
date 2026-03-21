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

// baeckler - 01-14-2012
// two 16:1 muxed to build 32:1

// to cut down pins for testing -
// set_instance_assignment -name VIRTUAL_PIN ON -to din

// DESCRIPTION
// 
// This is a registered 32:1 bus MUX composed from two copies of mx16r. It has a latency of 3 cycles and a
// LUT depth of one.
// 



// CONFIDENCE
// This muxing component has very little state.  Problems should be clearly visible in simulation.
// 

module alt_mx32r #(
	parameter WIDTH = 16
)(
	input clk,
	input [32*WIDTH-1:0] din,
	input [4:0] sel,
	output [WIDTH-1:0] dout
);

wire [2*WIDTH-1:0] mid_dout;

genvar i;
generate
for (i=0; i<2; i=i+1) begin : lp
	alt_mx16r m (
		.clk(clk),
		.din(din[(i+1)*16*WIDTH-1:i*16*WIDTH]),
		.sel(sel[3:0]),
		.dout(mid_dout[(i+1)*WIDTH-1:i*WIDTH])
	);
	defparam m .WIDTH = WIDTH;
end
endgenerate

// match the select latency
reg mid_sel = 1'b0 /* synthesis preserve */;
reg mid_sel_pre = 1'b0 /* synthesis preserve */;
always @(posedge clk) begin
	mid_sel_pre <= sel[4];
	mid_sel <= mid_sel_pre;
end

// final 2:1
reg [WIDTH-1:0] dout_r = {WIDTH{1'b0}} /* synthesis preserve */;
wire [WIDTH-1:0] mid_dout_hi, mid_dout_lo;
assign {mid_dout_hi, mid_dout_lo} = mid_dout;
always @(posedge clk) begin
	dout_r <= mid_sel ? mid_dout_hi : mid_dout_lo;
end
assign dout = dout_r;

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_mx32r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx16r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx4r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 182
// BENCHMARK INFO :  Total pins : 22
// BENCHMARK INFO :  Total virtual pins : 512
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  161                
// BENCHMARK INFO :  ALMs : 425 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.074 ns, From alt_mx16r:lp[1].m|mid_sel[1], To alt_mx16r:lp[1].m|alt_mx4r:m|dout_r[2]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.020 ns, From alt_mx16r:lp[1].m|mid_sel[0], To alt_mx16r:lp[1].m|alt_mx4r:m|dout_r[14]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.087 ns, From alt_mx16r:lp[0].m|mid_sel[1], To alt_mx16r:lp[0].m|alt_mx4r:m|dout_r[4]}
