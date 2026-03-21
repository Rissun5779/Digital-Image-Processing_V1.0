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


module altera_mirror_add (
   input            clk,
   input            reset,
   input            add,
   input      [7:0] addend,
   input            xfr,
   output reg [7:0] count
   );

   always @(posedge clk or posedge reset) begin
      if (reset) count <= 8'h0;
      else if (add) begin
         if (xfr) count <= addend;
         else     count <= count + addend;
      end
      else if (xfr) //and add not active
         count <= 8'h0;
   end
endmodule
