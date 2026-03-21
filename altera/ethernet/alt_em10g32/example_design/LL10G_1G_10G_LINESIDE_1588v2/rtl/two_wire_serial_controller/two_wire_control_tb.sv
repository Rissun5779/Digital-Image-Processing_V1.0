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
// Copyright 2010 Altera Corporation. All rights reserved.  
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

module two_wire_control_tb ();

reg clk = 1'b0;

wire sda_in, scl_in;
wire sda_out, sda_oe;
wire scl_out, scl_oe;

wire sda = sda_oe ? sda_out : 1'bz;
assign sda_in = sda;

wire scl = scl_oe ? scl_out : 1'bz;
assign scl_in = scl;

reg cmd_rd = 1'b0, cmd_wr = 1'b0;
reg [7:0] slave_addr = 8'ha0;
reg [7:0] mem_addr = 8'h33;
reg [7:0] wr_data = 6'h66;
wire [7:0] rd_data;
	
two_wire_control dut
(
	.*
);

always begin
	#5 clk = ~clk;
end

initial begin
	#50
	@(negedge clk);
	cmd_rd = 1'b1;
	@(negedge clk);
	cmd_rd = 1'b0;
end

endmodule