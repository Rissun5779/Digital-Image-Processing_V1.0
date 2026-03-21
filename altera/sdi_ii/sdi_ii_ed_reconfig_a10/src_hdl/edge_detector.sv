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


//**********************************************************************************
// Edge Detector
//**********************************************************************************
`timescale 1 ns / 1 ps

module edge_detector #(
   parameter EDGE_DETECT = "POSEDGE"
) (
   input wire clk,
   input wire rst,
   input wire d,
   output reg q
);

reg d_reg;
always @ (posedge clk or posedge rst)
begin
   if (rst) begin
      d_reg <= 1'b0;
      q <= 1'b0;
   end else begin 
      d_reg <= d;

      if (EDGE_DETECT == "POSEDGE") begin
         q <= d & ~d_reg;
      end else if (EDGE_DETECT == "NEGEDGE") begin
         q <= ~d & d_reg;
      end else if (EDGE_DETECT == "DUAL_EDGE") begin
         q <= d ^ d_reg;
      end
   end
end

endmodule
