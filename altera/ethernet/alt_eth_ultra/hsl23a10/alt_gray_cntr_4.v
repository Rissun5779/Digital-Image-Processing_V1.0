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

// DESCRIPTION
// 
// This is a 4 bit gray counter with aclr and enable implemented in a case statement. For even lower level
// control consider gray_cntr_4_sl.v.
// 


module alt_gray_cntr_4 #(
	parameter INIT_VAL = 4'h0
)(
	input clk,
	input ena,
	input aclr,
	output reg [3:0] cntr
);

initial cntr = INIT_VAL;

always @(posedge clk or posedge aclr) begin
	if (aclr) cntr <= INIT_VAL;
	else begin
		if (ena) begin
			case (cntr) 
				4'h0 : cntr <= 4'h1;
				4'h1 : cntr <= 4'h3;
				4'h2 : cntr <= 4'h6;
				4'h3 : cntr <= 4'h2;
				4'h4 : cntr <= 4'hc;
				4'h5 : cntr <= 4'h4;
				4'h6 : cntr <= 4'h7;
				4'h7 : cntr <= 4'h5;
				4'h8 : cntr <= 4'h0;
				4'h9 : cntr <= 4'h8;
				4'ha : cntr <= 4'hb;
				4'hb : cntr <= 4'h9;
				4'hc : cntr <= 4'hd;
				4'hd : cntr <= 4'hf;
				4'he : cntr <= 4'ha;
				4'hf : cntr <= 4'he;
			endcase
		end
	end
end

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_gray_cntr_4.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 4
// BENCHMARK INFO :  Total pins : 7
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  5                  
// BENCHMARK INFO :  ALMs : 3 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.345 ns, From cntr[0]~reg0, To cntr[1]~reg0}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.430 ns, From cntr[1]~reg0, To cntr[0]~reg0}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.322 ns, From cntr[0]~reg0, To cntr[1]~reg0}
