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

// baeckler - 03-12-2014

// DESCRIPTION
// Experimental heavily pipelined single clock FIFO.
// 

// CONFIDENCE
// This block is brand new and hasn't been used in a real system yet.

module alt_scfifo_mlab_hp #(
	parameter TARGET_CHIP = 5,
	parameter WIDTH = 80,  // less than 20 otherwise a multiple of 20
	parameter RAM_BLOCK_WIDTH = (WIDTH < 20) ? WIDTH : 20,
	parameter RAM_GROUPS = (WIDTH < 20) ? 1 : (WIDTH / 20),
	parameter SIM_EMULATE = 1'b0   // this may not be exactly the same at the fine grain timing level 
)(
	input clk,
	input sclr,
		
	input wreq,
	input [WIDTH-1:0] wdata,
	output wfull,					
	
	input rreq,						// request latency is 2
	output [WIDTH-1:0] rdata,
	output rempty			
);

/////////////////////////////////
// simulation error check
// synthesis translate_off
initial begin
	if ((RAM_BLOCK_WIDTH * RAM_GROUPS) != WIDTH) begin
		#1
		$display ("Illegal width setting in %m");
		$stop();
	end
end
// synthesis translate_on
/////////////////////////////////


reg ram_read = 1'b0;
always @(posedge clk) ram_read <= rreq && !rempty;

reg ram_write = 1'b0;
always @(posedge clk) ram_write <= wreq && !wfull;

reg sclr_r = 1'b0;
reg last_sclr = 1'b0;
always @(posedge clk) begin
	last_sclr <= sclr;
	sclr_r <= sclr | last_sclr;
end

/////////////////////////////////
// addr pointers

reg [4:0] raddr = 5'h1 /* synthesis preserve dont_replicate */;
always @(posedge clk) begin
	if (sclr_r) begin
		raddr <= 5'h1;
	end
	else begin
		if (ram_read) begin
			raddr <= raddr + 1'b1;
		end
	end
end

reg [4:0] waddr = 5'h0 /* synthesis preserve dont_replicate */;
always @(posedge clk) begin
	if (sclr_r) begin
		waddr <= 5'h0;
	end
	else begin
		if (ram_write) begin
			waddr <= waddr + 1'b1;
		end
	end
end

// this will be raddr - 1, mirrors the duplicated RAM addr regs
reg [4:0] serving_raddr = 5'h0 /* synthesis preserve */;
always @(posedge clk) begin
	if (sclr_r) serving_raddr <= 5'h0;
	else if (ram_read) serving_raddr <= raddr;
end

// number of used words, slightly stale
reg [4:0] ram_usedw = 5'h0;
always @(posedge clk) begin
	if (sclr_r) begin
		ram_usedw <= 5'h0;
	end
	else begin
		ram_usedw <= waddr - serving_raddr;
	end
end

/////////////////////////////////
// flags

reg rempty_r = 1'b0;
reg recent_read = 1'b0;

wire ram_usedw_low;
alt_le_5_const lc0 (
	.clk(clk),
	.din(ram_usedw),
	.include_eq(ram_read),
	.le(ram_usedw_low)
);
defparam lc0 .TARGET_CHIP = TARGET_CHIP;
defparam lc0 .VAL = 5'h4;

reg ram_usedw_very_low = 1'b0;
always @(posedge clk) begin
	ram_usedw_very_low <= ~|ram_usedw[4:1];
end

always @(posedge clk) begin
	if (sclr_r) begin
		rempty_r <= 1'b1;
		recent_read <= 1'b0;
	end
	else begin
		rempty_r <= ram_usedw_low && 
			(recent_read || (rreq && !rempty_r) || (ram_usedw_very_low && !ram_usedw[0]));
		recent_read <= (rreq && !rempty_r) || ram_read; 
	end
end
assign rempty = rempty_r;

reg wfull_r = 1'b0;
reg recent_write = 1'b0;

wire ram_usedw_high;
alt_ge_5_const lc1 (
	.clk(clk),
	.din(ram_usedw),
	.include_eq(ram_write),
	.ge(ram_usedw_high)
);
defparam lc1 .TARGET_CHIP = TARGET_CHIP;
defparam lc1 .VAL = 5'h1b;

reg ram_usedw_super_high = 1'b0;
always @(posedge clk) begin
	ram_usedw_super_high <= &ram_usedw[4:1];
end

always @(posedge clk) begin
	if (sclr_r) begin
		wfull_r <= 1'b0;
		recent_write <= 1'b0;
	end
	else begin
		wfull_r <= ram_usedw_high &&
				(ram_usedw_super_high || recent_write || (wreq && !wfull_r));				
		recent_write <= (wreq && !wfull_r) || ram_write; 
	end
end
assign wfull = wfull_r;

/////////////////////////////////
// RAM

wire [WIDTH-1:0] ram_q;
reg [WIDTH-1:0] wdata_d = {WIDTH{1'b0}};
always @(posedge clk) begin
	wdata_d <= wdata;
end		

genvar i;
generate
	for (i=0; i<RAM_GROUPS; i=i+1) begin : rl
		// duplicates per RAM block
		reg [4:0] ram_block_waddr = 5'h0 /* synthesis preserve */;
		always @(posedge clk) begin
			ram_block_waddr <= waddr;
		end

		reg [4:0] ram_block_raddr = 5'h0 /* synthesis preserve */;
		always @(posedge clk) begin
			if (sclr_r) ram_block_raddr <= 5'h0;
			else if (ram_read) ram_block_raddr <= raddr;
		end

		reg [RAM_BLOCK_WIDTH-1:0] ram_wdata = {RAM_BLOCK_WIDTH{1'b0}};
		always @(posedge clk) begin
			ram_wdata <= wdata_d[(i+1)*RAM_BLOCK_WIDTH-1:i*RAM_BLOCK_WIDTH];
		end
		
		// storage
		alt_a10mlab mm (
			.wclk(clk),
			.wena(1'b1),
			.waddr_reg(ram_block_waddr),
			.wdata_reg(ram_wdata),
			.raddr(ram_block_raddr),
			.rdata(ram_q[(i+1)*RAM_BLOCK_WIDTH-1:i*RAM_BLOCK_WIDTH])		
		);
		defparam mm .WIDTH = RAM_BLOCK_WIDTH;
		defparam mm .ADDR_WIDTH = 5;
		defparam mm .SIM_EMULATE = SIM_EMULATE;		
	end
endgenerate

/////////////////////////////////
// output reg

reg [WIDTH-1:0] rdata_r = {WIDTH{1'b0}};
always @(posedge clk) begin
	if (ram_read) rdata_r <= ram_q;
end
assign rdata = rdata_r;

endmodule
// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_mlab_hp.v
// BENCHMARK INFO :  Uses helper file :  alt_le_5_const.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_ge_5_const.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Max depth :  1.4 LUTs
// BENCHMARK INFO :  Total registers : 312
// BENCHMARK INFO :  Total pins : 166
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  28                 
// BENCHMARK INFO :  ALMs : 105 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -0.025 ns, From rl[2].ram_block_waddr[0], To alt_a10mlab:rl[2].mm|ml[19].lrm~reg1}
