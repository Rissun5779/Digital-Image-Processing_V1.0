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


// $Id: //acds/main/ip/altera_voltage_sensor/control/altera_voltage_sensor_control.sv#3 $
// $Revision: #3 $
// $Date: 2015/01/18 $
// $Author: tgngo $

// +-----------------------------------------------------------
// | Nadder SDM GPO
// +-----------------------------------------------------------

`timescale 1 ns / 1 ns
module altera_sdm_gpo #(
		parameter WIDTH = 9
	) (
		output wire [WIDTH - 1:0] gpo 
	);

	wire [WIDTH - 1:0] gpo_wire; 
	// The atom needs two parameters: bitpos and role : role not yet define
	generate 
		genvar i;
		for (i=0; i < WIDTH; i=i+1)
			begin : gpo_inst
				fourteennm_sdm_gpio_out #(
					.bitpos       (i),
					.role         ("nul")
					) sdm_gpio_out (
					.gpio_o        (gpo_wire[i])
					);
			end
		endgenerate
	assign gpo = gpo_wire;

endmodule
