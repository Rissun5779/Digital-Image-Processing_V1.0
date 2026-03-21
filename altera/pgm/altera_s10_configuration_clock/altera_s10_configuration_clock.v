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


// $Id: //acds/main/ip/pgm/altera_nd_mailbox_avst_adap/altera_nd_mailbox_avst_adap.sv#2 $
// $Revision: #2 $
// $Date: 2015/10/19 $
// $Author: tgngo $


`timescale 1 ps / 1 ps

module  altera_s10_configuration_clock
	( 
	clkout
	);

	parameter DEVICE_FAMILY   = " Stratix 10";
	
	output   clkout;
	
	wire  wire_clkout;
	
	assign clkout = wire_clkout;
		
	// -------------------------------------------------------------------
	// Instantiate wysiwyg for chipidblock according to device family
	// -------------------------------------------------------------------	
	fourteennm_sdm_oscillator oscillator_dut ( 
		.clkout(wire_clkout),
		.clkout1()
	);
	
endmodule //altera_int_osc
//VALID FILE
