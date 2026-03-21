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
// registered 4:1 MUX

// DESCRIPTION
// 
// This is a registered 4:1 MUX of N bit bus.
// 



// CONFIDENCE
// This muxing component has very little state.  Problems should be clearly visible in simulation.
// 

module alt_mx4r #(
	parameter WIDTH = 32
)(
	input clk,
	input [4*WIDTH-1:0] din,
	input [1:0] sel,
	output [WIDTH-1:0] dout
);

reg [WIDTH-1:0] dout_r = {WIDTH{1'b0}} /* synthesis preserve */;
reg [WIDTH-1:0] dout_w /* synthesis keep */;

assign dout = dout_r;

always @(*) begin
	case (sel) 
		2'b00 : dout_w = din[WIDTH-1:0];
		2'b01 : dout_w = din[(WIDTH*2)-1:WIDTH];
		2'b10 : dout_w = din[(WIDTH*3)-1:(WIDTH*2)];
		2'b11 : dout_w = din[(WIDTH*4)-1:(WIDTH*3)];		
	endcase
end

always @(posedge clk) dout_r <= dout_w;

endmodule


// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_mx4r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 32
// BENCHMARK INFO :  Total pins : 163
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  33                 
// BENCHMARK INFO :  ALMs : 33 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -14.474 ns, From (primary), To dout_r[23]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -15.819 ns, From (primary), To dout_r[23]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -17.579 ns, From (primary), To dout_r[30]}
