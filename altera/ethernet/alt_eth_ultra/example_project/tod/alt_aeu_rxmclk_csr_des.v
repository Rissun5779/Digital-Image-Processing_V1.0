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
// $Id: //acds/main/ip/ethernet/alt_eth_ultra_100g/rtl/ptp/e100_ptp_rx_csr.v#4 $
// $Revision: #4 $
// $Date: 2013/06/24 $
// $Author: jilee $
//-----------------------------------------------------------------------------
// Copyright 2011 Altera Corporation. All rights reserved.  Altera products are
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

// turn off bogus verilog processor warnings
// altera message_off 10034 10035 10036 10037 10230
// ajay dubey 06.2013

module alt_aeu_rxmclk_csr_des 
  #(
    parameter BASE=0,
    parameter ADDRSIZE=8 ,
    parameter REVID=32'h04122014,
    parameter TARGET_CHIP= 2
    )(
    input wire reset_csr,
    input wire clk_csr, 
    input wire clk_slv,
    input wire reset_slv,

    input wire serif_master_din,
    output wire serif_slave_dout, 

    input [19:0] rst_rxmclk_period,

    // all config outputs here
    output reg wr_rxmclk_period,
    output [19:0] rxmclk_period

      );

   //
 // ___________________________________________________________
 	localparam ADDR_CFG_00	= 00	// register 00
		 , ADDR_CFG_01	= 01	// register 01
		 , ADDR_CFG_02	= 02	// register 02
		 , ADDR_CFG_03	= 03	// register 03
		 , ADDR_CFG_04	= 04	// register 04
		 , ADDR_CFG_05	= 05	// register 05
		 , ADDR_CFG_06	= 06	// register 06
		 , ADDR_CFG_07	= 07	// register 07
		 , ADDR_CFG_08	= 08	// register 08
		 , ADDR_CFG_09	= 09	// register 09
		 ;
 // ___________________________________________________________
 //

 wire read;
 wire write;
 wire [31:0]writedata;
 wire [ADDRSIZE-1:0]address;
 reg readdatavalid;
 reg [31:0]readdata;

 serif_slave_async #(
	 .ADDR_PAGE	 (BASE)
	,.TARGET_CHIP	 (TARGET_CHIP)
 )sifsa_rxcsr (
    	 .aclr		(reset_csr)
    	,.sclk		(clk_csr)
    	,.din		(serif_master_din)
    	,.dout		(serif_slave_dout)

    	,.bclk		(clk_slv)
    	,.wr		(write)
    	,.rd		(read)
    	,.addr		(address)
    	,.wdata		(writedata)
    	,.rdata		(readdata)
    	,.rdata_valid   (readdatavalid)
 	);

 // _________________________________________________________________________
 //	config registers 
 // _________________________________________________________________________
   reg [31:0] cfg_reg_01;
   reg [31:0] cfg_reg_05;

 // _________________________________________________________________________
   //	registers writing
   // _________________________________________________________________________
   always @ (posedge clk_slv or posedge reset_slv)
     begin
	if (reset_slv)
	  begin
	     cfg_reg_01 <= 32'd0;
	     cfg_reg_05 <= {12'd0,rst_rxmclk_period};
	  end
	else
	   
  	  begin 
	     if (write) 
	       case(address) 
	         ADDR_CFG_01:cfg_reg_01 <= writedata;
	         ADDR_CFG_05:cfg_reg_05 <= {12'd0,writedata[19:0]}; 
	         default    :cfg_reg_01 <= cfg_reg_01; 
	       endcase
	  end // else: !if(reset_slv)
     end // always @ (posedge clk_slv or posedge reset_slv)

   always @(posedge clk_slv)
     begin
	if (write & (address == ADDR_CFG_05))
	  wr_rxmclk_period <= 1'b1;
	else
	  wr_rxmclk_period <= 1'b0;
     end

// _____________________________________________________________________
//  readdata logic
// _____________________________________________________________________
   wire [12*8-1:0] ip_name = "100gPTPRxCSR";

   always @ (posedge clk_slv) readdatavalid <= read; 
   always @ (posedge clk_slv) 
      begin 
	if (read)
	    begin
		case(address)
		   ADDR_CFG_00 : readdata <= REVID;
		   ADDR_CFG_01 : readdata <= {cfg_reg_01};
		  ADDR_CFG_02 : readdata <= ip_name[31:0];
		   ADDR_CFG_03 : readdata <= ip_name[63:32];
		   ADDR_CFG_04 : readdata <= ip_name[95:64];
		   ADDR_CFG_05 : readdata <= {cfg_reg_05};
		   default     : readdata <= 32'hdead_c0de;
		endcase
	    end
      end

 // _____________________________________________________________________________

   assign rxmclk_period = cfg_reg_05[19:0];
   

endmodule // alt_aeu_rxmclk_csr_100_des






