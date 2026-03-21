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

// baeckler - 03-12-2012
// unspecified width pipelined mux.
// Pads non-power-of-2 word counts with GNDs 

// DESCRIPTION
// 
// This is a variable word count LUT depth one pipelined MUX. Latency varies with word count. The Verilog
// contains simple heuristics for MUX decomposition. Simulation stops with an error message if the
// requested width requires additional rules. As a matter of simplicity the explicit word count variants
// should be used in cases where N is well known.
// 



// CONFIDENCE
// This muxing component has very little state.  Problems should be clearly visible in simulation.
// 

module alt_mx_nto1_r #(
	parameter WIDTH = 16,
	parameter SEL_WIDTH = 4,
	parameter NUM_WORDS = 1 << SEL_WIDTH
)(
	input clk,
	input [NUM_WORDS*WIDTH-1:0] din,
	input [SEL_WIDTH-1:0] sel,
	output [WIDTH-1:0] dout
);

localparam FULL_WIDTH = (1 << SEL_WIDTH) * WIDTH;
wire [FULL_WIDTH-1:0] din_pad = {FULL_WIDTH{1'b0}} | din;


generate
	if (SEL_WIDTH == 1) begin
		reg [WIDTH-1:0] dout_r = {WIDTH{1'b0}};
		wire [WIDTH-1:0] din_hi,din_lo;
		assign {din_hi,din_lo} = din_pad;
		always @(posedge clk) begin
			dout_r <= sel ? din_hi : din_lo;
		end
		assign dout = dout_r;
	end
	else if (SEL_WIDTH == 2) begin
		alt_mx4r m (.clk(clk),.din(din_pad),.sel(sel),.dout(dout));
		defparam m .WIDTH = WIDTH;
	end
	else if (SEL_WIDTH == 3) begin
		alt_mx8r m (.clk(clk),.din(din_pad),.sel(sel),.dout(dout));
		defparam m .WIDTH = WIDTH;
	end	
	else if (SEL_WIDTH == 4) begin
		alt_mx16r m (.clk(clk),.din(din_pad),.sel(sel),.dout(dout));
		defparam m .WIDTH = WIDTH;
	end
	else if (SEL_WIDTH == 5) begin
		alt_mx32r m (.clk(clk),.din(din_pad),.sel(sel),.dout(dout));
		defparam m .WIDTH = WIDTH;
	end
	else if (SEL_WIDTH == 6) begin
		alt_mx64r m (.clk(clk),.din(din_pad),.sel(sel),.dout(dout));
		defparam m .WIDTH = WIDTH;
	end
	else if (SEL_WIDTH == 8) begin
		alt_mx256r m (.clk(clk),.din(din_pad),.sel(sel),.dout(dout));
		defparam m .WIDTH = WIDTH;
	end
	else begin
		initial begin
			$display ("Ooops.  Please add a decomposition for sel = %d to mx_nto1_r",SEL_WIDTH);
			$stop();
		end
	end
endgenerate

endmodule


// BENCHMARK INFO :  10AX115R3F40I2SGES
// BENCHMARK INFO :  Quartus II 64-Bit Version 14.0.0 Internal Build 145 02/20/2014 SJ Full Version
// BENCHMARK INFO :  Uses helper file :  alt_mx_nto1_r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx16r.v
// BENCHMARK INFO :  Uses helper file :  alt_mx4r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 82
// BENCHMARK INFO :  Total pins : 277
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  81                 
// BENCHMARK INFO :  ALMs : 81 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 1.020 ns, From alt_mx16r:m|mid_sel[1], To alt_mx16r:m|alt_mx4r:m|dout_r[4]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.994 ns, From alt_mx16r:m|mid_sel[1], To alt_mx16r:m|alt_mx4r:m|dout_r[4]}
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.655 ns, From alt_mx16r:m|mid_sel[1], To alt_mx16r:m|alt_mx4r:m|dout_r[10]}
