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


`timescale 1 ps / 1 ps
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
// take in avalon, drive slaves around serial ring

// DESCRIPTION
// 
// Serif is a simple serial interface for moving an Avalon MM bus around with within FPGA. It addresses a
// problem observed in the 100G cores which is that the 32 bit standard Avalon bus used for statistics is
// routing 32 bit signals to and from far flung locations. None of the accesses are critical, however they are
// consuming significant long wire in a way that interferes with the datapath. The strategy here is to
// cheaply serialize and deserialize the Avalon control and status bus to do long distance hops with single
// wires in return for lower bandwidth.
// 
// The serif_master takes a 32 bit data 16 bit address Avalon Memory Mapped bus on one side and offers a
// 2 wire serial interface to up to 256 slaves, addressable by 8 bit page number. The serial lines idle at the 1
// level and are not latency sensitive. Combine slave serial outputs with AND gates. Register any of the
// serial signals freely.
// 
//  



// CONFIDENCE
// This has been used successfully in numerous hardware test and demo designs
// 

module alt_serif_master #(
	parameter READ_TIMEOUT = 8
)(
	input clk,
	input din,
	output dout,
	
	output reg busy,
	output reg read_timeout,
	input wr,
	input rd,
	input [15:0] addr,
	input [31:0] wdata,
	output reg [31:0] rdata,
	output reg rdata_valid	
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
// stream bytes to do 32 bit read + write

localparam 
	ST_IDLE = 4'h0,
	ST_ADDR = 4'h1,
	ST_ADDR2 = 4'h2,
	ST_ADDR3 = 4'h3,
	ST_WDATA = 4'h4,
	ST_WDATA2 = 4'h5,
	ST_WDATA3 = 4'h6,
	ST_WDATA4 = 4'h7,
	ST_FINISH = 4'h8,
	ST_READ = 4'h9,
	ST_READ2 = 4'ha,
	ST_READ3 = 4'hb,
	ST_READ4 = 4'hc,
	ST_READ_TIMEOUT = 4'hd;
	

reg [3:0] st = 4'h0 /* synthesis preserve */;

reg [15:0] addr_r = 16'h0;
reg [31:0] wdata_r = 16'h0;
reg wr_r = 1'b0;
reg expecting_rx = 1'b0;
wire read_expired;

always @(posedge clk) begin
	expecting_rx <= 1'b0;
	rdata_valid <= 1'b0;
	read_timeout <= 1'b0;
	
	case (st) 
		ST_IDLE : begin
			tx_byte_valid <= 1'b0;
			busy <= 1'b0;
			if (rd || wr) begin
				busy <= 1'b1;
				addr_r <= addr;
				wdata_r <= wdata;
				wr_r <= wr;
				st <= ST_ADDR;
			end	
		end
		ST_ADDR : begin
			tx_byte <= addr_r[15:8];
			addr_r [15:8] <= addr_r[7:0];
			tx_byte_valid <= 1'b1;
			st <= ST_ADDR2;						
		end
		ST_ADDR2 : begin
			if (tx_byte_ack) begin
				tx_byte <= addr_r[15:8];
				st <= ST_ADDR3;
			end
		end
		ST_ADDR3 : begin
			if (tx_byte_ack) begin
				if (wr_r) begin
					tx_byte <= 8'h55;
					st <= ST_WDATA;
				end
				else begin
					tx_byte <= 8'hcc;
					st <= ST_READ;
				end
			end
		end
		ST_WDATA : begin
			if (tx_byte_ack) begin
				tx_byte <= wdata_r[31:24];
				wdata_r <= wdata_r << 8;
				st <= ST_WDATA2;
			end			
		end
		ST_WDATA2 : begin
			if (tx_byte_ack) begin
				tx_byte <= wdata_r[31:24];
				wdata_r <= wdata_r << 8;
				st <= ST_WDATA3;
			end			
		end
		ST_WDATA3 : begin
			if (tx_byte_ack) begin
				tx_byte <= wdata_r[31:24];
				wdata_r <= wdata_r << 8;
				st <= ST_WDATA4;
			end			
		end
		ST_WDATA4 : begin
			if (tx_byte_ack) begin
				tx_byte <= wdata_r[31:24];
				wdata_r <= wdata_r << 8;
				st <= ST_FINISH;
			end			
		end
		ST_FINISH : begin
			if (tx_byte_ack) st <= ST_IDLE;
		end
		ST_READ : begin
			expecting_rx <= 1'b1;
			if (tx_byte_ack) tx_byte_valid <= 1'b0;
			if (rx_byte_valid) begin
				rdata <= {rdata [23:0],rx_byte};
				st <= ST_READ2;
			end
		end
		ST_READ2 : begin
			expecting_rx <= 1'b1;
			if (rx_byte_valid) begin
				rdata <= {rdata [23:0],rx_byte};
				st <= ST_READ3;
			end
		end
		ST_READ3 : begin
			expecting_rx <= 1'b1;
			if (rx_byte_valid) begin
				rdata <= {rdata [23:0],rx_byte};
				st <= ST_READ4;
			end
		end
		ST_READ4 : begin
			expecting_rx <= 1'b1;
			if (rx_byte_valid) begin
				rdata <= {rdata [23:0],rx_byte};
				st <= ST_IDLE;
				rdata_valid <= 1'b1;
			end
		end		
		ST_READ_TIMEOUT : begin
			read_timeout <= 1'b1;
			st <= ST_IDLE;
		end
	endcase
	
	
	if (read_expired) st <= ST_READ_TIMEOUT;
	
end

////////////////////////////////////////////
// make sure slave reads don't wait forever

alt_watchdog_timer wd (
	.clk(clk),
	.srst(!expecting_rx || rx_byte_valid),
	.expired(read_expired)
);
defparam wd .CNTR_BITS = READ_TIMEOUT;


endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_serif_master.v
// BENCHMARK INFO :  Uses helper file :  alt_serif_tap.v
// BENCHMARK INFO :  Uses helper file :  alt_watchdog_timer.v
// BENCHMARK INFO :  Max depth :  2.8 LUTs
// BENCHMARK INFO :  Total registers : 131
// BENCHMARK INFO :  Total pins : 88
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  78                 
// BENCHMARK INFO :  ALMs : 65 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.571 ns, From st[1]~DUPLICATE, To rdata[30]~reg0}
