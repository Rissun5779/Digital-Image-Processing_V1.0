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
// serif slave port on a different clock domain from the serial line
// Note : if Bclk is more than 9x the period of sclk the buffering can 
//   fill during repeated writes

// DESCRIPTION
// 
// This is an asynchronous version of the serif_slave. The local Avalon bus can be on a separate clock
// domain unrelated to the master.
// 
// This corrects a problem observed in 100G development which is excessive logic consumption in the
// cross domain hardening of status and control signals. The local signals share clock domain crossing logic
// to communicate with the master at the byte stream level. The intended use model would be a lower
// speed central management clock (say 100MHz) connected to a statistics and controls on a design
// domain (say 300-400 MHz). The bus clock rate should not exceed nine times the serial clock, or the
// buffering can fill during heavy activity.
// 



// CONFIDENCE
// This has been used successfully in numerous hardware test and demo designs
// 

module alt_serif_slave_async #(
	parameter ADDR_PAGE = 8'h1,
	parameter TARGET_CHIP = 5, // 1 S4, 2 S5
	parameter MODIFY_FIFO = 1'b0  // experimental speed optimization
)(
	input aclr, // no domain
	
	input sclk, // serial domain
	input din,
	output dout,
	
	input bclk,	// avalon bus domain
	output reg wr,
	output reg rd,
	output reg [7:0] addr,
	output reg [31:0] wdata,
	input [31:0] rdata,
	input rdata_valid	
);

wire bclk_rst;
alt_aclr_filter af0 (.aclr(aclr), .clk(bclk), .aclr_sync(bclk_rst));

////////////////////////////////////////////
// bit to byte interface

wire [7:0] rx_byte_i, rx_byte;
wire rx_byte_valid_i, rx_byte_valid;

reg [7:0] tx_byte = 8'h0;
reg tx_byte_valid = 1'b0;
wire tx_byte_ack = 1'b1; // the FIFO has plenty of room to accept

wire [7:0] tx_byte_i;
wire tx_byte_valid_i;
wire tx_byte_ack_i;

alt_serif_tap stp (
	.clk(sclk),
	.din(din),
	.dout(dout),
	
	.rx_byte(rx_byte_i),
	.rx_byte_valid(rx_byte_valid_i),
	
	.tx_byte_valid(tx_byte_valid_i),
	.tx_byte(tx_byte_i),
	.tx_byte_ack(tx_byte_ack_i)
);

////////////////////////////////////////////
// cross between serial and bus

alt_cross_mlab c0 (
	.aclr(bclk_rst), // no domain
	
	.din_clk(sclk),
	.din(rx_byte_i),
	.din_valid(rx_byte_valid_i),
	
	.dout_clk(bclk),
	.dout(rx_byte),
	.dout_valid(rx_byte_valid)	
);
defparam c0 .WIDTH = 8;
defparam c0 .TARGET_CHIP = TARGET_CHIP;

generate
	if (!MODIFY_FIFO) begin
		// original		
		alt_dcfifo_mlab_ack d0 (
			.aclr(bclk_rst), // no domain
			
			.wclk(bclk),
			.wdata(tx_byte),
			.wvalid(tx_byte_valid),
			.wfull(),
			.wused(),
			
			.rclk(sclk),
			.rdata(tx_byte_i),
			.rvalid(tx_byte_valid_i),
			.rack(tx_byte_ack_i),
			.rempty(),
			.rused()
		);
		defparam d0 .WIDTH = 8;
		defparam d0 .TARGET_CHIP = TARGET_CHIP;
		defparam d0 .DISABLE_RUSED = 1'b1;
		defparam d0 .DISABLE_WUSED = 1'b1;
	end
	else begin
		// likely faster, not as well tested
		alt_dcfifo_mlab_ack2 d0 (
			.aclr(bclk_rst), // no domain
			
			.wclk(bclk),
			.wdata(tx_byte),
			.wdata_valid(tx_byte_valid),
			
			.rclk(sclk),
			.rdata(tx_byte_i),
			.rdata_valid(tx_byte_valid_i),
			.rdata_ack(tx_byte_ack_i)	
		);
		defparam d0 .WIDTH = 8;
		defparam d0 .TARGET_CHIP = TARGET_CHIP;
	end
endgenerate

////////////////////////////////////////////
// it should frequently return to the idle state

wire hang_alarm;
reg idling = 1'b0;

alt_watchdog_timer wd (
	.clk(bclk),
	.srst(idling),
	.expired(hang_alarm)
);
defparam wd .PRESCALE = 1'b1;
defparam wd .CNTR_BITS = 8;

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
	ST_READ2 = 4'h7,
	ST_REPLY = 4'h8,
	ST_REPLY2 = 4'h9,
	ST_REPLY3 = 4'ha,
	ST_REPLY4 = 4'hb,
	ST_FINISH = 4'hc,
	ST_ERROR0 = 4'hd,
	ST_ERROR1 = 4'he,
	ST_ERROR2 = 4'hf;
	

reg [3:0] st = 4'h0 /* synthesis preserve */;

reg [7:0] select_page = 8'h0;
reg [31:0] rdata_r = 32'h0;
reg page_match = 1'b0;


always @(posedge bclk or posedge bclk_rst) begin
	if (bclk_rst) begin
		st <= ST_IDLE;
		wr <= 1'b0;
		addr <= 8'h0;
		rdata_r <= 0;
		select_page <= 8'h0;
		tx_byte <= 8'h0;
		tx_byte_valid <= 1'b0;
		wdata <= 32'h0;		
	end
	else begin
		page_match <= (select_page == ADDR_PAGE[7:0]);
		rd <= 1'b0;
		wr <= 1'b0;
		idling <= 1'b0;
			
		case (st) 
			ST_IDLE : begin
				idling <= 1'b1;
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
					if (rx_byte == 8'h55) begin
						st <= ST_WDATA;
					end
					else if (rx_byte == 8'hcc) begin
						if (page_match) begin
							rd <= 1'b1;
							st <= ST_READ2;
						end
						else begin
							st <= ST_IDLE;
						end
					end
					else begin
						st <= ST_ERROR0;
					end
				end
			end
			ST_WDATA : begin
				if (rx_byte_valid) begin
					wdata <= {wdata[23:0],rx_byte};
					st <= ST_WDATA2;
				end			
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
					if (page_match) begin
						wr <= 1'b1;
					end
					st <= ST_IDLE;			
				end						
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
			ST_ERROR0 : begin
				st <= ST_ERROR1;
			end		
			ST_ERROR1 : begin
				st <= ST_ERROR2;
			end		
			ST_ERROR2 : begin
				st <= ST_IDLE;
			end		
		endcase	
		if (hang_alarm) st <= ST_IDLE;
	end	
end

endmodule



// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_serif_slave_async.v
// BENCHMARK INFO :  Uses helper file :  alt_aclr_filter.v
// BENCHMARK INFO :  Uses helper file :  alt_serif_tap.v
// BENCHMARK INFO :  Uses helper file :  alt_cross_mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_gray_cntr_4.v
// BENCHMARK INFO :  Uses helper file :  alt_sync_regs_m2.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_dcfifo_mlab_ack.v
// BENCHMARK INFO :  Uses helper file :  alt_gray_cntr_5_sl.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_sync_regs_aclr_m2.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_5_ena.v
// BENCHMARK INFO :  Uses helper file :  alt_neq_5_ena.v
// BENCHMARK INFO :  Uses helper file :  alt_watchdog_timer.v
// BENCHMARK INFO :  Max depth :  3.0 LUTs
// BENCHMARK INFO :  Total registers : 279
// BENCHMARK INFO :  Total pins : 80
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  126                
// BENCHMARK INFO :  ALMs : 130 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -0.447 ns, From alt_cross_mlab:c0|waddr_reg[2], To alt_cross_mlab:c0|alt_a10mlab:tc10.sm|ml[7].lrm~reg1}
