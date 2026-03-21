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

// baeckler 01-07-2012
// serial byte RX/TX with one 0 as a start bit, no stop, no parity

`timescale 1ps/1ps

// DESCRIPTION
// 
// This is a lower level serial byte interface used by several of the Serif components.
// 



// CONFIDENCE
// This has been used successfully in numerous hardware test and demo designs
// 

module alt_serif_tap (
	input clk,
	input din,
	output dout,
	
	output [7:0] rx_byte,
	output rx_byte_valid,
	
	input [7:0] tx_byte,
	input tx_byte_valid,
	output reg tx_byte_ack	
);
	

//////////////////////////////////////
// RX bit to byte

reg [8:0] din_sr = 9'h1ff;
always @(posedge clk) begin
	din_sr <= {din_sr[7:0],din};
	if (!din_sr[8]) din_sr[8:1] <= 8'hff;
end

assign rx_byte_valid = !din_sr[8];
assign rx_byte = din_sr[7:0];

//////////////////////////////////////
// TX byte to bit

reg [8:0] dout_sr = 9'h1ff;
reg [3:0] dout_cntr = 4'h0;
reg dout_cntr_zero = 1'b1;

always @(posedge clk) begin
	tx_byte_ack <= 1'b0;
	
	if (!dout_cntr_zero) begin
		dout_cntr <= dout_cntr - 1'b1;
		dout_cntr_zero <= (dout_cntr == 4'h1);
	end
		
	dout_sr <= {dout_sr[7:0],1'b1};
	
	if (dout_cntr_zero && tx_byte_valid) begin
		dout_cntr_zero <= 1'b0;
		dout_cntr <= 4'h8;
		dout_sr <= {1'b0,tx_byte};
		tx_byte_ack <= 1'b1;
	end		
end
assign dout = dout_sr[8];


endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_serif_tap.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 24
// BENCHMARK INFO :  Total pins : 22
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  25                 
// BENCHMARK INFO :  ALMs : 14 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.308 ns, From dout_cntr_zero, To dout_cntr[2]}
