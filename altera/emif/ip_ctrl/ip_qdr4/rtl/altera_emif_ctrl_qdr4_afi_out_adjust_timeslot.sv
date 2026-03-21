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


module altera_emif_ctrl_qdr4_afi_out_adjust_timeslot #(
   parameter PORT_AFI_ADDR_WIDTH = 1,
   parameter PORT_AFI_LD_N_WIDTH = 1, 
   parameter PORT_AFI_RW_N_WIDTH = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH = 1,
   parameter PORT_AFI_WDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH = 1,
   
   parameter NUM_OF_AVL_CHANNELS = 8,
   parameter AVL_CHANNEL_NUM = 0
) (
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_addr_in,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_ld_n_in,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                     afi_rw_n_in,
   input logic [PORT_AFI_WDATA_VALID_WIDTH/NUM_OF_AVL_CHANNELS-1:0]              afi_wdata_valid_in,
   input logic [PORT_AFI_WDATA_WIDTH/NUM_OF_AVL_CHANNELS-1:0]                    afi_wdata_in,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rdata_en_full_in,
   
   output logic [PORT_AFI_ADDR_WIDTH-1:0]                     afi_addr_out,
   output logic [PORT_AFI_LD_N_WIDTH-1:0]                     afi_ld_n_out,
   output logic [PORT_AFI_RW_N_WIDTH-1:0]                     afi_rw_n_out,
   output logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]              afi_wdata_valid_out,
   output logic [PORT_AFI_WDATA_WIDTH-1:0]                    afi_wdata_out,
   output logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]            afi_rdata_en_full_out
);
   timeunit 1ps;
   timeprecision 1ps;
   
   localparam SINGLE_SLOT_ADDR_WIDTH = PORT_AFI_ADDR_WIDTH / NUM_OF_AVL_CHANNELS;
   localparam SINGLE_SLOT_WDATA_WIDTH = PORT_AFI_WDATA_WIDTH / NUM_OF_AVL_CHANNELS;
   
   assign afi_addr_out = {{PORT_AFI_ADDR_WIDTH}{1'b0}} | ( afi_addr_in << SINGLE_SLOT_ADDR_WIDTH*AVL_CHANNEL_NUM );
   assign afi_ld_n_out = ~( ~{{{PORT_AFI_LD_N_WIDTH-PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS}{1'b1}}, afi_ld_n_in} << 2*( (AVL_CHANNEL_NUM % 2 == 0) ? AVL_CHANNEL_NUM/2 : AVL_CHANNEL_NUM/2+4 ) );
   assign afi_rw_n_out = ~( ~{{{PORT_AFI_RW_N_WIDTH-PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS}{1'b1}}, afi_rw_n_in} << 2*( (AVL_CHANNEL_NUM % 2 == 0) ? AVL_CHANNEL_NUM/2 : AVL_CHANNEL_NUM/2+4 ) );
   assign afi_wdata_valid_out = {{PORT_AFI_WDATA_VALID_WIDTH}{1'b0}} | ( afi_wdata_valid_in << ( (AVL_CHANNEL_NUM % 2 == 0) ? AVL_CHANNEL_NUM/2 : AVL_CHANNEL_NUM/2+4 ) );
   assign afi_wdata_out = {{PORT_AFI_WDATA_WIDTH}{1'b0}} | ( afi_wdata_in << SINGLE_SLOT_WDATA_WIDTH*( (AVL_CHANNEL_NUM % 2 == 0) ? AVL_CHANNEL_NUM/2 : AVL_CHANNEL_NUM/2+4 ) );
   assign afi_rdata_en_full_out = {{PORT_AFI_RDATA_EN_FULL_WIDTH}{1'b0}} | ( afi_rdata_en_full_in << ( (AVL_CHANNEL_NUM % 2 == 0) ? AVL_CHANNEL_NUM/2 : AVL_CHANNEL_NUM/2+4 ) );
endmodule
