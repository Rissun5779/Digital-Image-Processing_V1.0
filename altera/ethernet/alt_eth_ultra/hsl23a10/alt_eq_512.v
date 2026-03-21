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
// Copyright 2013 Altera Corporation. All rights reserved.  
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

// baeckler - 10-08-2013

// set_instance_assignment -name VIRTUAL_PIN ON -to din_a
// set_instance_assignment -name VIRTUAL_PIN ON -to din_b


// DESCRIPTION
// 

module alt_eq_512 #(
	parameter TARGET_CHIP = 5
)(
	input clk,
	input [511:0] din_a,
	input [511:0] din_b,
	output match
);

localparam PAD_WIDTH = 513;
		 
wire [PAD_WIDTH-1:0] pad_a = {PAD_WIDTH{1'b0}} | din_a; 
wire [PAD_WIDTH-1:0] pad_b = {PAD_WIDTH{1'b0}} | din_b; 

localparam NUM_TRIPS = PAD_WIDTH / 3;

reg [NUM_TRIPS-1:0] mid = {NUM_TRIPS{1'b0}};

// combine in groups of 3 pair
genvar i;
generate 
	for (i=0; i<NUM_TRIPS; i=i+1) begin :lp
		wire eq_w;
		alt_eq_3 eq (
			.da(pad_a[(i+1)*3-1:i*3]),
			.db(pad_b[(i+1)*3-1:i*3]),
			.eq(eq_w)
		);
		defparam eq .TARGET_CHIP = TARGET_CHIP;

		always @(posedge clk) begin
			mid[i] <= eq_w;
		end
	end
endgenerate

// need to help with the AND decomposition here
// combine by hexes
wire [173:0] pad_mid = {3'b111,mid};
wire [28:0] merged;
generate 
	for (i=0; i<29; i=i+1) begin :mp
		alt_and_r a0 (.clk(clk),.din(pad_mid[(i+1)*6-1:i*6]),.dout(merged[i]));
		defparam a0 .WIDTH = 6;
	end
endgenerate

alt_and_r a1 (.clk(clk),.din({1'b1,merged}),.dout(match));
defparam a1 .WIDTH = 30;

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_eq_512.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_3.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_and_r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 206
// BENCHMARK INFO :  Total pins : 2
// BENCHMARK INFO :  Total virtual pins : 1,024
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  207                
// BENCHMARK INFO :  ALMs : 748 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.182 ns, From alt_and_r:a1|alt_and_r:lp[0].a|dout_r, To alt_and_r:a1|alt_and_r:h|dout_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.165 ns, From alt_and_r:a1|alt_and_r:lp[0].a|dout_r, To alt_and_r:a1|alt_and_r:h|dout_r}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.880 ns, From alt_and_r:mp[10].a0|dout_r, To alt_and_r:a1|alt_and_r:lp[1].a|dout_r}
