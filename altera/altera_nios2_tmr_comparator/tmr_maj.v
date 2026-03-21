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


module tmr_maj (
  a,
  b,
  c,
  en,

  control_in,
  status_out,
  q
  );
  
  parameter TMR_WIDTH = 1;

  input [TMR_WIDTH-1:0] a;
  input [TMR_WIDTH-1:0] b;
  input [TMR_WIDTH-1:0] c;

  input                 en;  
  input   [2:0] control_in;
  output  [2:0] status_out;
  
  output  [TMR_WIDTH-1:0] q;
  
  assign status_out[0] = | (a ^ c);
  assign status_out[1] = | (b ^ c);
  assign status_out[2] = | (a ^ b);
  
  assign q = ((a & ~{TMR_WIDTH{control_in[0]}}) | (b & ~{TMR_WIDTH{control_in[1]}}) | (c & ~{TMR_WIDTH{control_in[2]}})) & {TMR_WIDTH{en}};
  
endmodule
