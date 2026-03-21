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


// Copyright 2009 Altera Corporation. All rights reserved.  
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

module altera_pfl2_cfg_ready_synchronizer #(
	parameter DATA_WIDTH = 32,
	parameter STAGES = 2 // should not be less than 2
)
(
	
		input  wire        clk,       //   clk.clk
		input  wire        reset_n,   // reset.reset_n
		input  wire [DATA_WIDTH-1:0] in_data,   //    in.data
		input  wire        in_valid,  //      .valid
		output wire        in_ready,  //      .ready
		output wire [DATA_WIDTH-1:0] out_data,  //   out.data
		output wire        out_valid, //      .valid
		input  wire        out_ready  //      .ready	
);


// capture registers
reg [STAGES-1:0] c /* synthesis preserve */;
always @(posedge clk or negedge reset_n) begin
	if (~reset_n) c <= 0;
	else c <= {c[(STAGES-1)-1:0],out_ready};
end

assign in_ready = c[STAGES-1:(STAGES-1)];
assign out_valid = in_valid;
assign out_data = in_data;

endmodule
