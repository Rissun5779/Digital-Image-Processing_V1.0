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

module alt_aeu_3_cyc_add_tod_des
  #(
    parameter INST_NUM = 0
    )
  (
   input arst,
   input wr_tod,
   input [95:0] wr_tod_in,

   input [23:0] delta, // add delta to tod

   output [95:0] tod_out,
   input clk
   );

   reg [23:0] msb_sec;
   reg [23:0] lsb_sec;
   reg [15:0] msb_ns;
   reg [15:0] lsb_ns;
   reg [15:0] fr_ns;

   reg [23:0] msb_sec_d1;
   reg [23:0] lsb_sec_d1;
   reg [15:0] msb_ns_d1;
   reg [15:0] lsb_ns_d1;
   reg [15:0] fr_ns_d1;
   reg 	      lsb_ns_ovf_d1;
   reg 	      fr_ns_ovf_d1;

   reg [23:0] msb_sec_d2;
   reg [23:0] lsb_sec_d2;
   reg [15:0] msb_ns_d2;
   reg [15:0] lsb_ns_d2;
   reg [15:0] fr_ns_d2;
   reg 	      lsb_sec_max_d2;
   reg 	      msb_ns_max_d2;
   reg 	      lsb_ns_nor_max_d2;
   reg 	      lsb_ns_gt_max_d2;
   reg 	      lsb_ns_spl_max_d2;
   reg 	      fr_ns_ovf_d2, fr_ns_ovf_d2_cp1, fr_ns_ovf_d2_cp2 /* synthesis preserve */;
   reg [15:0] lsb_ns_alt_d2;
   reg 	      lsb_ns_ovf_d2;
   
   reg 	      ns_max_d2;
   reg 	      ns_ovf_d2;

	   initial msb_sec = 24'haaaaaa;
	   initial lsb_sec = 24'hbbbbbb;
	   initial msb_ns = 16'h0000;
	   initial msb_sec_d1 = 24'haaaaaa;
	   initial lsb_sec_d1 = 24'hbbbbbb;
	   initial msb_ns_d1 = 16'h0000;
	   initial lsb_ns_ovf_d1 = 1'b0;
	   initial fr_ns_ovf_d1 = 1'b0;
	   initial msb_sec_d2 = 24'haaaaaa;
	   initial lsb_sec_d2 = 24'hbbbbbb;
	   initial msb_ns_d2 = 16'h0000;
	   initial lsb_sec_max_d2 = 1'b0;
	   initial msb_ns_max_d2 = 1'b0;
	   initial lsb_ns_nor_max_d2 = 1'b0;
	   initial lsb_ns_gt_max_d2 = 1'b0;
	   initial lsb_ns_spl_max_d2 = 1'b0;
	   initial fr_ns_ovf_d2 = 1'b0;
	   initial fr_ns_ovf_d2_cp1 = 1'b0;
	   initial fr_ns_ovf_d2_cp2 = 1'b0;
	   initial lsb_ns_alt_d2 = 16'd0;
	   initial lsb_ns_ovf_d2 = 0;

   generate
      if (INST_NUM == 0)
	begin
	   initial lsb_ns = 16'h0000;
	   initial fr_ns = 16'h0000;
	   initial lsb_ns_d1 = 16'h0000;
	   initial fr_ns_d1 = 16'h0000;
	   initial lsb_ns_d2 = 16'h0000;
	   initial fr_ns_d2 = 16'h0000;
	end
      else
	begin
	   if (INST_NUM == 1)
	     begin
		initial lsb_ns_d2 = 16'h0002;
		initial fr_ns_d2 = 16'h8f5c;
		initial lsb_ns = 16'h0000;
		initial fr_ns = 16'h0000;
		initial lsb_ns_d1 = 16'h0000;
		initial fr_ns_d1 = 16'h0000;
	     end
	   else
	     begin
		initial lsb_ns_d1 = 16'h0005;
		initial fr_ns_d1 = 16'h1eb8;
		initial lsb_ns = 16'h0000;
		initial fr_ns = 16'h0000;
		initial lsb_ns_d2 = 16'h0000;
		initial fr_ns_d2 = 16'h0000;
	     end // else: !if(INST_NUM == 1)
	end // else: !if(INST_NUM == 0)
   endgenerate

   assign tod_out = {msb_sec,lsb_sec,msb_ns,lsb_ns,fr_ns};
   always @(posedge clk)
     begin
	msb_sec_d1 <= msb_sec;
	lsb_sec_d1 <= lsb_sec;
	msb_ns_d1 <= msb_ns;
	{lsb_ns_ovf_d1,lsb_ns_d1} <= {1'b0,lsb_ns} + {9'd0,delta[23:16]};
	{fr_ns_ovf_d1,fr_ns_d1} <= {1'b0,fr_ns} + {1'd0,delta[15:0]};
     end

   always @(posedge clk)
     begin
	msb_sec_d2 <= msb_sec_d1;

	lsb_sec_d2 <= lsb_sec_d1;
	if (lsb_sec_d1 == 24'hffffff)
	  lsb_sec_max_d2 <= 1'b1;
	else
	  lsb_sec_max_d2 <= 1'b0;

	msb_ns_d2 <= msb_ns_d1;
	if (msb_ns_d1 == 16'h3b9a) // 16 msbs of 1 billion
	  msb_ns_max_d2 <= 1'b1;
	else
	  msb_ns_max_d2 <= 1'b0;

	lsb_ns_d2 <= lsb_ns_d1;
	lsb_ns_ovf_d2 <= lsb_ns_ovf_d1;
	lsb_ns_alt_d2 <= lsb_ns_d1 - 16'hca00;
	if (lsb_ns_d1 == 16'hffff) // normal max
	  lsb_ns_nor_max_d2 <= 1'b1;
	else
	  lsb_ns_nor_max_d2 <= 1'b0;

	if (lsb_ns_d1 > 16'hc9ff) // greater than max for ovf at 1 billion
	  lsb_ns_gt_max_d2 <= 1'b1;
	else
	  lsb_ns_gt_max_d2 <= 1'b0;

	if (lsb_ns_d1 == 16'hc9ff) // special max for ovf at 1 billion
	  lsb_ns_spl_max_d2 <= 1'b1;
	else
	  lsb_ns_spl_max_d2 <= 1'b0;

	fr_ns_d2 <= fr_ns_d1;
	fr_ns_ovf_d2 <= fr_ns_ovf_d1;
	fr_ns_ovf_d2_cp1 <= fr_ns_ovf_d1;
	fr_ns_ovf_d2_cp2 <= fr_ns_ovf_d1;
     end // always @ (posedge clk)

   always @(*)
     begin
	ns_max_d2 = msb_ns_max_d2 & lsb_ns_spl_max_d2;
	ns_ovf_d2 = msb_ns_max_d2 & lsb_ns_gt_max_d2;
     end
   
   always @(posedge clk)
     begin
	if (wr_tod)
	  begin
	     {msb_sec,lsb_sec,msb_ns,lsb_ns,fr_ns} <= wr_tod_in;
	  end
	else
	  begin
	     fr_ns <= fr_ns_d2;

	     if (ns_max_d2 & fr_ns_ovf_d2)
	       begin
		  msb_ns <= 16'd0;
		  lsb_ns <= 16'd0;
	       end
	     else
	       begin
		  if (ns_ovf_d2)
		    begin
		       msb_ns <= 16'd0;
		       if (fr_ns_ovf_d2)
			 lsb_ns <= lsb_ns_alt_d2 + 16'd1;
		       else
			 lsb_ns <= lsb_ns_alt_d2;
		    end
		  else
		    begin
		       lsb_ns <= lsb_ns_d2 + fr_ns_ovf_d2_cp1;
		       msb_ns <= msb_ns_d2 + {15'd0,lsb_ns_nor_max_d2 & fr_ns_ovf_d2_cp2} + {15'd0,lsb_ns_ovf_d2};
		    end // else: !if(ns_ovf_d2)
	       end // else: !if(ns_max_d2 & fr_ns_ovf_d2)

	     if ((ns_max_d2 & fr_ns_ovf_d2_cp1) || (ns_ovf_d2))
	       lsb_sec <= lsb_sec_d2 + 24'd1;
	     else
	       lsb_sec <= lsb_sec_d2;

	     if (lsb_sec_max_d2 & ((ns_max_d2 & fr_ns_ovf_d2_cp2) || (ns_ovf_d2)))
	       msb_sec <= msb_sec_d2 + 24'd1;
	     else
	       msb_sec <= msb_sec_d2;
	  end // else: !if(wr_tod)
     end // always @ (posedge clk)
endmodule // alt_aeu_3_cyc_add_tod_des



