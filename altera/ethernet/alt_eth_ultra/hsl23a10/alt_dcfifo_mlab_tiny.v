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

// baeckler - 03-31-2014

// DESCRIPTION
// Experimental DCFIFO designed to operate in one MLAB with a depth of approximately 7.
// The three bit address pointers make the FULL/EMPTY determiniation single LUT,
// targeting high speeds.

// CONFIDENCE
// This has not been hardware tested yet.

module alt_dcfifo_mlab_tiny #(
	parameter WIDTH = 20, // intended to be 20 or less 
	parameter TARGET_CHIP = 5,
	parameter SIM_EMULATE = 1'b0
)(
	input wclk,
	input [WIDTH-1:0] wdata_reg,
	input wreq,
	output wfull,	
		
	input rclk,
	output [WIDTH-1:0] rdata,
	input rreq,
	output rempty
);

////////////////////////////////////////////////////
// write side pointer

reg [2:0] wptrg = 3'b0;
reg w_almost_full = 1'b0;
reg w_close = 1'b0;
wire [2:0] wptrg_w;
wire [2:0] w_rptrg;
reg wfull_r = 1'b0;

alt_wys_lut w0 (
	.a(wptrg[0]),
	.b(wptrg[1]),
	.c(wptrg[2]),
	.d(w_almost_full),
	.e(w_close),
	.f(wreq),	
	.out(wptrg_w[0])
);
defparam w0 .MASK = 64'haac3c3c3aaaaaaaa;
defparam w0 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut w1 (
	.a(wptrg[0]),
	.b(wptrg[1]),
	.c(wptrg[2]),
	.d(w_almost_full),
	.e(w_close),
	.f(wreq),	
	.out(wptrg_w[1])
);
defparam w1 .MASK = 64'hcc4e4e4ecccccccc;						
defparam w1 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut w2 (
	.a(wptrg[0]),
	.b(wptrg[1]),
	.c(wptrg[2]),
	.d(w_almost_full),
	.e(w_close),
	.f(wreq),	
	.out(wptrg_w[2])
);
defparam w2 .MASK = 64'hf0e4e4e4f0f0f0f0;
defparam w2 .TARGET_CHIP = TARGET_CHIP;

always @(posedge wclk) begin
	if (!wfull_r) wptrg <= wptrg_w;
end

wire wfull_w;
alt_wys_lut w3 (
	.a(wptrg[0]),
	.b(wptrg[1]),
	.c(wptrg[2]),
	.d(w_rptrg[0]),
	.e(w_rptrg[1]),
	.f(w_rptrg[2]),	
	.out(wfull_w)
);
defparam w3 .MASK = 64'h4004802002080110;
defparam w3 .TARGET_CHIP = TARGET_CHIP;

wire w_almost_full_w;
alt_wys_lut w4 (
	.a(wptrg[0]),
	.b(wptrg[1]),
	.c(wptrg[2]),
	.d(w_rptrg[0]),
	.e(w_rptrg[1]),
	.f(w_rptrg[2]),	
	.out(w_almost_full_w)
);
defparam w4 .MASK = 64'h440cc0a0030a1130;
defparam w4 .TARGET_CHIP = TARGET_CHIP;

always @(posedge wclk) begin
	w_almost_full <= w_almost_full_w;
	wfull_r <= wfull_w;
end

////////////////////////////////////////////////////
// read side pointer

reg [2:0] rptrg = 3'b0;
reg r_almost_empty = 1'b0;
reg r_close = 1'b0;
wire [2:0] rptrg_w;
wire [2:0] r_wptrg;
reg rempty_r = 1'b1;

alt_wys_lut r0 (
	.a(rptrg[0]),
	.b(rptrg[1]),
	.c(rptrg[2]),
	.d(r_almost_empty),
	.e(r_close),
	.f(rreq),	
	.out(rptrg_w[0])
);
defparam r0 .MASK = 64'haac3c3c3aaaaaaaa;
defparam r0 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut r1 (
	.a(rptrg[0]),
	.b(rptrg[1]),
	.c(rptrg[2]),
	.d(r_almost_empty),
	.e(r_close),
	.f(rreq),	
	.out(rptrg_w[1])
);
defparam r1 .MASK = 64'hcc4e4e4ecccccccc;
defparam r1 .TARGET_CHIP = TARGET_CHIP;

alt_wys_lut r2 (
	.a(rptrg[0]),
	.b(rptrg[1]),
	.c(rptrg[2]),
	.d(r_almost_empty),
	.e(r_close),
	.f(rreq),	
	.out(rptrg_w[2])
);
defparam r2 .MASK = 64'hf0e4e4e4f0f0f0f0;
defparam r2 .TARGET_CHIP = TARGET_CHIP;

always @(posedge rclk) begin
	if (!rempty_r) rptrg <= rptrg_w;
end

wire rempty_w;
alt_wys_lut r3 (
	.a(r_wptrg[0]),
	.b(r_wptrg[1]),
	.c(r_wptrg[2]),
	.d(rptrg[0]),
	.e(rptrg[1]),
	.f(rptrg[2]),	
	.out(rempty_w)
);
defparam r3 .MASK = 64'h8040201008040201;
defparam r3 .TARGET_CHIP = TARGET_CHIP;

wire r_almost_empty_w;
alt_wys_lut r4 (
	.a(r_wptrg[0]),
	.b(r_wptrg[1]),
	.c(r_wptrg[2]),
	.d(rptrg[0]),
	.e(rptrg[1]),
	.f(rptrg[2]),	
	.out(r_almost_empty_w)
);
defparam r4 .MASK = 64'ha0c030110c440a03;
defparam r4 .TARGET_CHIP = TARGET_CHIP;

always @(posedge rclk) begin
	r_almost_empty <= r_almost_empty_w;
	rempty_r <= rempty_w;
end

////////////////////////////////////////////////////
// crossing

alt_sync_regs_m2 ss0 (
	.clk(wclk),
	.din(rptrg),
	.dout(w_rptrg)
);
defparam ss0 .WIDTH = 3;

alt_sync_regs_m2 ss1 (
	.clk(rclk),
	.din(wptrg),
	.dout(r_wptrg)
);
defparam ss1 .WIDTH = 3;

////////////////////////////////////////////////////
//  mix in close flags

always @(posedge rclk) begin
	r_close <= rreq && !rempty;
end

always @(posedge wclk) begin
	w_close <= wreq && !wfull;
end

assign wfull = wfull_r | (w_close & w_almost_full);
assign rempty = rempty_r | (r_close & r_almost_empty);

////////////////////////////////////////////////////
//  storage

wire [WIDTH-1:0] ram_q;
alt_a10mlab sm0 (
	.wclk(wclk),
	.wena(1'b1),
	.waddr_reg(wptrg),
	.wdata_reg(wdata_reg),
	.raddr(rptrg),
	.rdata(ram_q)		
);		
defparam sm0 .WIDTH = WIDTH;
defparam sm0 .ADDR_WIDTH = 3;			
defparam sm0 .SIM_EMULATE = SIM_EMULATE;

reg [WIDTH-1:0] rdata_r = {WIDTH{1'b0}};
always @(posedge rclk) begin
	if (!rempty) rdata_r <= ram_q;
end
assign rdata = rdata_r;

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_dcfifo_mlab_tiny.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_sync_regs_m2.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Max depth :  2.0 LUTs
// BENCHMARK INFO :  Total registers : 44
// BENCHMARK INFO :  Total pins : 46
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  15                 
// BENCHMARK INFO :  ALMs : 28 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -0.050 ns, From wptrg[0], To alt_a10mlab:sm0|ml[19].lrm~reg0__nff}
