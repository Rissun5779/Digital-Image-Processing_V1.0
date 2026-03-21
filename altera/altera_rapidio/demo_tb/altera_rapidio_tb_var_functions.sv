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


// Package Declaration
package altera_rapidio_tb_var_functions;
parameter SUPPORT_4X    = 1'b1;
parameter SUPPORT_2X    = 1'b1;
parameter SUPPORT_1X    = 1'b1;
parameter LSIZE    =4;
parameter p_ref_clk_freq    ="156.25";
parameter p_TRANSPORT_LARGE    =1'b0 ;
parameter p_GENERIC_LOGICAL    = 1'b1;
parameter p_PROMISCUOUS    =1'b0 ;
parameter MAINTENANCE_ADDRESS_WIDTH    =26;
parameter p_IO_MASTER_WINDOWS    =1;
parameter IO_MASTER_ADDRESS_WIDTH    =32;
parameter IO_SLAVE_GUI    = 1'b1;
parameter p_IO_SLAVE_WINDOWS    =1;
parameter IO_SLAVE_ADDRESS_WIDTH    =32;
parameter SYS_CLK_FREQ    ="156.25";
parameter p_SYS_CLK_PERIOD    =6400;
parameter p_PRESCALER_VALUE    =3;
parameter REF_CLK_PERIOD    =6400;
parameter p_MAINTENANCE    = 1'b1;
parameter p_MAINTENANCE_MASTER    = 1'b1;
parameter p_MAINTENANCE_SLAVE    = 1'b1;
parameter p_TX_PORT_WRITE    =1'b0 ;
parameter p_RX_PORT_WRITE    =1'b0 ;
parameter p_DRBELL_TX    = 1'b1;
parameter p_DRBELL_RX = 1'b1;
parameter p_DRBELL_WRITE_ORDER = 1'b1;
parameter p_IO_MASTER    = 1'b1;
parameter p_IO_SLAVE    = 1'b1;
parameter mode_selection = "SERIAL_1X";
parameter REF_CLK_FREQ_WITH_UNIT    ="156.25 MHz";
parameter MAX_BAUD_RATE_WITH_UNIT    ="6250 Mbps";
parameter p_SEND_RESET_DEVICE = 1'b0;
parameter p_IO_SLAVE_WIDTH = 30;
parameter p_READ_WRITE_ORDER    =1'b0 ;
parameter p_timeout_enable = 1'b1;
parameter p_SOURCE_OPERATION_DATA_MESSAGE = 1'b0;
parameter p_DESTINATION_OPERATION_DATA_MESSAGE = 1'b0;
parameter XCVR_RECONFIG = 1'b1;
endpackage
