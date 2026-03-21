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


// vx_version verilog
/*
******************************************************

MODULE_NAME =  rio
COMPANY =      Altera Corporation
WEB =          www.altera.com

FUNCTIONAL_DESCRIPTION :
 Top level for RapidIO system with optional transport and logical layers.
END_FUNCTIONAL_DESCRIPTION

SUB_MODULES = <call>

REVISION = $Id: //acds/main/ip/rapidio/rio/hw/src/rtl/sys/rio.v.erp#39 

LEGAL :
Copyright 2002-2013 Altera Corporation.  All rights reserved.
END_LEGAL

******************************************************

*/
// altera message_level Level2
// altera message_off 10036
// vx2 translate_off
(* message_disable = "14130, 13410, 15610, 14320, 14131" *)
//vx2 translate_on
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module  altera_rapidio_rio /* vx2 no_prefix */  /* synthesis altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION OFF" */ // Compute Metastability based on only the explicitely identified synchronizers.
#(
     parameter TX_PORT_WRITE = 1'b0,
     parameter RX_PORT_WRITE = 1'b0,
     parameter IS_X2_MODE = 1'b0,
     parameter IS_X4_MODE = 1'b0,
     parameter DRBELL_TX = 1'b0,
     parameter DRBELL_RX = 1'b0,
     parameter TRANSPORT_LARGE = 1'b0,
     parameter p_GENERIC_LOGICAL = 1'b0,
     parameter p_SEND_RESET_DEVICE = 1'b0,
     parameter p_IO_SLAVE_WIDTH = 30,
     parameter p_MAINTENANCE = 1'b1,
     parameter p_IO_MASTER = 1'b1,
     parameter p_IO_SLAVE = 1'b1,
     parameter p_TIMEOUT_ENABLE = 1'b1,
     parameter p_SOURCE_OPERATION_DATA_MESSAGE = 1'b0,
     parameter p_DESTINATION_OPERATION_DATA_MESSAGE = 1'b0,
     parameter DEVICE_ID_WIDTH = ((TRANSPORT_LARGE == 1'b1)? 16 : 8),
     parameter MAINTENANCE_ADDRESS_WIDTH = 26,
     parameter p_ADAT = 64,
     parameter p_ADAT_NUM_WORD = ((p_ADAT == 64)? 3 : 2),
     parameter p_ADAT_SIZE_WIDTH = ((p_ADAT == 64)? 6 : 7),
     parameter p_ADAT_BYTEENABLE_WIDTH = ((p_ADAT == 64)? 8 : 4),
      parameter p_ADAT_MTY_WIDTH = ((p_ADAT == 64)? 3 : 2),
     parameter p_IO_SLAVE_ADDRESS_LSB = ((p_ADAT == 64) ? 3 : 2),
     parameter XCVR_NUMBER_OF_BYTE = ((IS_X2_MODE == 1'b1)? 4 : 2),
     parameter NUMBER_OF_XCVR_CHANNELS = (IS_X2_MODE == 1'b1)? 2 : ((IS_X4_MODE == 1'b1)? 4 : 1),
     parameter IO_SLAVE_ADDRESS_WIDTH = (32-p_IO_SLAVE_WIDTH),
     parameter max_icnt = 3

)
(
rx_patterndetect,
rx_ctrldetect,
rx_out,
tx_in,
tx_ctrlenable,
txclk,
rxclk,
rxgxbclk,
txgxbclk,
sysclk,
reset_n,
rxreset_n,
txreset_n,
ef_ptr,
io_m_wr_waitrequest,
io_m_wr_write,
io_m_wr_address,
io_m_wr_writedata,
io_m_wr_byteenable,
io_m_wr_burstcount,
io_m_rd_clk,
io_m_rd_waitrequest,
io_m_rd_read,
io_m_rd_address,
io_m_rd_readdatavalid,
io_m_rd_readerror,
io_m_rd_readdata,
io_m_rd_burstcount,
io_s_wr_clk,
io_s_wr_chipselect,
io_s_wr_waitrequest,
io_s_wr_write,
io_s_wr_address,
io_s_wr_writedata,
io_s_wr_byteenable,
io_s_wr_burstcount,
io_s_rd_clk,
io_s_rd_chipselect,
io_s_rd_waitrequest,
io_s_rd_read,
io_s_rd_address,
io_s_rd_readdatavalid,
io_s_rd_readdata,
io_s_rd_burstcount,
io_s_rd_readerror,
drbell_s_clk,
drbell_s_chipselect,
drbell_s_waitrequest,
drbell_s_read,
drbell_s_write,
drbell_s_address,
drbell_s_writedata,
drbell_s_readdata,
drbell_s_irq,
mnt_m_clk,
mnt_m_waitrequest,
mnt_m_read,
mnt_m_write,
mnt_m_address,
mnt_m_writedata,
mnt_m_readdata,
mnt_m_readdatavalid,
mnt_s_clk,
mnt_s_chipselect,
mnt_s_waitrequest,
mnt_s_read,
mnt_s_write,
mnt_s_address,
mnt_s_writedata,
mnt_s_readdata,
mnt_s_readerror,
mnt_s_readdatavalid,
sys_mnt_s_clk,
sys_mnt_s_chipselect,
sys_mnt_s_waitrequest,
sys_mnt_s_read,
sys_mnt_s_write,
sys_mnt_s_address,
sys_mnt_s_writedata,
sys_mnt_s_readdata,
sys_mnt_s_irq,
gen_tx_ready,
gen_tx_valid,
gen_tx_startofpacket,
gen_tx_endofpacket,
gen_tx_error,
gen_tx_empty,
gen_tx_data,
gen_rx_ready,
gen_rx_valid,
gen_rx_startofpacket,
gen_rx_endofpacket,
gen_rx_empty,
gen_rx_data,
gen_rx_size,
rx_packet_dropped,
master_enable,
output_enable,
input_enable,
rx_errdetect,
port_initialized,
atxwlevel,
atxovf,
arxwlevel,
buf_av0,
buf_av1,
buf_av2,
buf_av3,
packet_transmitted,
packet_cancelled,
packet_accepted,
packet_retry,
packet_not_accepted,
packet_crc_error,
symbol_error,
port_error,
char_err,
multicast_event_rx,
multicast_event_tx,
rx_threshold_0,
rx_threshold_1,
rx_threshold_2,
txclk_timeout_prescaler,
sysclk_timeout_prescaler,
device_identifier,
device_vendor_id,
device_revision,
assembly_id,
assembly_vendor_id,
assembly_revision,
extended_features_ptr,
bridge_support,
memory_access,
processor_present,
switch_support,
number_of_ports,
port_number,
link_drvr_oe,
port_response_timeout,
no_sync_indicator,
error_detect_message_error_response,
error_detect_message_format_error,
error_detect_message_request_timeout,
error_capture_letter,
error_capture_mbox,
error_capture_msgseg_or_xmbox,
error_detect_illegal_transaction_decode,
error_detect_illegal_transaction_target,
error_detect_packet_response_timeout,
error_detect_unsolicited_response,
error_detect_unsupported_transaction,
error_capture_ftype,
error_capture_ttype,
error_capture_destination_id,
error_capture_source_id
);
// Maintenance slave address width
input [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0]  rx_patterndetect;
input [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_ctrldetect;
input [((XCVR_NUMBER_OF_BYTE * 8) * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_out;
output [((XCVR_NUMBER_OF_BYTE * 8) * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] tx_in;
output [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] tx_ctrlenable;
input txclk;
input rxclk;
input rxgxbclk;
input txgxbclk;
input sysclk;
input reset_n;
input rxreset_n;
input txreset_n;
input[15:0] ef_ptr;
input io_m_wr_waitrequest;
output io_m_wr_write;
output[32 - 1:0] io_m_wr_address;
output[p_ADAT - 1:0] io_m_wr_writedata;
output[p_ADAT_BYTEENABLE_WIDTH - 1:0] io_m_wr_byteenable;
output[p_ADAT_SIZE_WIDTH - 1:0] io_m_wr_burstcount;
input io_m_rd_clk;
input io_m_rd_waitrequest;
output io_m_rd_read;
output[32 - 1:0] io_m_rd_address;
input io_m_rd_readdatavalid;
input io_m_rd_readerror;
input[p_ADAT - 1:0] io_m_rd_readdata;
output[p_ADAT_SIZE_WIDTH - 1:0] io_m_rd_burstcount;
input io_s_wr_clk;
input io_s_wr_chipselect;
output io_s_wr_waitrequest;
input io_s_wr_write;
input [p_IO_SLAVE_WIDTH - p_IO_SLAVE_ADDRESS_LSB - 1:0] io_s_wr_address;
input [p_ADAT - 1:0] io_s_wr_writedata;
input [p_ADAT_BYTEENABLE_WIDTH - 1:0] io_s_wr_byteenable;
input [p_ADAT_SIZE_WIDTH - 1:0] io_s_wr_burstcount;
input io_s_rd_clk;
input io_s_rd_chipselect;
output io_s_rd_waitrequest;
input io_s_rd_read;
input [p_IO_SLAVE_WIDTH - p_IO_SLAVE_ADDRESS_LSB - 1:0] io_s_rd_address;
output io_s_rd_readdatavalid;
output [p_ADAT - 1:0] io_s_rd_readdata;
input [p_ADAT_SIZE_WIDTH - 1:0] io_s_rd_burstcount;
output io_s_rd_readerror;
input drbell_s_clk;
input drbell_s_chipselect;
output drbell_s_waitrequest;
input drbell_s_read;
input drbell_s_write;
input [3:0] drbell_s_address;
input [31:0] drbell_s_writedata;
output[31:0] drbell_s_readdata;
output drbell_s_irq;
input mnt_m_clk;
input mnt_m_waitrequest;
output mnt_m_read;
output mnt_m_write;
output[31:0] mnt_m_address;
output[31:0] mnt_m_writedata;
input[31:0] mnt_m_readdata;
input mnt_m_readdatavalid;
input mnt_s_clk;
input mnt_s_chipselect;
output mnt_s_waitrequest;
input mnt_s_read;
input mnt_s_write;
input[MAINTENANCE_ADDRESS_WIDTH - 3:0] mnt_s_address;
input[31:0] mnt_s_writedata;
output[31:0] mnt_s_readdata;
output mnt_s_readerror;
output mnt_s_readdatavalid;
input sys_mnt_s_clk;
input sys_mnt_s_chipselect;
output sys_mnt_s_waitrequest;
input sys_mnt_s_read;
input sys_mnt_s_write;
input[14:0] sys_mnt_s_address;
input[31:0] sys_mnt_s_writedata;
output[31:0] sys_mnt_s_readdata;
output sys_mnt_s_irq;
output rx_packet_dropped;
output master_enable;
input output_enable;
input input_enable;
input [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_errdetect;
output port_initialized;
output[9 - 1:0] atxwlevel;
output atxovf;
output[10-1:0] arxwlevel;
output buf_av0;
output buf_av1;
output buf_av2;
output buf_av3;
output packet_transmitted;
output packet_cancelled;
output packet_accepted;
output packet_retry;
output packet_not_accepted;
output packet_crc_error;
output symbol_error;
output port_error;
output char_err;
output multicast_event_rx;
input multicast_event_tx;
input[9:0] rx_threshold_0;
input[9:0] rx_threshold_1;
input[9:0] rx_threshold_2;
input[6:0] txclk_timeout_prescaler;
input[6:0] sysclk_timeout_prescaler;
input[15:0] device_identifier;
input[15:0] device_vendor_id;
input[31:0] device_revision;
input[15:0] assembly_id;
input[15:0] assembly_vendor_id;
input[15:0] assembly_revision;
input[15:0] extended_features_ptr;
input bridge_support;
input memory_access;
input processor_present;
input switch_support;
input[7:0] number_of_ports;
input[7:0] port_number;
output  link_drvr_oe;
output gen_tx_ready;
input  gen_tx_valid;
input  gen_tx_startofpacket;
input  gen_tx_endofpacket;
input  gen_tx_error;
input  [p_ADAT_MTY_WIDTH-1:0] gen_tx_empty;
input  [p_ADAT-1:0] gen_tx_data;
input   gen_rx_ready;
output wire gen_rx_valid;
output wire gen_rx_startofpacket;
output wire gen_rx_endofpacket;
output wire [p_ADAT_MTY_WIDTH-1:0] gen_rx_empty;
output wire [p_ADAT-1:0] gen_rx_data;
output wire [p_ADAT_SIZE_WIDTH-1:0] gen_rx_size;
output wire [23:0] port_response_timeout  ;
output wire no_sync_indicator;
input error_detect_message_error_response;
input error_detect_message_format_error;
input error_detect_message_request_timeout;
input [1:0] error_capture_letter;
input [1:0] error_capture_mbox;
input [3:0] error_capture_msgseg_or_xmbox;
input error_detect_illegal_transaction_decode;
input error_detect_illegal_transaction_target;
input error_detect_packet_response_timeout;
input error_detect_unsolicited_response;
input error_detect_unsupported_transaction;
input [3:0] error_capture_ftype;
input [3:0] error_capture_ttype;
input [15:0] error_capture_destination_id;
input [15:0] error_capture_source_id;

//***************************************************
// Local parameter declaration
//***************************************************
localparam ATLANTIC_WIDTH = ((IS_X4_MODE == 1'b0) & (IS_X2_MODE == 1'b0))? 32 : 64;
localparam PORT_WRITE_ENABLE = ((TX_PORT_WRITE == 1'b1) && (RX_PORT_WRITE == 1'b1))? 1'b1: 1'b0;

// ***************************************************
// internal_variables (flop, signal, reg, wire, etc.)
// ***************************************************
// Metaharden the master_enable signal to the sysclk domain
wire  [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_patterndetect  /* RIO receiver pattern detect data input. */
/* vx2 port_info <desc scope="external" /> <grpmember grpid="rio"/> <desc>RIO receiver pattern detect data input.</desc> */;
wire  [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_ctrldetect  /* RIO receiver control character detection data input. */
/* vx2 port_info <desc scope="external" /> <grpmember grpid="rio"/> <desc>RIO receiver control character detection data input.</desc> */;
wire  [((XCVR_NUMBER_OF_BYTE * 8) * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_out  /* RIO receive data input. */
/* vx2 port_info <desc scope="external" /> <grpmember grpid="rio"/> <desc>RIO receive data input.</desc> */;
wire  [((XCVR_NUMBER_OF_BYTE * 8) * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] tx_in  /* RIO transmit data output. */
/* vx2 port_info <desc scope="external" /> <grpmember grpid="rio"/> <desc>RIO transmit data output.</desc> */;
wire  [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] tx_ctrlenable  /* RIO transmit control enable data outptu. */
/* vx2 port_info <desc scope="external" /> <grpmember grpid="rio"/> <desc>RIO transmit control enable data outptu.</desc> */;
/********************************/
/* Clocks and reset             */
/********************************/
wire  txclk  /* RapidIO TX internal clock. */
/* vx2 port_info <desc scope="external"/> <grpmember grpid="cnr"/> <desc>RapidIO TX internal clock.</desc> */;
wire  rxclk  /* RapidIO RX internal clock. */
/* vx2 port_info <desc scope="external"/> <grpmember grpid="cnr"/> <desc>RapidIO RX internal clock.</desc> */;
/* Recovered Clock */
wire  sysclk  /* Transport and Logical layers clock. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="cnr"/> <desc>Transport and Logical layers clock.</desc> */;
/* Main system clock, drives everything except the physical layer. */
wire  reset_n  /* System reset. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="cnr"/> <desc>System reset.</desc> */;
/* Reset is async assert and sync deassert to sysclk */
wire  [15:0] ef_ptr  /* Extended feature pointer. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_reg"/> <desc>Extended feature pointer.</desc> */;
///////////////////////////////////////
// Input Output Master Logical Layer //
///////////////////////////////////////
/******************************************/
/* IO MAster Datapath Write Avalon Master */
/******************************************/
//ptf: MASTER io_master_datapath_write_avalon_master {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "native";
//ptf:       Address_Width = "32";
//ptf:       Data_Width = "64";
//ptf:       Has_IRQ = "0";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {

wire  io_m_wr_waitrequest  /* I/O Master write wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master write wait request.</desc> */;
//ptf:       PORT io_m_wr_waitrequest { type = "waitrequest"; }
wire  io_m_wr_write  /* I/O Master write enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master write enable.</desc> */;
//ptf:       PORT io_m_wr_write       { type = "write";       }
wire  [32 - 1:0] io_m_wr_address  /* I/O Master write address. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master write address.</desc> */;
//ptf:       PORT io_m_wr_address     { type = "address";     }
wire  [p_ADAT - 1:0] io_m_wr_writedata  /* I/O Master write data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master write data.</desc> */;
//ptf:       PORT io_m_wr_writedata   { type = "writedata";   }
wire  [p_ADAT_BYTEENABLE_WIDTH - 1:0] io_m_wr_byteenable  /* I/O Master write byte enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master write byte enable.</desc> */;
//ptf:       PORT io_m_wr_byteenable  { type = "byteenable";  }
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_m_wr_burstcount  /* I/O Master write burst count. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master write burst count.</desc> */;
//ptf:       PORT io_m_wr_burstcount  { type = "burstcount";  }
//ptf:    }
//ptf: }
/******************************************/
/* IO Master Datapath Read Avalon Master  */
/******************************************/
//ptf: MASTER io_master_datapath_write_avalon_master {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "native";
//ptf:       Address_Width = "32";
//ptf:       Data_Width = "64";
//ptf:       Has_IRQ = "0";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {
wire  io_m_rd_clk  /* I/O Master read clock. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read clock.</desc> */;
//ptf:       PORT io_m_rd_clk           { type = "clk";           }
wire  io_m_rd_waitrequest  /* I/O Master read wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read wait request.</desc> */;
//ptf:       PORT io_m_rd_waitrequest   { type = "waitrequest";   }
wire  io_m_rd_read  /* I/O Master read enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read enable.</desc> */;
//ptf:       PORT io_m_rd_read          { type = "read";          }
wire  [32 - 1:0] io_m_rd_address  /* I/O Master read address. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read address.</desc> */;
//ptf:       PORT io_m_rd_address       { type = "address";       }
wire  io_m_rd_readdatavalid  /* I/O Master read data valid. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read data valid.</desc> */;
//ptf:       PORT io_m_rd_readdatavalid { type = "readdatavalid"; }
wire  io_m_rd_readerror  /* I/O Master read error. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read error.</desc> */;
//ptf:       PORT io_m_rd_readerror     { type = "endofpacket";   }
wire  [p_ADAT - 1:0] io_m_rd_readdata  /* I/O Master read data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read data.</desc> */;
//ptf:       PORT io_m_rd_readdata      { type = "readdata";      }
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_m_rd_burstcount  /* I/O Master read burst count. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Master read burst count.</desc> */;
//ptf:       PORT io_m_rd_burstcount    { type = "burstcount";    }
//ptf:    }
//ptf: }
///////////////////////////////////////
// Input Output Slave Logical Layer  //
///////////////////////////////////////
/*****************************************/
/* IO Slave Datapath Write Avalon Slave  */
/*****************************************/
//ptf: SLAVE io_slave_datapath_write_avalon_slave {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "dynamic";
//ptf:       Address_Width = "32";
//ptf:       Data_Width = "64";
//ptf:       Has_IRQ = "0";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {
wire  io_s_wr_clk  /* I/O Slave write clk. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write clk.</desc> */;
//ptf:       PORT io_s_wr_clk         { type = "clk";         }
wire  io_s_wr_chipselect  /* I/O Slave write chip select. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write chip select.</desc> */;
//ptf:       PORT io_s_wr_chipselect  { type = "chipselect";  }
wire  io_s_wr_waitrequest  /* I/O Slave write wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write wait request.</desc> */;
//ptf:       PORT io_s_wr_waitrequest { type = "waitrequest"; }
wire  io_s_wr_write  /* I/O Slave write write enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write write enable.</desc> */;
//ptf:       PORT io_s_wr_write       { type = "write";       }
wire  [p_IO_SLAVE_WIDTH - p_IO_SLAVE_ADDRESS_LSB - 1:0] io_s_wr_address  /* I/O Slave write address. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write address.</desc> */;
//ptf:       PORT io_s_wr_address     { type = "address";     }
wire  [p_ADAT - 1:0] io_s_wr_writedata  /* I/O Slave write data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write data.</desc> */;
//ptf:       PORT io_s_wr_writedata   { type = "writedata";   }
wire  [p_ADAT_BYTEENABLE_WIDTH - 1:0] io_s_wr_byteenable  /* I/O Slave write byte enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write byte enable.</desc> */;
//ptf:       PORT io_s_wr_byteenable  { type = "byteenable";  }
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_s_wr_burstcount  /* I/O Slave write burst count. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave write burst count.</desc> */;
//ptf:       PORT io_s_wr_burstcount  { type = "burstcount";  }
//ptf:    }
//ptf: }
/*****************************************/
/* IO Slave Datapath Read Avalon Slave   */
/*****************************************/
//ptf: SLAVE io_slave_datapath_read_avalon_slave {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "dynamic";
//ptf:       Address_Width = "32";
//ptf:       Data_Width = "64";
//ptf:       Has_IRQ = "0";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {
wire  io_s_rd_clk  /* I/O Slave read clk. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read clk.</desc> */;
//ptf:       PORT io_s_rd_clk           { type = "clk";           }
wire  io_s_rd_chipselect  /* I/O Slave read chip select. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read chip select.</desc> */;
//ptf:       PORT io_s_rd_chipselect    { type = "chipselect";    }
wire  io_s_rd_waitrequest  /* I/O Slave read wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read wait request.</desc> */;
//ptf:       PORT io_s_rd_waitrequest   { type = "waitrequest";   }
wire  io_s_rd_read  /* I/O Slave read enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read enable.</desc> */;
//ptf:       PORT io_s_rd_read          { type = "read";          }
wire  [p_IO_SLAVE_WIDTH - p_IO_SLAVE_ADDRESS_LSB - 1:0] io_s_rd_address  ;
//ptf:       PORT io_s_rd_address       { type = "address";       }
wire  io_s_rd_readdatavalid  /* I/O Slave read data valid. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read data valid.</desc> */;
//ptf:       PORT io_s_rd_readdatavalid { type = "readdatavalid"; }
wire  [p_ADAT - 1:0] io_s_rd_readdata  /* I/O Slave read data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read data.</desc> */;
//ptf:       PORT io_s_rd_readdata      { type = "readdata";      }
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_s_rd_burstcount  /* I/O Slave read burst count. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read burst count.</desc> */;
//ptf:       PORT io_s_rd_burstcount    { type = "burstcount";    }
wire  io_s_rd_readerror  /* I/O Slave read error. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>I/O Slave read error.</desc> */;
//ptf:       PORT io_s_rd_readerror     { type = "endofpacket";   }
//ptf:    }
//ptf: }
///////////////////////////////////////
// Doorbell Logical Layer  //
///////////////////////////////////////
/*****************************************/
/* Doorbell Avalon Slave     */
/*****************************************/
//ptf: SLAVE doorbell_avalon_slave {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "native";
//ptf:       Address_Width = "6";
//ptf:       Data_Width = "32";
//ptf:       Has_IRQ = "1";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {
wire  drbell_s_clk  /* Doorbell slave clock.(Not used.) */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave clock.(Not used.)</desc> */;
//ptf:       PORT drbell_s_clk         { type = "clk";         }
wire  drbell_s_chipselect  /* Doorbell slave chip select. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave chip select.</desc> */;
//ptf:       PORT drbell_s_chipselect  { type = "chipselect";  }
wire  drbell_s_waitrequest  /* Doorbell slave wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave wait request.</desc> */;
//ptf:       PORT drbell_s_waitrequest { type = "waitrequest"; }
wire  drbell_s_read  /* Doorbell slave read enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave read enable.</desc> */;
//ptf:       PORT drbell_s_read        { type = "read";        }
wire  drbell_s_write  /* Doorbell slave write enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave write enable.</desc> */;
//ptf:       PORT drbell_s_write       { type = "write";       }
wire  [3:0] drbell_s_address  /* Doorbell slave address. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave address.</desc> */;
//ptf:       PORT drbell_s_address     { type = "address";     }
wire  [31:0] drbell_s_writedata  /* Doorbell slave write data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave write data.</desc> */;
//ptf:       PORT drbell_s_writedata   { type = "writedata";   }
wire  [31:0] drbell_s_readdata  /* Doorbell slave read data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave read data.</desc> */;
//ptf:       PORT drbell_s_readdata    { type = "readdata";    }
wire  drbell_s_irq  /* Doorbell slave interrupt. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Doorbell slave interrupt.</desc> */;
//ptf:       PORT drbell_s_irq         { type = "irq";         }
//ptf:    }
//ptf: }
///////////////////////////////
// Maintenance Logical Layer //
///////////////////////////////
/*************************************/
/* Maintenance main Avalon Master    */
/*************************************/
//ptf: MASTER maintenance_master_avalon_master {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "native";
//ptf:       Address_Width = "32";
//ptf:       Data_Width = "32";
//ptf:       Has_IRQ = "0";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {
wire  mnt_m_clk  /* Maintenance Master clk. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master clk.</desc> */;
//ptf:       PORT mnt_m_clk           { type = "clk";         }
wire  mnt_m_waitrequest  /* Maintenance Master wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master wait request.</desc> */;
//ptf:       PORT mnt_m_waitrequest   { type = "waitrequest"; }
wire  mnt_m_read  /* Maintenance Master read enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master read enable.</desc> */;
//ptf:       PORT mnt_m_read          { type = "read";        }
wire  mnt_m_write  /* Maintenance Master write enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master write enable.</desc> */;
//ptf:       PORT mnt_m_write         { type = "write";       }
wire  [31:0] mnt_m_address  /* Maintenance Master address. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master address.</desc> */;
//ptf:       PORT mnt_m_address       { type = "address";     }
wire  [31:0] mnt_m_writedata  /* Maintenance Master write data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master write data.</desc> */;
//ptf:       PORT mnt_m_writedata     { type = "writedata";   }
wire  [31:0] mnt_m_readdata  /* Maintenance Master read data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master read data.</desc> */;
//ptf:       PORT mnt_m_readdata      { type = "readdata";    }
wire  mnt_m_readdatavalid  /* Maintenance Master read data valid. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Master read data valid.</desc> */;
//ptf:       PORT mnt_m_readdatavalid { type = "readdatavalid"; }
//ptf:    }
//ptf: }
/*************************************/
/* Maintenance main Avalon Slave     */
/*************************************/
//ptf: SLAVE system_maintenance_slave_avalon_slave {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "native";
//ptf:       Address_Width = "26";
//ptf:       Data_Width = "32";
//ptf:       Has_IRQ = "0";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {
wire  mnt_s_clk  /* Maintenance Slave clk. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave clk.</desc> */;
//ptf:       PORT mnt_s_clk           { type = "clk";         }
wire  mnt_s_chipselect  /* Maintenance Slave chip select. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave chip select.</desc> */;
//ptf:       PORT mnt_s_chipselect    { type = "chipselect";  }
wire  mnt_s_waitrequest  /* Maintenance Slave wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave wait request.</desc> */;
//ptf:       PORT mnt_s_waitrequest   { type = "waitrequest"; }
wire  mnt_s_read  /* Maintenance Slave read enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave read enable.</desc> */;
//ptf:       PORT mnt_s_read          { type = "read";        }
wire  mnt_s_write  /* Maintenance Slave write enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave write enable.</desc> */;
//ptf:       PORT mnt_s_write         { type = "write";       }
wire  [MAINTENANCE_ADDRESS_WIDTH - 3:0] mnt_s_address  /* Maintenance Slave write address. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave write address.</desc> */;
//ptf:       PORT mnt_s_address       { type = "address"; width = "26"    }
wire  [31:0] mnt_s_writedata  /* Maintenance Slave write data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave write data.</desc> */;
//ptf:       PORT mnt_s_writedata     { type = "writedata";   }
wire  [31:0] mnt_s_readdata  /* Maintenance Slave read data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave read data.</desc> */;
//ptf:       PORT mnt_s_readdata      { type = "readdata";    }
wire  mnt_s_readerror  /* Maintenance Slave read error. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave read error.</desc> */;
//ptf:       PORT mnt_s_readerror     { type = "endofpacket";   }
wire  mnt_s_readdatavalid  /* Maintenance Slave read data valid. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>Maintenance Slave read data valid.</desc> */;
//ptf:       PORT mnt_s_readdatavalid { type = "readdatavalid"; }
//ptf:    }
//ptf: }
/***********************************/
/* System Maintenance Avalon Slave */
/***********************************/
/*************************************/
/* Maintenance main Avalon Slave     */
/*************************************/
//ptf: SLAVE system_maintenance_slave_avalon_slave {
//ptf:    SYSTEM_BUILDER_INFO {
//ptf:       Bus_Type = "avalon";
//ptf:       Address_Alignment = "native";
//ptf:       Address_Width = "17";
//ptf:       Data_Width = "32";
//ptf:       Has_IRQ = "1";
//ptf:       Has_Base_Address = "1";
//ptf:       Write_Wait_States = "peripheral_controlled";
//ptf:       Read_Wait_States = "peripheral_controlled";
//ptf:       Is_Memory_Device = "0";
//ptf:       Uses_Tri_State_Data_Bus = "0";
//ptf:       Is_Enabled = "1";
//ptf:    }
//ptf:    PORT_WIRING {
wire  sys_mnt_s_clk  /* System maintenance slave clock. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave clock.</desc> */;
//ptf:       PORT sys_mnt_s_clk         { type = "clk";         }
wire  sys_mnt_s_chipselect  /* System maintenance slave chip select. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave chip select.</desc> */;
//ptf:       PORT sys_mnt_s_chipselect  { type = "chipselect";  }
wire  sys_mnt_s_waitrequest  /* System maintenance slave wait request. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave wait request.</desc> */;
//ptf:       PORT sys_mnt_s_waitrequest { type = "waitrequest"; }
wire  sys_mnt_s_read  /* System maintenance slave read enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave read enable.</desc> */;
//ptf:       PORT sys_mnt_s_read        { type = "read";        }
wire  sys_mnt_s_write  /* System maintenance slave write enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave write enable.</desc> */;
//ptf:       PORT sys_mnt_s_write       { type = "write";       }
wire  [14:0] sys_mnt_s_address  /* System maintenance slave address. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave address.</desc> */;
//ptf:       PORT sys_mnt_s_address     { type = "address";     }
wire  [31:0] sys_mnt_s_writedata  /* System maintenance slave write data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave write data.</desc> */;
//ptf:       PORT sys_mnt_s_writedata   { type = "writedata";   }
wire  [31:0] sys_mnt_s_readdata  /* System maintenance slave read data. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave read data.</desc> */;
//ptf:       PORT sys_mnt_s_readdata    { type = "readdata";    }
wire  sys_mnt_s_irq  /* System maintenance slave interrupt. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="avl"/> <desc>System maintenance slave interrupt.</desc> */;
//ptf:       PORT sys_mnt_s_irq         { type = "irq";         }
//ptf:    }
//ptf: }
wire  rx_packet_dropped  /* A received packet is dropped. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>A received packet is dropped.</desc> */;
/********************************/
/* Other Miscellaneous Signals  */
/********************************/
/* Register Bits */
wire  master_enable  /* Indicates that the EndPoint is authorized to send request packets. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_glo"/> <desc>Indicates that the EndPoint is authorized to send request packets.</desc> */;
/* Master Enable field of the Port General Control CSR */
wire  output_enable  /* Output port enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Output port enable.</desc> */;
/* ORed with Output Port Enable CSR */
wire  input_enable  /* Input port enable. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Input port enable.</desc> */;
/* ORed with Input Port Enable CSR */
wire  [(XCVR_NUMBER_OF_BYTE * NUMBER_OF_XCVR_CHANNELS) - 1 : 0] rx_errdetect  /* Transceiver received error. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>Transceiver received error.</desc> */;
/* From ALTGXB Serializer */
/* Physical Informative Signals */
wire  port_initialized  /* Port initialization has been completed. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_glo"/> <desc>Port initialization has been completed.</desc> */;
wire  [8:0] atxwlevel  /* Atlantic Transmit buffer write level. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="aif"/> <desc>Atlantic Transmit buffer write level.</desc> */;
wire  atxovf  /* Atlantic Transmit buffer overflow. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="aif"/> <desc>Atlantic Transmit buffer overflow.</desc> */;
wire  [9:0] arxwlevel  /* Atlantic receive buffer write level. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="aif"/> <desc>Atlantic receive buffer write level.</desc> */;
wire  buf_av0  /* Buffer avaliable signal; relates to priority retry threshold 0. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>Buffer avaliable signal; relates to priority retry threshold 0.</desc> */;
wire  buf_av1  /* Buffer avaliable signal; relates to priority retry threshold 1. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>Buffer avaliable signal; relates to priority retry threshold 1.</desc> */;
wire  buf_av2  /* Buffer avaliable signal; relates to priority retry threshold 2. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>Buffer avaliable signal; relates to priority retry threshold 2.</desc> */;
wire  buf_av3  /* Buffer avaliable signal; relates to priority retry threshold 3. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>Buffer avaliable signal; relates to priority retry threshold 3.</desc> */;
wire  packet_transmitted  /* Packet transmission completes normally. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>Packet transmission completes normally.</desc> */;
wire  packet_cancelled  /* Packet transmission is cancelled. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>Packet transmission is cancelled.</desc> */;
wire  packet_accepted  /* A packet-accepted symbol is being transmitted. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>A packet-accepted symbol is being transmitted.</desc> */;
wire  packet_retry  /* A packet-retry symbol is being transmitted. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>A packet-retry symbol is being transmitted.</desc> */;
wire  packet_not_accepted  /* A packet-not-accepted symbol is being transmitted. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>A packet-not-accepted symbol is being transmitted.</desc> */;
wire  packet_crc_error  /* A CRC error is detected in a received packet. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>A CRC error is detected in a received packet.</desc> */;
wire  symbol_error  /* A corrupt symbol is received. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>A corrupt symbol is received.</desc> */;
wire  port_error  /* A fatal error has been encountered. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>A fatal error has been encountered.</desc> */;
wire  char_err  /* An invalid character or a valid but illegal character is detected. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_err"/> <desc>An invalid character or a valid but illegal character is detected.</desc> */;
wire  multicast_event_rx  /* Toggles when a multicast-event control symbol is received. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_glo"/> <desc>Toggles when a multicast-event control symbol is received.</desc> */;
wire  multicast_event_tx  /* Toggled to request a multicast-event control symbol be sent. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_glo"/> <desc>Toggled to request a multicast-event control symbol be sent.</desc> */;
/**************************/
/* MegaWizard Set Signals */
/**************************/
/* RX PHY3 Buffer Threshold Connect Inputs */
wire  [9:0] rx_threshold_0  /* Priority retry threshold 0. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Priority retry threshold 0.</desc> */;
wire  [9:0] rx_threshold_1  /* Priority retry threshold 1. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Priority retry threshold 1.</desc> */;
wire  [9:0] rx_threshold_2  /* Priority retry threshold 2. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Priority retry threshold 2.</desc> */;
wire  [6:0] txclk_timeout_prescaler  /* Port link timeout prescaler. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Port link timeout prescaler.</desc> */;
/* MegaWizard Derived Connect Inputs */
wire  [6:0] sysclk_timeout_prescaler  /* System timeout prescaler. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>System timeout prescaler.</desc> */;
/* Port Response Timeout */
/* CARs and CSRs Connected Inputs */
wire  [15:0] device_identifier  /* Device identifier. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Device identifier.</desc> */;
wire  [15:0] device_vendor_id  /* Device vendor identity. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Device vendor identity.</desc> */;
wire  [31:0] device_revision  /* Device revision level. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Device revision level.</desc> */;
wire  [15:0] assembly_id  /* Assembly identity. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Assembly identity.</desc> */;
wire  [15:0] assembly_vendor_id  /* Assembly Vendor Identity. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Assembly Vendor Identity.</desc> */;
wire  [15:0] assembly_revision  /* Assembly revision. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Assembly revision.</desc> */;
wire  [15:0] extended_features_ptr  /* Extended feature pointer. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Extended feature pointer.</desc> */;
wire  bridge_support  /* Bridge support. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Bridge support.</desc> */;
wire  memory_access  /* Memory access. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Memory access.</desc> */;
wire  processor_present  /* Processor present. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Processor present.</desc> */;
wire  switch_support  /* Switch support. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Switch support.</desc> */;
wire  [7:0] number_of_ports  /* Number of ports. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Number of ports.</desc> */;
wire  [7:0] port_number  /* Port number. */
/* vx2 port_info <desc scope="internal"/> <grpmember grpid="doc_cnt"/> <desc>Port number.</desc> */;
reg  master_enable_meta  /* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name SYNCHRONIZER_TOGGLE_RATE 1; disable_da_rule=\"d101,d103\"" */;
reg  master_enable_sync  /* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name SYNCHRONIZER_TOGGLE_RATE 1" */;
wire  simulation_speedup  ;
// vx2 translate_off
`ifdef QUARTUS__SIMGEN
assign simulation_speedup = 1'b1;
`else
assign simulation_speedup = 1'b0;
`endif
// vx2 translate_on

//wire io_m_mnt_s_clk;
wire  io_m_mnt_s_chipselect  ;
wire  io_m_mnt_s_waitrequest  ;
wire  io_m_mnt_s_read  ;
wire  io_m_mnt_s_write  ;
wire  [8 - 1:0] io_m_mnt_s_address  ;
wire  [31:0] io_m_mnt_s_writedata  ;
wire  [31:0] io_m_mnt_s_readdata  ;
wire  io_m_rx_ready  ;
wire  io_m_rx_valid  ;
wire  [p_ADAT - 1:0] io_m_rx_data  ;
wire  [p_ADAT_NUM_WORD - 1:0] io_m_rx_empty  ;
wire  io_m_rx_start_packet  ;
wire  io_m_rx_end_packet  ;
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_m_rx_packet_size  ;
wire  io_m_tx_packet_available  ;
wire  io_m_tx_ready  ;
wire  io_m_tx_valid  ;
wire  [p_ADAT - 1:0] io_m_tx_data  ;
wire  [p_ADAT_NUM_WORD - 1:0] io_m_tx_empty  ;
wire  io_m_tx_start_packet  ;
wire  io_m_tx_end_packet  ;
wire  io_m_tx_error  ;
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_m_tx_packet_size  ;
wire  io_m_err_unsupported_transaction  ;
wire  io_m_err_illegal_transaction_decode  ;
wire  [DEVICE_ID_WIDTH - 1:0] io_m_err_source_id  ;
wire  [DEVICE_ID_WIDTH - 1:0] io_m_err_destination_id  ;
wire  [3:0] io_m_err_ttype  ;
wire  [3:0] io_m_err_ftype  ;
wire  [1:0] io_m_err_xamsbs  ;
wire  [28:0] io_m_err_address  ; //wire io_s_mnt_s_clk;
wire  io_s_mnt_s_chipselect  ;
wire  io_s_mnt_s_waitrequest  ;
wire  io_s_mnt_s_read  ;
wire  io_s_mnt_s_write  ;
wire  [9 - 1:0] io_s_mnt_s_address  ;
wire  [31:0] io_s_mnt_s_writedata  ;
wire  [31:0] io_s_mnt_s_readdata  ;
wire  io_s_mnt_s_irq  ;
wire  io_s_rx_ready  ;
wire  [p_ADAT - 1:0] io_s_rx_data  ;
wire  io_s_rx_valid  ;
wire  [p_ADAT_NUM_WORD - 1:0] io_s_rx_empty  ;
wire  io_s_rx_start_packet  ;
wire  io_s_rx_end_packet  ;
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_s_rx_packet_size  ;
wire  io_s_tx_packet_available  ;
wire  io_s_tx_ready  ;
wire  [p_ADAT - 1:0] io_s_tx_data  ;
wire  io_s_tx_valid  ;
wire  [p_ADAT_NUM_WORD - 1:0] io_s_tx_empty  ;
wire  io_s_tx_start_packet  ;
wire  io_s_tx_end_packet  ;
wire  [p_ADAT_SIZE_WIDTH - 1:0] io_s_tx_packet_size  ;
wire  io_s_tx_error  ;
wire  io_s_err_error_response  ;
wire  io_s_err_illegal_transaction_decode  ;
wire  io_s_err_timeout  ;
wire  io_s_err_unexpected_response  ;
wire  [DEVICE_ID_WIDTH - 1:0] io_s_err_source_id  ;
wire  [DEVICE_ID_WIDTH - 1:0] io_s_err_destination_id  ;
wire  [3:0] io_s_err_ttype  ;
wire  [3:0] io_s_err_ftype  ;
wire  [1:0] io_s_err_xamsbs  ;
wire  [28:0] io_s_err_address  ; // Input for Maintenance module
wire drbell_rx_ready;
wire[p_ADAT -1:0] drbell_rx_data;
wire drbell_rx_valid;
wire[p_ADAT_MTY_WIDTH - 1:0] drbell_rx_empty;
wire drbell_rx_start_packet;
wire drbell_rx_end_packet;
wire[p_ADAT_SIZE_WIDTH - 1:0] drbell_rx_packet_size;
wire drbell_tx_packet_available;
wire drbell_tx_ready;
wire[p_ADAT - 1:0] drbell_tx_data;
wire drbell_tx_valid;
wire [p_ADAT_MTY_WIDTH - 1:0] drbell_tx_empty;
wire drbell_tx_start_packet;
wire drbell_tx_end_packet;
wire[p_ADAT_SIZE_WIDTH - 1:0] drbell_tx_packet_size;
wire drbell_tx_error;
wire drbell_err_error_response;
wire drbell_err_illegal_transaction_decode;
wire drbell_err_timeout;
wire drbell_err_unexpected_response;
wire[DEVICE_ID_WIDTH - 1:0] drbell_err_source_id;
wire[DEVICE_ID_WIDTH - 1:0] drbell_err_destination_id;
wire[3:0] drbell_err_ttype;
wire[3:0] drbell_err_ftype; // Input for Maintenance module
wire  mnt_tx_ready  ;
wire  mnt_rx_valid  ;
wire  mnt_rx_start_packet  ;
wire  mnt_rx_end_packet  ;
wire  [p_ADAT_NUM_WORD - 1:0] mnt_rx_empty  ;
wire  [p_ADAT - 1:0] mnt_rx_data  ;
wire  [p_ADAT_SIZE_WIDTH - 1:0] mnt_rx_size  ; //wire  mnt_mnt_s_clk;
wire[3:0] mnt_rx_ttype; //wire  mnt_mnt_s_clk;
wire  mnt_mnt_s_chipselect  ;
wire  mnt_mnt_s_read  ;
wire  mnt_mnt_s_write  ;
wire  [9:0] mnt_mnt_s_address  ;
wire  [31:0] mnt_mnt_s_writedata  ; // Output for Maintenance module
wire  mnt_tx_packet_available  ;
wire  mnt_tx_valid  ;
wire  mnt_tx_start_packet  ;
wire  mnt_tx_end_packet  ;
wire  mnt_tx_error  ;
wire  [p_ADAT_NUM_WORD - 1:0] mnt_tx_empty  ;
wire  [p_ADAT - 1:0] mnt_tx_data  ;
wire  [p_ADAT_SIZE_WIDTH - 1:0] mnt_tx_size  ;
wire  mnt_rx_ready  ;
wire  mnt_mnt_s_waitrequest  ;
wire  [31:0] mnt_mnt_s_readdata  ;
wire  mnt_mnt_s_irq  ; // Error management
wire  mnt_s_error_response  ;
wire  mnt_s_illegal_trans_decode  ;
wire  mnt_s_illegal_trans_target  ;
wire  mnt_s_error_timeout  ;
wire  mnt_s_unsolicited_response  ;
wire  [DEVICE_ID_WIDTH - 1:0] mnt_s_err_dest_id  ;
wire  [DEVICE_ID_WIDTH - 1:0] mnt_s_err_src_id  ;
wire  [3:0] mnt_s_err_ftype  ;
wire  [3:0] mnt_s_err_ttype  ;
wire  reg_mnt_s_chipselect  ;
wire  reg_mnt_s_waitrequest  ;
wire  reg_mnt_s_read  ;
wire  reg_mnt_s_write  ;
wire  [16:0] reg_mnt_s_address  ;
wire  [31:0] reg_mnt_s_writedata  ;
wire  [31:0] reg_mnt_s_readdata  ;
wire  reg_mnt_s_irq  ; // Input for Transport module
wire  tx_data_status  ;
wire  rx_packet_available  ;
wire  rx_valid  ;
wire  rx_start_packet  ;
wire  rx_end_packet  ;
wire  rx_error  ;
wire  [p_ADAT_NUM_WORD - 1:0] rx_empty  ;
wire  [p_ADAT - 1:0] rx_data  ; // Output for Transport
wire  tx_valid  ;
wire  tx_start_packet  ;
wire  tx_end_packet  ;
wire  tx_error  ;
wire  [p_ADAT_NUM_WORD - 1:0] tx_empty  ;
wire  [p_ADAT - 1:0] tx_data  ;
wire  rx_ready  ; // Signals for riophy
wire  link_drvr_oe  ;
wire  select_silence  ;
/********************************/
/* Maintenance Avalon Slave     */
/********************************/
//wire  phy_mnt_s_clk;
wire  phy_mnt_s_chipselect  ;
wire  phy_mnt_s_waitrequest  ;
wire  phy_mnt_s_read  ;
wire  phy_mnt_s_write  ;
wire  [16:0] phy_mnt_s_address  ;
wire  [31:0] phy_mnt_s_writedata  ;
wire  [31:0] phy_mnt_s_readdata  ;
wire  sel  ;
wire  read  ;
wire  [16:2] addr  ;
wire  [31:0] wdata  ;
wire  [31:0] rdata  ;
wire  dtack  ; // Signals for concentrator
wire  sys_mnt_s_reset_n  ; // Signals for reg_mnt
wire  [DEVICE_ID_WIDTH - 1:0] device_id  ;
wire  promiscuous_mode  ;
wire  [30:0] lcsba  ;
//Signals for transaction order preservation
wire[16 - 1:0] started_writes;
wire[16 - 1:0] completed_writes;
wire  [23:0] prtctrl_value_ctrl  ; // In txclk clock domain
reg  txclk_handshake_meta  /* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; disable_da_rule=\"d101,d103\"" */;
reg  txclk_handshake_hard  /* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS" */;
reg  txclk_handshake_d1  ;
reg  [23:0] prtctrl_value_ctrl_frozen  /* synthesis altera_attribute="disable_da_rule=\"d101,d103\"" */;
// In sysclk clock domain
reg  sysclk_handshake_meta  /* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; disable_da_rule=\"d101,d103\"" */;
reg  sysclk_handshake_hard  /* altera_attribute = "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS" */;
reg  sysclk_handshake_inverted  ;
reg  [23:0] prtctrl_value_ctrl_sysclk  ;

wire [32 - 1 : 0] io_s_wr_address_in;
wire [32 - 1 : 0] io_s_rd_address_in;

localparam IO_SLAVE_WIDTH_MSB = p_IO_SLAVE_WIDTH - 1;
assign io_s_wr_address_in = (p_IO_SLAVE_WIDTH == 0)? {io_s_wr_address,{p_IO_SLAVE_ADDRESS_LSB{1'b0}}} : {{{IO_SLAVE_ADDRESS_WIDTH}{1'b0}},io_s_wr_address,{p_IO_SLAVE_ADDRESS_LSB{1'b0}}};
assign io_s_rd_address_in = (p_IO_SLAVE_WIDTH == 0)? {io_s_rd_address,{p_IO_SLAVE_ADDRESS_LSB{1'b0}}} : {{{IO_SLAVE_ADDRESS_WIDTH}{1'b0}},io_s_rd_address,{p_IO_SLAVE_ADDRESS_LSB{1'b0}}};


always @(posedge txclk or negedge txreset_n)
begin 
    if (! txreset_n) begin 
        txclk_handshake_meta<=1'b0;
        txclk_handshake_hard<=1'b0;
        txclk_handshake_d1<=1'b0;
        prtctrl_value_ctrl_frozen<=23'd0;
    end 
    else
    begin 
        txclk_handshake_meta<=sysclk_handshake_inverted;
        txclk_handshake_hard<=txclk_handshake_meta;
        txclk_handshake_d1<=txclk_handshake_hard;
        if (txclk_handshake_hard != txclk_handshake_d1) begin 
            prtctrl_value_ctrl_frozen<=prtctrl_value_ctrl;
        end 
    end 
end 

always @(posedge sysclk or negedge reset_n)
begin 
    if (! reset_n) begin 
        sysclk_handshake_meta<=1'b0;
        sysclk_handshake_hard<=1'b0;
        sysclk_handshake_inverted<=1'b0;
        prtctrl_value_ctrl_sysclk<=23'd0;
    end 
    else
    begin 
        sysclk_handshake_meta<=txclk_handshake_d1;
        sysclk_handshake_hard<=sysclk_handshake_meta;
        sysclk_handshake_inverted<=~ sysclk_handshake_hard;
        if (sysclk_handshake_hard == sysclk_handshake_inverted) begin 
            prtctrl_value_ctrl_sysclk<=prtctrl_value_ctrl_frozen;
        end 
    end 
end 
assign port_response_timeout = prtctrl_value_ctrl_sysclk;// ***************************************************
// structural_code
// ***************************************************
//*****************************************
// IO MASTER
//*****************************************
/*CALL*/

generate
    if (TRANSPORT_LARGE == 1'b1 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && p_IO_MASTER == 1'b1) begin 

         altera_rapidio_io_master_tl_large_x1 /* vx2 no_prefix */   io_master(.sysclk(sysclk),
        .reset_n(reset_n), .device_id(device_id),
        /********************************/
        /* Datapath Write Avalon Master */
        /********************************/
        .io_m_wr_clk(sysclk), .io_m_wr_waitrequest(io_m_wr_waitrequest),
        .io_m_wr_write(io_m_wr_write), .io_m_wr_address(io_m_wr_address),
        .io_m_wr_writedata(io_m_wr_writedata),
        .io_m_wr_byteenable(io_m_wr_byteenable),
        .io_m_wr_burstcount(io_m_wr_burstcount),
        /********************************/
        /* Datapath Read Avalon Master  */
        /********************************/
        .io_m_rd_clk(io_m_rd_clk), .io_m_rd_waitrequest(io_m_rd_waitrequest),
        .io_m_rd_read(io_m_rd_read), .io_m_rd_address(io_m_rd_address),
        .io_m_rd_readdatavalid(io_m_rd_readdatavalid),
        .io_m_rd_readerror(io_m_rd_readerror),
        .io_m_rd_readdata(io_m_rd_readdata),
        .io_m_rd_burstcount(io_m_rd_burstcount),
        /********************************/
        /* Maintenance Avalon Slave     */
        /********************************/
        .io_m_mnt_s_clk(sysclk), .io_m_mnt_s_chipselect(io_m_mnt_s_chipselect),
        .io_m_mnt_s_waitrequest(io_m_mnt_s_waitrequest),
        .io_m_mnt_s_read(io_m_mnt_s_read), .io_m_mnt_s_write(io_m_mnt_s_write),
        .io_m_mnt_s_address({io_m_mnt_s_address[8 - 1:2], 2'b00}),
        .io_m_mnt_s_writedata(io_m_mnt_s_writedata),
        .io_m_mnt_s_readdata(io_m_mnt_s_readdata),
        /********************************/
        /* Error Management             */
        /********************************/
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        .io_m_err_source_id(io_m_err_source_id),
        .io_m_err_destination_id(io_m_err_destination_id),
        .io_m_err_ttype(io_m_err_ttype), .io_m_err_ftype(io_m_err_ftype),
        .io_m_err_xamsbs(io_m_err_xamsbs), .io_m_err_address(io_m_err_address),
        /********************************/
        /*  RX Atlantic Interface       */
        /********************************/
        .io_m_rx_ready(io_m_rx_ready), .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet),
        .io_m_rx_packet_size(io_m_rx_packet_size),
        /********************************/
        /*  TX Atlantic Interface       */
        /********************************/
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_data(io_m_tx_data), .io_m_tx_empty(io_m_tx_empty),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_packet_size(io_m_tx_packet_size));

    end else if (TRANSPORT_LARGE == 1'b1 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && p_IO_MASTER == 1'b1) begin 

         altera_rapidio_io_master_tl_large_x2_x4 /* vx2 no_prefix */   io_master(.sysclk(sysclk),
        .reset_n(reset_n), .device_id(device_id),
        /********************************/
        /* Datapath Write Avalon Master */
        /********************************/
        .io_m_wr_clk(sysclk), .io_m_wr_waitrequest(io_m_wr_waitrequest),
        .io_m_wr_write(io_m_wr_write), .io_m_wr_address(io_m_wr_address),
        .io_m_wr_writedata(io_m_wr_writedata),
        .io_m_wr_byteenable(io_m_wr_byteenable),
        .io_m_wr_burstcount(io_m_wr_burstcount),
        /********************************/
        /* Datapath Read Avalon Master  */
        /********************************/
        .io_m_rd_clk(io_m_rd_clk), .io_m_rd_waitrequest(io_m_rd_waitrequest),
        .io_m_rd_read(io_m_rd_read), .io_m_rd_address(io_m_rd_address),
        .io_m_rd_readdatavalid(io_m_rd_readdatavalid),
        .io_m_rd_readerror(io_m_rd_readerror),
        .io_m_rd_readdata(io_m_rd_readdata),
        .io_m_rd_burstcount(io_m_rd_burstcount),
        /********************************/
        /* Maintenance Avalon Slave     */
        /********************************/
        .io_m_mnt_s_clk(sysclk), .io_m_mnt_s_chipselect(io_m_mnt_s_chipselect),
        .io_m_mnt_s_waitrequest(io_m_mnt_s_waitrequest),
        .io_m_mnt_s_read(io_m_mnt_s_read), .io_m_mnt_s_write(io_m_mnt_s_write),
        .io_m_mnt_s_address({io_m_mnt_s_address[8 - 1:2], 2'b00}),
        .io_m_mnt_s_writedata(io_m_mnt_s_writedata),
        .io_m_mnt_s_readdata(io_m_mnt_s_readdata),
        /********************************/
        /* Error Management             */
        /********************************/
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        .io_m_err_source_id(io_m_err_source_id),
        .io_m_err_destination_id(io_m_err_destination_id),
        .io_m_err_ttype(io_m_err_ttype), .io_m_err_ftype(io_m_err_ftype),
        .io_m_err_xamsbs(io_m_err_xamsbs), .io_m_err_address(io_m_err_address),
        /********************************/
        /*  RX Atlantic Interface       */
        /********************************/
        .io_m_rx_ready(io_m_rx_ready), .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet),
        .io_m_rx_packet_size(io_m_rx_packet_size),
        /********************************/
        /*  TX Atlantic Interface       */
        /********************************/
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_data(io_m_tx_data), .io_m_tx_empty(io_m_tx_empty),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_packet_size(io_m_tx_packet_size));

    end else if (TRANSPORT_LARGE == 1'b0 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && p_IO_MASTER == 1'b1) begin 

         altera_rapidio_io_master_tl_small_x1 /* vx2 no_prefix */   io_master(.sysclk(sysclk),
        .reset_n(reset_n), .device_id(device_id),
        /********************************/
        /* Datapath Write Avalon Master */
        /********************************/
        .io_m_wr_clk(sysclk), .io_m_wr_waitrequest(io_m_wr_waitrequest),
        .io_m_wr_write(io_m_wr_write), .io_m_wr_address(io_m_wr_address),
        .io_m_wr_writedata(io_m_wr_writedata),
        .io_m_wr_byteenable(io_m_wr_byteenable),
        .io_m_wr_burstcount(io_m_wr_burstcount),
        /********************************/
        /* Datapath Read Avalon Master  */
        /********************************/
        .io_m_rd_clk(io_m_rd_clk), .io_m_rd_waitrequest(io_m_rd_waitrequest),
        .io_m_rd_read(io_m_rd_read), .io_m_rd_address(io_m_rd_address),
        .io_m_rd_readdatavalid(io_m_rd_readdatavalid),
        .io_m_rd_readerror(io_m_rd_readerror),
        .io_m_rd_readdata(io_m_rd_readdata),
        .io_m_rd_burstcount(io_m_rd_burstcount),
        /********************************/
        /* Maintenance Avalon Slave     */
        /********************************/
        .io_m_mnt_s_clk(sysclk), .io_m_mnt_s_chipselect(io_m_mnt_s_chipselect),
        .io_m_mnt_s_waitrequest(io_m_mnt_s_waitrequest),
        .io_m_mnt_s_read(io_m_mnt_s_read), .io_m_mnt_s_write(io_m_mnt_s_write),
        .io_m_mnt_s_address({io_m_mnt_s_address[8 - 1:2], 2'b00}),
        .io_m_mnt_s_writedata(io_m_mnt_s_writedata),
        .io_m_mnt_s_readdata(io_m_mnt_s_readdata),
        /********************************/
        /* Error Management             */
        /********************************/
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        .io_m_err_source_id(io_m_err_source_id),
        .io_m_err_destination_id(io_m_err_destination_id),
        .io_m_err_ttype(io_m_err_ttype), .io_m_err_ftype(io_m_err_ftype),
        .io_m_err_xamsbs(io_m_err_xamsbs), .io_m_err_address(io_m_err_address),
        /********************************/
        /*  RX Atlantic Interface       */
        /********************************/
        .io_m_rx_ready(io_m_rx_ready), .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet),
        .io_m_rx_packet_size(io_m_rx_packet_size),
        /********************************/
        /*  TX Atlantic Interface       */
        /********************************/
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_data(io_m_tx_data), .io_m_tx_empty(io_m_tx_empty),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_packet_size(io_m_tx_packet_size));

    end else if (TRANSPORT_LARGE == 1'b0 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && p_IO_MASTER == 1'b1) begin 

         altera_rapidio_io_master_tl_small_x2_x4 /* vx2 no_prefix */   io_master(.sysclk(sysclk),
        .reset_n(reset_n), .device_id(device_id),
        /********************************/
        /* Datapath Write Avalon Master */
        /********************************/
        .io_m_wr_clk(sysclk), .io_m_wr_waitrequest(io_m_wr_waitrequest),
        .io_m_wr_write(io_m_wr_write), .io_m_wr_address(io_m_wr_address),
        .io_m_wr_writedata(io_m_wr_writedata),
        .io_m_wr_byteenable(io_m_wr_byteenable),
        .io_m_wr_burstcount(io_m_wr_burstcount),
        /********************************/
        /* Datapath Read Avalon Master  */
        /********************************/
        .io_m_rd_clk(io_m_rd_clk), .io_m_rd_waitrequest(io_m_rd_waitrequest),
        .io_m_rd_read(io_m_rd_read), .io_m_rd_address(io_m_rd_address),
        .io_m_rd_readdatavalid(io_m_rd_readdatavalid),
        .io_m_rd_readerror(io_m_rd_readerror),
        .io_m_rd_readdata(io_m_rd_readdata),
        .io_m_rd_burstcount(io_m_rd_burstcount),
        /********************************/
        /* Maintenance Avalon Slave     */
        /********************************/
        .io_m_mnt_s_clk(sysclk), .io_m_mnt_s_chipselect(io_m_mnt_s_chipselect),
        .io_m_mnt_s_waitrequest(io_m_mnt_s_waitrequest),
        .io_m_mnt_s_read(io_m_mnt_s_read), .io_m_mnt_s_write(io_m_mnt_s_write),
        .io_m_mnt_s_address({io_m_mnt_s_address[8 - 1:2], 2'b00}),
        .io_m_mnt_s_writedata(io_m_mnt_s_writedata),
        .io_m_mnt_s_readdata(io_m_mnt_s_readdata),
        /********************************/
        /* Error Management             */
        /********************************/
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        .io_m_err_source_id(io_m_err_source_id),
        .io_m_err_destination_id(io_m_err_destination_id),
        .io_m_err_ttype(io_m_err_ttype), .io_m_err_ftype(io_m_err_ftype),
        .io_m_err_xamsbs(io_m_err_xamsbs), .io_m_err_address(io_m_err_address),
        /********************************/
        /*  RX Atlantic Interface       */
        /********************************/
        .io_m_rx_ready(io_m_rx_ready), .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet),
        .io_m_rx_packet_size(io_m_rx_packet_size),
        /********************************/
        /*  TX Atlantic Interface       */
        /********************************/
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_data(io_m_tx_data), .io_m_tx_empty(io_m_tx_empty),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_packet_size(io_m_tx_packet_size));


    end else begin
        assign io_m_wr_write = 1'b0;
        assign io_m_wr_address = 32'b0;
        assign io_m_wr_writedata = {p_ADAT{1'b0}};
        assign io_m_wr_byteenable = {p_ADAT_BYTEENABLE_WIDTH{1'b0}};
        assign io_m_wr_burstcount = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign io_m_rd_read = 1'b0;
        assign io_m_rd_address = 32'b0;
        assign io_m_rd_burstcount = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign io_m_mnt_s_waitrequest = 1'b0;
        assign io_m_mnt_s_readdata = 32'b0;
        assign io_m_err_unsupported_transaction = 1'b0;
        assign io_m_err_illegal_transaction_decode = 1'b0;
        assign io_m_err_source_id = {DEVICE_ID_WIDTH{1'b0}};
        assign io_m_err_destination_id = {DEVICE_ID_WIDTH{1'b0}};
        assign io_m_err_ttype = 4'b0;
        assign io_m_err_ftype = 4'b0;
        assign io_m_err_xamsbs = 2'b0;
        assign io_m_err_address = 29'b0;
        assign io_m_rx_ready = 1'b0;
        assign io_m_tx_packet_available = 1'b0;
        assign io_m_tx_valid = 1'b0;
        assign io_m_tx_data = {p_ADAT{1'b0}};
        assign io_m_tx_empty = {p_ADAT_NUM_WORD{1'b0}};
        assign io_m_tx_start_packet = 1'b0;
        assign io_m_tx_end_packet = 1'b0;
        assign io_m_tx_error = 1'b0;
        assign io_m_tx_packet_size = {p_ADAT_SIZE_WIDTH{1'b0}};

    end

endgenerate

//*****************************************
// IO SLAVE
//*****************************************
/*CALL*/

generate
    if (TRANSPORT_LARGE == 1'b1 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && p_IO_SLAVE == 1'b1) begin 

        altera_rapidio_io_slave_tl_large_x1 /* vx2 no_prefix */   io_slave(.sysclk(sysclk), // input
            .reset_n(reset_n),
            // input
            /********************************/
            /* Datapath Write Avalon Slave  */
            /********************************/
            .io_s_wr_clk(io_s_wr_clk), // input
            .io_s_wr_chipselect(io_s_wr_chipselect), // input
            .io_s_wr_waitrequest(io_s_wr_waitrequest), // output
            .io_s_wr_write(io_s_wr_write), // input
            .io_s_wr_address(io_s_wr_address_in), // input 
            .io_s_wr_writedata(io_s_wr_writedata), // input
            .io_s_wr_byteenable(io_s_wr_byteenable), // input
            .io_s_wr_burstcount(io_s_wr_burstcount),
            // input
            /********************************/
            /* Datapath Read Avalon Slave   */
            /********************************/
            .io_s_rd_clk(io_s_rd_clk), // input
            .io_s_rd_chipselect(io_s_rd_chipselect), // input
            .io_s_rd_waitrequest(io_s_rd_waitrequest), // output
            .io_s_rd_read(io_s_rd_read), // input
            .io_s_rd_address(io_s_rd_address_in), // input 
            .io_s_rd_readdatavalid(io_s_rd_readdatavalid), // output
            .io_s_rd_readdata(io_s_rd_readdata), // output
            .io_s_rd_burstcount(io_s_rd_burstcount), // input
            .io_s_rd_readerror(io_s_rd_readerror),
            // output
            /********************************/
            /* Maintenance Avalon Slave     */
            /********************************/
            .io_s_mnt_s_clk(sysclk), // input
            .io_s_mnt_s_chipselect(io_s_mnt_s_chipselect), // input
            .io_s_mnt_s_waitrequest(io_s_mnt_s_waitrequest), // output
            .io_s_mnt_s_read(io_s_mnt_s_read), // input
            .io_s_mnt_s_write(io_s_mnt_s_write), // input
            .io_s_mnt_s_address({io_s_mnt_s_address[9 - 1:2], 2'b00}), // input
            .io_s_mnt_s_writedata(io_s_mnt_s_writedata), // input
            .io_s_mnt_s_readdata(io_s_mnt_s_readdata), // output
            .io_s_mnt_s_irq(io_s_mnt_s_irq),
            // output
            /********************************/
            /* RX Atlantic (II) sink        */
            /********************************/
            .io_s_rx_ready(io_s_rx_ready), // output
            .io_s_rx_data(io_s_rx_data), // input
            .io_s_rx_valid(io_s_rx_valid), // input
            .io_s_rx_empty(io_s_rx_empty), // input
            .io_s_rx_start_packet(io_s_rx_start_packet), // input
            .io_s_rx_end_packet(io_s_rx_end_packet), // input
            .io_s_rx_packet_size(io_s_rx_packet_size),
            // input
            /********************************/
            /* TX Atlantic (II) source      */
            /********************************/
            .io_s_tx_packet_available(io_s_tx_packet_available), // output
            .io_s_tx_ready(io_s_tx_ready), // input
            .io_s_tx_data(io_s_tx_data), // output
            .io_s_tx_valid(io_s_tx_valid), // output
            .io_s_tx_empty(io_s_tx_empty), // output
            .io_s_tx_start_packet(io_s_tx_start_packet), // output
            .io_s_tx_end_packet(io_s_tx_end_packet), // output
            .io_s_tx_packet_size(io_s_tx_packet_size), // output
            .io_s_tx_error(io_s_tx_error),
            // output
            /*********************************/
            /* Transaction ordering Preserve */
            /*********************************/
            .started_writes(started_writes), //output
            .completed_writes(completed_writes),
            
            /********************************/
            /* Error Management             */
            /********************************/
            .io_s_err_error_response(io_s_err_error_response), // output
            .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
            // output
            .io_s_err_timeout(io_s_err_timeout), // output
            .io_s_err_unexpected_response(io_s_err_unexpected_response), // output
            .io_s_err_source_id(io_s_err_source_id), // output
            .io_s_err_destination_id(io_s_err_destination_id), // output
            .io_s_err_ttype(io_s_err_ttype), // output
            .io_s_err_ftype(io_s_err_ftype), // output
            .io_s_err_xamsbs(io_s_err_xamsbs), // output
            .io_s_err_address(io_s_err_address),
            // output
            /********************************/
            /* MegaWizard Set Signals       */
            /********************************/
            .sysclk_timeout_prescaler(sysclk_timeout_prescaler),
            // input [6:0]
            /********************************/
            /* CARs and CSRs Connected Inputs */
            /********************************/
            .port_response_timeout(port_response_timeout), // input
            .device_id(device_id), // input
            .master_enable(master_enable_sync)// input
        );
            
        defparam io_slave.is_x2_mode = IS_X2_MODE;
    
    end else if (TRANSPORT_LARGE == 1'b1 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && p_IO_SLAVE == 1'b1) begin

        altera_rapidio_io_slave_tl_large_x2_x4 /* vx2 no_prefix */   io_slave(.sysclk(sysclk), // input
            .reset_n(reset_n),
            // input
            /********************************/
            /* Datapath Write Avalon Slave  */
            /********************************/
            .io_s_wr_clk(io_s_wr_clk), // input
            .io_s_wr_chipselect(io_s_wr_chipselect), // input
            .io_s_wr_waitrequest(io_s_wr_waitrequest), // output
            .io_s_wr_write(io_s_wr_write), // input
            .io_s_wr_address(io_s_wr_address_in), // input 
            .io_s_wr_writedata(io_s_wr_writedata), // input
            .io_s_wr_byteenable(io_s_wr_byteenable), // input
            .io_s_wr_burstcount(io_s_wr_burstcount),
            // input
            /********************************/
            /* Datapath Read Avalon Slave   */
            /********************************/
            .io_s_rd_clk(io_s_rd_clk), // input
            .io_s_rd_chipselect(io_s_rd_chipselect), // input
            .io_s_rd_waitrequest(io_s_rd_waitrequest), // output
            .io_s_rd_read(io_s_rd_read), // input
            .io_s_rd_address(io_s_rd_address_in), // input 
            .io_s_rd_readdatavalid(io_s_rd_readdatavalid), // output
            .io_s_rd_readdata(io_s_rd_readdata), // output
            .io_s_rd_burstcount(io_s_rd_burstcount), // input
            .io_s_rd_readerror(io_s_rd_readerror),
            // output
            /********************************/
            /* Maintenance Avalon Slave     */
            /********************************/
            .io_s_mnt_s_clk(sysclk), // input
            .io_s_mnt_s_chipselect(io_s_mnt_s_chipselect), // input
            .io_s_mnt_s_waitrequest(io_s_mnt_s_waitrequest), // output
            .io_s_mnt_s_read(io_s_mnt_s_read), // input
            .io_s_mnt_s_write(io_s_mnt_s_write), // input
            .io_s_mnt_s_address({io_s_mnt_s_address[9 - 1:2], 2'b00}), // input
            .io_s_mnt_s_writedata(io_s_mnt_s_writedata), // input
            .io_s_mnt_s_readdata(io_s_mnt_s_readdata), // output
            .io_s_mnt_s_irq(io_s_mnt_s_irq),
            // output
            /********************************/
            /* RX Atlantic (II) sink        */
            /********************************/
            .io_s_rx_ready(io_s_rx_ready), // output
            .io_s_rx_data(io_s_rx_data), // input
            .io_s_rx_valid(io_s_rx_valid), // input
            .io_s_rx_empty(io_s_rx_empty), // input
            .io_s_rx_start_packet(io_s_rx_start_packet), // input
            .io_s_rx_end_packet(io_s_rx_end_packet), // input
            .io_s_rx_packet_size(io_s_rx_packet_size),
            // input
            /********************************/
            /* TX Atlantic (II) source      */
            /********************************/
            .io_s_tx_packet_available(io_s_tx_packet_available), // output
            .io_s_tx_ready(io_s_tx_ready), // input
            .io_s_tx_data(io_s_tx_data), // output
            .io_s_tx_valid(io_s_tx_valid), // output
            .io_s_tx_empty(io_s_tx_empty), // output
            .io_s_tx_start_packet(io_s_tx_start_packet), // output
            .io_s_tx_end_packet(io_s_tx_end_packet), // output
            .io_s_tx_packet_size(io_s_tx_packet_size), // output
            .io_s_tx_error(io_s_tx_error),
            // output
            /*********************************/
            /* Transaction ordering Preserve */
            /*********************************/
            .started_writes(started_writes), //output
            .completed_writes(completed_writes),
                        
            /********************************/
            /* Error Management             */
            /********************************/
            .io_s_err_error_response(io_s_err_error_response), // output
            .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
            // output
            .io_s_err_timeout(io_s_err_timeout), // output
            .io_s_err_unexpected_response(io_s_err_unexpected_response), // output
            .io_s_err_source_id(io_s_err_source_id), // output
            .io_s_err_destination_id(io_s_err_destination_id), // output
            .io_s_err_ttype(io_s_err_ttype), // output
            .io_s_err_ftype(io_s_err_ftype), // output
            .io_s_err_xamsbs(io_s_err_xamsbs), // output
            .io_s_err_address(io_s_err_address),
            // output
            /********************************/
            /* MegaWizard Set Signals       */
            /********************************/
            .sysclk_timeout_prescaler(sysclk_timeout_prescaler),
            // input [6:0]
            /********************************/
            /* CARs and CSRs Connected Inputs */
            /********************************/
            .port_response_timeout(port_response_timeout), // input
            .device_id(device_id), // input
            .master_enable(master_enable_sync)// input
        );
            
        defparam io_slave.is_x2_mode = IS_X2_MODE;

    end else if (TRANSPORT_LARGE == 1'b0 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && p_IO_SLAVE == 1'b1) begin

        altera_rapidio_io_slave_tl_small_x1 /* vx2 no_prefix */   io_slave(.sysclk(sysclk), // input
            .reset_n(reset_n),
            // input
            /********************************/
            /* Datapath Write Avalon Slave  */
            /********************************/
            .io_s_wr_clk(io_s_wr_clk), // input
            .io_s_wr_chipselect(io_s_wr_chipselect), // input
            .io_s_wr_waitrequest(io_s_wr_waitrequest), // output
            .io_s_wr_write(io_s_wr_write), // input
            .io_s_wr_address(io_s_wr_address_in), // input 
            .io_s_wr_writedata(io_s_wr_writedata), // input
            .io_s_wr_byteenable(io_s_wr_byteenable), // input
            .io_s_wr_burstcount(io_s_wr_burstcount),
            // input
            /********************************/
            /* Datapath Read Avalon Slave   */
            /********************************/
            .io_s_rd_clk(io_s_rd_clk), // input
            .io_s_rd_chipselect(io_s_rd_chipselect), // input
            .io_s_rd_waitrequest(io_s_rd_waitrequest), // output
            .io_s_rd_read(io_s_rd_read), // input
            .io_s_rd_address(io_s_rd_address_in), // input 
            .io_s_rd_readdatavalid(io_s_rd_readdatavalid), // output
            .io_s_rd_readdata(io_s_rd_readdata), // output
            .io_s_rd_burstcount(io_s_rd_burstcount), // input
            .io_s_rd_readerror(io_s_rd_readerror),
            // output
            /********************************/
            /* Maintenance Avalon Slave     */
            /********************************/
            .io_s_mnt_s_clk(sysclk), // input
            .io_s_mnt_s_chipselect(io_s_mnt_s_chipselect), // input
            .io_s_mnt_s_waitrequest(io_s_mnt_s_waitrequest), // output
            .io_s_mnt_s_read(io_s_mnt_s_read), // input
            .io_s_mnt_s_write(io_s_mnt_s_write), // input
            .io_s_mnt_s_address({io_s_mnt_s_address[9 - 1:2], 2'b00}), // input
            .io_s_mnt_s_writedata(io_s_mnt_s_writedata), // input
            .io_s_mnt_s_readdata(io_s_mnt_s_readdata), // output
            .io_s_mnt_s_irq(io_s_mnt_s_irq),
            // output
            /********************************/
            /* RX Atlantic (II) sink        */
            /********************************/
            .io_s_rx_ready(io_s_rx_ready), // output
            .io_s_rx_data(io_s_rx_data), // input
            .io_s_rx_valid(io_s_rx_valid), // input
            .io_s_rx_empty(io_s_rx_empty), // input
            .io_s_rx_start_packet(io_s_rx_start_packet), // input
            .io_s_rx_end_packet(io_s_rx_end_packet), // input
            .io_s_rx_packet_size(io_s_rx_packet_size),
            // input
            /********************************/
            /* TX Atlantic (II) source      */
            /********************************/
            .io_s_tx_packet_available(io_s_tx_packet_available), // output
            .io_s_tx_ready(io_s_tx_ready), // input
            .io_s_tx_data(io_s_tx_data), // output
            .io_s_tx_valid(io_s_tx_valid), // output
            .io_s_tx_empty(io_s_tx_empty), // output
            .io_s_tx_start_packet(io_s_tx_start_packet), // output
            .io_s_tx_end_packet(io_s_tx_end_packet), // output
            .io_s_tx_packet_size(io_s_tx_packet_size), // output
            .io_s_tx_error(io_s_tx_error),
            // output
            /*********************************/
            /* Transaction ordering Preserve */
            /*********************************/
            .started_writes(started_writes), //output
            .completed_writes(completed_writes),
            
            /********************************/
            /* Error Management             */
            /********************************/
            .io_s_err_error_response(io_s_err_error_response), // output
            .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
            // output
            .io_s_err_timeout(io_s_err_timeout), // output
            .io_s_err_unexpected_response(io_s_err_unexpected_response), // output
            .io_s_err_source_id(io_s_err_source_id), // output
            .io_s_err_destination_id(io_s_err_destination_id), // output
            .io_s_err_ttype(io_s_err_ttype), // output
            .io_s_err_ftype(io_s_err_ftype), // output
            .io_s_err_xamsbs(io_s_err_xamsbs), // output
            .io_s_err_address(io_s_err_address),
            // output
            /********************************/
            /* MegaWizard Set Signals       */
            /********************************/
            .sysclk_timeout_prescaler(sysclk_timeout_prescaler),
            // input [6:0]
            /********************************/
            /* CARs and CSRs Connected Inputs */
            /********************************/
            .port_response_timeout(port_response_timeout), // input
            .device_id(device_id), // input
            .master_enable(master_enable_sync)// input
        );
            
        defparam io_slave.is_x2_mode = IS_X2_MODE;

     end else if (TRANSPORT_LARGE == 1'b0 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && p_IO_SLAVE == 1'b1) begin

        altera_rapidio_io_slave_tl_small_x2_x4 /* vx2 no_prefix */   io_slave(.sysclk(sysclk), // input
            .reset_n(reset_n),
            // input
            /********************************/
            /* Datapath Write Avalon Slave  */
            /********************************/
            .io_s_wr_clk(io_s_wr_clk), // input
            .io_s_wr_chipselect(io_s_wr_chipselect), // input
            .io_s_wr_waitrequest(io_s_wr_waitrequest), // output
            .io_s_wr_write(io_s_wr_write), // input
            .io_s_wr_address(io_s_wr_address_in), // input 
            .io_s_wr_writedata(io_s_wr_writedata), // input
            .io_s_wr_byteenable(io_s_wr_byteenable), // input
            .io_s_wr_burstcount(io_s_wr_burstcount),
            // input
            /********************************/
            /* Datapath Read Avalon Slave   */
            /********************************/
            .io_s_rd_clk(io_s_rd_clk), // input
            .io_s_rd_chipselect(io_s_rd_chipselect), // input
            .io_s_rd_waitrequest(io_s_rd_waitrequest), // output
            .io_s_rd_read(io_s_rd_read), // input
            .io_s_rd_address(io_s_rd_address_in), // input 
            .io_s_rd_readdatavalid(io_s_rd_readdatavalid), // output
            .io_s_rd_readdata(io_s_rd_readdata), // output
            .io_s_rd_burstcount(io_s_rd_burstcount), // input
            .io_s_rd_readerror(io_s_rd_readerror),
            // output
            /********************************/
            /* Maintenance Avalon Slave     */
            /********************************/
            .io_s_mnt_s_clk(sysclk), // input
            .io_s_mnt_s_chipselect(io_s_mnt_s_chipselect), // input
            .io_s_mnt_s_waitrequest(io_s_mnt_s_waitrequest), // output
            .io_s_mnt_s_read(io_s_mnt_s_read), // input
            .io_s_mnt_s_write(io_s_mnt_s_write), // input
            .io_s_mnt_s_address({io_s_mnt_s_address[9 - 1:2], 2'b00}), // input
            .io_s_mnt_s_writedata(io_s_mnt_s_writedata), // input
            .io_s_mnt_s_readdata(io_s_mnt_s_readdata), // output
            .io_s_mnt_s_irq(io_s_mnt_s_irq),
            // output
            /********************************/
            /* RX Atlantic (II) sink        */
            /********************************/
            .io_s_rx_ready(io_s_rx_ready), // output
            .io_s_rx_data(io_s_rx_data), // input
            .io_s_rx_valid(io_s_rx_valid), // input
            .io_s_rx_empty(io_s_rx_empty), // input
            .io_s_rx_start_packet(io_s_rx_start_packet), // input
            .io_s_rx_end_packet(io_s_rx_end_packet), // input
            .io_s_rx_packet_size(io_s_rx_packet_size),
            // input
            /********************************/
            /* TX Atlantic (II) source      */
            /********************************/
            .io_s_tx_packet_available(io_s_tx_packet_available), // output
            .io_s_tx_ready(io_s_tx_ready), // input
            .io_s_tx_data(io_s_tx_data), // output
            .io_s_tx_valid(io_s_tx_valid), // output
            .io_s_tx_empty(io_s_tx_empty), // output
            .io_s_tx_start_packet(io_s_tx_start_packet), // output
            .io_s_tx_end_packet(io_s_tx_end_packet), // output
            .io_s_tx_packet_size(io_s_tx_packet_size), // output
            .io_s_tx_error(io_s_tx_error),
            // output
            /*********************************/
            /* Transaction ordering Preserve */
            /*********************************/
            .started_writes(started_writes), //output
            .completed_writes(completed_writes),
            
            /********************************/
            /* Error Management             */
            /********************************/
            .io_s_err_error_response(io_s_err_error_response), // output
            .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
            // output
            .io_s_err_timeout(io_s_err_timeout), // output
            .io_s_err_unexpected_response(io_s_err_unexpected_response), // output
            .io_s_err_source_id(io_s_err_source_id), // output
            .io_s_err_destination_id(io_s_err_destination_id), // output
            .io_s_err_ttype(io_s_err_ttype), // output
            .io_s_err_ftype(io_s_err_ftype), // output
            .io_s_err_xamsbs(io_s_err_xamsbs), // output
            .io_s_err_address(io_s_err_address),
            // output
            /********************************/
            /* MegaWizard Set Signals       */
            /********************************/
            .sysclk_timeout_prescaler(sysclk_timeout_prescaler),
            // input [6:0]
            /********************************/
            /* CARs and CSRs Connected Inputs */
            /********************************/
            .port_response_timeout(port_response_timeout), // input
            .device_id(device_id), // input
            .master_enable(master_enable_sync)// input
        );
            
        defparam io_slave.is_x2_mode = IS_X2_MODE;

    end else begin
        assign io_s_wr_waitrequest = 1'b0;
        assign io_s_rd_waitrequest = 1'b0;
        assign io_s_rd_readdatavalid = 1'b0;
        assign io_s_rd_readdata = {p_ADAT {1'b0}};
        assign io_s_rd_readerror = 1'b0;
        assign io_s_mnt_s_waitrequest = 1'b0;
        assign io_s_mnt_s_readdata = 32'b0;
        assign io_s_mnt_s_irq = 1'b0;
        assign io_s_err_error_response = 1'b0;
        assign io_s_err_illegal_transaction_decode = 1'b0;
        assign io_s_err_timeout = 1'b0;
        assign io_s_err_unexpected_response = 1'b0;
        assign io_s_err_source_id = {DEVICE_ID_WIDTH{1'b0}};
        assign io_s_err_destination_id = {DEVICE_ID_WIDTH{1'b0}};
        assign io_s_err_ttype = 4'b0;
        assign io_s_err_ftype = 4'b0;
        assign io_s_err_xamsbs = 2'b0;
        assign io_s_err_address = 29'b0;
        assign io_s_rx_ready = 1'b0;
        assign io_s_tx_packet_available = 1'b0;
        assign io_s_tx_data = {p_ADAT{1'b0}};
        assign io_s_tx_valid = 1'b0;
        assign io_s_tx_empty = {p_ADAT_NUM_WORD{1'b0}};
        assign io_s_tx_start_packet = 1'b0;
        assign io_s_tx_end_packet = 1'b0;
        assign io_s_tx_packet_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign io_s_tx_error = 1'b0;

    end
    
endgenerate

    
    
//*****************************************
// DOORBELL SLAVE
//*****************************************

generate
    if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1)) begin 
/*CALL*/
 altera_rapidio_drbell /* vx2 no_prefix */   drbell(.sysclk(sysclk),
// input
.reset_n(reset_n),
// input
/********************************/
/* Doorbell Avalon Slave     */
/********************************/
.drbell_s_chipselect(drbell_s_chipselect), // input
.drbell_s_waitrequest(drbell_s_waitrequest), // output
.drbell_s_read(drbell_s_read), // input
.drbell_s_write(drbell_s_write), // input
.drbell_s_address(drbell_s_address), // input
.drbell_s_writedata(drbell_s_writedata), // input
.drbell_s_readdata(drbell_s_readdata), // output
.drbell_s_irq(drbell_s_irq),
// output
/********************************/
/* RX Atlantic (II) sink        */
/********************************/
.drbell_s_rx_ready(drbell_rx_ready), // output
.drbell_s_rx_data(drbell_rx_data), // input
.drbell_s_rx_valid(drbell_rx_valid), // input
.drbell_s_rx_empty(drbell_rx_empty), // input
.drbell_s_rx_start_packet(drbell_rx_start_packet), // input
.drbell_s_rx_end_packet(drbell_rx_end_packet),
// input
//.drbell_s_rx_packet_size(drbell_rx_packet_size), // input
/********************************/
/* TX Atlantic (II) source      */
/********************************/
.drbell_s_tx_packet_available(drbell_tx_packet_available), // output
.drbell_s_tx_ready(drbell_tx_ready), // input
.drbell_s_tx_data(drbell_tx_data), // output
.drbell_s_tx_valid(drbell_tx_valid), // output
.drbell_s_tx_empty(drbell_tx_empty), // output
.drbell_s_tx_start_packet(drbell_tx_start_packet), // output
.drbell_s_tx_end_packet(drbell_tx_end_packet),
/*********************************/
/* Transaction ordering Preserve */
/*********************************/
.started_writes(started_writes[4:0]), //input
.completed_writes(completed_writes[4:0]),
// output
//.drbell_s_tx_packet_size(drbell_tx_packet_size), // output
.drbell_s_tx_error(drbell_tx_error),
// output
//input
/********************************/
/* Error Management             */
/********************************/
//.drbell_s_err_error_response(drbell_err_error_response), // output
//.drbell_s_err_illegal_transaction_decode(drbell_err_illegal_transaction_decode), // output
.drbell_s_err_timeout(drbell_err_timeout), // output
.drbell_s_err_unexpected_response(drbell_err_unexpected_response),
// output
.drbell_s_err_source_id(drbell_err_source_id), // output
.drbell_s_err_destination_id(drbell_err_destination_id), // output
.drbell_s_err_ttype(drbell_err_ttype), // output
.drbell_s_err_ftype(drbell_err_ftype),
// output
/********************************/
/* MegaWizard Set Signals       */
/********************************/
.sysclk_timeout_prescaler(sysclk_timeout_prescaler),
// input [6:0]
/********************************/
/* CARs and CSRs Connected Inputs */
/********************************/
.port_response_timeout(port_response_timeout), // input
.device_id(device_id), // input
.master_enable(master_enable_sync)// input
);

defparam drbell.MTY_WIDTH = ((IS_X4_MODE == 1'b0) & (IS_X2_MODE == 1'b0))? 2 : 3;
defparam drbell.ATLANTIC_WIDTH =  ATLANTIC_WIDTH;
defparam drbell.TRANSPORT_LARGE = TRANSPORT_LARGE;
defparam drbell.DEVICE_ID_WIDTH = DEVICE_ID_WIDTH;

end else begin
    // Doorbell Slave
    assign drbell_s_readdata = 32'b0;
    assign drbell_s_waitrequest = 1'b0;
    assign drbell_s_irq = 1'b0;
    assign drbell_err_timeout = 1'b0;
    assign drbell_err_unexpected_response = 1'b0;
    assign drbell_err_source_id = {DEVICE_ID_WIDTH{1'b0}};
    assign drbell_err_destination_id = {DEVICE_ID_WIDTH{1'b0}};
    assign drbell_err_ttype = 4'b0;
    assign drbell_err_ftype = 4'b0;
    
end
endgenerate

//++++++++++++++++++++++++++++++++++++++++++
//+            Concentrator                +
//++++++++++++++++++++++++++++++++++++++++++
/*CALL*/
        
    altera_rapidio_concentrator /* vx2 no_prefix */   concentrator(.clk(sysclk),
        // input
        .reset_n(reset_n), .sys_mnt_s_chipselect(sys_mnt_s_chipselect),
        // input
        .sys_mnt_s_waitrequest(sys_mnt_s_waitrequest), // output
        .sys_mnt_s_read(sys_mnt_s_read), // input
        .sys_mnt_s_write(sys_mnt_s_write), // input
        .sys_mnt_s_address({sys_mnt_s_address, 2'b00}), // input [16:0]
        .sys_mnt_s_writedata(sys_mnt_s_writedata), // input [31:0]
        .sys_mnt_s_readdata(sys_mnt_s_readdata), // input [31:0]
        .sys_mnt_s_irq(sys_mnt_s_irq), // output
        .sys_mnt_s_reset_n(sys_mnt_s_reset_n), // output
        .phy_mnt_s_chipselect(phy_mnt_s_chipselect), // output
        .phy_mnt_s_waitrequest(phy_mnt_s_waitrequest), // input
        .phy_mnt_s_read(phy_mnt_s_read), // output
        .phy_mnt_s_write(phy_mnt_s_write), // output
        .phy_mnt_s_address(phy_mnt_s_address), // output [16:0]
        .phy_mnt_s_writedata(phy_mnt_s_writedata), // output [31:0]
        .phy_mnt_s_readdata(phy_mnt_s_readdata),
        // input [31:0]
        /* Maintenance module */
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // input
        .mnt_mnt_s_read(mnt_mnt_s_read), // output
        .mnt_mnt_s_write(mnt_mnt_s_write), // output
        .mnt_mnt_s_address(mnt_mnt_s_address), // output [9:0]
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // output [31:0]
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // input [31:0]
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // input
        /* I/O Master */
        .io_m_mnt_s_chipselect(io_m_mnt_s_chipselect),
        .io_m_mnt_s_waitrequest(io_m_mnt_s_waitrequest),
        .io_m_mnt_s_read(io_m_mnt_s_read), .io_m_mnt_s_write(io_m_mnt_s_write),
        .io_m_mnt_s_address(io_m_mnt_s_address),
        .io_m_mnt_s_writedata(io_m_mnt_s_writedata),
        .io_m_mnt_s_readdata(io_m_mnt_s_readdata), /* I/O Slave  */
        .io_s_mnt_s_chipselect(io_s_mnt_s_chipselect),
        .io_s_mnt_s_waitrequest(io_s_mnt_s_waitrequest),
        .io_s_mnt_s_read(io_s_mnt_s_read), .io_s_mnt_s_write(io_s_mnt_s_write),
        .io_s_mnt_s_address(io_s_mnt_s_address),
        .io_s_mnt_s_writedata(io_s_mnt_s_writedata),
        .io_s_mnt_s_readdata(io_s_mnt_s_readdata),
        .io_s_mnt_s_irq(io_s_mnt_s_irq), /* Main register block */
        .reg_mnt_s_chipselect(reg_mnt_s_chipselect), // output
        .reg_mnt_s_waitrequest(reg_mnt_s_waitrequest), // input
        .reg_mnt_s_read(reg_mnt_s_read), // output
        .reg_mnt_s_write(reg_mnt_s_write), // output
        .reg_mnt_s_address(reg_mnt_s_address), // output [16:0]
        .reg_mnt_s_writedata(reg_mnt_s_writedata), // output [31:0]
        .reg_mnt_s_readdata(reg_mnt_s_readdata), // output
        .reg_mnt_s_irq(reg_mnt_s_irq)// input
    );


//++++++++++++++++++++++++++++++++++++++++++
//+           Main register module         +
//*       (CARs,CSRs & Error Management)   +
//++++++++++++++++++++++++++++++++++++++++++
/*CALL*/
generate
    if (TRANSPORT_LARGE == 1'b1 && DRBELL_TX == 1'b1 && DRBELL_RX == 1'b1) begin 
    
     altera_rapidio_reg_mnt_tl_large_drbell /* vx2 no_prefix */   reg_mnt(.clk(sysclk), // input
        .reset_n(sys_mnt_s_reset_n), // input
        .reg_mnt_s_chipselect(reg_mnt_s_chipselect), // input
        .reg_mnt_s_waitrequest(reg_mnt_s_waitrequest), // output
        .reg_mnt_s_read(reg_mnt_s_read), // input
        .reg_mnt_s_write(reg_mnt_s_write), // input
        .reg_mnt_s_address({reg_mnt_s_address[16:2], 2'b00}), // input [16:0]
        .reg_mnt_s_writedata(reg_mnt_s_writedata), // input [31:0]
        .reg_mnt_s_readdata(reg_mnt_s_readdata), // output [31:0]
        .reg_mnt_s_irq(reg_mnt_s_irq), // output
        .device_identifier(device_identifier), // input [15:0]
        .device_vendor_identifier(device_vendor_id), // input [15:0]
        .device_rev(device_revision), // input [31:0]
        .assy_id(assembly_id), // input [15:0]
        .assy_vendor_id(assembly_vendor_id), // input [15:0]
        .assy_rev(assembly_revision), // input [15:0]
        .ext_feature_ptr(extended_features_ptr), // input [15:0]
        .bridge(bridge_support), // input
        .memory(memory_access), // input
        .processor(processor_present), // input
        .switch(switch_support), // input
        .number_of_ports(number_of_ports), // input [7:0]
        .port_number(port_number), // input [7:0]
        .lcsba(lcsba), // output [30:0]
        .device_id(device_id), // output [7:0]
        .promiscuous_mode(promiscuous_mode),
        // output
        // Error Management
        // IO Master
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        // input
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        // input
        .io_m_err_source_id(io_m_err_source_id), // input
        .io_m_err_destination_id(io_m_err_destination_id), // input
        .io_m_err_ttype(io_m_err_ttype), // input
        .io_m_err_ftype(io_m_err_ftype), // input
        .io_m_err_xamsbs(io_m_err_xamsbs), // input
        .io_m_err_address(io_m_err_address), // input
        // IO Slave
        .io_s_err_error_response(io_s_err_error_response), // input
        .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
        // input
        .io_s_err_timeout(io_s_err_timeout), // input
        .io_s_err_unexpected_response(io_s_err_unexpected_response), // input
        .io_s_err_source_id(io_s_err_source_id), // input
        .io_s_err_destination_id(io_s_err_destination_id), // input
        .io_s_err_ttype(io_s_err_ttype), // input
        .io_s_err_ftype(io_s_err_ftype), // input
        .io_s_err_xamsbs(io_s_err_xamsbs), // input
        .io_s_err_address(io_s_err_address), // input
        // Doorbell Slave
        .drbell_err_error_response(1'b0), // input
        .drbell_err_illegal_transaction_decode(1'b0),
        // input
        .drbell_err_timeout(drbell_err_timeout), // input
        .drbell_err_unexpected_response(drbell_err_unexpected_response),
        // input
        .drbell_err_source_id(drbell_err_source_id), // input
        .drbell_err_destination_id(drbell_err_destination_id), // input
        .drbell_err_ttype(drbell_err_ttype), // input
        .drbell_err_ftype(drbell_err_ftype), // input
        // Maintenance module
        .mnt_s_error_response(mnt_s_error_response), // input
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // input
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // input
        .mnt_s_error_timeout(mnt_s_error_timeout), // input
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // input
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // input [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // input [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // input [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // input[3:0]
        // Message Passing
        .msg_error_response(error_detect_message_error_response), // input
        .msg_format_error(error_detect_message_format_error), // input
        .msg_request_timeout(error_detect_message_request_timeout), // input
        .msg_err_letter(error_capture_letter), // input [1:0]
        .msg_err_mbox(error_capture_mbox), // input [1:0]
        .msg_err_msgseg_or_xmbox(error_capture_msgseg_or_xmbox), // input [3:0]
        // Generic Pass-Through
        .gen_illegal_transaction_decode(error_detect_illegal_transaction_decode), // input
        .gen_illegal_transaction_target(error_detect_illegal_transaction_target), // input
        .gen_packet_response_timeout(error_detect_packet_response_timeout), // input
        .gen_unsolicited_response(error_detect_unsolicited_response), // input
        .gen_unsupported_transaction(error_detect_unsupported_transaction), // input
        .gen_err_ftype(error_capture_ftype), // input [3:0]
        .gen_err_ttype(error_capture_ttype), // input [3:0]
        .gen_err_destination_id(error_capture_destination_id), // input [15:0]
        .gen_err_source_id(error_capture_source_id) // input [15:0]
    );
    
    // Paramerization to reduce variations
    defparam reg_mnt.source_operations_read = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write = p_IO_SLAVE;
    defparam reg_mnt.source_operations_streamwrite = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write_response = p_IO_SLAVE;
    defparam reg_mnt.source_operations_data_message = p_SOURCE_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.source_operations_port_write = PORT_WRITE_ENABLE;
    defparam reg_mnt.destination_operations_read = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write = p_IO_MASTER;
    defparam reg_mnt.destination_operations_streamwrite = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write_response = p_IO_MASTER;
    defparam reg_mnt.destination_operations_data_message = p_DESTINATION_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.destination_operations_port_write = PORT_WRITE_ENABLE;
    
end else if (TRANSPORT_LARGE == 1'b1 && DRBELL_TX == 1'b0 && DRBELL_RX == 1'b0) begin

       altera_rapidio_reg_mnt_tl_large /* vx2 no_prefix */   reg_mnt(.clk(sysclk), // input
        .reset_n(sys_mnt_s_reset_n), // input
        .reg_mnt_s_chipselect(reg_mnt_s_chipselect), // input
        .reg_mnt_s_waitrequest(reg_mnt_s_waitrequest), // output
        .reg_mnt_s_read(reg_mnt_s_read), // input
        .reg_mnt_s_write(reg_mnt_s_write), // input
        .reg_mnt_s_address({reg_mnt_s_address[16:2], 2'b00}), // input [16:0]
        .reg_mnt_s_writedata(reg_mnt_s_writedata), // input [31:0]
        .reg_mnt_s_readdata(reg_mnt_s_readdata), // output [31:0]
        .reg_mnt_s_irq(reg_mnt_s_irq), // output
        .device_identifier(device_identifier), // input [15:0]
        .device_vendor_identifier(device_vendor_id), // input [15:0]
        .device_rev(device_revision), // input [31:0]
        .assy_id(assembly_id), // input [15:0]
        .assy_vendor_id(assembly_vendor_id), // input [15:0]
        .assy_rev(assembly_revision), // input [15:0]
        .ext_feature_ptr(extended_features_ptr), // input [15:0]
        .bridge(bridge_support), // input
        .memory(memory_access), // input
        .processor(processor_present), // input
        .switch(switch_support), // input
        .number_of_ports(number_of_ports), // input [7:0]
        .port_number(port_number), // input [7:0]
        .lcsba(lcsba), // output [30:0]
        .device_id(device_id), // output [7:0]
        .promiscuous_mode(promiscuous_mode),
        // output
        // Error Management
        // IO Master
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        // input
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        // input
        .io_m_err_source_id(io_m_err_source_id), // input
        .io_m_err_destination_id(io_m_err_destination_id), // input
        .io_m_err_ttype(io_m_err_ttype), // input
        .io_m_err_ftype(io_m_err_ftype), // input
        .io_m_err_xamsbs(io_m_err_xamsbs), // input
        .io_m_err_address(io_m_err_address), // input
        // IO Slave
        .io_s_err_error_response(io_s_err_error_response), // input
        .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
        // input
        .io_s_err_timeout(io_s_err_timeout), // input
        .io_s_err_unexpected_response(io_s_err_unexpected_response), // input
        .io_s_err_source_id(io_s_err_source_id), // input
        .io_s_err_destination_id(io_s_err_destination_id), // input
        .io_s_err_ttype(io_s_err_ttype), // input
        .io_s_err_ftype(io_s_err_ftype), // input
        .io_s_err_xamsbs(io_s_err_xamsbs), // input
        .io_s_err_address(io_s_err_address), // input
         // Maintenance module
        .mnt_s_error_response(mnt_s_error_response), // input
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // input
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // input
        .mnt_s_error_timeout(mnt_s_error_timeout), // input
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // input
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // input [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // input [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // input [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // input[3:0]
        // Message Passing
        .msg_error_response(error_detect_message_error_response), // input
        .msg_format_error(error_detect_message_format_error), // input
        .msg_request_timeout(error_detect_message_request_timeout), // input
        .msg_err_letter(error_capture_letter), // input [1:0]
        .msg_err_mbox(error_capture_mbox), // input [1:0]
        .msg_err_msgseg_or_xmbox(error_capture_msgseg_or_xmbox), // input [3:0]
        // Generic Pass-Through
        .gen_illegal_transaction_decode(error_detect_illegal_transaction_decode), // input
        .gen_illegal_transaction_target(error_detect_illegal_transaction_target), // input
        .gen_packet_response_timeout(error_detect_packet_response_timeout), // input
        .gen_unsolicited_response(error_detect_unsolicited_response), // input
        .gen_unsupported_transaction(error_detect_unsupported_transaction), // input
        .gen_err_ftype(error_capture_ftype), // input [3:0]
        .gen_err_ttype(error_capture_ttype), // input [3:0]
        .gen_err_destination_id(error_capture_destination_id), // input [15:0]
        .gen_err_source_id(error_capture_source_id) // input [15:0]
    );
    

    defparam reg_mnt.source_operations_read = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write = p_IO_SLAVE;
    defparam reg_mnt.source_operations_streamwrite = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write_response = p_IO_SLAVE;
    defparam reg_mnt.source_operations_data_message = p_SOURCE_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.source_operations_port_write = PORT_WRITE_ENABLE;
    defparam reg_mnt.destination_operations_read = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write = p_IO_MASTER;
    defparam reg_mnt.destination_operations_streamwrite = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write_response = p_IO_MASTER;
    defparam reg_mnt.destination_operations_data_message = p_DESTINATION_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.destination_operations_port_write = PORT_WRITE_ENABLE;

end else if (TRANSPORT_LARGE == 1'b0 && DRBELL_TX == 1'b1 && DRBELL_RX == 1'b1) begin

     altera_rapidio_reg_mnt_tl_small_drbell /* vx2 no_prefix */   reg_mnt(.clk(sysclk), // input
        .reset_n(sys_mnt_s_reset_n), // input
        .reg_mnt_s_chipselect(reg_mnt_s_chipselect), // input
        .reg_mnt_s_waitrequest(reg_mnt_s_waitrequest), // output
        .reg_mnt_s_read(reg_mnt_s_read), // input
        .reg_mnt_s_write(reg_mnt_s_write), // input
        .reg_mnt_s_address({reg_mnt_s_address[16:2], 2'b00}), // input [16:0]
        .reg_mnt_s_writedata(reg_mnt_s_writedata), // input [31:0]
        .reg_mnt_s_readdata(reg_mnt_s_readdata), // output [31:0]
        .reg_mnt_s_irq(reg_mnt_s_irq), // output
        .device_identifier(device_identifier), // input [15:0]
        .device_vendor_identifier(device_vendor_id), // input [15:0]
        .device_rev(device_revision), // input [31:0]
        .assy_id(assembly_id), // input [15:0]
        .assy_vendor_id(assembly_vendor_id), // input [15:0]
        .assy_rev(assembly_revision), // input [15:0]
        .ext_feature_ptr(extended_features_ptr), // input [15:0]
        .bridge(bridge_support), // input
        .memory(memory_access), // input
        .processor(processor_present), // input
        .switch(switch_support), // input
        .number_of_ports(number_of_ports), // input [7:0]
        .port_number(port_number), // input [7:0]
        .lcsba(lcsba), // output [30:0]
        .device_id(device_id), // output [7:0]
        .promiscuous_mode(promiscuous_mode),
        // output
        // Error Management
        // IO Master
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        // input
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        // input
        .io_m_err_source_id(io_m_err_source_id), // input
        .io_m_err_destination_id(io_m_err_destination_id), // input
        .io_m_err_ttype(io_m_err_ttype), // input
        .io_m_err_ftype(io_m_err_ftype), // input
        .io_m_err_xamsbs(io_m_err_xamsbs), // input
        .io_m_err_address(io_m_err_address), // input
        // IO Slave
        .io_s_err_error_response(io_s_err_error_response), // input
        .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
        // input
        .io_s_err_timeout(io_s_err_timeout), // input
        .io_s_err_unexpected_response(io_s_err_unexpected_response), // input
        .io_s_err_source_id(io_s_err_source_id), // input
        .io_s_err_destination_id(io_s_err_destination_id), // input
        .io_s_err_ttype(io_s_err_ttype), // input
        .io_s_err_ftype(io_s_err_ftype), // input
        .io_s_err_xamsbs(io_s_err_xamsbs), // input
        .io_s_err_address(io_s_err_address), // input
        // Doorbell Slave
        .drbell_err_error_response(1'b0), // input
        .drbell_err_illegal_transaction_decode(1'b0),
        // input
        .drbell_err_timeout(drbell_err_timeout), // input
        .drbell_err_unexpected_response(drbell_err_unexpected_response),
        // input
        .drbell_err_source_id(drbell_err_source_id), // input
        .drbell_err_destination_id(drbell_err_destination_id), // input
        .drbell_err_ttype(drbell_err_ttype), // input
        .drbell_err_ftype(drbell_err_ftype), // input
        // Maintenance module
        .mnt_s_error_response(mnt_s_error_response), // input
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // input
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // input
        .mnt_s_error_timeout(mnt_s_error_timeout), // input
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // input
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // input [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // input [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // input [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // input[3:0]
        // Message Passing
        .msg_error_response(error_detect_message_error_response), // input
        .msg_format_error(error_detect_message_format_error), // input
        .msg_request_timeout(error_detect_message_request_timeout), // input
        .msg_err_letter(error_capture_letter), // input [1:0]
        .msg_err_mbox(error_capture_mbox), // input [1:0]
        .msg_err_msgseg_or_xmbox(error_capture_msgseg_or_xmbox), // input [3:0]
        // Generic Pass-Through
        .gen_illegal_transaction_decode(error_detect_illegal_transaction_decode), // input
        .gen_illegal_transaction_target(error_detect_illegal_transaction_target), // input
        .gen_packet_response_timeout(error_detect_packet_response_timeout), // input
        .gen_unsolicited_response(error_detect_unsolicited_response), // input
        .gen_unsupported_transaction(error_detect_unsupported_transaction), // input
        .gen_err_ftype(error_capture_ftype), // input [3:0]
        .gen_err_ttype(error_capture_ttype), // input [3:0]
        .gen_err_destination_id(error_capture_destination_id), // input [15:0]
        .gen_err_source_id(error_capture_source_id) // input [15:0]
    );
    
    // Paramerization to reduce variations
    defparam reg_mnt.source_operations_read = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write = p_IO_SLAVE;
    defparam reg_mnt.source_operations_streamwrite = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write_response = p_IO_SLAVE;
    defparam reg_mnt.source_operations_data_message = p_SOURCE_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.source_operations_port_write = PORT_WRITE_ENABLE;
    defparam reg_mnt.destination_operations_read = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write = p_IO_MASTER;
    defparam reg_mnt.destination_operations_streamwrite = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write_response = p_IO_MASTER;
    defparam reg_mnt.destination_operations_data_message = p_DESTINATION_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.destination_operations_port_write = PORT_WRITE_ENABLE;

end else begin

       altera_rapidio_reg_mnt_tl_small /* vx2 no_prefix */   reg_mnt(.clk(sysclk), // input
        .reset_n(sys_mnt_s_reset_n), // input
        .reg_mnt_s_chipselect(reg_mnt_s_chipselect), // input
        .reg_mnt_s_waitrequest(reg_mnt_s_waitrequest), // output
        .reg_mnt_s_read(reg_mnt_s_read), // input
        .reg_mnt_s_write(reg_mnt_s_write), // input
        .reg_mnt_s_address({reg_mnt_s_address[16:2], 2'b00}), // input [16:0]
        .reg_mnt_s_writedata(reg_mnt_s_writedata), // input [31:0]
        .reg_mnt_s_readdata(reg_mnt_s_readdata), // output [31:0]
        .reg_mnt_s_irq(reg_mnt_s_irq), // output
        .device_identifier(device_identifier), // input [15:0]
        .device_vendor_identifier(device_vendor_id), // input [15:0]
        .device_rev(device_revision), // input [31:0]
        .assy_id(assembly_id), // input [15:0]
        .assy_vendor_id(assembly_vendor_id), // input [15:0]
        .assy_rev(assembly_revision), // input [15:0]
        .ext_feature_ptr(extended_features_ptr), // input [15:0]
        .bridge(bridge_support), // input
        .memory(memory_access), // input
        .processor(processor_present), // input
        .switch(switch_support), // input
        .number_of_ports(number_of_ports), // input [7:0]
        .port_number(port_number), // input [7:0]
        .lcsba(lcsba), // output [30:0]
        .device_id(device_id), // output [7:0]
        .promiscuous_mode(promiscuous_mode),
        // output
        // Error Management
        // IO Master
        .io_m_err_unsupported_transaction(io_m_err_unsupported_transaction),
        // input
        .io_m_err_illegal_transaction_decode(io_m_err_illegal_transaction_decode),
        // input
        .io_m_err_source_id(io_m_err_source_id), // input
        .io_m_err_destination_id(io_m_err_destination_id), // input
        .io_m_err_ttype(io_m_err_ttype), // input
        .io_m_err_ftype(io_m_err_ftype), // input
        .io_m_err_xamsbs(io_m_err_xamsbs), // input
        .io_m_err_address(io_m_err_address), // input
        // IO Slave
        .io_s_err_error_response(io_s_err_error_response), // input
        .io_s_err_illegal_transaction_decode(io_s_err_illegal_transaction_decode),
        // input
        .io_s_err_timeout(io_s_err_timeout), // input
        .io_s_err_unexpected_response(io_s_err_unexpected_response), // input
        .io_s_err_source_id(io_s_err_source_id), // input
        .io_s_err_destination_id(io_s_err_destination_id), // input
        .io_s_err_ttype(io_s_err_ttype), // input
        .io_s_err_ftype(io_s_err_ftype), // input
        .io_s_err_xamsbs(io_s_err_xamsbs), // input
        .io_s_err_address(io_s_err_address), // input
         // Maintenance module
        .mnt_s_error_response(mnt_s_error_response), // input
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // input
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // input
        .mnt_s_error_timeout(mnt_s_error_timeout), // input
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // input
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // input [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // input [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // input [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // input[3:0]
        // Message Passing
        .msg_error_response(error_detect_message_error_response), // input
        .msg_format_error(error_detect_message_format_error), // input
        .msg_request_timeout(error_detect_message_request_timeout), // input
        .msg_err_letter(error_capture_letter), // input [1:0]
        .msg_err_mbox(error_capture_mbox), // input [1:0]
        .msg_err_msgseg_or_xmbox(error_capture_msgseg_or_xmbox), // input [3:0]
        // Generic Pass-Through
        .gen_illegal_transaction_decode(error_detect_illegal_transaction_decode), // input
        .gen_illegal_transaction_target(error_detect_illegal_transaction_target), // input
        .gen_packet_response_timeout(error_detect_packet_response_timeout), // input
        .gen_unsolicited_response(error_detect_unsolicited_response), // input
        .gen_unsupported_transaction(error_detect_unsupported_transaction), // input
        .gen_err_ftype(error_capture_ftype), // input [3:0]
        .gen_err_ttype(error_capture_ttype), // input [3:0]
        .gen_err_destination_id(error_capture_destination_id), // input [15:0]
        .gen_err_source_id(error_capture_source_id) // input [15:0]
    );
    

    defparam reg_mnt.source_operations_read = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write = p_IO_SLAVE;
    defparam reg_mnt.source_operations_streamwrite = p_IO_SLAVE;
    defparam reg_mnt.source_operations_write_response = p_IO_SLAVE;
    defparam reg_mnt.source_operations_data_message = p_SOURCE_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.source_operations_port_write = PORT_WRITE_ENABLE;
    defparam reg_mnt.destination_operations_read = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write = p_IO_MASTER;
    defparam reg_mnt.destination_operations_streamwrite = p_IO_MASTER;
    defparam reg_mnt.destination_operations_write_response = p_IO_MASTER;
    defparam reg_mnt.destination_operations_data_message = p_DESTINATION_OPERATION_DATA_MESSAGE;
    defparam reg_mnt.destination_operations_port_write = PORT_WRITE_ENABLE;

end
endgenerate
    
//+++++++++++++++++++++++++++++++++++++++++++++
//+            Maintenance Module             +
//+++++++++++++++++++++++++++++++++++++++++++++
/*CALL*/
generate
    if (TRANSPORT_LARGE == 1'b1 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && PORT_WRITE_ENABLE == 1'b0 && p_MAINTENANCE == 1'b1) begin 
         altera_rapidio_maintenance_tl_large_x2_x4 /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else if (TRANSPORT_LARGE == 1'b1 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && PORT_WRITE_ENABLE == 1'b0 && p_MAINTENANCE == 1'b1)  begin
         altera_rapidio_maintenance_tl_large_x1 /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .mnt_rx_ttype(mnt_rx_ttype), // input [3:0]
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else if (TRANSPORT_LARGE == 1'b1 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && PORT_WRITE_ENABLE == 1'b1 && p_MAINTENANCE == 1'b1) begin
         altera_rapidio_maintenance_tl_large_x2_x4_pw /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else if (TRANSPORT_LARGE == 1'b1 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && PORT_WRITE_ENABLE == 1'b1 && p_MAINTENANCE == 1'b1) begin
         altera_rapidio_maintenance_tl_large_x1_pw /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .mnt_rx_ttype(mnt_rx_ttype), // input [3:0]
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else if (TRANSPORT_LARGE == 1'b0 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && PORT_WRITE_ENABLE == 1'b0 && p_MAINTENANCE == 1'b1) begin
         altera_rapidio_maintenance_tl_small_x2_x4 /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else if (TRANSPORT_LARGE == 1'b0 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && PORT_WRITE_ENABLE == 1'b0 && p_MAINTENANCE == 1'b1) begin
         altera_rapidio_maintenance_tl_small_x1 /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .mnt_rx_ttype(mnt_rx_ttype), // input [3:0]
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else if (TRANSPORT_LARGE == 1'b0 && (IS_X2_MODE == 1'b1 || IS_X4_MODE == 1'b1) && PORT_WRITE_ENABLE == 1'b1 && p_MAINTENANCE == 1'b1) begin
         altera_rapidio_maintenance_tl_small_x2_x4_pw /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else if (TRANSPORT_LARGE == 1'b0 && IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && PORT_WRITE_ENABLE == 1'b1 && p_MAINTENANCE == 1'b1) begin
         altera_rapidio_maintenance_tl_small_x1_pw /* vx2 no_prefix */   maintenance(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Output
        .mnt_tx_ready(mnt_tx_ready), // Input
        .mnt_tx_valid(mnt_tx_valid), // Output
        .mnt_tx_start_packet(mnt_tx_start_packet), // Output
        .mnt_tx_end_packet(mnt_tx_end_packet), // Output
        .mnt_tx_error(mnt_tx_error), // Output
        .mnt_tx_empty(mnt_tx_empty), // Output
        .mnt_tx_data(mnt_tx_data), // Output
        .mnt_tx_size(mnt_tx_size), // Output
        .mnt_rx_ready(mnt_rx_ready), // Output
        .mnt_rx_valid(mnt_rx_valid), // Input
        .mnt_rx_start_packet(mnt_rx_start_packet), // Input
        .mnt_rx_end_packet(mnt_rx_end_packet), // Input
        .mnt_rx_empty(mnt_rx_empty), // Input
        .mnt_rx_data(mnt_rx_data), // Input
        .mnt_rx_size(mnt_rx_size), // Input
        .mnt_s_clk(mnt_s_clk), // Input - not used
        .mnt_s_chipselect(mnt_s_chipselect), // Input
        .mnt_s_address({mnt_s_address, 2'b00}),
        // Input
        .mnt_s_waitrequest(mnt_s_waitrequest), // Output
        .mnt_s_write(mnt_s_write), // Input
        .mnt_s_writedata(mnt_s_writedata), // Input
        .mnt_s_read(mnt_s_read), // Input
        .mnt_s_readdatavalid(mnt_s_readdatavalid), // Output
        .mnt_s_readdata(mnt_s_readdata), // Output
        .mnt_s_readerror(mnt_s_readerror), // Output
        .mnt_m_clk(mnt_m_clk), // Input - not used
        .mnt_m_read(mnt_m_read), // Output
        .mnt_m_readdatavalid(mnt_m_readdatavalid), // Input
        .mnt_m_readdata(mnt_m_readdata), // Input
        .mnt_m_waitrequest(mnt_m_waitrequest), // Input
        .mnt_m_address(mnt_m_address), // Output
        .mnt_m_write(mnt_m_write), // Output
        .mnt_m_writedata(mnt_m_writedata), // Output
        .mnt_mnt_s_clk(sysclk), // Input
        .mnt_mnt_s_reset_n(sys_mnt_s_reset_n), // input
        .mnt_mnt_s_chipselect(mnt_mnt_s_chipselect), // Input
        .mnt_mnt_s_irq(mnt_mnt_s_irq), // Output
        .mnt_mnt_s_waitrequest(mnt_mnt_s_waitrequest), // Output
        .mnt_mnt_s_address({mnt_mnt_s_address[9:2], 2'b00}), // Input
        .mnt_mnt_s_read(mnt_mnt_s_read), // Input
        .mnt_mnt_s_readdata(mnt_mnt_s_readdata), // Output
        .mnt_mnt_s_write(mnt_mnt_s_write), // Input
        .mnt_mnt_s_writedata(mnt_mnt_s_writedata), // Input
        .mnt_rx_ttype(mnt_rx_ttype), // input [3:0]
        .port_response_timeout(port_response_timeout), // Input
        .timer_prescaler(sysclk_timeout_prescaler), // input [6:0]
        .device_id(device_id), // input [7:0]
        .mnt_s_error_response(mnt_s_error_response), // output
        .mnt_s_illegal_trans_decode(mnt_s_illegal_trans_decode), // output
        .mnt_s_illegal_trans_target(mnt_s_illegal_trans_target), // output
        .mnt_s_error_timeout(mnt_s_error_timeout), // output
        .mnt_s_unsolicited_response(mnt_s_unsolicited_response), // output
        .mnt_s_err_dest_id(mnt_s_err_dest_id), // output [7:0]
        .mnt_s_err_src_id(mnt_s_err_src_id), // output [7:0]
        .mnt_s_err_ftype(mnt_s_err_ftype), // output [3:0]
        .mnt_s_err_ttype(mnt_s_err_ttype), // output[3:0]
        .master_enable(master_enable_sync)// input
        );
        
        defparam maintenance.maintenance_address_width=MAINTENANCE_ADDRESS_WIDTH;

    end else begin
    
        // Set the maintenance related output ports to 0
        assign mnt_m_read = 1'b0;
        assign mnt_m_write = 1'b0;
        assign mnt_m_address = 32'b0;
        assign mnt_m_writedata = 32'b0;
        assign mnt_s_waitrequest = 1'b0;
        assign mnt_s_readdata = 32'b0;
        assign mnt_s_readerror = 1'b0;
        assign mnt_s_readdatavalid = 1'b0;
        assign mnt_mnt_s_waitrequest = 1'b0;
        assign mnt_mnt_s_readdata = 32'b0;
        assign mnt_mnt_s_irq = 1'b0;
        assign mnt_s_error_response = 1'b0;
        assign mnt_s_illegal_trans_decode = 1'b0;
        assign mnt_s_illegal_trans_target = 1'b0;
        assign mnt_s_error_timeout = 1'b0;
        assign mnt_s_unsolicited_response = 1'b0;
        assign mnt_s_err_dest_id = {DEVICE_ID_WIDTH{1'b0}};
        assign mnt_s_err_src_id = {DEVICE_ID_WIDTH{1'b0}};
        assign mnt_s_err_ftype = 4'b0;
        assign mnt_s_err_ttype = 4'b0;
        assign mnt_tx_packet_available = 1'b0;
        assign mnt_tx_valid = 1'b0;
        assign mnt_tx_start_packet = 1'b0;
        assign mnt_tx_end_packet = 1'b0;
        assign mnt_tx_error = 1'b0;
        assign mnt_tx_empty = {p_ADAT_NUM_WORD{1'b0}};
        assign mnt_tx_data = {p_ADAT{1'b0}};
        assign mnt_tx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign mnt_rx_ready = 1'b0;

    end

endgenerate

//+++++++++++++++++++++++++++++++++++++++++++++
//+            Transport Layer                +
//+++++++++++++++++++++++++++++++++++++++++++++
/*CALL*/
generate
if (TRANSPORT_LARGE == 1'b1) begin
    if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE) || (IS_X4_MODE)) && (p_GENERIC_LOGICAL == 1'b0)) begin 

        altera_rapidio_transport_tl_large_x2_x4_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(6'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [7-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE == 1'b1) || (IS_X4_MODE == 1'b1)) && (p_GENERIC_LOGICAL == 1'b1)) begin 
    
        altera_rapidio_transport_tl_large_x2_x4_pt_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(6'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );
    
        assign rx_packet_dropped = 1'b0;
        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; 
    
    end else if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0)) && ((p_GENERIC_LOGICAL == 1'b1))) begin
         altera_rapidio_transport_tl_large_x1_pt_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(7'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );
    
        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; 
        assign rx_packet_dropped = 1'b0;

    end else if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0)) && ((p_GENERIC_LOGICAL == 1'b0))) begin
        altera_rapidio_transport_tl_large_x1_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(7'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else if ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0) && (p_GENERIC_LOGICAL == 1'b0)) begin
        altera_rapidio_transport_tl_large_x1 /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else if ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0) && (p_GENERIC_LOGICAL == 1'b1)) begin
        altera_rapidio_transport_tl_large_x1_pt /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

        assign rx_packet_dropped = 1'b0;

    end else if (((IS_X2_MODE == 1'b1) || (IS_X4_MODE == 1'b1)) && (p_GENERIC_LOGICAL == 1'b1)) begin
        altera_rapidio_transport_tl_large_x2_x4_pt /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),  .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign rx_packet_dropped = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else begin

        altera_rapidio_transport_tl_large_x2_x4 /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end
end else begin
    if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE) || (IS_X4_MODE)) && (p_GENERIC_LOGICAL == 1'b0)) begin 

        altera_rapidio_transport_tl_small_x2_x4_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(6'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [7-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE == 1'b1) || (IS_X4_MODE == 1'b1)) && (p_GENERIC_LOGICAL == 1'b1)) begin 
    
        altera_rapidio_transport_tl_small_x2_x4_pt_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(6'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );
    
        assign rx_packet_dropped = 1'b0;
        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; 
    
    end else if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0)) && ((p_GENERIC_LOGICAL == 1'b1))) begin
         altera_rapidio_transport_tl_small_x1_pt_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(7'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );
    
        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; 
        assign rx_packet_dropped = 1'b0;

    end else if ((DRBELL_TX == 1'b1) && (DRBELL_RX == 1'b1) && ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0)) && ((p_GENERIC_LOGICAL == 1'b0))) begin
        altera_rapidio_transport_tl_small_x1_db /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .drbell_tx_packet_available(drbell_tx_packet_available),
        .drbell_tx_ready(drbell_tx_ready), .drbell_tx_valid(drbell_tx_valid),
        .drbell_tx_start_packet(drbell_tx_start_packet),
        .drbell_tx_end_packet(drbell_tx_end_packet),
        .drbell_tx_error(drbell_tx_error), .drbell_tx_empty(drbell_tx_empty),
        .drbell_tx_data(drbell_tx_data),
        .drbell_tx_size(7'd0 /*drbell_tx_packet_size*/),
        // Dummy but not used by transport module anyways.
        .drbell_rx_ready(drbell_rx_ready), .drbell_rx_valid(drbell_rx_valid),
        .drbell_rx_start_packet(drbell_rx_start_packet),
        .drbell_rx_end_packet(drbell_rx_end_packet),
        .drbell_rx_empty(drbell_rx_empty), .drbell_rx_data(drbell_rx_data),
        .drbell_rx_size(drbell_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else if ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0) && (p_GENERIC_LOGICAL == 1'b0)) begin
        altera_rapidio_transport_tl_small_x1 /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else if ((IS_X2_MODE == 1'b0) && (IS_X4_MODE == 1'b0) && (p_GENERIC_LOGICAL == 1'b1)) begin
        altera_rapidio_transport_tl_small_x1_pt /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .mnt_rx_ttype(mnt_rx_ttype), // output [3:0]
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

        assign rx_packet_dropped = 1'b0;

    end else if (((IS_X2_MODE == 1'b1) || (IS_X4_MODE == 1'b1)) && (p_GENERIC_LOGICAL == 1'b1)) begin
        altera_rapidio_transport_tl_small_x2_x4_pt /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),  .gen_txena(gen_tx_ready), // Output
        .gen_txval(gen_tx_valid), // Input
        .gen_txsop(gen_tx_startofpacket), // Input
        .gen_txeop(gen_tx_endofpacket), // Input
        .gen_txerr(gen_tx_error), // Input
        .gen_txmty(gen_tx_empty), // Input
        .gen_txdat(gen_tx_data), // Input
        .gen_rxena(gen_rx_ready), // Input
        .gen_rxval(gen_rx_valid), // Output
        .gen_rxsop(gen_rx_startofpacket), // Output
        .gen_rxeop(gen_rx_endofpacket), // Output
        .gen_rxmty(gen_rx_empty), // Output
        .gen_rxdat(gen_rx_data), // Output
        .gen_rxsize(gen_rx_size), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign rx_packet_dropped = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end else begin

        altera_rapidio_transport_tl_small_x2_x4 /* vx2 no_prefix */   transport(.sysclk(sysclk),
        // Input
        .reset_n(reset_n), // Input
        .device_id(device_id), // Input
        .promiscuous_mode(promiscuous_mode), // Input
        .tx_data_status(tx_data_status), // Input
        .tx_valid(tx_valid), // Output
        .tx_start_packet(tx_start_packet), // Output
        .tx_end_packet(tx_end_packet), // Output
        .tx_error(tx_error), // Output
        .tx_empty(tx_empty), // Output
        .tx_data(tx_data), // Output
        .rx_packet_available(rx_packet_available), // Input
        .rx_ready(rx_ready), // Output
        .rx_valid(rx_valid), // Input
        .rx_start_packet(rx_start_packet), // Input
        .rx_end_packet(rx_end_packet), // Input
        .rx_error(rx_error), // Input
        .rx_empty(rx_empty), // Input
        .rx_data(rx_data), // Input
        .mnt_tx_packet_available(mnt_tx_packet_available), // Input
        .mnt_tx_ready(mnt_tx_ready), // Output
        .mnt_tx_valid(mnt_tx_valid), // Input
        .mnt_tx_start_packet(mnt_tx_start_packet), // Input
        .mnt_tx_end_packet(mnt_tx_end_packet), // Input
        .mnt_tx_error(mnt_tx_error), // Input
        .mnt_tx_empty(mnt_tx_empty), // Input
        .mnt_tx_data(mnt_tx_data), // Input
        .mnt_tx_size(mnt_tx_size), // Input
        .mnt_rx_ready(mnt_rx_ready), // Input
        .mnt_rx_valid(mnt_rx_valid), // Output
        .mnt_rx_start_packet(mnt_rx_start_packet), // Output
        .mnt_rx_end_packet(mnt_rx_end_packet), // Output
        .mnt_rx_empty(mnt_rx_empty), // Output
        .mnt_rx_data(mnt_rx_data), // Output
        .mnt_rx_size(mnt_rx_size), // Output
        .io_m_tx_packet_available(io_m_tx_packet_available),
        .io_m_tx_ready(io_m_tx_ready), .io_m_tx_valid(io_m_tx_valid),
        .io_m_tx_start_packet(io_m_tx_start_packet),
        .io_m_tx_end_packet(io_m_tx_end_packet), .io_m_tx_error(io_m_tx_error),
        .io_m_tx_empty(io_m_tx_empty), .io_m_tx_data(io_m_tx_data),
        .io_m_tx_size(io_m_tx_packet_size), .io_m_rx_ready(io_m_rx_ready),
        .io_m_rx_valid(io_m_rx_valid),
        .io_m_rx_start_packet(io_m_rx_start_packet),
        .io_m_rx_end_packet(io_m_rx_end_packet), .io_m_rx_empty(io_m_rx_empty),
        .io_m_rx_data(io_m_rx_data), .io_m_rx_size(io_m_rx_packet_size),
        .io_s_tx_packet_available(io_s_tx_packet_available),
        .io_s_tx_ready(io_s_tx_ready), .io_s_tx_valid(io_s_tx_valid),
        .io_s_tx_start_packet(io_s_tx_start_packet),
        .io_s_tx_end_packet(io_s_tx_end_packet), .io_s_tx_error(io_s_tx_error),
        .io_s_tx_empty(io_s_tx_empty), .io_s_tx_data(io_s_tx_data),
        .io_s_tx_size(io_s_tx_packet_size), .io_s_rx_ready(io_s_rx_ready),
        .io_s_rx_valid(io_s_rx_valid),
        .io_s_rx_start_packet(io_s_rx_start_packet),
        .io_s_rx_end_packet(io_s_rx_end_packet), .io_s_rx_empty(io_s_rx_empty),
        .io_s_rx_data(io_s_rx_data), .io_s_rx_size(io_s_rx_packet_size),
        .rx_packet_dropped(rx_packet_dropped), // Output
        .atxwlevel(atxwlevel)// output [9-1:0]
        );

        assign gen_tx_ready = 1'b0;
        assign gen_rx_empty = {p_ADAT_MTY_WIDTH{1'b0}};
        assign gen_rx_data = {p_ADAT{1'b0}};
        assign gen_rx_size = {p_ADAT_SIZE_WIDTH{1'b0}};
        assign gen_rx_valid = 1'b0;
        assign gen_rx_startofpacket = 1'b0;
        assign gen_rx_endofpacket = 1'b0;

        defparam transport.rx_port_write  = PORT_WRITE_ENABLE;
        defparam transport.device_width=DEVICE_ID_WIDTH; //wire io_m_mnt_s_clk;

    end

end

endgenerate


//+++++++++++++++++++++++++++++++++++++++++++++++
//   Physical layer Avalon to AIRbus adaptor    +
//+++++++++++++++++++++++++++++++++++++++++++++++
/*CALL*/
 altera_rapidio_phy_mnt /* vx2 no_prefix */   phy_mnt(.clk(sysclk),
.reset_n(sys_mnt_s_reset_n), .phy_mnt_s_chipselect(phy_mnt_s_chipselect),
// Input
.phy_mnt_s_waitrequest(phy_mnt_s_waitrequest), // Output
.phy_mnt_s_read(phy_mnt_s_read), // Input
.phy_mnt_s_write(phy_mnt_s_write), // Input
.phy_mnt_s_address(phy_mnt_s_address[16:2]), // Input [16:2]
.phy_mnt_s_writedata(phy_mnt_s_writedata), // Input
.phy_mnt_s_readdata(phy_mnt_s_readdata), // Output
.sel(sel), // Output
.read(read), // Output
.addr(addr), // Output
.wdata(wdata), // Output
.rdata(rdata), // Input
.dtack(dtack)// Input
);
//++++++++++++++++++++++++++++++++++++
//+      Serial Physical Layer       +
//++++++++++++++++++++++++++++++++++++
assign select_silence = 1'b1;// select low speed
// Keep all parts of riophy_dcore in reset until all clocks are valid i.e. until rxreset_n is de-asserted
// Retime rxreset_n in sysclk


reg sysclk_rxreset_n_meta;
reg sysclk_rxreset_n_hard;

always @(posedge sysclk or negedge reset_n)
begin 
    if (! reset_n) begin 
        sysclk_rxreset_n_meta<=1'b0;
        sysclk_rxreset_n_hard<=1'b0;
    end 
    else
    begin 
        sysclk_rxreset_n_meta<=rxreset_n;
        sysclk_rxreset_n_hard<=sysclk_rxreset_n_meta;
    end 
end 
wire  atxclk = sysclk  ;
wire  atxclk_rxreset_n = sysclk_rxreset_n_hard  ;
reg  atxreset_n  ;

always @(posedge atxclk or negedge reset_n)
begin 
    if (! reset_n) begin 
        atxreset_n<=0;
    end 
    else
    begin 
        if (atxclk_rxreset_n == 0) begin 
            atxreset_n<=1'b0;
        end 
        else
        begin 
            atxreset_n<=1'b1;
        end 
    end 
end 
wire  arxclk = sysclk  ;
wire  arxclk_rxreset_n = sysclk_rxreset_n_hard  ;
reg  arxreset_n  ;

always @(posedge arxclk or negedge reset_n)
begin 
    if (! reset_n) begin 
        arxreset_n<=0;
    end 
    else
    begin 
        if (arxclk_rxreset_n == 0) begin 
            arxreset_n<=1'b0;
        end 
        else
        begin 
            arxreset_n<=1'b1;
        end 
    end 
end /*CALL*/


generate
    if (IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && p_TIMEOUT_ENABLE == 1'b1) begin

        altera_rapidio_riophy_dcore_x1 /* vx2 no_prefix */   riophy_dcore(.txclk(txclk),
        // input
        .rxclk(rxclk), // input
        .txreset_n(txreset_n), // input
        .rxreset_n(rxreset_n), // input
        .port_initialized(port_initialized), // output
        .atxclk(atxclk), // input
        .atxreset_n(atxreset_n), // input
        .arxclk(arxclk), // input
        .arxreset_n(arxreset_n), // input
        .atxdav(tx_data_status), // output
        .atxena(tx_valid), // input
        .atxsop(tx_start_packet), // input
        .atxeop(tx_end_packet), // input
        .atxerr(tx_error), // input
        .atxmty(tx_empty), // input [3-1:0]
        .atxdat(tx_data), // input [64-1:0]
        .arxena(rx_ready), // input
        .arxdav(rx_packet_available), // output
        .arxdat(rx_data), // output [ARXDAT-1:0]
        .arxval(rx_valid), // output
        .arxsop(rx_start_packet), // output
        .arxeop(rx_end_packet), // output
        .arxmty(rx_empty), // output [3-1:0]
        .arxerr(rx_error), // output
        .atxwlevel(atxwlevel), // output [9-1:0]
        .atxovf(atxovf), // output
        .arxwlevel(arxwlevel), // output [9:0]
        .rx_threshold_0(rx_threshold_0), // input
        .rx_threshold_1(rx_threshold_1), // input
        .rx_threshold_2(rx_threshold_2), // input
        .buf_av0(buf_av0), // output
        .buf_av1(buf_av1), // output
        .buf_av2(buf_av2), // output
        .buf_av3(buf_av3), // output
        .output_enable(output_enable), // input
        .input_enable(input_enable), // input
        .rx_patterndetect(rx_patterndetect), // input
        .rx_ctrldetect(rx_ctrldetect), // input
        .rx_errdetect(rx_errdetect), // input
        .rx_out(rx_out), // input
        .link_drvr_oe(link_drvr_oe), // output
        .tx_in(tx_in), // output
        .tx_ctrlenable(tx_ctrlenable), // output
        .rxgxbclk(rxgxbclk), // input
        .txgxbclk(txgxbclk), // input
        // Airbus Interface
        .sel(sel), // input
        .read(read), // input
        .addr(addr), // input [16:2]
        .wdata(wdata), // input [31:0]
        .rdata(rdata), // output [31:0]
        .dtack(dtack), // output
        // Silence timer control.
        .test_silence(simulation_speedup), // input
        .select_silence(select_silence), // input
        .packet_transmitted(packet_transmitted), // output
        .packet_cancelled(packet_cancelled), // output
        .packet_accepted(packet_accepted), // output
        .packet_retry(packet_retry), // output
        .packet_not_accepted(packet_not_accepted), // output
        .packet_crc_error(packet_crc_error), // output
        .sym_err(symbol_error), // output
        .char_err(char_err), // output
        .ef_ptr(ef_ptr), // input [15:0]
        .prtctrl_value_ctrl(prtctrl_value_ctrl), // output[23:0]
        .errstat_port_err_ctrl(port_error), // output
        .master_enable(master_enable), // output
        .txclk_timeout_prescaler(txclk_timeout_prescaler), // input [6:0]
        .multicast_event_rx(multicast_event_rx), // output
        .multicast_event_tx(multicast_event_tx),// input
        .no_sync_indicator(no_sync_indicator)
        );
        defparam riophy_dcore.p_SEND_RESET_DEVICE = p_SEND_RESET_DEVICE;
        defparam riophy_dcore.max_icnt = max_icnt;

    end else if (IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b0 && p_TIMEOUT_ENABLE == 1'b0) begin

        altera_rapidio_riophy_dcore_x1_notimeout /* vx2 no_prefix */   riophy_dcore(.txclk(txclk),
        // input
        .rxclk(rxclk), // input
        .txreset_n(txreset_n), // input
        .rxreset_n(rxreset_n), // input
        .port_initialized(port_initialized), // output
        .atxclk(atxclk), // input
        .atxreset_n(atxreset_n), // input
        .arxclk(arxclk), // input
        .arxreset_n(arxreset_n), // input
        .atxdav(tx_data_status), // output
        .atxena(tx_valid), // input
        .atxsop(tx_start_packet), // input
        .atxeop(tx_end_packet), // input
        .atxerr(tx_error), // input
        .atxmty(tx_empty), // input [3-1:0]
        .atxdat(tx_data), // input [64-1:0]
        .arxena(rx_ready), // input
        .arxdav(rx_packet_available), // output
        .arxdat(rx_data), // output [ARXDAT-1:0]
        .arxval(rx_valid), // output
        .arxsop(rx_start_packet), // output
        .arxeop(rx_end_packet), // output
        .arxmty(rx_empty), // output [3-1:0]
        .arxerr(rx_error), // output
        .atxwlevel(atxwlevel), // output [9-1:0]
        .atxovf(atxovf), // output
        .arxwlevel(arxwlevel), // output [9:0]
        .rx_threshold_0(rx_threshold_0), // input
        .rx_threshold_1(rx_threshold_1), // input
        .rx_threshold_2(rx_threshold_2), // input
        .buf_av0(buf_av0), // output
        .buf_av1(buf_av1), // output
        .buf_av2(buf_av2), // output
        .buf_av3(buf_av3), // output
        .output_enable(output_enable), // input
        .input_enable(input_enable), // input
        .rx_patterndetect(rx_patterndetect), // input
        .rx_ctrldetect(rx_ctrldetect), // input
        .rx_errdetect(rx_errdetect), // input
        .rx_out(rx_out), // input
        .link_drvr_oe(link_drvr_oe), // output
        .tx_in(tx_in), // output
        .tx_ctrlenable(tx_ctrlenable), // output
        .rxgxbclk(rxgxbclk), // input
        .txgxbclk(txgxbclk), // input
        // Airbus Interface
        .sel(sel), // input
        .read(read), // input
        .addr(addr), // input [16:2]
        .wdata(wdata), // input [31:0]
        .rdata(rdata), // output [31:0]
        .dtack(dtack), // output
        // Silence timer control.
        .test_silence(simulation_speedup), // input
        .select_silence(select_silence), // input
        .packet_transmitted(packet_transmitted), // output
        .packet_cancelled(packet_cancelled), // output
        .packet_accepted(packet_accepted), // output
        .packet_retry(packet_retry), // output
        .packet_not_accepted(packet_not_accepted), // output
        .packet_crc_error(packet_crc_error), // output
        .sym_err(symbol_error), // output
        .char_err(char_err), // output
        .ef_ptr(ef_ptr), // input [15:0]
        .prtctrl_value_ctrl(prtctrl_value_ctrl), // output[23:0]
        .errstat_port_err_ctrl(port_error), // output
        .master_enable(master_enable), // output
        .txclk_timeout_prescaler(txclk_timeout_prescaler), // input [6:0]
        .multicast_event_rx(multicast_event_rx), // output
        .multicast_event_tx(multicast_event_tx),// input
        .no_sync_indicator(no_sync_indicator)
        );
        defparam riophy_dcore.p_SEND_RESET_DEVICE = p_SEND_RESET_DEVICE;
        defparam riophy_dcore.max_icnt = max_icnt;

    end else if (IS_X2_MODE == 1'b1 && IS_X4_MODE == 1'b0 && p_TIMEOUT_ENABLE == 1'b1) begin

         altera_rapidio_riophy_dcore_x2 /* vx2 no_prefix */   riophy_dcore(.txclk(txclk),
        // input
        .rxclk(rxclk), // input
        .txreset_n(txreset_n), // input
        .rxreset_n(rxreset_n), // input
        .port_initialized(port_initialized), // output
        .atxclk(atxclk), // input
        .atxreset_n(atxreset_n), // input
        .arxclk(arxclk), // input
        .arxreset_n(arxreset_n), // input
        .atxdav(tx_data_status), // output
        .atxena(tx_valid), // input
        .atxsop(tx_start_packet), // input
        .atxeop(tx_end_packet), // input
        .atxerr(tx_error), // input
        .atxmty(tx_empty), // input [3-1:0]
        .atxdat(tx_data), // input [64-1:0]
        .arxena(rx_ready), // input
        .arxdav(rx_packet_available), // output
        .arxdat(rx_data), // output [ARXDAT-1:0]
        .arxval(rx_valid), // output
        .arxsop(rx_start_packet), // output
        .arxeop(rx_end_packet), // output
        .arxmty(rx_empty), // output [3-1:0]
        .arxerr(rx_error), // output
        .atxwlevel(atxwlevel), // output [9-1:0]
        .atxovf(atxovf), // output
        .arxwlevel(arxwlevel), // output [9:0]
        .rx_threshold_0(rx_threshold_0), // input
        .rx_threshold_1(rx_threshold_1), // input
        .rx_threshold_2(rx_threshold_2), // input
        .buf_av0(buf_av0), // output
        .buf_av1(buf_av1), // output
        .buf_av2(buf_av2), // output
        .buf_av3(buf_av3), // output
        .output_enable(output_enable), // input
        .input_enable(input_enable), // input
        .rx_patterndetect(rx_patterndetect), // input
        .rx_ctrldetect(rx_ctrldetect), // input
        .rx_errdetect(rx_errdetect), // input
        .rx_out(rx_out), // input
        .link_drvr_oe(link_drvr_oe), // output
        .tx_in(tx_in), // output
        .tx_ctrlenable(tx_ctrlenable), // output
        // Airbus Interface
        .sel(sel), // input
        .read(read), // input
        .addr(addr), // input [16:2]
        .wdata(wdata), // input [31:0]
        .rdata(rdata), // output [31:0]
        .dtack(dtack), // output
        // Silence timer control.
        .test_silence(simulation_speedup), // input
        .select_silence(select_silence), // input
        .packet_transmitted(packet_transmitted), // output
        .packet_cancelled(packet_cancelled), // output
        .packet_accepted(packet_accepted), // output
        .packet_retry(packet_retry), // output
        .packet_not_accepted(packet_not_accepted), // output
        .packet_crc_error(packet_crc_error), // output
        .sym_err(symbol_error), // output
        .char_err(char_err), // output
        .ef_ptr(ef_ptr), // input [15:0]
        .prtctrl_value_ctrl(prtctrl_value_ctrl), // output[23:0]
        .errstat_port_err_ctrl(port_error), // output
        .master_enable(master_enable), // output
        .txclk_timeout_prescaler(txclk_timeout_prescaler), // input [6:0]
        .multicast_event_rx(multicast_event_rx), // output
        .multicast_event_tx(multicast_event_tx),// input
        .no_sync_indicator(no_sync_indicator)
        );
        defparam riophy_dcore.p_SEND_RESET_DEVICE = p_SEND_RESET_DEVICE;
        defparam riophy_dcore.max_icnt = max_icnt;

    end else if (IS_X2_MODE == 1'b1 && IS_X4_MODE == 1'b0 && p_TIMEOUT_ENABLE == 1'b0) begin

         altera_rapidio_riophy_dcore_x2_notimeout /* vx2 no_prefix */   riophy_dcore(.txclk(txclk),
        // input
        .rxclk(rxclk), // input
        .txreset_n(txreset_n), // input
        .rxreset_n(rxreset_n), // input
        .port_initialized(port_initialized), // output
        .atxclk(atxclk), // input
        .atxreset_n(atxreset_n), // input
        .arxclk(arxclk), // input
        .arxreset_n(arxreset_n), // input
        .atxdav(tx_data_status), // output
        .atxena(tx_valid), // input
        .atxsop(tx_start_packet), // input
        .atxeop(tx_end_packet), // input
        .atxerr(tx_error), // input
        .atxmty(tx_empty), // input [3-1:0]
        .atxdat(tx_data), // input [64-1:0]
        .arxena(rx_ready), // input
        .arxdav(rx_packet_available), // output
        .arxdat(rx_data), // output [ARXDAT-1:0]
        .arxval(rx_valid), // output
        .arxsop(rx_start_packet), // output
        .arxeop(rx_end_packet), // output
        .arxmty(rx_empty), // output [3-1:0]
        .arxerr(rx_error), // output
        .atxwlevel(atxwlevel), // output [9-1:0]
        .atxovf(atxovf), // output
        .arxwlevel(arxwlevel), // output [9:0]
        .rx_threshold_0(rx_threshold_0), // input
        .rx_threshold_1(rx_threshold_1), // input
        .rx_threshold_2(rx_threshold_2), // input
        .buf_av0(buf_av0), // output
        .buf_av1(buf_av1), // output
        .buf_av2(buf_av2), // output
        .buf_av3(buf_av3), // output
        .output_enable(output_enable), // input
        .input_enable(input_enable), // input
        .rx_patterndetect(rx_patterndetect), // input
        .rx_ctrldetect(rx_ctrldetect), // input
        .rx_errdetect(rx_errdetect), // input
        .rx_out(rx_out), // input
        .link_drvr_oe(link_drvr_oe), // output
        .tx_in(tx_in), // output
        .tx_ctrlenable(tx_ctrlenable), // output
        // Airbus Interface
        .sel(sel), // input
        .read(read), // input
        .addr(addr), // input [16:2]
        .wdata(wdata), // input [31:0]
        .rdata(rdata), // output [31:0]
        .dtack(dtack), // output
        // Silence timer control.
        .test_silence(simulation_speedup), // input
        .select_silence(select_silence), // input
        .packet_transmitted(packet_transmitted), // output
        .packet_cancelled(packet_cancelled), // output
        .packet_accepted(packet_accepted), // output
        .packet_retry(packet_retry), // output
        .packet_not_accepted(packet_not_accepted), // output
        .packet_crc_error(packet_crc_error), // output
        .sym_err(symbol_error), // output
        .char_err(char_err), // output
        .ef_ptr(ef_ptr), // input [15:0]
        .prtctrl_value_ctrl(prtctrl_value_ctrl), // output[23:0]
        .errstat_port_err_ctrl(port_error), // output
        .master_enable(master_enable), // output
        .txclk_timeout_prescaler(txclk_timeout_prescaler), // input [6:0]
        .multicast_event_rx(multicast_event_rx), // output
        .multicast_event_tx(multicast_event_tx),// input
        .no_sync_indicator(no_sync_indicator)
        );
        defparam riophy_dcore.p_SEND_RESET_DEVICE = p_SEND_RESET_DEVICE;
        defparam riophy_dcore.max_icnt = max_icnt;

    end else if (IS_X2_MODE == 1'b0 && IS_X4_MODE == 1'b1 && p_TIMEOUT_ENABLE == 1'b1) begin

         altera_rapidio_riophy_dcore_x4 /* vx2 no_prefix */   riophy_dcore(.txclk(txclk),
        // input
        .rxclk(rxclk), // input
        .txreset_n(txreset_n), // input
        .rxreset_n(rxreset_n), // input
        .port_initialized(port_initialized), // output
        .atxclk(atxclk), // input
        .atxreset_n(atxreset_n), // input
        .arxclk(arxclk), // input
        .arxreset_n(arxreset_n), // input
        .atxdav(tx_data_status), // output
        .atxena(tx_valid), // input
        .atxsop(tx_start_packet), // input
        .atxeop(tx_end_packet), // input
        .atxerr(tx_error), // input
        .atxmty(tx_empty), // input [3-1:0]
        .atxdat(tx_data), // input [64-1:0]
        .arxena(rx_ready), // input
        .arxdav(rx_packet_available), // output
        .arxdat(rx_data), // output [ARXDAT-1:0]
        .arxval(rx_valid), // output
        .arxsop(rx_start_packet), // output
        .arxeop(rx_end_packet), // output
        .arxmty(rx_empty), // output [3-1:0]
        .arxerr(rx_error), // output
        .atxwlevel(atxwlevel), // output [9-1:0]
        .atxovf(atxovf), // output
        .arxwlevel(arxwlevel), // output [9:0]
        .rx_threshold_0(rx_threshold_0), // input
        .rx_threshold_1(rx_threshold_1), // input
        .rx_threshold_2(rx_threshold_2), // input
        .buf_av0(buf_av0), // output
        .buf_av1(buf_av1), // output
        .buf_av2(buf_av2), // output
        .buf_av3(buf_av3), // output
        .output_enable(output_enable), // input
        .input_enable(input_enable), // input
        .rx_patterndetect(rx_patterndetect), // input
        .rx_ctrldetect(rx_ctrldetect), // input
        .rx_errdetect(rx_errdetect), // input
        .rx_out(rx_out), // input
        .link_drvr_oe(link_drvr_oe), // output
        .tx_in(tx_in), // output
        .tx_ctrlenable(tx_ctrlenable), // output
        // Airbus Interface
        .sel(sel), // input
        .read(read), // input
        .addr(addr), // input [16:2]
        .wdata(wdata), // input [31:0]
        .rdata(rdata), // output [31:0]
        .dtack(dtack), // output
        // Silence timer control.
        .test_silence(simulation_speedup), // input
        .select_silence(select_silence), // input
        .packet_transmitted(packet_transmitted), // output
        .packet_cancelled(packet_cancelled), // output
        .packet_accepted(packet_accepted), // output
        .packet_retry(packet_retry), // output
        .packet_not_accepted(packet_not_accepted), // output
        .packet_crc_error(packet_crc_error), // output
        .sym_err(symbol_error), // output
        .char_err(char_err), // output
        .ef_ptr(ef_ptr), // input [15:0]
        .prtctrl_value_ctrl(prtctrl_value_ctrl), // output[23:0]
        .errstat_port_err_ctrl(port_error), // output
        .master_enable(master_enable), // output
        .txclk_timeout_prescaler(txclk_timeout_prescaler), // input [6:0]
        .multicast_event_rx(multicast_event_rx), // output
        .multicast_event_tx(multicast_event_tx),// input
        .no_sync_indicator(no_sync_indicator)
        );
        defparam riophy_dcore.p_SEND_RESET_DEVICE = p_SEND_RESET_DEVICE;
        defparam riophy_dcore.max_icnt = max_icnt;

    end else begin
         altera_rapidio_riophy_dcore_x4_notimeout /* vx2 no_prefix */   riophy_dcore(.txclk(txclk),
        // input
        .rxclk(rxclk), // input
        .txreset_n(txreset_n), // input
        .rxreset_n(rxreset_n), // input
        .port_initialized(port_initialized), // output
        .atxclk(atxclk), // input
        .atxreset_n(atxreset_n), // input
        .arxclk(arxclk), // input
        .arxreset_n(arxreset_n), // input
        .atxdav(tx_data_status), // output
        .atxena(tx_valid), // input
        .atxsop(tx_start_packet), // input
        .atxeop(tx_end_packet), // input
        .atxerr(tx_error), // input
        .atxmty(tx_empty), // input [3-1:0]
        .atxdat(tx_data), // input [64-1:0]
        .arxena(rx_ready), // input
        .arxdav(rx_packet_available), // output
        .arxdat(rx_data), // output [ARXDAT-1:0]
        .arxval(rx_valid), // output
        .arxsop(rx_start_packet), // output
        .arxeop(rx_end_packet), // output
        .arxmty(rx_empty), // output [3-1:0]
        .arxerr(rx_error), // output
        .atxwlevel(atxwlevel), // output [9-1:0]
        .atxovf(atxovf), // output
        .arxwlevel(arxwlevel), // output [9:0]
        .rx_threshold_0(rx_threshold_0), // input
        .rx_threshold_1(rx_threshold_1), // input
        .rx_threshold_2(rx_threshold_2), // input
        .buf_av0(buf_av0), // output
        .buf_av1(buf_av1), // output
        .buf_av2(buf_av2), // output
        .buf_av3(buf_av3), // output
        .output_enable(output_enable), // input
        .input_enable(input_enable), // input
        .rx_patterndetect(rx_patterndetect), // input
        .rx_ctrldetect(rx_ctrldetect), // input
        .rx_errdetect(rx_errdetect), // input
        .rx_out(rx_out), // input
        .link_drvr_oe(link_drvr_oe), // output
        .tx_in(tx_in), // output
        .tx_ctrlenable(tx_ctrlenable), // output
        // Airbus Interface
        .sel(sel), // input
        .read(read), // input
        .addr(addr), // input [16:2]
        .wdata(wdata), // input [31:0]
        .rdata(rdata), // output [31:0]
        .dtack(dtack), // output
        // Silence timer control.
        .test_silence(simulation_speedup), // input
        .select_silence(select_silence), // input
        .packet_transmitted(packet_transmitted), // output
        .packet_cancelled(packet_cancelled), // output
        .packet_accepted(packet_accepted), // output
        .packet_retry(packet_retry), // output
        .packet_not_accepted(packet_not_accepted), // output
        .packet_crc_error(packet_crc_error), // output
        .sym_err(symbol_error), // output
        .char_err(char_err), // output
        .ef_ptr(ef_ptr), // input [15:0]
        .prtctrl_value_ctrl(prtctrl_value_ctrl), // output[23:0]
        .errstat_port_err_ctrl(port_error), // output
        .master_enable(master_enable), // output
        .txclk_timeout_prescaler(txclk_timeout_prescaler), // input [6:0]
        .multicast_event_rx(multicast_event_rx), // output
        .multicast_event_tx(multicast_event_tx),// input
        .no_sync_indicator(no_sync_indicator)
        );
        defparam riophy_dcore.p_SEND_RESET_DEVICE = p_SEND_RESET_DEVICE;
        defparam riophy_dcore.max_icnt = max_icnt;

    end
    
endgenerate

// Metaharden the master_enable signal to the sysclk domain

always @(posedge sysclk or negedge reset_n)
begin 
    if (reset_n == 1'b0) begin 
        master_enable_meta<=1'b0;
        master_enable_sync<=1'b0;
    end 
    else
    begin 
        master_enable_meta<=master_enable;
        master_enable_sync<=master_enable_meta;
    end 
end 
endmodule

