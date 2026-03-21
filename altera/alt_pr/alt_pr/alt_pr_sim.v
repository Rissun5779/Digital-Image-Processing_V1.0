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



`timescale 1ns/1ns
module alt_pr(
	clk,
	nreset,
	freeze,
	pr_start,
	double_pr,
	status,
	data,
	data_valid,
	data_ready,
	avmm_slave_address,
	avmm_slave_read,
	avmm_slave_readdata,
	avmm_slave_write,
	avmm_slave_writedata,
	avmm_slave_waitrequest,
	irq,
	pr_ready_pin,
	pr_done_pin,
	pr_error_pin,
	pr_request_pin,
	pr_clk_pin,
	pr_data_pin,
	crc_error_pin
);
	parameter PR_INTERNAL_HOST = 1; // '1' means Internal Host, '0' means External Host
	parameter CDRATIO = 1; // valid: 1, 2, 4, 8(Arria 10 only)
	parameter DATA_WIDTH_INDEX = 16; // valid: 1, 2, 4, 8, 16, 32. For Avalon-MM interface, always set to 16.
	parameter CB_DATA_WIDTH = 16;
	parameter ENABLE_DATA_PACKING = 1;
	parameter ENABLE_AVMM_SLAVE = 0; // '1' means Enable Avalon-MM slave interface, '0' means Conduit interface
	parameter ENABLE_JTAG = 1;	// '1' means Enable JTAG debug mode, '0' means Disable
	parameter EDCRC_OSC_DIVIDER = 1; // valid: 1, 2, 4, 8, 16, 32, 64, 128, 256
	parameter DEVICE_FAMILY	= "Stratix V";
    parameter EXT_HOST_TARGET_DEVICE_FAMILY	= "Stratix V"; // Target device family for PR when External Host is enabled. 
	parameter ENABLE_PRPOF_ID_CHECK = 1; // '1' means Enable, '0' means Disable
	parameter EXT_HOST_PRPOF_ID = 0; // valid: 32-bit integer value
	parameter ENABLE_ENHANCED_DECOMPRESSION = 0;
	parameter INSTANTIATE_PR_BLOCK = 1;
	parameter INSTANTIATE_CRC_BLOCK = 1;
	parameter ENABLE_INTERRUPT = 0;

	// We have two different input data paths - ST/MM and JTAG.
	localparam ST_MM_INPUT_DATA_WIDTH = DATA_WIDTH_INDEX; // An alias.
	localparam JTAG_INPUT_DATA_WIDTH = 16;

	localparam EFFECTIVE_DEVICE_FAMILY = PR_INTERNAL_HOST ? DEVICE_FAMILY : EXT_HOST_TARGET_DEVICE_FAMILY;

	localparam CSR_IRQ_BIT_OFFSET = 5;
	
	input clk;
	input nreset;
	input pr_start;
	input double_pr;
	input data_valid;
	input [ST_MM_INPUT_DATA_WIDTH-1:0] data;
	input avmm_slave_address;
	input avmm_slave_read;
	input avmm_slave_write;
	input [ST_MM_INPUT_DATA_WIDTH-1:0] avmm_slave_writedata;
	input pr_ready_pin;
	input pr_done_pin;
	input pr_error_pin;
	input crc_error_pin;
	
	output freeze;
	output data_ready;
	output [2:0] status;
	output [ST_MM_INPUT_DATA_WIDTH-1:0] avmm_slave_readdata;
	output avmm_slave_waitrequest;
	output pr_request_pin;
	output pr_clk_pin;
	output [CB_DATA_WIDTH-1:0] pr_data_pin;
	output irq;
	
	// Hard code outputs
	assign freeze = 1'b0;
	assign data_ready = 1'b0;
	assign status = 3'b0;
	assign avmm_slave_readdata = {ST_MM_INPUT_DATA_WIDTH{1'b0}};
	assign avmm_slave_waitrequest = 1'b1;
	assign pr_request_pin = 1'b0;
	assign pr_clk_pin = 1'b0;
	assign pr_data_pin = {CB_DATA_WIDTH{1'b0}};
	assign irq = 1'b0;

endmodule

