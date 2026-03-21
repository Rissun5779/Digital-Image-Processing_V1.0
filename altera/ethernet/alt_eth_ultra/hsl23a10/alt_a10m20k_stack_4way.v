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

`timescale 1 ps / 1 ps
// baeckler - 04-30-2013

// DESCRIPTION
// 
// This is a 4 channel time division multiplexed stack (LIFO) intended for use by the stacker_3 processor.
// The memory is in ECC mode with extra pipeline enabled. The errors are consolidated to a sticky flag.
// Each channel gets a quarter of the memory space, which works out to 128 words of 32 bits for one
// M20K. The stacker only uses 16 of the bits, but ECC mode requires 32 bit storage width.
// 


module alt_a10m20k_stack_4way #(
	parameter ADDR = 9, // 9 is natural for ECC M20k
	parameter WIDTH = 32 // this is required by the ECC RAM
)(
	input clk,
	input sclr,
	input [WIDTH-1:0] din,
	input push,
	input pop,
	output [WIDTH-1:0] dout,
	
	// ecc flags
	output sticky_err,
    input sclr_err
);

reg [ADDR-1:0] raddr0 = {2'b10,{(ADDR-2){1'b0}}};
reg [ADDR-1:0] raddr1 = {2'b11,{(ADDR-2){1'b0}}};
reg [ADDR-1:0] raddr2 = {2'b00,{(ADDR-2){1'b0}}};
reg [ADDR-1:0] raddr3 = {2'b01,{(ADDR-2){1'b0}}};

reg [ADDR-1:0] waddr = {2'b00,{(ADDR-2){1'b0}}} | 1'b1;

always @(posedge clk) begin
	if (sclr) begin
		raddr0 <= {2'b10,{(ADDR-2){1'b0}}};
		raddr1 <= {2'b11,{(ADDR-2){1'b0}}};
		raddr2 <= {2'b00,{(ADDR-2){1'b0}}};
		raddr3 <= {2'b01,{(ADDR-2){1'b0}}};

		waddr <= {2'b00,{(ADDR-2){1'b0}}} | 1'b1;
	
	end
	else begin
		raddr3 <= raddr0;	
		raddr2 <= raddr3;
		raddr1 <= raddr2 + (push | {ADDR{pop}});
		raddr0 <= raddr1;	
		
		// waddr needs to equal raddr2 + 1, get it a cycle early
		waddr <= raddr3 + 1'b1;
	end
end

wire err,uncor;
altsyncram   br (
			.address_a (waddr),
			.clock0 (clk),
			.data_a (din),
			.wren_a (push),
			.address_b (raddr1), // 0 for plain, 1 for ecc
			.q_b (dout),
			.aclr0 (1'b0),
			.aclr1 (1'b0),
			.addressstall_a (1'b0),
			.addressstall_b (1'b0),
			.byteena_a (1'b1),
			.byteena_b (1'b1),
			.clock1 (1'b1),
			.clocken0 (1'b1),
			.clocken1 (1'b1),
			.clocken2 (1'b1),
			.clocken3 (1'b1),
			.data_b ({WIDTH{1'b1}}),
			.eccstatus ({err,uncor}),
			.q_a (),
			.rden_a (1'b1),
			.rden_b (1'b1),
			.wren_b (1'b0));
defparam
	br.address_aclr_b = "NONE",
	br.address_reg_b = "CLOCK0",
	br.clock_enable_input_a = "BYPASS",
	br.clock_enable_input_b = "BYPASS",
	br.clock_enable_output_b = "BYPASS",
	
	br.enable_ecc = "TRUE",
	br.ecc_pipeline_stage_enabled = "TRUE",
	br.width_eccstatus = 2,
	
	br.intended_device_family = "Stratix V",
	br.lpm_type = "altsyncram",
	br.numwords_a = 1 << ADDR,
	br.numwords_b = 1 << ADDR,
	br.operation_mode = "DUAL_PORT",
	br.outdata_aclr_b = "NONE",
	br.outdata_reg_b = "CLOCK0",
	br.power_up_uninitialized = "FALSE",
	br.ram_block_type = "M20K",
	br.read_during_write_mode_mixed_ports = "DONT_CARE",
	br.widthad_a = ADDR,
	br.widthad_b = ADDR,
	br.width_a = WIDTH,
	br.width_b = WIDTH,
	br.width_byteena_a = 1;


reg sticky_err_r = 1'b0 /* synthesis preserve */;
always @(posedge clk) begin
    if (sclr_err) sticky_err_r <= 1'b0;
    else if (err || uncor) sticky_err_r <= 1'b1;
end
assign sticky_err = sticky_err_r;

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_a10m20k_stack_4way.v
// BENCHMARK INFO :  Max depth :  2.8 LUTs
// BENCHMARK INFO :  Total registers : 46
// BENCHMARK INFO :  Total pins : 70
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 16,384
// BENCHMARK INFO :  Comb ALUTs :  29                  
// BENCHMARK INFO :  ALMs : 19 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.012 ns, From raddr2[1], To raddr1[7]}
