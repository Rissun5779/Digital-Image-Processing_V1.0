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


// ******************************************************************************************************************************** 
// File name: crcerror_genflp.v
// 
//
// Generic Flops
//

module crcerror_edcrc_genflp #(
			         parameter                    WIDTH = 14  
					 )
(                    input  logic               clk,
					 input  logic               reset,
					 input  logic[WIDTH-1:0]    in,     
					 output logic[WIDTH-1:0]    inflp
);
    always @(posedge clk or posedge reset) begin
    if(reset)
	    inflp <= 0;
    else
		inflp <= in;
    end
	
endmodule   