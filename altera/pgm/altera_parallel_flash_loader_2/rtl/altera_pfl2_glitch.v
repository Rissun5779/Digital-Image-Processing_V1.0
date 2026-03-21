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


////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_GLITCH
//
//  (c) Altera Corporation, 2007
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module used by PFL to avoid glitch
//************************************************************

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module altera_pfl2_glitch
(
	clk,
	data_in,
	data_out
);

	parameter INIT = 1;
	
	input clk;
	input data_in;
	output data_out;

	reg stage_one;
	reg stage_two;
    
	assign data_out = stage_two;
	
	always @ (posedge clk) begin
		stage_one = data_in;
	end
	
	always @ (posedge clk) begin
		if (stage_one == data_in)
			stage_two = stage_one;
		else
			stage_two = stage_two;
	end
	
	generate
		if (INIT == 1) begin
			initial begin
				stage_one = 1'b1;
				stage_two = 1'b1;
			end
		end
		else begin
			initial begin
				stage_one = 1'b0;
				stage_two = 1'b0;
			end
		end
	endgenerate
	
endmodule


