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
// This is a small register circuit for synchronizing aclr signals to produce asynchronous attack and
// synchronous release across clock domains.
// 



// CONFIDENCE
// This component has significant hardware test coverage in reference designs and Altera IP cores.
// 

module alt_aclr_filter (
	input aclr, // no domain
	
	input clk,
	output aclr_sync
);

reg [2:0] aclr_meta = 3'b0 /* synthesis preserve dont_replicate */
/* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"set_false_path -from [get_fanins -async *aclr_filter*aclr_meta\[*\]] -to [get_keepers *aclr_filter*aclr_meta\[*\]]\" " */;

always @(posedge clk or posedge aclr) begin
	if (aclr) aclr_meta <= 3'b0;
	else aclr_meta <= {aclr_meta[1:0],1'b1};	
end

assign aclr_sync = ~aclr_meta[2];

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_aclr_filter.v
// BENCHMARK INFO :  Max depth :  0.0 LUTs
// BENCHMARK INFO :  Total registers : 3
// BENCHMARK INFO :  Total pins : 3
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  1                  
// BENCHMARK INFO :  ALMs : 1 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.455 ns, From aclr_meta[1], To aclr_meta[2]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.470 ns, From aclr_meta[0], To aclr_meta[1]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.410 ns, From aclr_meta[0], To aclr_meta[1]}
