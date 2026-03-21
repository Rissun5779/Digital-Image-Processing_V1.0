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


module alt_xcvr_12_bus_split_top #(
  parameter DWIDTH_I1 = 8,
  parameter DWIDTH_O1 = 8,
  parameter DWIDTH_O2 = 8,
  parameter CHANNELS  = 1
) (

  input  [DWIDTH_I1*CHANNELS-1:0] data_in1,
  output [DWIDTH_O1*CHANNELS-1:0] data_out1,
  output [DWIDTH_O2*CHANNELS-1:0] data_out2

);


genvar i;
generate 
  
  for(i=0; i<CHANNELS; i=i+1) begin: gen_split_12

    alt_xcvr_12_bus_split #(
      .DWIDTH_I1(DWIDTH_I1),
      .DWIDTH_O1(DWIDTH_O1),
      .DWIDTH_O2(DWIDTH_O2)
    ) split_12_inst (
      .port_i1(  data_in1[(i*DWIDTH_I1) +: DWIDTH_I1] ),
      .port_o1( data_out1[(i*DWIDTH_O1) +: DWIDTH_O1] ),
      .port_o2( data_out2[(i*DWIDTH_O2) +: DWIDTH_O2] )
    );
  
  end 

endgenerate

endmodule 
