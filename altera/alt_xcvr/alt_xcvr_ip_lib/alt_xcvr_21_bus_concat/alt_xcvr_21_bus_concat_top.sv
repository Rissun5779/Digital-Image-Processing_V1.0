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


module alt_xcvr_21_bus_concat_top #(
  parameter DWIDTH_O1 = 8,
  parameter DWIDTH_I1 = 8,
  parameter DWIDTH_I2 = 8,
  parameter CHANNELS  = 1
) (

  output [DWIDTH_O1*CHANNELS-1:0] data_out1,
  input  [DWIDTH_I1*CHANNELS-1:0] data_in1,
  input  [DWIDTH_I2*CHANNELS-1:0] data_in2

);


genvar i;
generate 
  
  for(i=0; i<CHANNELS; i=i+1) begin: gen_concat_21

    alt_xcvr_21_bus_concat #(
      .DWIDTH_O1(DWIDTH_O1),
      .DWIDTH_I1(DWIDTH_I1),
      .DWIDTH_I2(DWIDTH_I2)
    ) concat_21_inst (
      .port_o1( data_out1[(i*DWIDTH_O1) +: DWIDTH_O1] ),
      .port_i1(  data_in1[(i*DWIDTH_I1) +: DWIDTH_I1] ),
      .port_i2(  data_in2[(i*DWIDTH_I2) +: DWIDTH_I2] )
    );
  
  end

endgenerate

endmodule 
