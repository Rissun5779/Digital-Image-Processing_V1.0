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


////////////////////////////////////////////////////////////////////
//
//   ALT_PFL_COUNTER
//
//  (c) Altera Corporation, 2012
//
//
//
////////////////////////////////////////////////////////////////////

//************************************************************
// Description:
//
// This module is PFL counter
//
//************************************************************
// HW need blocking, simulation need non_blocking

// synthesis VERILOG_INPUT_VERSION VERILOG_2001

module altera_pfl2_counter
(
	clock,
	sclr,
	sload,
	data,
	cnt_en,
	q
);
	parameter 	WIDTH = 8;
	parameter 	DIRECTION = "UP";
	localparam 	[0:0] BIT_CHANGE = (DIRECTION == "DOWN")? 1'b0 : 1'b1;
	
	input 	clock;
	input 	sclr;
	input 	sload;
	input 	[WIDTH-1:0] data;
	input 	cnt_en;
	output 	[WIDTH-1:0] q;
	reg 		[WIDTH-1:0] q;
	
	genvar i;
	generate
		always @ (posedge clock) begin
			if (sclr)
				q[0] = 1'b0;
			else if (sload)
				q[0] = data[0];
			else if (cnt_en)
				q[0] = ~q[0];
		end
		if (WIDTH > 1) begin
			for (i=1; i<WIDTH; i=i+1) begin: BIT_LOOP
				always @ (posedge clock) begin
					if (sclr)
						q[i] = 1'b0;
					else if (sload)
						q[i] = data[i];
					else if (cnt_en && (q[i-1:0] == {(i){BIT_CHANGE[0]}}))
						q[i] = ~q[i];
				end
			end
		end
	endgenerate
	
endmodule
	