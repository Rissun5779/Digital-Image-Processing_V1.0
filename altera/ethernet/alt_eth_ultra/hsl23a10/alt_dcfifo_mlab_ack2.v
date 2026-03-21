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

// baeckler - 03-07-2014

// DESCRIPTION
// 
// This is restricted use small MLAB FIFO with acknowledge based read.  
// 
// The read side is heavily registered, the maximum acknowledge rate is once per
//  (five?) cycles.  The acknowledge needs to be single cycle pulses, it is not OK
// to hold it asserted because the valid doesn't respond immediately, data will be
// lost.   Writes are not restricted.

// CONFIDENCE
// This block is experimental


module alt_dcfifo_mlab_ack2 #(
	parameter WIDTH = 20,
	parameter TARGET_CHIP = 5 // 1=S4, 2=S5, 5=A10
)(
	input aclr, // no domain
	
	input wclk,
	input [WIDTH-1:0] wdata,
	input wdata_valid,
	
	input rclk,
	output reg [WIDTH-1:0] rdata,
	output reg rdata_valid,
	input rdata_ack
);

reg rempty_r = 1'b1;
reg rreq_r = 1'b0;
wire [WIDTH-1:0] rdata_i;
wire rempty;

alt_dcfifo_mlab dm0 (
	.aclr(aclr), // no domain
	
	.wclk(wclk),
	.wdata(wdata),
	.wreq(wdata_valid),
	.wfull(),	// optional duplicates for loading
	.wused(),
	
	.rclk(rclk),
	.rdata(rdata_i),
	.rreq(rreq_r),
	.rempty(rempty),	// optional duplicates for loading
	.rused()	
);
defparam dm0 .WIDTH = WIDTH;
defparam dm0 .ADDR_WIDTH = 4;
defparam dm0 .TARGET_CHIP = TARGET_CHIP;

initial rdata = {WIDTH{1'b0}};
initial rdata_valid = 1'b0;

reg last_rreq_r = 1'b0;

always @(posedge rclk) begin
	rreq_r <= 1'b0;
	
	if (rdata_ack) rdata_valid <= 1'b0;
	
	rempty_r <= rempty;
	
	if (!rdata_valid && !rreq_r && !last_rreq_r && !rempty_r) begin
		rreq_r <= 1'b1;
	end	
	
	last_rreq_r <= rreq_r;
	
	if (last_rreq_r) begin
		rdata <= rdata_i;
		rdata_valid <= 1'b1;
	end			
end

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_dcfifo_mlab_ack2.v
// BENCHMARK INFO :  Uses helper file :  alt_dcfifo_mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_aclr_filter.v
// BENCHMARK INFO :  Uses helper file :  alt_gray_cntr_4_sl.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_sync_regs_aclr_m2.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_5_ena.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_gray_to_bin_4.v
// BENCHMARK INFO :  Uses helper file :  alt_neq_5_ena.v
// BENCHMARK INFO :  Max depth :  3.0 LUTs
// BENCHMARK INFO :  Total registers : 114
// BENCHMARK INFO :  Total pins : 46
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  28                 
// BENCHMARK INFO :  ALMs : 46 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.032 ns, From alt_dcfifo_mlab:dm0|waddr_reg[3], To alt_dcfifo_mlab:dm0|alt_a10mlab:sm[0].tc3.sm0|ml[19].lrm~reg0__nff}
