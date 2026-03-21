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

module alt_aeu_txmclk_csr_des
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
    input wire clk_slv2,
    input wire reset_slv2,

    input wire serif_master_din,
    output wire serif_slave_dout, 

    input [19:0] rst_txmclk_period,
    input [95:0] rst_txmclk_tod,

    output reg 	wr_txmclk_tod /* synthesis preserve */,
    output reg 	wr_txmclk_tod_cp1 /* synthesis preserve */,
    output reg 	wr_txmclk_tod_cp2 /* synthesis preserve */,
    output [95:0] txmclk_tod,

    output reg 	wr_txmclk_period,
    output [19:0] txmclk_period,

    output reg 	wr_rxmclk_tod /* synthesis preserve */,
    output reg 	wr_rxmclk_tod_cp1 /* synthesis preserve */,
    output reg 	wr_rxmclk_tod_cp2 /* synthesis preserve */,
    output [95:0] rxmclk_tod,

    input [95:0] txmclk_tod_in

      );

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
		 , ADDR_CFG_0a	= 10	// register 0a
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
   reg [31:0] cfg_reg_00;
   reg [31:0] cfg_reg_01;
   reg [31:0] cfg_reg_02;
   reg [31:0] cfg_reg_03;
   reg [31:0] cfg_reg_04;
   reg [31:0] cfg_reg_05;
   reg [31:0] cfg_reg_06;
   reg [31:0] cfg_reg_07;
   reg [31:0] cfg_reg_08;
   reg [31:0] cfg_reg_09;
   reg [31:0] cfg_reg_0a;

 // _________________________________________________________________________
   //	registers writing
   // _________________________________________________________________________

   always @ (posedge clk_slv or posedge reset_slv)
     begin
	if (reset_slv)
	  begin
	     cfg_reg_01 <= 32'd0;
	     cfg_reg_05 <= {12'd0,rst_txmclk_period};
	     cfg_reg_06 <= {rst_txmclk_tod[95:64]};
	     cfg_reg_07 <= {rst_txmclk_tod[63:32]};
	     cfg_reg_08 <= {rst_txmclk_tod[31:0]};
	     cfg_reg_09 <= 32'd0;
	     cfg_reg_0a <= 32'd0;
	  end
	else
  	  begin 
	     if (write)
	       begin
	       case(address) 
	         ADDR_CFG_01:cfg_reg_01 <= writedata;
	         ADDR_CFG_05:cfg_reg_05 <= {12'd0,writedata[19:0]}; 
	         ADDR_CFG_06:cfg_reg_06 <= writedata; 
	         ADDR_CFG_07:cfg_reg_07 <= writedata;
	         ADDR_CFG_08:cfg_reg_08 <= writedata;
	         ADDR_CFG_09:cfg_reg_09 <= 32'd0;
	         ADDR_CFG_0a:cfg_reg_0a <= 32'd0;
	       endcase // case (address)
	       end // if (write)
	     else
	       begin
		  if (read & (address == ADDR_CFG_06))
		    begin
		       {cfg_reg_02,cfg_reg_03,cfg_reg_04} <= txmclk_tod_in;
		    end
	       end // else: !if(write)
	  end // else: !if(reset_slv)
     end // always @ (posedge clk_slv or posedge reset_slv)

   always @(posedge clk_slv)
     begin
	if (write & (address == ADDR_CFG_05))
	  wr_txmclk_period <= 1'b1;
	else
	  wr_txmclk_period <= 1'b0;

	if (write & (address == ADDR_CFG_06))
	  begin
	     wr_txmclk_tod <= 1'b1;
	     wr_txmclk_tod_cp1 <= 1'b1;
	     wr_txmclk_tod_cp2 <= 1'b1;
	  end
	else
	  begin
	     wr_txmclk_tod <= 1'b0;
	     wr_txmclk_tod_cp1 <= 1'b0;
	     wr_txmclk_tod_cp2 <= 1'b0;
	  end
     end // always @ (posedge clk_slv)
   
// _____________________________________________________________________
//  readdata logic
// _____________________________________________________________________

   wire [12*8-1:0] ip_name = "100gPTPTxCSR";

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
		   ADDR_CFG_06 : readdata <= {cfg_reg_06};
		   ADDR_CFG_07 : readdata <= {cfg_reg_07};
		   ADDR_CFG_08 : readdata <= {cfg_reg_08};
		  ADDR_CFG_09 : readdata <= 32'd0;
		   ADDR_CFG_0a : readdata <= 32'd0;
		   default     : readdata <= 32'hdead_c0de;
		endcase
	    end
      end

 // _____________________________________________________________________________

   assign txmclk_period = cfg_reg_05[19:0];
   assign txmclk_tod = {cfg_reg_06,cfg_reg_07,cfg_reg_08};

   // second slave for rxmclk to get tod in that domain
 wire read2;
 wire write2;
 wire [31:0]writedata2;
 wire [ADDRSIZE-1:0]address2;
 reg readdatavalid2;
 wire [31:0]readdata2;

   always @ (posedge clk_slv) readdatavalid2 <= read; 

 assign	readdata2 = 32'd0;

   wire serif_slave_dout2;
   
 serif_slave_async #(
	 .ADDR_PAGE	 (BASE)
	,.TARGET_CHIP	 (TARGET_CHIP)
 )sifsa_rxcsr2 (
    	 .aclr		(reset_csr)
    	,.sclk		(clk_csr)
    	,.din		(serif_master_din)
    	,.dout		(serif_slave_dout2)

    	,.bclk		(clk_slv2)
    	,.wr		(write2)
    	,.rd		(read2)
    	,.addr		(address2)
    	,.wdata		(writedata2)
    	,.rdata		(readdata2)
    	,.rdata_valid   (readdatavalid2)
 	);

 // _________________________________________________________________________
 //	config registers 
 // _________________________________________________________________________
   reg [31:0] cfg_reg_2_02;
   reg [31:0] cfg_reg_2_03;
   reg [31:0] cfg_reg_2_04;
   reg [31:0] cfg_reg_2_06;
   reg [31:0] cfg_reg_2_07;
   reg [31:0] cfg_reg_2_08;

 // _________________________________________________________________________
   //	registers writing
   // _________________________________________________________________________

   always @ (posedge clk_slv2 or posedge reset_slv2)
     begin
	if (reset_slv2)
	  begin
	     cfg_reg_2_06 <= {rst_txmclk_tod[95:64]};
	     cfg_reg_2_07 <= {rst_txmclk_tod[63:32]};
	     cfg_reg_2_08 <= {rst_txmclk_tod[31:0]};
	  end
	else
  	  begin 
	     if (write2)
	       begin
	       case(address2) 
	         ADDR_CFG_06:cfg_reg_2_06 <= writedata2; 
	         ADDR_CFG_07:cfg_reg_2_07 <= writedata2;
	         ADDR_CFG_08:cfg_reg_2_08 <= writedata2;
	         default    :cfg_reg_2_06 <= cfg_reg_2_06; 
	       endcase // case (address)
	       end // if (write)
	  end // else: !if(reset_slv)
     end // always @ (posedge clk_slv or posedge reset_slv)

   always @(posedge clk_slv2)
     begin
	if (write2 & (address2 == ADDR_CFG_06))
	  begin
	     wr_rxmclk_tod <= 1'b1;
	     wr_rxmclk_tod_cp1 <= 1'b1;
	     wr_rxmclk_tod_cp2 <= 1'b1;
	  end
	else
	  begin
	     wr_rxmclk_tod <= 1'b0;
	     wr_rxmclk_tod_cp1 <= 1'b0;
	     wr_rxmclk_tod_cp2 <= 1'b0;
	  end
     end // always @ (posedge clk_slv)
   assign rxmclk_tod = {cfg_reg_2_06,cfg_reg_2_07,cfg_reg_2_08};
   
endmodule // alt_aeu_txmclk_csr





