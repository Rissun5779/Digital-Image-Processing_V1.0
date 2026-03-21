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



`timescale 1ns / 1ns

module altera_qspi_address_adaption_core #(
	parameter CS_WIDTH		= 1,
	parameter ENABLE_4BYTE_ADDR = 1,
	parameter ADDR_WIDTH	= 22,
	parameter ASI_WIDTH		= 1,
	parameter DEVICE_FAMILY = "CYCLONE V",
	parameter ASMI_ADDR_WIDTH = 22,
	parameter CHIP_SELS = 1
)(
	input 				  								clk,
	input 				  								reset_n,
	                                        			
	// ports to access csr                        			
	input 												avl_csr_write,
	input 				  								avl_csr_read,
	input 		 	[2:0] 								avl_csr_addr,
	input 		 	[31:0] 								avl_csr_wrdata,
	output 	logic 	[31:0] 								avl_csr_rddata,
	output 	logic 		 								avl_csr_rddata_valid,
	output 	logic 			 							avl_csr_waitrequest,
	                                        			
	// ports to access memory        			
	input				  								avl_mem_write,
	input												avl_mem_read,
	input		  	[ADDR_WIDTH-1:0]					avl_mem_addr,			
	input			[31:0]								avl_mem_wrdata,
	input		 	[3:0]								avl_mem_byteenable,
	input			[6:0]								avl_mem_burstcount,
	output			[31:0]								avl_mem_rddata,
	output	logic										avl_mem_rddata_valid,
	output 	logic 			 							avl_mem_waitrequest,
	
	// interrupt signal
	output	logic 										irq,
	
	// ASMI PARALLEL interface
	output logic	[5:0]  								asmi_csr_address,      
	output logic       									asmi_csr_read,         
	input  		 	[31:0] 								asmi_csr_readdata,     
	output logic       									asmi_csr_write,        
	output logic	[31:0] 								asmi_csr_writedata,    
	input          										asmi_csr_waitrequest,  
	input       	   									asmi_csr_readdatavalid,
	output logic	[ADDR_WIDTH-1:0]					asmi_mem_address,      
	output logic       									asmi_mem_read,         
	input  		 	[31:0] 								asmi_mem_readdata,     
	output logic       									asmi_mem_write,        
	output logic	[31:0] 								asmi_mem_writedata,    
	output logic	[3:0]  								asmi_mem_byteenable,   
	output logic	[6:0]  								asmi_mem_burstcount,   
	input   	       									asmi_mem_waitrequest,  
	input  	        									asmi_mem_readdatavalid
);
	localparam LOCAL_ADDR_WIDTH = ADDR_WIDTH+2;
	localparam CSR_DATA_WIDTH   = 32;
	localparam LAST_ADDR_BIT    = (ASMI_ADDR_WIDTH == 24) ? 15 :
									(ASMI_ADDR_WIDTH == 32) ? 23 : 15;
	
	
endmodule
