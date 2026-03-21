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
module phylite_niosii_bridge #(
	parameter ADDR_WIDTH = 28,
	parameter USE_AVL_CTRL = 1
	) (
		input  wire        core_clk_in,            
		input  wire        interface_locked,       
		output wire        nios_clock,             
		output wire        nios_reset,             
		output wire        avl_out_clk,            
		output wire        avl_out_reset,          
		output wire        avl_out_read,           
		output wire        avl_out_write,          
		output wire [3:0]  avl_out_byteenable,     
		output wire [31:0] avl_out_writedata,      
		output wire [ADDR_WIDTH-1:0] avl_out_address,
		input  wire [31:0] avl_out_readdata,       
		input  wire        avl_out_readdata_valid, 
		input  wire        avl_out_waitrequest,    
		input  wire        avl_read,               
		input  wire        avl_write,              
		input  wire [3:0]  avl_byteenable,         
		input  wire [31:0] avl_writedata,          
		input  wire [23:0] avl_address,  
		output wire [31:0] avl_readdata,           
		output wire        avl_readdata_valid,     
		output wire        avl_waitrequest,         

        output wire        interface_locked_probe,
		input wire		   reset_input_for_system,
		output wire		   reset_source,
		output wire 	   clock_source_to_system,
		input wire		   clock_input_for_system,
		input wire         nios_done_in,
		output wire        nios_done_probe

	);

    assign interface_locked_probe = interface_locked;
	assign reset_source = reset_input_for_system;
	assign clock_source_to_system = clock_input_for_system;
	assign nios_done_probe = nios_done_in;


	assign nios_clock = core_clk_in;
	assign nios_reset = interface_locked;

	assign avl_out_clk = core_clk_in;
	assign avl_out_reset = interface_locked;

	assign avl_out_read = avl_read;
	assign avl_out_byteenable = avl_byteenable;
	assign avl_out_writedata = avl_writedata;
	assign avl_out_write = avl_write;
	assign avl_readdata = avl_out_readdata;
	assign avl_waitrequest = avl_out_waitrequest;
	assign avl_readdata_valid = avl_out_readdata_valid;

	generate
	if (USE_AVL_CTRL) begin
		assign avl_out_address = {8'h00, avl_address};
	end else begin
		assign avl_out_address = {4'h0, avl_address};
	end
	endgenerate

endmodule
