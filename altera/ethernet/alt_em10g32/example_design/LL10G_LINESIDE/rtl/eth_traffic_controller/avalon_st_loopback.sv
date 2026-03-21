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


//-----------------------------------------------------------------------------
// Title         : avalon_st_loopback
// Project       : 10G Ethernet reference design
//-----------------------------------------------------------------------------
// File          : avalon_st_loopback.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Functional Description:
// This module is the top level of the Avalon ST Loopback Mux
//-------------------------------------------------------------------------------
//
// Copyright 2010 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
// This reference design file, and your use thereof, is subject to and governed by
// the terms and conditions of the applicable Altera Reference Design License Agreement.
// By using this reference design file, you indicate your acceptance of such terms and
// conditions between you and Altera Corporation.  In the event that you do not agree with
// such terms and conditions, you may not use the reference design file. Please promptly
// destroy any copies you have made.
//
// This reference design file being provided on an "as-is" basis and as an accommodation
// and therefore all warranties, representations or guarantees of any kind
// (whether express, implied or statutory) including, without limitation, warranties of
// merchantability, non-infringement, or fitness for a particular purpose, are
// specifically disclaimed.  By making this reference design file available, Altera
// expressly does not recommend, suggest or require that this reference design file be
// used in combination with any other product not provided by Altera

module avalon_st_loopback 
	#(
	parameter	amm_addr_width = 8,
	parameter	amm_data_width = 32,	
	parameter	ast_data_width = 64,	
	parameter	ast_empty_width = 3,	
	parameter	ast_rx_error_width = 6	
	)
	(
	input                 						clk,             // TX FIFO Interface clock
	input                 						reset,           // Reset signal
	input          [amm_addr_width-1:0]  		address,         // Register Address
	input                 						write,           // Register Write Strobe
	input                 						read,            // Register Read Strobe
	output wire           						waitrequest,  
	input          [amm_data_width-1:0] 		writedata,       // Register Write Data
	output reg     [amm_data_width-1:0] 		readdata,        // Register Read Data
                                            	
	//To 10G MAC Avalon ST                  	
	input                 						from_mac_tx_ready,        // Avalon-ST Ready Input
	output reg     [ast_data_width-1:0] 		to_mac_tx_data,         // Avalon-ST TX Data
	output reg            						to_mac_tx_valid,        // Avalon-ST TX Valid
	output reg            						to_mac_tx_sop,          // Avalon-ST TX StartOfPacket
	output reg            						to_mac_tx_eop,          // Avalon-ST TX EndOfPacket
	output reg     [ast_empty_width-1:0]  		to_mac_tx_empty,        // Avalon-ST TX Empty
	output reg           						to_mac_tx_error,        // Avalon-ST TX Error
	                                        	
	//From 10G MAC Avalon ST                	
	input 			[ast_data_width-1:0]		from_mac_rx_data,           
 	input 										from_mac_rx_valid,          
 	input 										from_mac_rx_sop,            
 	input 										from_mac_rx_eop,            
 	input 			[ast_empty_width-1:0]		from_mac_rx_empty,          
 	input 			[ast_rx_error_width-1:0]	from_mac_rx_error,          
 	output reg   								to_mac_rx_ready,          
	
 	//From Gen Avalon ST
 	output reg									to_gen_tx_ready,
 	input			[ast_data_width-1:0]		from_gen_tx_data,
 	input										from_gen_tx_valid,
 	input										from_gen_tx_sop,
 	input										from_gen_tx_eop,
 	input			[ast_empty_width-1:0]		from_gen_tx_empty,
 	input										from_gen_tx_error,
 	                                        	
 	//To Mon Avalon ST                      	
 	output reg		[ast_data_width-1:0]		to_mon_rx_data,
 	output reg 									to_mon_rx_valid,
 	output reg									to_mon_rx_sop,
 	output reg									to_mon_rx_eop,
 	output reg		[ast_empty_width-1:0]		to_mon_rx_empty,
 	output reg		[ast_rx_error_width-1:0]	to_mon_rx_error,
 	input										from_mon_rx_ready
);

parameter	AVALON_ST_LB_ENA = 8'h00;

reg		avalon_st_loopback_ena;

reg rddly, wrdly;

always@(posedge clk or posedge reset)
begin
   if(reset) 
	 begin 
	      wrdly <= 1'b0; 
	      rddly <= 1'b0; 
	 end 
   else 
	 begin 
	      wrdly <= write; 
	      rddly <= read; 
	 end 
end

wire wredge = write& ~wrdly;
wire rdedge = read & ~rddly;

assign waitrequest = (wredge|rdedge); // your design is done with transaction when this goes down

// ____________________________________________________________________________
// Avalon ST Loopback Enable Register
// ____________________________________________________________________________
always @ (posedge reset or posedge clk)
	if (reset) 
    	avalon_st_loopback_ena <= 1'b0;
    else if (write & address == AVALON_ST_LB_ENA) 
    	avalon_st_loopback_ena <= writedata[0];
    	
// ____________________________________________________________________________    	
// Output MUX of registers into readdata bus
// ____________________________________________________________________________
always@(posedge clk or posedge reset)
begin
	if(reset) begin 
		readdata <= 32'h0;
	end
   	else if (read) begin
    	case (address)
         	AVALON_ST_LB_ENA: readdata <= {31'd0, avalon_st_loopback_ena};
         	default: readdata <=32'h0;
      	endcase
   	end
end    	
 
// ____________________________________________________________________________    	
// Register Mux 
// ____________________________________________________________________________
always @(*)
begin
	if (avalon_st_loopback_ena) begin
	  	to_mac_tx_data	  = from_mac_rx_data;
		to_mac_tx_valid   = from_mac_rx_valid; 
		to_mac_tx_sop     = from_mac_rx_sop;
		to_mac_tx_eop     = from_mac_rx_eop;
		to_mac_tx_empty   = from_mac_rx_empty;
		to_mac_tx_error   = |from_mac_rx_error;
		to_gen_tx_ready	  = 1'b0;
	end
	else begin
		to_mac_tx_data	  = from_gen_tx_data;
		to_mac_tx_valid   = from_gen_tx_valid; 
		to_mac_tx_sop     = from_gen_tx_sop;
		to_mac_tx_eop     = from_gen_tx_eop;
		to_mac_tx_empty   = from_gen_tx_empty;
		to_mac_tx_error   = from_gen_tx_error;
		to_gen_tx_ready	  = from_mac_tx_ready;
	end
end 	
	
always @(*)
begin
	if (avalon_st_loopback_ena) begin
		to_mon_rx_data	  = {ast_data_width{1'b0}};
		to_mon_rx_valid   = 1'b0; 
		to_mon_rx_sop     = 1'b0;
		to_mon_rx_eop     = 1'b0;
		to_mon_rx_empty   = {ast_empty_width{1'b0}};
		to_mon_rx_error   = {ast_rx_error_width{1'b0}};
		to_mac_rx_ready	  = from_mac_tx_ready;
	end
	else begin
		to_mon_rx_data	  = from_mac_rx_data;
		to_mon_rx_valid   = from_mac_rx_valid; 
		to_mon_rx_sop     = from_mac_rx_sop;
		to_mon_rx_eop     = from_mac_rx_eop;
		to_mon_rx_empty   = from_mac_rx_empty;
		to_mon_rx_error   = from_mac_rx_error;
		to_mac_rx_ready	  = from_mon_rx_ready;
	end
end  	
 	
	
endmodule	