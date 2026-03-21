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


module tmr_maj_control (
  input clk,
  input reset_n,
  
  input [2:0] core_comparison,
  input [2:0] error_injection,
  
  output  wire [2:0] control_out,
  output  interrupt,
  output  reset_request
  );
  
  parameter ASIC_ENABLED = 0;

  reg [2:0] sticky_reg;
  wire [2:0] control_out_unfiltered;
  
  // Core comparison decoding
  wire [2:0] filter_core;
  
  assign filter_core[0] = core_comparison[2] & core_comparison[0];
  assign filter_core[1] = core_comparison[2] & core_comparison[1];
  assign filter_core[2] = core_comparison[1] & core_comparison[0];

  always @(posedge clk, negedge reset_n)
    begin
      if (reset_n == 0)  sticky_reg <= 0;
      else sticky_reg <= control_out;
      
    end
  assign control_out_unfiltered[0] =  error_injection[0] | sticky_reg[0] | filter_core[0];
  assign control_out_unfiltered[1] =  error_injection[1] | sticky_reg[1] | filter_core[1];
  assign control_out_unfiltered[2] =  error_injection[2] | sticky_reg[2] | filter_core[2];

  assign control_out[0] =  control_out_unfiltered[0];
  assign control_out[1] =  control_out_unfiltered[1];
  assign control_out[2] =  control_out_unfiltered[2];

  assign interrupt = | control_out;
  assign reset_request = & control_out;
  
endmodule
