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


// baeckler - 06-04-2013

`timescale 1ps/1ps

// DESCRIPTION
// 
// This is a MLAB based SCFIFO configured for a natural Ethernet / Interlaken word buffer with strong
// parity checking. The native width is 80 bits. There are 3 parity bits per 17 data bits which works out
// well for the 20 bit wide MLAB data. This produces an effective data word width of 68 bits.
// 


module alt_scfifo_wp #(
	parameter TARGET_CHIP = 5, // 1 S4, 2 S5,
	parameter DISABLE_USED = 1'b0	
)(
	input clk,
	input sclr,
	
	input [67:0] wdata,
	input wreq,
	output full,
	
	output [67:0] rdata,
	input rreq,
	output empty,

	output [4:0] used,
	
	input sclr_err,
	output reg sticky_err
);

genvar i;

//////////////////////////////////////////////////////////////////////
// insert 3 parity bits on every 17 data bits, to make words of 20
// 68 data -> 80 for storage, good localized wiring pattern

wire [79:0] wdata_p;
generate 
	for (i=0; i<4; i=i+1) begin : pl
		wire [20:0] local_wdata;
		
		// this is 18:21, lose one bit off the top
		alt_ins_parity_6 ip (
			.din({1'b0,wdata[(i+1)*17-1:i*17]}),
			.dout(local_wdata)
		);
		defparam ip .BLOCKS = 3;
		assign wdata_p[(i+1)*20-1:i*20] = local_wdata[19:0];
	end
endgenerate

//////////////////////////////////////////////////////////////////////

wire [79:0] rdata_p;
alt_scfifo_mlab sc (
	.clk(clk),
	.sclr(sclr),
	
	.wdata(wdata_p),
	.wreq(wreq),
	.full(full),	// optional duplicates for loading
	
	.rdata(rdata_p),
	.rreq(rreq),
	.empty(empty),	// optional duplicates for loading

	.used(used)	
);
defparam sc .TARGET_CHIP = TARGET_CHIP; // 1 S4, 2 S5
defparam sc .WIDTH = 80;

//////////////////////////////////////////////////////////////////////
// separate the data wires, and recheck the parity

reg sclr_err_r =  1'b0 /* synthesis preserve */;
always @(posedge clk) sclr_err_r <= sclr_err;

wire [3:0] sticky_err_sub;
generate 
	for (i=0; i<4; i=i+1) begin : pc
		wire [19:0] local_rdata_p;
		wire [17:0] local_recover;
		
		assign local_rdata_p = rdata_p[(i+1)*20-1:i*20];
			
		// this is 21:18, lose one bit off the top
		alt_chk_parity_6 cp (
			.clk(clk),
			.din({1'b0,local_rdata_p}),
			.dout(local_recover),
			.sclr_err(sclr_err_r),
			.sticky_err(sticky_err_sub[i])
		);
		defparam cp .BLOCKS = 3;
		defparam cp .TARGET_CHIP = TARGET_CHIP;
		
		assign rdata[(i+1)*17-1:i*17] = local_recover[16:0];		
	end
endgenerate

initial sticky_err = 1'b0;
always @(posedge clk) begin
	sticky_err <= |sticky_err_sub;
end

endmodule

// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 160 03/13/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_wp.v
// BENCHMARK INFO :  Uses helper file :  alt_ins_parity_6.v
// BENCHMARK INFO :  Uses helper file :  alt_xor_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_wys_lut.v
// BENCHMARK INFO :  Uses helper file :  alt_scfifo_mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_5_ena.v
// BENCHMARK INFO :  Uses helper file :  alt_a10mlab.v
// BENCHMARK INFO :  Uses helper file :  alt_neq_5_ena.v
// BENCHMARK INFO :  Uses helper file :  alt_chk_parity_6.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_n.v
// BENCHMARK INFO :  Uses helper file :  alt_eq_3.v
// BENCHMARK INFO :  Max depth :  3.0 LUTs
// BENCHMARK INFO :  Total registers : 265
// BENCHMARK INFO :  Total pins : 149
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  70                 
// BENCHMARK INFO :  ALMs : 106 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : -0.101 ns, From alt_scfifo_mlab:sc|waddr_reg[12], To alt_scfifo_mlab:sc|alt_a10mlab:sm[2].tc5.sm0|ml[14].lrm~reg1}
