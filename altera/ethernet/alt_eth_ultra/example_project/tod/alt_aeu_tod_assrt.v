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

module alt_aeu_tod_assrt # 
  (
   parameter TX_OR_RX = 1
   )			 
   (
    input rst,
    input clk,
    input [95:0] tod,
    input [19:0] period
    );

   // ignore first 15 cycles
   reg [15:0]   cnt;
   reg rollover;

   always @(posedge clk or posedge rst)
     begin
	if (rst)
	  cnt <= 16'd0;
	else
	  begin
	     if (cnt != 16'd500)
	       cnt <= cnt + 16'd1;
	  end
     end

   reg [95:0] tod_d1;
   reg [95:0] tod_exp;
   reg [95:0] tod_exp1;

   always @(posedge clk)
     begin
	tod_d1 <= tod;
     end

   
   always @(*)
     begin
	tod_exp = tod_d1 + {76'd0,period};
	if (tod_exp[47:16] >= 32'd1_000_000_000)
	  begin
	     rollover = 1'b1;
	     if (TX_OR_RX == 1)
	       $display ("rollover in ns occourred in TX at time = %d tod_d1 = %h", $time, tod_d1);
	     else
	       $display ("rollover in ns occourred in TX at time = %d tod_d1 = %h", $time, tod_d1);
	     tod_exp1[47:16] = tod_exp[47:16] - 32'd1_000_000_000;
	     tod_exp1[95:48] = tod_exp[95:48] + 48'd1;
	     tod_exp1[15:0] = tod_exp[15:0];
	  end
	else
	  begin
	     tod_exp1 = tod_exp;
	     rollover = 1'b0;
	  end // else: !if(tod_exp[47:16] >= 32'd1_000_000_000)
     end
   
   reg incr_err;
     
   always @(negedge clk)
     begin
	if (cnt == 16'd500) // ignore first 500 cycles
	  begin
	     if (tod_exp1 != tod)
	       begin
		  $display ("xx tod = %h tod_d1 = %h tod_exp = %h period = %h", tod, tod_d1, tod_exp1, period);
		  
		  if (TX_OR_RX == 1)
		    $display ("aa tod incrementing error in txmclk at time %d ", $time);
		  else
		    $display ("bb tod incrementing error in rxmclk at time %d", $time);
		  incr_err <= 1'b1;
//		  $finish;
	       end // if (tod_exp1 != tod)
	     else
	       begin
		  incr_err <= 1'b0;
	       end // else: !if(tod_exp1 != tod)
	  end // if (cnt == 4'd500)
	else
	  begin
	     incr_err <= 1'b0;
	  end // else: !if(cnt == 16'd500)
     end // always @ (*)
endmodule // alt_aeu_tod_assrt

   
	     
