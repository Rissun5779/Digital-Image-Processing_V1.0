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


// *********************************************************************
//
//
// dp_analog_mappings
// 
// Description
// 
// This module maps the 2-bit VOD and pre-emphasis settings from the
// DisplayPort core to the family specific settings.
//
// *********************************************************************

`timescale 1 ns / 1 ps
`default_nettype none

module dp_analog_mappings #(
	parameter DEVICE_FAMILY = "Arria 10"
)(
	input  wire [1:0]   in_vod,  
	input  wire [1:0]   in_emp, 
	output reg  [4:0]   out_vod, 
	output reg  [4:0]   out_emp
);

	// Settings are based on family
	generate begin
		case (DEVICE_FAMILY)
			"Arria 10":
			begin : a10
				always @(*)
					case (in_vod)
						2'b00 :
						begin
							out_vod = 5'd13;			//400mv
							case(in_emp) 
								2'b00 : out_emp = 5'h0; // (0db)
								2'b01 : out_emp = 5'h4; // (3.52db)
								2'b10 : out_emp = 5'h6; // (6.02db)
								2'b11 : out_emp = 5'h9; // (9.54db)
							endcase
						end
						2'b01 :
						begin
							out_vod = 5'd19;			//600mv
							case(in_emp) 
								2'b00 : out_emp = 5'h0; // (0db)
								2'b01 : out_emp = 5'h5; // (3.52db)
								2'b10 : out_emp = 5'h8; // (6.62db)
								2'b11 : out_emp = 5'h8; // Unused
							endcase
						end
						2'b10 :
						begin
							out_vod = 5'd25;			//800mv
							case(in_emp) 
								2'b00 : out_emp = 5'h0; // (0db)
								2'b01 : out_emp = 5'h8; // (3.52db)
								2'b10 : out_emp = 5'h8; // Unused
								2'b11 : out_emp = 5'h8; // Unused
							endcase
						end
						2'b11 :
						begin
							out_vod = 5'd31;			//1000mv
							case(in_emp) 
								2'b00 : out_emp = 5'h0; // (0db)
								2'b01 : out_emp = 5'h0; // Unused
								2'b10 : out_emp = 5'h0; // Unused
								2'b11 : out_emp = 5'h0; // Unused
							endcase
						end
					endcase
			end // Arria 10
		endcase
	end // generate
	endgenerate

endmodule

`default_nettype wire
