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

// baeckler - 01-08-2012
// cheap depth 16 clock crossing, intended to be often empty, never full

`timescale 1ps/1ps

// DESCRIPTION
// 
//  
// This is a stripped down MLAB based depth 16 dual clock FIFO that just has a valid input on the write side
// and a valid output on the read side. There is a simulation only overflow alarm. The block is suitable for
// cases when a crossing needs some degree of buffering capability, but doesn't require real FIFO control.
// 


module alt_cross_mlab #(
	parameter TARGET_CHIP = 5, // 1 S4, 2 S5
	parameter WIDTH = 10 // max speed at width is up to 20 (one lab)
)(
	input aclr, // no domain
	
	input din_clk,
	input [WIDTH-1:0] din,
	input din_valid,
	
	input dout_clk,
	output reg [WIDTH-1:0] dout,
	output reg dout_valid	
);


//////////////////////////////////////////////////
// resync aclr

wire din_aclr, dout_aclr;

alt_aclr_filter af0 (
	.aclr(aclr), // no domain
	.clk(din_clk),
	.aclr_sync(din_aclr)
);

alt_aclr_filter af1 (
	.aclr(aclr), // no domain
	.clk(dout_clk),
	.aclr_sync(dout_aclr)
);

//////////////////////////////////////////////////
// rd and wr pointers

wire [3:0] waddr, raddr;
wire rdempty;

alt_gray_cntr_4 wc (
	.clk(din_clk),
	.ena(din_valid),
	.aclr(din_aclr),
	.cntr(waddr)
);

alt_gray_cntr_4 rc (
	.clk(dout_clk),
	.ena(!rdempty),
	.aclr(dout_aclr),
	.cntr(raddr)
);

//////////////////////////////////////////
// adjust for ram latency

localparam ADDR_WIDTH = 4;
reg [ADDR_WIDTH-1:0] raddr_g_completed = {ADDR_WIDTH{1'b0}};

always @(posedge dout_clk or posedge dout_aclr) begin
	if (dout_aclr) begin
		raddr_g_completed <= {ADDR_WIDTH{1'b0}};
	end
	else begin
		if (!rdempty) raddr_g_completed <= raddr[ADDR_WIDTH-1:0];		
	end
end

reg [ADDR_WIDTH-1:0] waddr_g_d = {ADDR_WIDTH{1'b0}};
reg [ADDR_WIDTH-1:0] waddr_g_completed = {ADDR_WIDTH{1'b0}};
always @(posedge din_clk or posedge din_aclr) begin
	if (din_aclr) begin
		waddr_g_d <= {ADDR_WIDTH{1'b0}};
		waddr_g_completed <= {ADDR_WIDTH{1'b0}};		
	end
	else begin
		if (din_valid) waddr_g_d <= waddr;			
		waddr_g_completed <= waddr_g_d;
	end
end

//////////////////////////////////////////////////
// cross and compare to make rempty

wire [ADDR_WIDTH-1:0] rside_waddr_g_completed;
alt_sync_regs_m2 sr (
	.clk(dout_clk),
	.din(waddr_g_completed),
	.dout(rside_waddr_g_completed)
);
defparam sr .WIDTH = ADDR_WIDTH;

assign rdempty = (rside_waddr_g_completed == raddr_g_completed);

//////////////////////////////////////////////////
// simulation only fullness alarm

// synthesis translate_off
wire [ADDR_WIDTH-1:0] tmp_r,tmp_w;
wire [ADDR_WIDTH-1:0] tmp_diff = tmp_w - tmp_r;
alt_gray_to_bin_4 gb0 (.gray(raddr_g_completed),.bin(tmp_r));
alt_gray_to_bin_4 gb1 (.gray(waddr_g_completed),.bin(tmp_w));

always @(posedge dout_clk) begin
	if (tmp_diff > 12) begin
		$display ("Warning : cross_mlab is approaching full, holding approx %d words",tmp_diff);		
	end
end
// synthesis translate_on

//////////////////////////////////////////////////
// storage 

wire [WIDTH-1:0] ram_q;
reg [WIDTH-1:0] wdata_reg = {WIDTH{1'b0}};
reg [ADDR_WIDTH-1:0] waddr_reg = {ADDR_WIDTH{1'b0}};

always @(posedge din_clk) begin
	waddr_reg <= waddr;
	wdata_reg <= din;
end

generate
	if (TARGET_CHIP == 1) begin : tc4
		alt_s4mlab sm (
			.wclk(din_clk),
			.wena(1'b1),
			.waddr_reg(waddr_reg),
			.wdata_reg(wdata_reg),
			.raddr(raddr),
			.rdata(ram_q)		
		);
		defparam sm .WIDTH = WIDTH;
		defparam sm .ADDR_WIDTH = ADDR_WIDTH;
	end
	else if (TARGET_CHIP == 2 || TARGET_CHIP == 0) begin : tc5
		alt_a10mlab sm (
			.wclk(din_clk),
			.wena(1'b1),
			.waddr_reg(waddr_reg),
			.wdata_reg(wdata_reg),
			.raddr(raddr),
			.rdata(ram_q)		
		);
		defparam sm .WIDTH = WIDTH;
		defparam sm .ADDR_WIDTH = ADDR_WIDTH;
	end
	else if (TARGET_CHIP == 5) begin : tc10
		alt_a10mlab sm (
			.wclk(din_clk),
			.wena(1'b1),
			.waddr_reg(waddr_reg),
			.wdata_reg(wdata_reg),
			.raddr(raddr),
			.rdata(ram_q)		
		);
		defparam sm .WIDTH = WIDTH;
		defparam sm .ADDR_WIDTH = ADDR_WIDTH;
	end
	else begin : tc66
		// synthesis translate_off
		initial begin
			$display ("Error - Unsure how to make mlab cells for this target chip");
			$stop();				
		end
		// synthesis translate_on
	end			
endgenerate

//////////////////////////////////////////////////
// output regs
    
initial dout_valid = 1'b0;
initial dout = {WIDTH{1'b0}};

always @(posedge dout_clk) begin
	dout_valid <= 1'b0;
	if (!rdempty) begin 
		dout <= ram_q;
		dout_valid <= 1'b1;
	end	
end

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_cross_mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_aclr_filter.v
// BENCHMARK INFO :  Uses helper file :  alt_gray_cntr_4.v
// BENCHMARK INFO :  Uses helper file :  alt_sync_regs_m2.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Max depth :  3.0 LUTs
// BENCHMARK INFO :  Total registers : 59
// BENCHMARK INFO :  Total pins : 25
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  11                 
// BENCHMARK INFO :  ALMs : 28 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.012 ns, From alt_a10mlab:tc10.sm|ml[9].lrm~reg0, To dout[9]~reg0}
