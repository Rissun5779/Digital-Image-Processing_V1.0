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

// baeckler - 05-02-2014


// DESCRIPTION
// 

module alt_scfifo_bully #(
	parameter [3:0] POLY_SEED = 4'h0,
	parameter [7:0] INIT_SEED = 8'h0,
	parameter NUM_CHAN = 32,
	parameter FTYPE = 1      // 0-none 1-mlab 2-20K
)(
	input clk,
	input sclr,
	input sclr_err,
	output [NUM_CHAN-1:0] sticky_err
);

genvar i;
generate
	for (i=0; i<NUM_CHAN; i=i+1) begin : lp0

		reg sclr_r = 1'b0 /* synthesis preserve */;
		always @(posedge clk) sclr_r <= sclr;

		reg sclr_err_r = 1'b0 /* synthesis preserve */;
		always @(posedge clk) sclr_err_r <= sclr_err;

		wire [7:0] lfq /* synthesis keep */;
		alt_lfsr_8 lg (
			.clk(clk),
			.sclr(sclr_r),
			.ena(1'b1),
			.q(lfq)
		);
		defparam lg .POLY_SEL = i[3:0] ^ POLY_SEED;
		defparam lg .INIT_VAL = (i[7:0] ^ INIT_SEED) | 1'b1;

		wire [7:0] lfq_f;

		if (FTYPE == 1) begin
			alt_scfifo_mlab sc0 (
				.clk(clk),
				.sclr(sclr_r),
				.wdata(lfq),
				.wreq(1'b1),
				.full(),	// optional duplicates for loading
			
				.rdata(lfq_f),
				.rreq(1'b1),
				.empty(),	// optional duplicates for loading
				.used()
			);
			defparam sc0 .WIDTH = 8;
		end
		else if (FTYPE == 2) begin
			
			wire [7:0] lfq_if;

			alt_scfifo_a10m20k sc1 (
				.clk(clk),
				.sclr(sclr_r),
				.data(lfq),
				.wrreq(1'b1),
				.full(),	// optional duplicates for loading
			
				.q(lfq_if),
				.rdreq(1'b1),
				.empty(),	// optional duplicates for loading
				.usedw()
			);
			defparam sc1 .WIDTH = 8;
			
			reg [7:0] lfq_if_r = 8'h0 /* synthesis preserve */;
			always @(posedge clk) begin
				lfq_if_r <= lfq_if;
			end
			
			assign lfq_f = lfq_if_r;				
		
		end
		else begin
			assign lfq_f = lfq;
		end
		
		
		reg [7:0] lfq_f_r = 8'h0 /* synthesis preserve */;
		always @(posedge clk) begin
			lfq_f_r <= lfq_f;
		end						

		wire err;
		alt_lfsr_8_check lc (	
			.clk(clk),
			.ena(1'b1),
			.seq(lfq_f_r),
			.err(err)
		);
		defparam lc .POLY_SEL = i[3:0] ^ POLY_SEED;
		
		reg err_r = 1'b0;
		always @(posedge clk) err_r <= err;
		
		reg sticky = 1'b0;
		always @(posedge clk) begin
			if (err_r) sticky <= 1'b1;
			if (sclr_err_r) sticky <= 1'b0;
		end
		
		assign sticky_err[i] = sticky;				
	end
endgenerate

endmodule