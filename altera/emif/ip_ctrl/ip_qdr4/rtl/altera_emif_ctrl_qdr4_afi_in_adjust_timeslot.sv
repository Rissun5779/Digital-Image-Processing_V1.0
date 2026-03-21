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


module altera_emif_ctrl_qdr4_afi_in_adjust_timeslot #(
   parameter PORT_AFI_RDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH = 1,
   
   parameter NUM_OF_AVL_CHANNELS = 8,
   parameter AVL_CHANNEL_NUM = 0
) (
   input  logic [PORT_AFI_RDATA_WIDTH-1:0]                               afi_rdata_in,
   input  logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]                         afi_rdata_valid_in,

   output  logic [PORT_AFI_RDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]          afi_rdata_out,
   output  logic [PORT_AFI_RDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]    afi_rdata_valid_out
);
   timeunit 1ps;
   timeprecision 1ps;
   
   localparam SINGLE_SLOT_RDATA_WIDTH = PORT_AFI_RDATA_WIDTH / NUM_OF_AVL_CHANNELS;
   
   wire [PORT_AFI_RDATA_WIDTH-1:0] afi_rdata_shifted;
   wire [PORT_AFI_RDATA_VALID_WIDTH-1:0] afi_rdata_valid_shifted;
   
   assign afi_rdata_shifted = afi_rdata_in >> SINGLE_SLOT_RDATA_WIDTH*( (AVL_CHANNEL_NUM % 2 == 0) ? AVL_CHANNEL_NUM/2 : AVL_CHANNEL_NUM/2+4 );
   assign afi_rdata_valid_shifted = afi_rdata_valid_in >> ( (AVL_CHANNEL_NUM % 2 == 0) ? AVL_CHANNEL_NUM/2 : AVL_CHANNEL_NUM/2+4 );
   
   assign afi_rdata_out = afi_rdata_shifted[PORT_AFI_RDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0];
   assign afi_rdata_valid_out = afi_rdata_valid_shifted[PORT_AFI_RDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0];
endmodule
