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


// Copyright 2013 Altera Corporation. All rights reserved.  
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
// baeckler - 01-18-2013

// DESCRIPTION
// 

// CONFIDENCE
// This doesn't have very wide deployment.  Consider using the scfifo_mlab variant instead
// 

// This is a single clock FIFO module designed to be a drop in replacement for the Altera LPM SCFIFO
// module. It may be somewhat under pipelined compared to the other FIFO versions in the library, but
// the performance is more than adequate for 468MHz at low to medium data width on Stratix 4+ chips.
// 


module alt_scfifo_mw #(
	parameter WIDTH = 8,
	parameter ADDR_WIDTH = 11,
	parameter DEVICE = "Stratix V",					// "Stratix V", "Stratix IV"
	parameter RAM_TYPE = "M20K",					
		//	for Stratix IV : "M9K", "M144K", "LUTRAM", "AUTO"
		//  for Stratix V : "M20K", "MLAB", "AUTO"		
	parameter AF_LEVEL = ((1<<ADDR_WIDTH) / 4) * 3,	// default to 75%
	parameter AE_LEVEL = (1<<ADDR_WIDTH) / 4,		// default to 25%
	parameter OVERFLOW_CHECK = 1'b1,
	parameter UNDERFLOW_CHECK = 1'b1,
	parameter QUAL_RAM_READ = 1'b1					// disable the ram raddr when not requesting?
)(
	input clk,
	input sclr,
	input aclr,
	
	input wrreq,
	input [WIDTH-1:0] data,
	output full,
	output almost_full,
	
	input rdreq,
	output [WIDTH-1:0] q,
	output empty,
	output almost_empty,

	output [ADDR_WIDTH-1:0] usedw	
);

//////////////////////////////////////////////////////////
// overflow/underflow protection

wire qualified_write = OVERFLOW_CHECK ? (wrreq & !full) : wrreq;
wire qualified_read = UNDERFLOW_CHECK ? (rdreq & !empty) : rdreq;

//////////////////////////////////////////////////////////
// addr pointers

reg [ADDR_WIDTH+1-1:0] waddr = {(ADDR_WIDTH+1){1'b0}};
reg [ADDR_WIDTH+1-1:0] raddr = {(ADDR_WIDTH+1){1'b0}};

always @(posedge clk or posedge aclr) begin
	if (aclr) waddr <= {(ADDR_WIDTH+1){1'b0}};
	else begin
		if (sclr) waddr <= {(ADDR_WIDTH+1){1'b0}};
		else if (qualified_write) waddr <= waddr + 1'b1;
	end
end

always @(posedge clk or posedge aclr) begin
	if (aclr) raddr <= {(ADDR_WIDTH+1){1'b0}};
	else begin
		if (sclr) raddr <= {(ADDR_WIDTH+1){1'b0}};
		else if (qualified_read) raddr <= raddr + 1'b1;
	end
end

//////////////////////////////////////////////////////////
// flags

assign empty = (waddr == raddr) ? 1'b1 : 1'b0;
assign full = (waddr == (raddr ^ {1'b1,{ADDR_WIDTH{1'b0}}})) ? 1'b1 : 1'b0;
assign usedw = waddr - raddr;
assign almost_full = !(usedw < AF_LEVEL) || full;
assign almost_empty =(usedw < AE_LEVEL) && !full;

//////////////////////////////////////////////////////////
// storage

altsyncram	altsyncram_component (
				.address_a (waddr[ADDR_WIDTH-1:0]),
				.clock0 (clk),
				.data_a (data),
				.wren_a (qualified_write),
				.address_b (raddr[ADDR_WIDTH-1:0]),
				.q_b (q),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (clk),
				.clocken0 (1'b1),
				.clocken1 (QUAL_RAM_READ ? qualified_read : 1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_b ({WIDTH{1'b1}}),
				.eccstatus (),
				.q_a (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_b (1'b0));
	defparam
		altsyncram_component.address_aclr_b = "NONE",
		altsyncram_component.address_reg_b = "CLOCK1",
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_input_b = "NORMAL",
		altsyncram_component.clock_enable_output_b = "BYPASS",
		altsyncram_component.enable_ecc = "FALSE",
		altsyncram_component.intended_device_family = DEVICE,
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = (1 << ADDR_WIDTH),
		altsyncram_component.numwords_b =  (1 << ADDR_WIDTH),
		altsyncram_component.operation_mode = "DUAL_PORT",
		altsyncram_component.outdata_aclr_b = "NONE",
		altsyncram_component.outdata_reg_b = "UNREGISTERED",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.ram_block_type = RAM_TYPE,
		altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
		altsyncram_component.widthad_a = ADDR_WIDTH,
		altsyncram_component.widthad_b = ADDR_WIDTH,
		altsyncram_component.width_a = WIDTH,
		altsyncram_component.width_b = WIDTH,
		altsyncram_component.width_byteena_a = 1;

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_mw.v
// BENCHMARK INFO :  Max depth :  3.0 LUTs
// BENCHMARK INFO :  Total registers : 24
// BENCHMARK INFO :  Total pins : 36
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 16,384
// BENCHMARK INFO :  Comb ALUTs :  48                  
// BENCHMARK INFO :  ALMs : 27 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.333 ns, From waddr[8], To altsyncram:altsyncram_component|altsyncram_e932:auto_generated|ram_block1a0~reg0}
