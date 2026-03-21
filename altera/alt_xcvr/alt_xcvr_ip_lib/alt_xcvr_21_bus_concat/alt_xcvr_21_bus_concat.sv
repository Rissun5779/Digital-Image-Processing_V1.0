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


module  alt_xcvr_21_bus_concat #(
    parameter DWIDTH_O1    = 8,    // Width of the data input
    parameter DWIDTH_I1    = 8,    // Width of the data output
    parameter DWIDTH_I2    = 8     // Width of the data output
) (
  output [DWIDTH_O1-1:0]  port_o1,
  input  [DWIDTH_I1-1:0]  port_i1,
  input  [DWIDTH_I2-1:0]  port_i2
);

 assign port_o1 = {port_i2, port_i1};

endmodule
