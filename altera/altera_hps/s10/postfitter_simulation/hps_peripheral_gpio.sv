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


module cyclonev_hps_peripheral_gpio 
#(
   parameter dummy_param = 0
)(
   input  wire [28:0] gpio0_porta_i,
   output wire [28:0] gpio0_porta_o,
   output wire [28:0] gpio0_porta_oe,
   input  wire [28:0] gpio1_porta_i,
   output wire [28:0] gpio1_porta_o,
   output wire [28:0] gpio1_porta_oe,
   input  wire [8:0]  gpio2_porta_i,
   output wire [8:0]  gpio2_porta_o,
   output wire [8:0]  gpio2_porta_oe
);

   assign gpio0_porta_o = 29'b0;
   assign gpio0_porta_oe = 29'b0;
   assign gpio1_porta_o = 29'b0;
   assign gpio1_porta_oe = 29'b0;
   assign gpio2_porta_o = 9'b0;
   assign gpio2_porta_oe = 9'b0;

endmodule 

module arriav_hps_peripheral_gpio 
#(
   parameter dummy_param = 0
)(
   input  wire [28:0] gpio0_porta_i,
   output wire [28:0] gpio0_porta_o,
   output wire [28:0] gpio0_porta_oe,
   input  wire [28:0] gpio1_porta_i,
   output wire [28:0] gpio1_porta_o,
   output wire [28:0] gpio1_porta_oe,
   input  wire [8:0]  gpio2_porta_i,
   output wire [8:0]  gpio2_porta_o,
   output wire [8:0]  gpio2_porta_oe
);

   assign gpio0_porta_o = 29'b0;
   assign gpio0_porta_oe = 29'b0;
   assign gpio1_porta_o = 29'b0;
   assign gpio1_porta_oe = 29'b0;
   assign gpio2_porta_o = 9'b0;
   assign gpio2_porta_oe = 9'b0;

endmodule 