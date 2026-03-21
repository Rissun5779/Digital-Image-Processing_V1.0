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


module alt_xcvr_if_fanout_top #(
    parameter port_width=1,
    parameter num_bcast_outputs
) (
    input  [port_width-1:0] port_i,
    output [port_width*num_bcast_outputs-1:0] port_o
);
  
  genvar i;
  generate
    for(i=0;i<num_bcast_outputs;i=i+1) begin: ports
      assign port_o[(port_width*(i+1))-1:(port_width*i)] = port_i;
    end
  endgenerate
endmodule


