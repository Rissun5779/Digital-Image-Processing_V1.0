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

`timescale 1 ps / 1 ps
// baeckler - 03-09-2012

// DESCRIPTION
// 
// This is a wrapper for instantiating a group of M20Ks for additional width. It aggregates the ECC reporting
// and smoothly handles cases where the width is a non multiple of 32 bits.
// 


module alt_a10m20k_group #(
	parameter ADDR_WIDTH = 9,  // natural 9 
	parameter DATA_WIDTH = 72,
	parameter EXTRA_ADDR_REGS = 1'b0
)(
	input wclk,
	input wena,
	input [ADDR_WIDTH-1:0] waddr,
	input [DATA_WIDTH-1:0] wdata,
	
	input rclk,
	input [ADDR_WIDTH-1:0] raddr,
	output [DATA_WIDTH-1:0] rdata,
	output sticky_err,
	input sclr_err			
);

localparam NUM_RAMS = (DATA_WIDTH + 31) / 32;
localparam FULL_WIDTH = NUM_RAMS * 32;

wire [FULL_WIDTH-1:0] wdata_pad = {FULL_WIDTH{1'b0}} | wdata;
wire [FULL_WIDTH-1:0] rdata_pad;

// aggregate the RAM ECC flags
reg sclr_err_local = 1'b0 /* synthesis preserve */;
wire [NUM_RAMS-1:0] sticky_err_local;
reg sticky_err_r = 1'b0;
always @(posedge rclk) begin
	sclr_err_local <= sclr_err;
	sticky_err_r <= |sticky_err_local;
end
assign sticky_err = sticky_err_r;

// carve out to 32 bit sub blocks
genvar i;
generate
	for (i=0; i<NUM_RAMS; i=i+1) begin : rlp
		
		reg [ADDR_WIDTH-1:0] waddr_local /* synthesis preserve */;
		reg [ADDR_WIDTH-1:0] raddr_local /* synthesis preserve */;
		always @(posedge wclk) waddr_local <= waddr;
		always @(posedge rclk) raddr_local <= raddr;
		
		alt_a10m20k_ecc_1r1w m (
			.wclk(wclk),
			.wena(wena),
			.waddr(EXTRA_ADDR_REGS ? waddr_local : waddr),
			.wdata(wdata_pad[(i+1)*32-1:i*32]),
			
			.rclk(rclk),
			.raddr(EXTRA_ADDR_REGS ? raddr_local : raddr),
			.rdata(rdata_pad[(i+1)*32-1:i*32]),
			.sticky_err(sticky_err_local[i]),
			.sclr_err(sclr_err_local)			
		);
		defparam m .ADDR_WIDTH = ADDR_WIDTH;			
	
	end
endgenerate

assign rdata = rdata_pad [DATA_WIDTH-1:0];

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_a10m20k_group.v
// BENCHMARK INFO :  Uses helper file :  alt_a10m20k_ecc_1r1w.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 5
// BENCHMARK INFO :  Total pins : 167
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 49,152
// BENCHMARK INFO :  Comb ALUTs :  5                   
// BENCHMARK INFO :  ALMs : 3 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.704 ns, From alt_a10m20k_ecc_1r1w:rlp[0].m|altsyncram:altsyncram_component|altsyncram_vt22:auto_generated|ram_block1a0~reg1, To alt_a10m20k_ecc_1r1w:rlp[0].m|sticky_err_r}
