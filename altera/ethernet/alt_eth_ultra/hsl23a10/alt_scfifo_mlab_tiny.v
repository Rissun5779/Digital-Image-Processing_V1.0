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


// Copyright 2014 Altera Corporation. All rights reserved.  
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

`timescale 1ps/1ps

// baeckler - 03-24-2014

// DESCRIPTION
// This is an experimental 3 word MLAB based SCFIFO.  The control logic is all
// implemented as single LUT registered functions.
//
// CONFIDENCE
// Due to the tiny size it has excellent simulation coverage, but it hasn't been 
// deployed at all. 

module alt_scfifo_mlab_tiny #(
	parameter WIDTH = 20,	// not intended for or tested at more than 20 
	parameter TARGET_CHIP = 5,
	parameter SIM_EMULATE = 1'b0  // emulate the RAM for faster sim
)(
	input clk,
	
	input wreq,
	input [WIDTH-1:0] wdata_reg,	// must be a register
	output reg wfull,
	
	input rreq,	
	output [WIDTH-1:0] rdata,
	output reg rempty
);

initial rempty = 1'b0;
initial wfull = 1'b0;

//////////////////////////////////

reg [1:0] rptr = 2'b0;
reg [1:0] wptr = 2'b0;
wire [WIDTH-1:0] rdata_w;

alt_a10mlab sm (
    .wclk(clk),
    .wena(1'b1),
    .waddr_reg(wptr),
    .wdata_reg(wdata_reg),
    .raddr(rptr),
    .rdata(rdata_w)
);
defparam sm .WIDTH = WIDTH;
defparam sm .ADDR_WIDTH = 2;
defparam sm .SIM_EMULATE = SIM_EMULATE;

reg [WIDTH-1:0] rdata_r = {WIDTH{1'b0}};
always @(posedge clk) rdata_r <= rdata_w;
assign rdata = rdata_r;

//////////////////////////////////

wire [1:0] next_wptr;
wire [1:0] next_rptr;
wire next_rempty;
wire next_wfull;

//always @(*) begin
//	next_wptr = wptr;
//	next_rptr = rptr;
//	
//	if (!rempty && rreq) begin
//		next_rptr = rptr + 1'b1;
//	end
//	if (!wfull && wreq) begin
//		next_wptr = wptr + 1'b1;
//	end
//	
//	next_rempty = (next_rptr == next_wptr);
//	next_wfull = (next_wptr == (next_rptr-1'b1));	
//end

wire [5:0] din = {wreq,rreq,wptr,rptr};

alt_wys_lut w0 (.a(din[0]),.b(din[1]),.c(din[2]),.d(din[3]),.e(din[4]),.f(din[5]),.out(next_wptr[0]));
defparam w0 .MASK = 64'h174d174df0f0f0f0;
defparam w0 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut w1 (.a(din[0]),.b(din[1]),.c(din[2]),.d(din[3]),.e(din[4]),.f(din[5]),.out(next_wptr[1]));
defparam w1 .MASK = 64'h1fb01fb0ff00ff00;
defparam w1 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut w2 (.a(din[0]),.b(din[1]),.c(din[2]),.d(din[3]),.e(din[4]),.f(din[5]),.out(next_rptr[0]));
defparam w2 .MASK = 64'hd174aaaad174aaaa;
defparam w2 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut w3 (.a(din[0]),.b(din[1]),.c(din[2]),.d(din[3]),.e(din[4]),.f(din[5]),.out(next_rptr[1]));
defparam w3 .MASK = 64'he646cccce646cccc;
defparam w3 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut w4 (.a(din[0]),.b(din[1]),.c(din[2]),.d(din[3]),.e(din[4]),.f(din[5]),.out(next_rempty));
defparam w4 .MASK = 64'h00000000c6398421;
defparam w4 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut w5 (.a(din[0]),.b(din[1]),.c(din[2]),.d(din[3]),.e(din[4]),.f(din[5]),.out(next_wfull));
defparam w5 .MASK = 64'h000039c600001842;
defparam w5 .TARGET_CHIP = TARGET_CHIP;

always @(posedge clk) begin
	wfull <= next_wfull;
	rempty <= next_rempty;
	rptr <= next_rptr;
	wptr <= next_wptr;
end

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_mlab_tiny.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 26
// BENCHMARK INFO :  Total pins : 45
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  6                  
// BENCHMARK INFO :  ALMs : 14 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.030 ns, From wptr[0], To alt_a10mlab:sm|ml[2].lrm~reg1}
