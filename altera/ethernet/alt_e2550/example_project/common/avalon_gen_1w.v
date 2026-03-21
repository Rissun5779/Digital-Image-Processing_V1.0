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


`timescale 1ps/1ps
// altera message_off 10230
module avalon_gen_1w #(
    parameter WORDS = 1
)(
    input       clk,
    input       srst,
    input       enable,

    input read_data,
    output reg data_valid,
    output reg [63:0] data,
    output reg sop,
    output reg eop,
    output reg [2:0] empty
);

reg enable_r;
reg enable_s;
always @(posedge clk) begin
   enable_r <= enable;
   enable_s <= enable_r;
end

// Set operating mode, cycle lengths, etc.
`define TEST_CRC
//`define FULL_RACK

`ifdef TEST_CRC
localparam CYCLE_LENGTH = 24;
localparam LAST_RACK = 8;
`else
localparam CYCLE_LENGTH = 32;
localparam LAST_RACK = 14;
`endif

always @(posedge clk) begin
	if (srst) begin
		data_valid <= 1'b0;
	end else begin
		data_valid <= 1'b1;
	end
end

function [WORDS*64-1:0] build_input;
input [4:0] rack;
input [7:0] cycle;
begin
	//$display("GEN: %d",i);
`ifdef TEST_CRC
    case(rack)
	   0:       build_input = 64'h0001020304050607;
	   1:       build_input = 64'h08090a0b0c0d0e0f;
	   2:       build_input = 64'h1011121314151617;
	   3:       build_input = 64'h18191a1b1c1d1e1f;
	   4:       build_input = 64'h2021222324252627;
	   5:       build_input = 64'h28292a2b2c2d2e2f;
	   6:       build_input = 64'h3031323334353637;
	   7:       build_input = 64'h38393a3b3c3d3e3f;
	   8:       build_input = 64'h4041424344454647;
	   9:       build_input = 64'h48494a4b4c4d4e4f;
	   10:      build_input = 64'h5051525354555657;
	   11:      build_input = 64'h58595a5b5c5d5e5f;
	   12:      build_input = 64'h6061626364656667;
	   13:      build_input = 64'h68696a6b6c6d6e6f;
	   14:      build_input = 64'h6061626364656667;
	   default: build_input = 64'h78797a7b7c7d7e7f;
    endcase
`else
	build_input = {cycle, 3'h0, rack, 8'h00, 8'h55, cycle, 3'h0, rack, 8'h11, 8'haa};
`endif
end
endfunction

// Control rack number within a cycle, and the number
// of cycles (packets) that have been sent
reg [4:0] rack;
reg [7:0] cycle;
always @(posedge clk) begin
	if (srst) begin
		rack <= 0;
		cycle <= 0;
	end else if (read_data) begin
		if (rack  == CYCLE_LENGTH - 1) begin
		   rack <= 0;
		   cycle <= cycle + 8'h1;
		end else if (enable_s | (rack > 0)) begin
		   rack <= rack + 5'h1;
		   cycle <= cycle;
		end
	end
end

// Use rack number to determine control signals
always @(*) begin
	if (rack == 0) begin
			sop <= enable_s;
	end else begin
			sop <= 1'b0;
	end
	if (rack == LAST_RACK) begin
		eop <= 1'b1;
`ifdef FULL_RACK
		empty <= 'h0;
`else
   `ifdef TEST_CRC
		empty <= (7 - (cycle % 8));
   `else
		empty <= cycle;
   `endif
`endif
	end else begin
		eop <= 1'b0;
		empty <= 3'h0;
	end
	if (rack <= LAST_RACK) begin
		data <= build_input(rack, cycle);
	end else begin
		data <= 'h0;
	end
end

// Add simple protocol checker

// synthesis translate_off
wire sop_qual = sop & read_data;
wire eop_qual = eop & read_data;

reg in_packet;
always @(posedge clk) begin
   if (srst) begin
      in_packet <= 1'b0;
   end else if (sop_qual) begin
      in_packet <= 1'b1;
   end else if (eop_qual) begin
      in_packet <= 1'b0;
   end
end

wire protocol_error_i = (sop_qual & eop_qual) | (sop_qual & in_packet) | (eop_qual & ~in_packet);
reg protocol_error;
always @(posedge clk) begin
   if (srst) begin
      protocol_error <= 1'b0;
   end else begin
      protocol_error <= protocol_error_i;
   end
end

reg protocol_error_sticky;
always @(posedge clk) begin
   if (srst) begin
      protocol_error_sticky <= 1'b0;
   end else if (protocol_error) begin
      protocol_error_sticky <= 1'b1;
   end
end

// synthesis translate_on

endmodule
