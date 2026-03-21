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


// $Id: //acds/main/ip/ethernet/alt_eth_ultra_100g/rtl/pcs/e100_rx_pcs_4.v#1 $
// $Revision: #1 $
// $Date: 2013/02/27 $
// $Author: pscheidt $
//-----------------------------------------------------------------------------
// Copyright 2012 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_aeu_clks_des # 
  (
   parameter TARGET_CHIP = 5,
   parameter SYNOPT_PTP = 1,
   parameter REVID = 32'h04172014,
   parameter CSRADDRSIZE = 8,
   parameter BASE_TXPTP = 8,
   parameter BASE_RXPTP = 9
   )			 
   (
    // csr interface
//    input reset_csr,
//    input clk_csr,
//    input serif_master_din,
//    output serif_slave_out_ptp,

   
    input rst_txmac,
    input rst_rxmac,

    output [95:0] tod_txmclk,
    output [95:0] tod_rxmclk,

    input clk_txmac, // mac tx clk
    input clk_rxmac  // mac rx clk
    );

	   localparam RST_RXMCLK_PERIOD = 20'h2_8F5C; // mac clk period 2.56 ns
	   localparam RST_TXMCLK_PERIOD = 20'h2_8F5C; // mac clk period 2.56 ns
   wire [19:0] txmclk_period;
   wire [19:0] rxmclk_period;
   
   generate
      if (SYNOPT_PTP == 0)
	begin
	   assign tod_txmclk = 96'd0;
	   assign tod_rxmclk = 96'd0;
	   assign txmclk_period = 20'd0;
	   assign rxmclk_period = 20'd0;
//	   assign serif_slave_out_ptp = 1'b1;
	end
      else
	begin


	   wire wr_txmclk_period;
	   //   wire [19:0] txmclk_period;

	   wire wr_rxmclk_period;
	   //   wire [19:0] rxmclk_period;

	   wire wr_txmclk_tod;
	   wire wr_txmclk_tod_cp1;
	   wire wr_txmclk_tod_cp2;
	   wire [95:0] txmclk_tod;
	   wire [95:0] txmclk_tod_in;

	   wire        wr_rxmclk_tod;
	   wire        wr_rxmclk_tod_cp1;
	   wire        wr_rxmclk_tod_cp2;
	   wire [95:0] rxmclk_tod;

	   wire        serif_slave_dout_txm;
	   wire        serif_slave_dout_rxm;

//	   assign serif_slave_out_ptp = serif_slave_dout_txm & serif_slave_dout_rxm;
	   

	   alt_aeu_txmclk_csr_des # (
			     .BASE(BASE_TXPTP),
			     .TARGET_CHIP(TARGET_CHIP)
			     )
	   txmcsr
	     (
	      .reset_csr(1'b1),
	      .clk_csr(1'b1), 
	      .clk_slv	(clk_txmac),
	      .reset_slv(rst_txmac),
	      .clk_slv2	(clk_rxmac),
	      .reset_slv2(rst_rxmac),
	      .serif_master_din(1'b0),
	      .serif_slave_dout(serif_slave_dout_txm), 
	      .rst_txmclk_period(RST_TXMCLK_PERIOD), // for now
	      .rst_txmclk_tod(96'h0000_0000_0000_0000_0000_0000),

	      .wr_txmclk_tod(wr_txmclk_tod),
	      .wr_txmclk_tod_cp1(wr_txmclk_tod_cp1),
	      .wr_txmclk_tod_cp2(wr_txmclk_tod_cp2),
	      .txmclk_tod(txmclk_tod),

	      .wr_txmclk_period(wr_txmclk_period),
	      .txmclk_period(txmclk_period),

	      .wr_rxmclk_tod(wr_rxmclk_tod),
	      .wr_rxmclk_tod_cp1(wr_rxmclk_tod_cp1),
	      .wr_rxmclk_tod_cp2(wr_rxmclk_tod_cp2),
	      .rxmclk_tod(rxmclk_tod),
	      .txmclk_tod_in(tod_txmclk)
	      );

	   defparam txmcsr.REVID = REVID;

	   alt_aeu_common_des cmn
	     (
	      .arst(rst_txmac),
	      .wr_tod(wr_txmclk_tod),
	      .wr_tod_cp1(wr_txmclk_tod_cp1),
	      .wr_tod_cp2(wr_txmclk_tod_cp2),
	      .wr_tod_in(txmclk_tod),
	      .wr_period(wr_txmclk_period),
	      .rst_period_val(RST_TXMCLK_PERIOD),
	      .wr_period_in(txmclk_period), // 16 bit fraction, 4 bit integer. period no more than 16ns. can be changed
	      .tod_out_etd(tod_txmclk),
	      .clk(clk_txmac)
	      );

	   alt_aeu_common_des cmn_rx
	     (
	      .arst(rst_rxmac),
	      .wr_tod(wr_rxmclk_tod),
	      .wr_tod_cp1(wr_rxmclk_tod_cp1),
	      .wr_tod_cp2(wr_rxmclk_tod_cp2),
	      .wr_tod_in(rxmclk_tod),
	      .wr_period(wr_rxmclk_period),
	      .rst_period_val(RST_TXMCLK_PERIOD),
	      .wr_period_in(rxmclk_period), // 16 bit fraction, 4 bit integer. period no more than 16ns. can be changed
	      .tod_out_etd(tod_rxmclk),
	      .clk(clk_rxmac)
	      );

	   alt_aeu_rxmclk_csr_des # (
			     .BASE(BASE_RXPTP),
			     .TARGET_CHIP(TARGET_CHIP)
			     )
	   rxmcsr
	     (
	      .reset_csr(1'b1),
	      .clk_csr(1'b1), 
	      .clk_slv(clk_rxmac),
	      .reset_slv(rst_rxmac),
	      .serif_master_din(1'b0),
	      .serif_slave_dout(serif_slave_dout_rxm), 
	      .rst_rxmclk_period(RST_RXMCLK_PERIOD), // for now
	      .wr_rxmclk_period(wr_rxmclk_period),
	      .rxmclk_period(rxmclk_period)
	      );

	   defparam rxmcsr.REVID = REVID;

	end // else: !if(SYNOPT_PTP == 0)
   endgenerate
   
endmodule // alt_aeu_clks_100_des




