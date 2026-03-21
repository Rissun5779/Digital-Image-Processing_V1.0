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

// baeckler 01-07-2012

`timescale 1ps/1ps

// DESCRIPTION
// 
// A Serif slave implements a 256 word page of the master's memory map. The page number parameter
// indicates the most significant 8 bits of address for this page in the master's memory map. I slave is
// relatively cheap, about 100 registers.
// 
// By convention Serif slave pages should start with the following pattern, to allow automatic software
// recognition and test.
// 
// 8'h0 : ss0_rdata <= 32'h02182012; // date stamp mm-dd-yyyy
// 8'h1 : ss0_rdata <= 32'h0 | scratch; // 32 bit scratch register
// 8'h2 : ss0_rdata <= 32'h0 | my_name[8*12-1:8*8]; // 12 byte ASCII name
// 8'h3 : ss0_rdata <= 32'h0 | my_name[8*8-1:8*4];
// 8'h4 : ss0_rdata <= 32'h0 | my_name[8*4-1:0];
// 



// CONFIDENCE
// This has been used successfully in numerous hardware test and demo designs
// 

module alt_serif_slave #(
	parameter ADDR_PAGE = 8'h1,
	parameter TARGET_CHIP = 5
)(
	input clk,
	input din,
	output dout,
	
	output reg wr,
	output reg rd,
	output reg [7:0] addr,
	output reg [31:0] wdata,
	input [31:0] rdata,
	input rdata_valid	
);


////////////////////////////////////////////
// bit to byte interface

wire [7:0] rx_byte;
wire rx_byte_valid;

reg [7:0] tx_byte = 8'h0;
reg tx_byte_valid = 1'b0;
wire tx_byte_ack;

alt_serif_tap stp (
	.clk(clk),
	.din(din),
	.dout(dout),
	
	.rx_byte(rx_byte),
	.rx_byte_valid(rx_byte_valid),
	
	.tx_byte_valid(tx_byte_valid),
	.tx_byte(tx_byte),
	.tx_byte_ack(tx_byte_ack)
);

////////////////////////////////////////////
// watch for rx activity

wire recent_rx;
alt_grace_period_64 gp0 (
	.clk(clk),
	.start_grace(rx_byte_valid),
	.grace(recent_rx)
);
defparam gp0 .TARGET_CHIP = TARGET_CHIP;


////////////////////////////////////////////
// stream bytes to do 32 bit read + write

localparam 
	ST_IDLE = 4'h0,
	ST_ADDR = 4'h1,
	ST_OPCODE = 4'h2,
	ST_WDATA = 4'h3,
	ST_WDATA2 = 4'h4,
	ST_WDATA3 = 4'h5,
	ST_WDATA4 = 4'h6,
	ST_READ = 4'h7,
	ST_READ2 = 4'h8,
	ST_REPLY = 4'h9,
	ST_REPLY2 = 4'ha,
	ST_REPLY3 = 4'hb,
	ST_REPLY4 = 4'hc,
	ST_FINISH = 4'hd,
	ST_WRITE = 4'he,
	ST_ERROR = 4'hf;
	

reg [3:0] st = 4'h0 /* synthesis preserve */;

reg [7:0] select_page = 8'h0;
reg [31:0] rdata_r = 32'h0;
reg page_match = 1'b0;
reg legal_op = 1'b0;
reg check_opcode = 1'b0;

initial addr = 8'h0;
initial wdata = 32'h0;

always @(posedge clk) begin
	
	rd <= 1'b0;
	wr <= 1'b0;
	page_match <= (select_page == ADDR_PAGE[7:0]);
	legal_op <= (rx_byte[7:0] == 8'h55) || (rx_byte[7:0] == 8'hcc);
	check_opcode <= 1'b0;
	
	case (st) 
		ST_IDLE : begin
			tx_byte_valid <= 1'b0;
			if (rx_byte_valid) begin
				select_page <= rx_byte;
				st <= ST_ADDR;
			end
		end
		ST_ADDR : begin
			if (rx_byte_valid) begin
				addr <= rx_byte;
				st <= ST_OPCODE;
			end
		end
		ST_OPCODE : begin
			if (rx_byte_valid) begin
				// guess opcode - double check in next state
				check_opcode <= 1'b1;
				if (!rx_byte[7]) begin
					st <= ST_WDATA;
				end
				else begin
					st <= ST_READ;
				end				
			end
		end
		ST_WDATA : begin
			if (rx_byte_valid) begin
				wdata <= {wdata[23:0],rx_byte};
				st <= ST_WDATA2;
			end			
			if (check_opcode && !legal_op) st <= ST_ERROR;			
		end
		ST_WDATA2 : begin
			if (rx_byte_valid) begin
				wdata <= {wdata[23:0],rx_byte};
				st <= ST_WDATA3;
			end					
		end
		ST_WDATA3 : begin
			if (rx_byte_valid) begin
				wdata <= {wdata[23:0],rx_byte};
				st <= ST_WDATA4;
			end						
		end
		ST_WDATA4 : begin
			if (rx_byte_valid) begin
				wdata <= {wdata[23:0],rx_byte};
				st <= ST_WRITE;
			end						
		end
		ST_READ : begin
			if (page_match) begin
				rd <= 1'b1;
				st <= ST_READ2;
			end
			else begin
				st <= ST_IDLE;
			end
			if (check_opcode && !legal_op) st <= ST_ERROR;			
		end
		ST_READ2 : begin
			if (rdata_valid) begin
				rdata_r <= rdata;
				st <= ST_REPLY;
			end			
		end
		ST_REPLY : begin
			tx_byte <= rdata_r[31:24];
			rdata_r <= rdata_r << 8;
			tx_byte_valid <= 1'b1;
			st <= ST_REPLY2;
		end
		ST_REPLY2 : begin
			if (tx_byte_ack) begin
				tx_byte <= rdata_r[31:24];
				rdata_r <= rdata_r << 8;
				st <= ST_REPLY3;
			end
		end
		ST_REPLY3 : begin
			if (tx_byte_ack) begin
				tx_byte <= rdata_r[31:24];
				rdata_r <= rdata_r << 8;
				st <= ST_REPLY4;
			end
		end
		ST_REPLY4 : begin
			if (tx_byte_ack) begin
				tx_byte <= rdata_r[31:24];
				rdata_r <= rdata_r << 8;
				st <= ST_FINISH;
			end
		end
		ST_FINISH : begin
			if (tx_byte_ack) begin
				st <= ST_IDLE;
				tx_byte_valid <= 1'b0;
			end
		end
		ST_WRITE : begin
			if (page_match) begin
				wr <= 1'b1;
			end
			st <= ST_IDLE;
		end				
		ST_ERROR : begin
			if (!recent_rx) st <= ST_IDLE;
		end		
	endcase
end


endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_serif_slave.v
// BENCHMARK INFO :  Uses helper file :  alt_serif_tap.v
// BENCHMARK INFO :  Uses helper file :  alt_grace_period_64.v
// BENCHMARK INFO :  Max depth :  2.0 LUTs
// BENCHMARK INFO :  Total registers : 129
// BENCHMARK INFO :  Total pins : 78
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  86                 
// BENCHMARK INFO :  ALMs : 67 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.776 ns, From st[2], To rdata_r[7]}
