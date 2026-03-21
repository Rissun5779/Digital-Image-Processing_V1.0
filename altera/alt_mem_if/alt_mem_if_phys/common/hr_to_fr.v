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

module hr_to_fr(
	clk,
	d_h0,
	d_h1,
	d_l0,
	d_l1,
	q0,
	q1
);

input	clk;
input	d_h0;
input	d_h1;
input	d_l0;
input	d_l1;
output	q0;
output	q1;

reg	q_h0;
reg	q_h1;
reg	q_l0;
reg	q_l1;
reg	q_l0_neg;
reg	q_l1_neg;

	always @(posedge clk)
	begin
		q_h0 <= d_h0;
		q_l0 <= d_l0;
		q_h1 <= d_h1;
		q_l1 <= d_l1;
	end

	always @(negedge clk)
	begin
		q_l0_neg <= q_l0;
		q_l1_neg <= q_l1;
	end

	assign q0 = clk ? q_l0_neg : q_h0;
	assign q1 = clk ? q_l1_neg : q_h1;

endmodule
