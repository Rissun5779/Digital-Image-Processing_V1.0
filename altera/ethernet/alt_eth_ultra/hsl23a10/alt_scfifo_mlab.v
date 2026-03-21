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

// baeckler - 02-19-2012

`timescale 1ps/1ps

// DESCRIPTION
// 
// This is a single clock version of dcfifo_mlab. It is suitable for replacing smaller instances of LPM SCFIFO.
// The maximum depth is 31. The implementation follows dcfifo_mlab very closely, with the cross
// domain hardening removed.
// 
// Where possible connect the "used words" outputs to create partial full and empty signals. These can be
// pipelined and facilitate easy timing closure better than the full and empty which have tighter functional
// requirements.
// 
//  
// 
// Where possible set these parameters to 0 to improve read and write request speed.
// 
//  parameter PREVENT_OVERFLOW = 1'b1, // ignore requests that would cause overflow
// 
//  parameter PREVENT_UNDERFLOW = 1'b1, // ignore requests that would cause underflow
// 
// With prevention disabled the FIFO will wrap during an underflow or overflow, and then resume
// coherent operation from that illegally entered state.
// 



// CONFIDENCE
// This has been used successfully in multiple Altera wireline projects
// 

module alt_scfifo_mlab #(
	parameter TARGET_CHIP = 5, // 1 S4, 2 S5,
	parameter SIM_EMULATE = 1'b0,  // simulation equivalent, only for S5 right now
	parameter WIDTH = 80, // typical 20,40,60,80
	parameter PREVENT_OVERFLOW = 1'b1,	// ignore requests that would cause overflow
	parameter PREVENT_UNDERFLOW = 1'b1,	// ignore requests that would cause underflow
	parameter RAM_GROUPS = (WIDTH < 20) ? 1 : (WIDTH / 20), // min 1, WIDTH must be divisible by RAM_GROUPS
	parameter GROUP_RADDR = (WIDTH < 20) ? 1'b0 : 1'b1,  // 1 to duplicate RADDR per group as well as WADDR
	parameter FLAG_DUPES = 1, // if > 1 replicate full / empty flags for fanout balancing
	parameter ADDR_WIDTH = 5, // 4 or 5
	parameter DISABLE_USED = 1'b0	
)(
	input clk,
	input sclr,
	
	input [WIDTH-1:0] wdata,
	input wreq,
	output [FLAG_DUPES-1:0] full,	// optional duplicates for loading
	
	output [WIDTH-1:0] rdata,
	input rreq,
	output [FLAG_DUPES-1:0] empty,	// optional duplicates for loading

	output [ADDR_WIDTH-1:0] used	
);

// synthesis translate_off
initial begin
	if (WIDTH > 20 && (RAM_GROUPS * 20 != WIDTH)) begin
		$display ("Error in scfifo_mlab parameters - the physical width is a multiple of 20, this needs to match");
		$stop();
	end 
end
// synthesis translate_on


////////////////////////////////////
// rereg sclr
////////////////////////////////////

reg sclr_int = 1'b1 /* synthesis preserve */;
always @(posedge clk) begin
	sclr_int <= sclr;
end

////////////////////////////////////
// addr pointers 
////////////////////////////////////

wire winc;
wire rinc;

wire [RAM_GROUPS*ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wcntr = {ADDR_WIDTH{1'b0}} /* synthesis preserve */;
reg [ADDR_WIDTH-1:0] rcntr = {ADDR_WIDTH{1'b0}} /* synthesis preserve */;

always @(posedge clk) begin
	if (sclr_int) wcntr <= {ADDR_WIDTH{1'b0}} | 1'b1;
	else if (winc) wcntr <= wcntr + 1'b1;
	
	if (sclr_int) rcntr <= {ADDR_WIDTH{1'b0}} | (GROUP_RADDR ? 2'd2 : 2'd1);
	else if (rinc) rcntr <= rcntr + 1'b1;	
end

// optional duplication of the read address 	
generate 
	if (GROUP_RADDR) begin : gr
		reg [RAM_GROUPS*ADDR_WIDTH-1:0] rptr_r = {RAM_GROUPS{{ADDR_WIDTH{1'b0}} | 1'b1}} 
			/* synthesis preserve */;
		always @(posedge clk) begin
			if (sclr_int) rptr_r <= {RAM_GROUPS{{ADDR_WIDTH{1'b0}} | 1'b1}} ;
			else if (rinc) rptr_r <= {RAM_GROUPS{rcntr}};			
		end		
		assign rptr = rptr_r;
	end
	else begin : ngr
		assign rptr = {RAM_GROUPS{rcntr}};
	end
endgenerate

//////////////////////////////////////////////////
// adjust pointers for RAM latency
//////////////////////////////////////////////////

reg [ADDR_WIDTH-1:0] rptr_completed = {ADDR_WIDTH{1'b0}};

always @(posedge clk) begin
	if (sclr_int) begin
		rptr_completed <= {ADDR_WIDTH{1'b0}};
	end
	else begin
		if (rinc) rptr_completed <= rptr[ADDR_WIDTH-1:0];		
	end
end

reg [ADDR_WIDTH-1:0] wptr_d = {ADDR_WIDTH{1'b0}};
reg [ADDR_WIDTH-1:0] wptr_completed = {ADDR_WIDTH{1'b0}};

wire [ADDR_WIDTH-1:0] wptr_d_w = winc ? wcntr : wptr_d /* synthesis keep */;

always @(posedge clk) begin
	if (sclr_int) begin
		wptr_d <= {ADDR_WIDTH{1'b0}};
		wptr_completed <= {ADDR_WIDTH{1'b0}};		
	end
	else begin
		wptr_d <= wptr_d_w;			
		wptr_completed <= wptr_d;
	end
end

//////////////////////////////////////////////////
// compare pointers
//////////////////////////////////////////////////

genvar i;
generate
	for (i=0; i<FLAG_DUPES; i=i+1) begin : fg
		
		//assign full[i] = ~|(rptr_completed ^ wcntr); 
		//assign empty[i] = ~|(rptr_completed ^ wptr_completed);

		alt_eq_5_ena eq0 (
			.da(5'h0 | rptr_completed),
			.db(5'h0 | wcntr),
			.ena(1'b1),
			.eq(full[i])
		);
		defparam eq0 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5
		
		alt_eq_5_ena eq1 (
			.da(5'h0 | rptr_completed),
			.db(5'h0 | wptr_completed),
			.ena(1'b1),
			.eq(empty[i])
		);
		defparam eq1 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5		
		
	end
endgenerate

//////////////////////////////////////////////////
// storage array - split in addr reg groups
//////////////////////////////////////////////////

reg [ADDR_WIDTH*RAM_GROUPS-1:0] waddr_reg = {(RAM_GROUPS*ADDR_WIDTH){1'b0}} /* synthesis preserve */;
reg [WIDTH-1:0] wdata_reg = {WIDTH{1'b0}} /* synthesis preserve */;
wire [WIDTH-1:0] ram_q;
reg [WIDTH-1:0] rdata_reg = {WIDTH{1'b0}};

wire [ADDR_WIDTH-1:0] wptr_inv = wcntr ^ 1'b1;
always @(posedge clk) begin
	waddr_reg <= {RAM_GROUPS{wptr_inv}};
	wdata_reg <= wdata;
end

generate
	for (i=0; i<RAM_GROUPS;i=i+1) begin : sm
		if (TARGET_CHIP == 1) begin : tc1
			alt_s4mlab sm0 (
				.wclk(clk),
				.wena(1'b1),
				.waddr_reg(waddr_reg[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH]),
				.wdata_reg(wdata_reg[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)]),
				.raddr(rptr[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH] ^ 1'b1),
				.rdata(ram_q[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)])		
			);
			defparam sm0 .WIDTH = WIDTH / RAM_GROUPS;
			defparam sm0 .ADDR_WIDTH = ADDR_WIDTH;
		end
		else if (TARGET_CHIP == 2 || TARGET_CHIP == 0) begin : tc2
			alt_a10mlab sm0 (
				.wclk(clk),
				.wena(1'b1),
				.waddr_reg(waddr_reg[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH]),
				.wdata_reg(wdata_reg[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)]),
				.raddr(rptr[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH] ^ 1'b1),
				.rdata(ram_q[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)])		
			);		
			defparam sm0 .WIDTH = WIDTH / RAM_GROUPS;
			defparam sm0 .ADDR_WIDTH = ADDR_WIDTH;
			defparam sm0 .SIM_EMULATE = SIM_EMULATE;
		end
		else if (TARGET_CHIP == 5) begin : tc5
			alt_a10mlab sm0 (
				.wclk(clk),
				.wena(1'b1),
				.waddr_reg(waddr_reg[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH]),
				.wdata_reg(wdata_reg[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)]),
				.raddr(rptr[((i+1)*ADDR_WIDTH)-1:i*ADDR_WIDTH] ^ 1'b1),
				.rdata(ram_q[(i+1)*(WIDTH/RAM_GROUPS)-1:i*(WIDTH/RAM_GROUPS)])		
			);		
			defparam sm0 .WIDTH = WIDTH / RAM_GROUPS;
			defparam sm0 .ADDR_WIDTH = ADDR_WIDTH;
			defparam sm0 .SIM_EMULATE = SIM_EMULATE;
		end
		else begin : tc66
			// synthesis translate_off
			initial begin
				$display ("Error - Unsure how to make mlab cells for this target chip");
				$stop();				
			end
			// synthesis translate_on
		end
	end
endgenerate

// output reg - don't defeat clock enable (?) Works really well on S5
wire [WIDTH-1:0] rdata_mx = rinc ? ram_q: rdata_reg ;		
always @(posedge clk) begin
	rdata_reg <= rdata_mx;
end
assign rdata = rdata_reg;

//////////////////////////////////////////////////
// used words
//////////////////////////////////////////////////

generate
	if (DISABLE_USED) begin : nwu
		assign used = {ADDR_WIDTH{1'b0}};
	end
	else begin : wu
		reg [ADDR_WIDTH-1:0] used_r = {ADDR_WIDTH{1'b0}} /* synthesis preserve */;
		always @(posedge clk) begin
			used_r <= wptr_completed - rptr_completed;
		end
		assign used = used_r;
	end
endgenerate

////////////////////////////////////
// qualified requests
////////////////////////////////////

//wire winc = wreq & (~full[0] | ~PREVENT_OVERFLOW);
//wire rinc = rreq & (~empty[0] | ~PREVENT_UNDERFLOW);

generate
	if (PREVENT_OVERFLOW) begin
		alt_neq_5_ena eq2 (
			.da(5'h0 | rptr_completed),
			.db(5'h0 | wcntr),
			.ena(wreq),
			.eq(winc)
		);
		defparam eq2 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5
	end
	else assign winc = wreq;
endgenerate
	
generate 
	if (PREVENT_UNDERFLOW) begin
		alt_neq_5_ena eq3 (
			.da(5'h0 | rptr_completed),
			.db(5'h0 | wptr_completed),
			.ena(rreq),
			.eq(rinc)
		);
		defparam eq3 .TARGET_CHIP = TARGET_CHIP;   // 0 generic, 1 S4, 2 S5		
	end
	else assign rinc = rreq;
endgenerate

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_5_ena.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_neq_5_ena.v
// BENCHMARK INFO :  Max depth :  3.0 LUTs
// BENCHMARK INFO :  Total registers : 231
// BENCHMARK INFO :  Total pins : 171
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  37                 
// BENCHMARK INFO :  ALMs : 87 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -0.066 ns, From waddr_reg[13], To alt_a10mlab:sm[2].tc5.sm0|ml[19].lrm~reg1}
