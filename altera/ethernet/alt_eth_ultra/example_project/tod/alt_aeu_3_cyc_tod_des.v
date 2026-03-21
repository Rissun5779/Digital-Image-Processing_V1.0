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

module alt_aeu_3_cyc_tod_des
  #(
   parameter SIM_ONLY = 1'b1
   )
  (
   input                   arst,
   input wr_tod,
   input [95:0] wr_tod_in,

   input wr_period,
   input [19:0] wr_period_in,

   output reg [95:0] tod_out,
   input clk
   );

   reg 		     wr_tod_d1, wr_tod_d2, wr_tod_d3;
   
   reg                    wr_tod0;
   wire [95:0] 		   wr_tod_in0;
   reg [23:0] 		   delta0;
   wire [95:0] 		   tod_out0;
   reg [23:0] 		   period0;
   
   reg                    wr_tod1;
   wire [95:0] 		   wr_tod_in1;
   reg [23:0] 		   delta1;
   wire [95:0] 		   tod_out1;
   reg [23:0] 		   period1;
   
   reg                    wr_tod2;
   wire [95:0] 		   wr_tod_in2;
   reg [23:0] 		   delta2;
   wire [95:0] 		   tod_out2;
   reg [23:0] 		   period2;

   reg 			   wr_tod_int;
   reg [1:0] 		   sel;

   reg [19:0] 		   period_new;
   reg [19:0] 		   period_old;
   

   initial sel = 2'b00;
   initial delta0 = 24'h07_AE14;
   initial delta1 = 24'h07_AE14;
   initial delta2 = 24'h07_AE14;
   
   always @(posedge clk or posedge arst)
     begin
	     case (sel) // synthesis parallel_case
	       2'b00: sel <= 2'b01;
	       2'b01: sel <= 2'b10;
	       default: sel <= 2'b00;
	     endcase // case (sel)
     end // always @ (posedge clk or posedge arst)

   reg [3:0] cnt;
   always @(posedge clk or posedge arst)
     begin
	if (arst)
	  cnt <= 4'b0001;
	else
	  cnt <= {cnt[2:0],1'b0};
     end
   
   always @(posedge clk)
     begin
	case (sel) // synthesis parallel_case
	  2'b00: tod_out <= tod_out0;
	  2'b01: tod_out <= tod_out1;
	  default: tod_out <= tod_out2;
	endcase // case (sel)
     end

   always @(posedge clk or posedge arst)
     begin
	if (arst)
	  begin
	     wr_tod0 <= 1'b0;
	     wr_tod1 <= 1'b0;
	     wr_tod2 <= 1'b0;
	     wr_tod_int <= 1'b0;
	     wr_tod_d1 <= 1'b0;
	     wr_tod_d2 <= 1'b0;
	     wr_tod_d3 <= 1'b0;
	  end
	else
	  begin
	     wr_tod_d1 <= wr_tod|cnt[3];
	     wr_tod_d2 <= wr_tod_d1;
	     wr_tod_d3 <= wr_tod_d2; // delay wr_tod by 3 cycles so that outputs from upd0,1,2 are ready
	     if (wr_tod_d3)
	       begin
		  wr_tod_int <= 1'b1;
	       end
	     else
	       begin
		  if (wr_tod0)
		    wr_tod_int <= 1'b0;
		  if (wr_tod_int & (sel == 2'b01))
		    wr_tod0 <= 1'b1;
		  else
		    wr_tod0 <= 1'b0;
	       end // else: !if(wr_tod)
	     wr_tod2 <= wr_tod1;
	     wr_tod1 <= wr_tod0;
	  end
     end // always @ (posedge clk or posedge arst)

   always @(posedge clk)
     begin
	period0 <= 24'd0;
	period1 <= {4'd0,period_new};
	period2 <= {3'd0,period_new,1'b0};
     end

   // three instances for updating tod
   // need to add period 
   alt_aeu_3_cyc_add_des upd0 // update tod 0
     (
      .arst(arst),
      .tod_in(wr_tod_in),
      .delta(period0),
      .tod_out(wr_tod_in0),
      .clk(clk)
      );

   alt_aeu_3_cyc_add_des upd1
     (
      .arst(arst),
      .tod_in(wr_tod_in),
      .delta(period1),
      .tod_out(wr_tod_in1),
      .clk(clk)
      );

   alt_aeu_3_cyc_add_des upd2
     (
      .arst(arst),
      .tod_in(wr_tod_in),
      .delta(period2),
      .tod_out(wr_tod_in2),
      .clk(clk)
      );

   reg wr_period_d1, wr_period_d2, wr_period_d3;
   reg wr_period0, wr_period1, wr_period2, wr_period_int;
   

   reg [23:0] period_new_mult_3, period_delta;
   
   always @(posedge clk)
     begin
	if (arst)
	  begin
	     wr_period_d1 <= 1'b0;
	     wr_period_d2 <= 1'b0;
	     wr_period_d3 <= 1'b0;
	  end
	else
	  begin
	     wr_period_d1 <= wr_period;
	     wr_period_d2 <= wr_period_d1;
	     wr_period_d3 <= wr_period_d2;
	  end
     end

   always @(posedge clk)
     begin
	if (arst)
	  begin
	     period_new <= 20'h2_8F5C;
	     period_old <= 20'h0_0000;
	  end
	else
	  begin
	     if (wr_period)
	       begin
		  period_new <= wr_period_in;
		  period_old <= period_new;
	       end
	  end // else: !if(arst)
	period_new_mult_3 <= {3'd0,period_new,1'b0} + {4'd0,period_new};
	period_delta <= period_new - period_old;
     end

   always @(posedge clk or posedge arst)
     begin
	if (arst)
	  begin
	     wr_period0 <= 1'b0;
	     wr_period1 <= 1'b0;
	     wr_period2 <= 1'b0;
	     wr_period_int <= 1'b0;
	  end
	else
	  begin
	     if (wr_period_d3)
	       begin
		  wr_period_int <= 1'b1;
	       end
	     else
	       begin
		  if (wr_period0)
		    wr_period_int <= 1'b0;
		  if (wr_period_int & (sel == 2'b01))
		    wr_period0 <= 1'b1;
		  else
		    wr_period0 <= 1'b0;
	       end // else: !if(wr_period)
	     wr_period1 <= wr_period0;
	     wr_period2 <= wr_period1;
	  end
     end // always @ (posedge clk or posedge arst)

   always @(posedge clk)
     begin
	if (arst)
	  begin
	     delta0 <= 24'h07_AE14;
	     delta1 <= 24'h07_AE14;
	     delta2 <= 24'h07_AE14;
	  end
	else
	  begin
	     if (wr_period0)
	       delta0 <= period_new_mult_3;
	     if (wr_period1)
	       delta1 <= delta0 + period_delta;
	     else
	       delta1 <= delta0;
	     if (wr_period2)
	       delta2 <= delta0 + 2*period_delta;
	     else
	       delta2 <= delta0;
	  end // else: !if(arst)
     end // always @ (posedge clk)

   // actual tod counters

   defparam tod0.INST_NUM = 0;
   alt_aeu_3_cyc_add_tod_des tod0
     (
      .arst(arst),
      .wr_tod(wr_tod0),
      .wr_tod_in(wr_tod_in0),
      .delta(delta0),
      .tod_out(tod_out0),
      .clk(clk)
      );

   defparam tod1.INST_NUM = 1;
   alt_aeu_3_cyc_add_tod_des tod1
     (
      .arst(arst),
      .wr_tod(wr_tod1),
      .wr_tod_in(wr_tod_in1),
      .delta(delta1),
      .tod_out(tod_out1),
      .clk(clk)
      );

   defparam tod2.INST_NUM = 2;
   alt_aeu_3_cyc_add_tod_des tod2
     (
      .arst(arst),
      .wr_tod(wr_tod2),
      .wr_tod_in(wr_tod_in2),
      .delta(delta2),
      .tod_out(tod_out2),
      .clk(clk)
      );

   /* synthesis translate_off */
   alt_aeu_tod_assrt asr
     (
      .rst(arst),
      .clk(clk),
      .tod(tod_out),
      .period(wr_period_in)
      );
   /* synthesis translate_on */

endmodule // alt_aeu_3_cyc_tod_des


