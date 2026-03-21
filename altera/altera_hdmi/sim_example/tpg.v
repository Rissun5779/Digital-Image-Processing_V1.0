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


// *********************************************************************
//
//
// Bitec HDMI IP Core
// 
//
// All rights reserved. Property of Bitec.
// Restricted rights to use, duplicate or disclose this code are
// granted through contract.
// 
// (C) Copyright Bitec 2010,2011,2012
//       All rights reserved
//
// *********************************************************************
// Author         : $Author: Andy $ @ bitec-dsp.com
// Department     : 
// Date           : $Date: 2012-09-25 19:03:22 +0200 (Tue, 25 Sep 2012) $
// Revision       : $Revision: 16 $
// URL            : $URL: file://nas-bitec/svn/hdmi/bitec_hdmi/bitec_hdmi_tb.v $
// *********************************************************************
// Description
// 
//
// *********************************************************************

// synthesis translate_off
`timescale 1ns / 1ns
// synthesis translate_on


module  tpg  (
    clk,
    reset,
    current_x, current_y,
    v,h,de,
    h_front, h_sync, h_back, h_act,
    v_front, v_sync, v_back, v_act);
	
parameter PIXELS_PER_CLOCK=1;
input wire clk, reset;
output wire [16*PIXELS_PER_CLOCK-1:0] current_x,current_y;
output reg  [ 1*PIXELS_PER_CLOCK-1:0] v, h, de;

input wire [15:0] h_front, h_sync, h_back, h_act;
input wire [15:0] v_front, v_sync, v_back, v_act;

reg [15:0] h_cntr [PIXELS_PER_CLOCK-1:0];
reg [15:0] v_cntr [PIXELS_PER_CLOCK-1:0];
reg [15:0] x [PIXELS_PER_CLOCK-1:0];
reg [15:0] y [PIXELS_PER_CLOCK-1:0];

wire [15:0] h_blank = h_front+h_sync+h_back;
wire [15:0] h_total = h_front+h_sync+h_back+h_act;
wire [15:0] v_blank = v_front+v_sync+v_back;
wire [15:0] v_total = v_front+v_sync+v_back+v_act;

function [68:0] counter;

input v;
input h;
input h_active;
input v_active;
input [15:0] x;
input [15:0] y;
input [15:0] h_cntr;
input [15:0] v_cntr;

reg de;
  begin
    if(h_cntr != h_total-1) 
    begin
      h_cntr = h_cntr + 1;
      if (h_cntr == h_blank-1) h_active = 1;
    end
    else begin
      h_cntr  = 0;
      h_active = 0;
      x = 0;
    end
    
    if (h_cntr == h_front+h_sync) 
      h = 0;  

    if(h_cntr == h_front) 
    begin
      h = 1;
	  
      if(v_cntr != v_total-1) 
      begin
        v_cntr = v_cntr + 1;
        if (v_active) y = y + 1;
        if (v_cntr == v_blank) v_active = 1;
        
      end
      else 
      begin
        v_cntr = 0;
        y = 0;
        v_active = 0;
      end
      if(v_cntr == v_front) v = 1;
      if(v_cntr == v_front+v_sync) v = 0;
    end  

    if (de) x = x + 1; else x = 0;
       de = ((h_cntr>=h_blank && h_cntr<h_total)  &&
            (v_cntr>=v_blank && v_cntr<v_total));
    
       counter = {de, v, h, h_active, v_active, x, y, h_cntr, v_cntr};
  end
endfunction

wire [15:0] h_cntr_i [PIXELS_PER_CLOCK-1:0];
wire [15:0] v_cntr_i [PIXELS_PER_CLOCK-1:0];
wire [15:0] x_i [PIXELS_PER_CLOCK-1:0];
wire [15:0] y_i [PIXELS_PER_CLOCK-1:0];
wire [PIXELS_PER_CLOCK-1:0] v_active_i;
wire [PIXELS_PER_CLOCK-1:0] h_active_i;
reg  [PIXELS_PER_CLOCK-1:0] v_active;
reg  [PIXELS_PER_CLOCK-1:0] h_active;
wire [PIXELS_PER_CLOCK-1:0] de_i, v_i, h_i;
genvar i;
assign {de_i[0], v_i[0], h_i[0], h_active_i[0], v_active_i[0], x_i[0], y_i[0], h_cntr_i[0],v_cntr_i[0]} 
  = counter(v[PIXELS_PER_CLOCK-1],  h[PIXELS_PER_CLOCK-1], h_active[PIXELS_PER_CLOCK-1], v_active[PIXELS_PER_CLOCK-1], x[PIXELS_PER_CLOCK-1],y[PIXELS_PER_CLOCK-1],h_cntr[PIXELS_PER_CLOCK-1],v_cntr[PIXELS_PER_CLOCK-1]);
  
always @(posedge clk or posedge reset)
if(reset)
  begin
      {de[0], h_active[0], h[0], x[0], h_cntr[0]} <= {PIXELS_PER_CLOCK{35'd0}}; 
      {v[0], v_active[0], y[0], v_cntr[0]} <= {PIXELS_PER_CLOCK{34'd0}};
  end
else
  begin
      {de[0], v[0], h[0], h_active[0], v_active[0], x[0],y[0],h_cntr[0],v_cntr[0]} <= {de_i[0], v_i[0], h_i[0], h_active_i[0], v_active_i[0], x_i[0],y_i[0],h_cntr_i[0],v_cntr_i[0]};
  end
  
assign current_x[15:0] = x[0] & {16{de[0]}};
assign current_y[15:0] = y[0] & {16{de[0]}};
generate
  for(i=1;i<PIXELS_PER_CLOCK;i=i+1)
    begin : gen_cntrs
      assign current_x[i*16+:16] = x[i] & {16{de[i]}};
      assign current_y[i*16+:16] = y[i] & {16{de[i]}};

	    assign {de_i[i], v_i[i], h_i[i], h_active_i[i], v_active_i[i], x_i[i], y_i[i], h_cntr_i[i],v_cntr_i[i]} = counter(v_i[i-1], h_i[i-1], h_active_i[i-1], v_active_i[i-1], x_i[i-1],y_i[i-1],h_cntr_i[i-1],v_cntr_i[i-1]);
      always @(posedge clk or posedge reset)
      if(reset)
        begin
          {de[i]      } <= 0;
          {h_cntr[i]  } <= i; 
          {x[i]       } <= 0; 
          {h[i]       } <= 0; 
          {h_active[i]} <= 0;
          {v[i], v_active[i], y[i], v_cntr[i]} <= 34'd0;
        end
      else
        begin
          {de[i], v[i], h[i], h_active[i], v_active[i], x[i],y[i],h_cntr[i],v_cntr[i]} <= {de_i[i], v_i[i], h_i[i], h_active_i[i], v_active_i[i], x_i[i],y_i[i],h_cntr_i[i],v_cntr_i[i]};
        end
        
    end
endgenerate

endmodule

module tpg_tb();
reg reset;    
  initial 
    begin
      reset <= 1;
      #100 reset <= 0;
    end

reg clk;
initial
  clk = 0;
always
  #10 clk <= ~clk;  
  
tpg 
#(.PIXELS_PER_CLOCK(4)) dut(
    .clk (clk),
    .reset (reset),
    .current_x (), .current_y(),
    .v (),.h (),.de (),
    .h_front (4), .h_sync(4), .h_back (4), .h_act (5),
    .v_front (4), .v_sync (4), .v_back (4), .v_act (4)); 
  
endmodule
