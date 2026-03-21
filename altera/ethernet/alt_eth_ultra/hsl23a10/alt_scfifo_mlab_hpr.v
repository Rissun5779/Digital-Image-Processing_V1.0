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

// baeckler - 03-20-2014

// DESCRIPTION
// Experimental heavily pipelined single clock FIFO.
// Fitted with output side adapter to change the request latency from 2 to 1

// CONFIDENCE
// This block is brand new and hasn't been used in a real system yet.

module alt_scfifo_mlab_hpr #(
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
	
	input rreq,						// request latency is 1
	output [WIDTH-1:0] rdata,
	output rempty			
);

////////////////////////////////////////////////
// main event

wire rreq_i;
wire [WIDTH-1:0] rdata_i;
wire rempty_i;
	
alt_scfifo_mlab_hp sm (
	.clk(clk),
	.sclr(sclr),
	.wreq(wreq),
	.wdata(wdata),
	.wfull(wfull),
	.rreq(rreq_i),						// request latency is 2
	.rdata(rdata_i),
	.rempty(rempty_i)	
);
defparam sm .TARGET_CHIP = TARGET_CHIP;
defparam sm .WIDTH = WIDTH;
defparam sm .RAM_BLOCK_WIDTH = RAM_BLOCK_WIDTH;
defparam sm .RAM_GROUPS = RAM_GROUPS;
defparam sm .SIM_EMULATE = SIM_EMULATE;

////////////////////////////////////////////////
// hide read latency

reg flush_r = 1'b0;
reg last_sclr = 1'b0;
always @(posedge clk) begin
	last_sclr <= sclr;
	flush_r <= sclr | last_sclr;
end

alt_req2_req1 rr (
	.clk(clk),
	.flush(flush_r),
	.din(rdata_i),
	.din_empty(rempty_i),
	.din_req(rreq_i),		// request latency 2
	
	.dout(rdata),
	.dout_empty(rempty),
	.dout_req(rreq)			// request latency 1
);
defparam rr .WIDTH = WIDTH;


endmodule


// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_mlab_hpr.v
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_mlab_hp.v
// BENCHMARK INFO :  Uses helper file :  alt_le_5_const.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_ge_5_const.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_req2_req1.v
// BENCHMARK INFO :  Max depth :  2.0 LUTs
// BENCHMARK INFO :  Total registers : 480
// BENCHMARK INFO :  Total pins : 166
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  38                 
// BENCHMARK INFO :  ALMs : 170 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -0.042 ns, From alt_scfifo_mlab_hp:sm|rl[1].ram_block_waddr[0], To alt_scfifo_mlab_hp:sm|alt_a10mlab:rl[1].mm|ml[19].lrm~reg1}
