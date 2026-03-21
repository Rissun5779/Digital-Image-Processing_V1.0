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
// baeckler - 06-01-2012

// set_instance_assignment -name VIRTUAL_PIN ON -to din
// set_instance_assignment -name VIRTUAL_PIN ON -to sel

// DESCRIPTION
// 
// This is a registered 36:1 bus MUX composed from two 16's and a 4. It has a latency of 3 cycles and a LUT
// depth of one.
// 



// CONFIDENCE
// This muxing component has very little state.  Problems should be clearly visible in simulation.
// 

module alt_mx36r #(
	parameter WIDTH = 16
)(
	input clk,
	input [36*WIDTH-1:0] din,
	input [5:0] sel,
	output [WIDTH-1:0] dout
);

wire [WIDTH-1:0] m0w;
alt_mx16r m0 (
	.clk(clk),
	.din(din[16*WIDTH-1:0]),
	.sel(sel[3:0]),
	.dout(m0w)
);
defparam m0 .WIDTH = WIDTH;

wire [WIDTH-1:0] m1w;
alt_mx16r m1 (
	.clk(clk),
	.din(din[32*WIDTH-1:16*WIDTH]),
	.sel(sel[3:0]),
	.dout(m1w)
);
defparam m1 .WIDTH = WIDTH;

wire [WIDTH-1:0] m2w;
alt_mx4r m2 (
	.clk(clk),
	.din(din[36*WIDTH-1:32*WIDTH]),
	.sel(sel[1:0]),
	.dout(m2w)	
);
defparam m2 .WIDTH = WIDTH;

wire [WIDTH-1:0] m2w_lag;
alt_delay_regs dr0 (
	.clk(clk),
	.din(m2w),
	.dout(m2w_lag)
);
defparam dr0 .LATENCY = 1;
defparam dr0 .WIDTH = WIDTH;

// match the select latency
reg [1:0] mid_sel = 2'b0 /* synthesis preserve */;
reg [1:0] mid_sel_pre = 2'b0 /* synthesis preserve */;
always @(posedge clk) begin
	mid_sel_pre <= sel[5:4];
	mid_sel <= mid_sel_pre;
end

wire [WIDTH-1:0] blank = {WIDTH{1'b0}};
alt_mx4r mh (
	.clk(clk),
	.din({blank,m2w_lag,m1w,m0w}),
	.sel(mid_sel),
	.dout(dout)	
);
defparam mh .WIDTH = WIDTH;

endmodule


// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_mx36r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx16r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx4r.v
// BENCHMARK INFO :  Uses helper file :  alt_delay_regs.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 216
// BENCHMARK INFO :  Total pins : 17
// BENCHMARK INFO :  Total virtual pins : 582
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  193                
// BENCHMARK INFO :  ALMs : 478 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.839 ns, From alt_mx16r:m1|mid_sel[0], To alt_mx16r:m1|alt_mx4r:m|dout_r[14]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.894 ns, From alt_mx16r:m1|mid_sel[0], To alt_mx16r:m1|alt_mx4r:m|dout_r[6]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.144 ns, From alt_mx16r:m0|mid_sel[1], To alt_mx16r:m0|alt_mx4r:m|dout_r[12]}
