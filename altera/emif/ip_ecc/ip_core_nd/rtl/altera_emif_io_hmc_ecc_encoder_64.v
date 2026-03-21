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







// synthesis VERILOG_INPUT_VERSION VERILOG_2001
//altera message_off 10463

`timescale 1 ps / 1 ps
module altera_emif_io_hmc_ecc_encoder_64 (
	data,
	q)/* synthesis synthesis_clearbox = 1 */;

	input	[63:0]  data;
	output	[71:0]  q;

	wire [71:0] sub_wire0;
	wire [71:0] q = sub_wire0[71:0];

	altera_emif_io_hmc_ecc_encoder_64_altecc_encoder	io_hmc_ecc_encoder_64_altecc_encoder_component (
				.data (data),
				.q (sub_wire0));

endmodule

