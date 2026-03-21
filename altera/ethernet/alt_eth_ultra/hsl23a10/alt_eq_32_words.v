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

// baeckler - 02-22-2012
// compare an array of 32 bit values - 3 ticks

// set_instance_assignment -name VIRTUAL_PIN ON -to din_a
// set_instance_assignment -name VIRTUAL_PIN ON -to din_b

// DESCRIPTION
// 
// This is an array of comparators for equality checking a variable number of 32 bit words (e.g. CRC
// checking). The latency is 3 ticks.
// 



// CONFIDENCE
// This is a small equality circuit.  Any problems should be easily spotted in simulation.
// 

module alt_eq_32_words #(
	parameter WORDS = 16,
	parameter TARGET_CHIP = 5
)(
	input clk,
	input [WORDS*32-1:0] din_a,
	input [WORDS*32-1:0] din_b,
	output [WORDS-1:0] match	
);

genvar i;
generate
	for (i=0; i<WORDS; i=i+1) begin : ck
		wire [31:0] local_a = din_a[(i+1)*32-1:i*32];
		wire [31:0] local_b = din_b[(i+1)*32-1:i*32];
		alt_eq_36 eq (
			.clk(clk),
			.din_a ({2'b0,local_a[31:16],2'b0,local_a[15:0]}),
			.din_b ({2'b0,local_b[31:16],2'b0,local_b[15:0]}),
			.match(match[i])			
		);		
		defparam eq .TARGET_CHIP = TARGET_CHIP;
	end
endgenerate

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_eq_32_words.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_36.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_18.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_3.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 240
// BENCHMARK INFO :  Total pins : 17
// BENCHMARK INFO :  Total virtual pins : 1,024
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  241                
// BENCHMARK INFO :  ALMs : 753 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.328 ns, From alt_eq_36:ck[15].eq|alt_eq_18:lp[0].eq|cmp3[2], To alt_eq_36:ck[15].eq|alt_eq_18:lp[0].eq|match}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.244 ns, From alt_eq_36:ck[10].eq|alt_eq_18:lp[0].eq|match, To alt_eq_36:ck[10].eq|match}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.323 ns, From alt_eq_36:ck[4].eq|alt_eq_18:lp[0].eq|cmp3[1], To alt_eq_36:ck[4].eq|alt_eq_18:lp[0].eq|match}
