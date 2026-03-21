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

MODULE_NAME =  transport
COMPANY =      Altera Corporation, Altera Ottawa Technology Center
WEB =          www.altera.com
EMAIL =        otc_technical@altera.com

FUNCTIONAL_DESCRIPTION :

END_FUNCTIONAL_DESCRIPTION

SUB_MODULES = <call>

REVISION = $Id: //acds/main/ip/rapidio/rio/hw/src/rtl/transport/transport.v.erp#2 

LEGAL :
Copyright 2005-2008 Altera Corporation.  All rights reserved.
END_LEGAL

******************************************************
*/
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module  altera_rapidio_transport_tl_small_x2_x4_pt_db /* vx2 no_prefix */  (
sysclk,
reset_n,
device_id,
promiscuous_mode,
atxwlevel,
tx_data_status,
tx_valid,
tx_start_packet,
tx_end_packet,
tx_error,
tx_empty,
tx_data,
rx_packet_available,
rx_ready,
rx_valid,
rx_start_packet,
rx_end_packet,
rx_error,
rx_empty,
rx_data,
mnt_tx_packet_available,
mnt_tx_ready,
mnt_tx_valid,
mnt_tx_start_packet,
mnt_tx_end_packet,
mnt_tx_error,
mnt_tx_empty,
mnt_tx_data,
mnt_tx_size,
mnt_rx_ready,
mnt_rx_valid,
mnt_rx_start_packet,
mnt_rx_end_packet,
mnt_rx_empty,
mnt_rx_data,
mnt_rx_size,
io_m_tx_packet_available,
io_m_tx_ready,
io_m_tx_valid,
io_m_tx_start_packet,
io_m_tx_end_packet,
io_m_tx_error,
io_m_tx_empty,
io_m_tx_data,
io_m_tx_size,
io_m_rx_ready,
io_m_rx_valid,
io_m_rx_start_packet,
io_m_rx_end_packet,
io_m_rx_empty,
io_m_rx_data,
io_m_rx_size,
io_s_tx_packet_available,
io_s_tx_ready,
io_s_tx_valid,
io_s_tx_start_packet,
io_s_tx_end_packet,
io_s_tx_error,
io_s_tx_empty,
io_s_tx_data,
io_s_tx_size,
io_s_rx_ready,
io_s_rx_valid,
io_s_rx_start_packet,
io_s_rx_end_packet,
io_s_rx_empty,
io_s_rx_data,
io_s_rx_size,
drbell_tx_packet_available,
drbell_tx_ready,
drbell_tx_valid,
drbell_tx_start_packet,
drbell_tx_end_packet,
drbell_tx_error,
drbell_tx_empty,
drbell_tx_data,
drbell_tx_size,
drbell_rx_ready,
drbell_rx_valid,
drbell_rx_start_packet,
drbell_rx_end_packet,
drbell_rx_empty,
drbell_rx_data,
drbell_rx_size,
gen_txena,
gen_txval,
gen_txsop,
gen_txeop,
gen_txerr,
gen_txmty,
gen_txdat,
gen_rxena,
gen_rxval,
gen_rxsop,
gen_rxeop,
gen_rxmty,
gen_rxdat,
gen_rxsize);

// Ports and local variables. 
// '_F' indicates an auxiliary variable for flip-flops
// '_S' indicates an auxiliary variable for combinational signals
// '_W' indicates a VX2-created wire
parameter device_width = 8;
parameter rx_port_write = 1'b0;
// **************************************************************
// **************************************************************
// internal_variables (flop, signal, reg, wire, etc.)
// **************************************************************
// structural_code
/*CALL*/
input sysclk;
input reset_n;
input[device_width - 1:0] device_id;
input promiscuous_mode;
input[9 - 1:0] atxwlevel;
input tx_data_status;
output tx_valid;
output tx_start_packet;
output tx_end_packet;
output tx_error;
output[3 - 1:0] tx_empty;
output[64 - 1:0] tx_data;
input rx_packet_available;
output rx_ready;
input rx_valid;
input rx_start_packet;
input rx_end_packet;
input rx_error;
input[3 - 1:0] rx_empty;
input[64 - 1:0] rx_data;
input mnt_tx_packet_available;
output mnt_tx_ready;
input mnt_tx_valid;
input mnt_tx_start_packet;
input mnt_tx_end_packet;
input mnt_tx_error;
input[3 - 1:0] mnt_tx_empty;
input[64 - 1:0] mnt_tx_data;
input[6 - 1:0] mnt_tx_size;
input mnt_rx_ready;
output mnt_rx_valid;
output mnt_rx_start_packet;
output mnt_rx_end_packet;
output[3 - 1:0] mnt_rx_empty;
output[64 - 1:0] mnt_rx_data;
output[6 - 1:0] mnt_rx_size;
input io_m_tx_packet_available;
output io_m_tx_ready;
input io_m_tx_valid;
input io_m_tx_start_packet;
input io_m_tx_end_packet;
input io_m_tx_error;
input[3 - 1:0] io_m_tx_empty;
input[64 - 1:0] io_m_tx_data;
input[6 - 1:0] io_m_tx_size;
input io_m_rx_ready;
output io_m_rx_valid;
output io_m_rx_start_packet;
output io_m_rx_end_packet;
output[3 - 1:0] io_m_rx_empty;
output[64 - 1:0] io_m_rx_data;
output[6 - 1:0] io_m_rx_size;
input io_s_tx_packet_available;
output io_s_tx_ready;
input io_s_tx_valid;
input io_s_tx_start_packet;
input io_s_tx_end_packet;
input io_s_tx_error;
input[3 - 1:0] io_s_tx_empty;
input[64 - 1:0] io_s_tx_data;
input[6 - 1:0] io_s_tx_size;
input io_s_rx_ready;
output io_s_rx_valid;
output io_s_rx_start_packet;
output io_s_rx_end_packet;
output[3 - 1:0] io_s_rx_empty;
output[64 - 1:0] io_s_rx_data;
output[6 - 1:0] io_s_rx_size;
input drbell_tx_packet_available;
output drbell_tx_ready;
input drbell_tx_valid;
input drbell_tx_start_packet;
input drbell_tx_end_packet;
input drbell_tx_error;
input[3 - 1:0] drbell_tx_empty;
input[64 - 1:0] drbell_tx_data;
input[6 - 1:0] drbell_tx_size;
input drbell_rx_ready;
output drbell_rx_valid;
output drbell_rx_start_packet;
output drbell_rx_end_packet;
output[3 - 1:0] drbell_rx_empty;
output[64 - 1:0] drbell_rx_data;
output[6 - 1:0] drbell_rx_size;
output gen_txena;
input gen_txval;
input gen_txsop;
input gen_txeop;
input gen_txerr;
input[3 - 1:0] gen_txmty;
input[64 - 1:0] gen_txdat;
input gen_rxena;
output gen_rxval;
output gen_rxsop;
output gen_rxeop;
output[3 - 1:0] gen_rxmty;
output[64 - 1:0] gen_rxdat;
output[6 - 1:0] gen_rxsize;
wire  sysclk  ;
wire  reset_n  ;
wire  [device_width - 1:0] device_id  ;
wire  promiscuous_mode  ;
wire  [9 - 1:0] atxwlevel  ;
wire  tx_data_status  ;
wire  tx_valid  ;
wire  tx_start_packet  ;
wire  tx_end_packet  ;
wire  tx_error  ;
wire  [3 - 1:0] tx_empty  ;
wire  [64 - 1:0] tx_data  ;
wire  rx_packet_available  ;
wire  rx_ready  ;
wire  rx_valid  ;
wire  rx_start_packet  ;
wire  rx_end_packet  ;
wire  rx_error  ;
wire  [3 - 1:0] rx_empty  ;
wire  [64 - 1:0] rx_data  ;
wire  mnt_tx_packet_available  ;
wire  mnt_tx_ready  ;
wire  mnt_tx_valid  ;
wire  mnt_tx_start_packet  ;
wire  mnt_tx_end_packet  ;
wire  mnt_tx_error  ;
wire  [3 - 1:0] mnt_tx_empty  ;
wire  [64 - 1:0] mnt_tx_data  ;
wire  [6 - 1:0] mnt_tx_size  ;
wire  mnt_rx_ready  ;
wire  mnt_rx_valid  ;
wire  mnt_rx_start_packet  ;
wire  mnt_rx_end_packet  ;
wire  [3 - 1:0] mnt_rx_empty  ;
wire  [64 - 1:0] mnt_rx_data  ;
wire  [6 - 1:0] mnt_rx_size  ;
wire  io_m_tx_packet_available  ;
wire  io_m_tx_ready  ;
wire  io_m_tx_valid  ;
wire  io_m_tx_start_packet  ;
wire  io_m_tx_end_packet  ;
wire  io_m_tx_error  ;
wire  [3 - 1:0] io_m_tx_empty  ;
wire  [64 - 1:0] io_m_tx_data  ;
wire  [6 - 1:0] io_m_tx_size  ;
wire  io_m_rx_ready  ;
wire  io_m_rx_valid  ;
wire  io_m_rx_start_packet  ;
wire  io_m_rx_end_packet  ;
wire  [3 - 1:0] io_m_rx_empty  ;
wire  [64 - 1:0] io_m_rx_data  ;
wire  [6 - 1:0] io_m_rx_size  ;
wire  io_s_tx_packet_available  ;
wire  io_s_tx_ready  ;
wire  io_s_tx_valid  ;
wire  io_s_tx_start_packet  ;
wire  io_s_tx_end_packet  ;
wire  io_s_tx_error  ;
wire  [3 - 1:0] io_s_tx_empty  ;
wire  [64 - 1:0] io_s_tx_data  ;
wire  [6 - 1:0] io_s_tx_size  ;
wire  io_s_rx_ready  ;
wire  io_s_rx_valid  ;
wire  io_s_rx_start_packet  ;
wire  io_s_rx_end_packet  ;
wire  [3 - 1:0] io_s_rx_empty  ;
wire  [64 - 1:0] io_s_rx_data  ;
wire  [6 - 1:0] io_s_rx_size  ;
wire  drbell_tx_packet_available  ;
wire  drbell_tx_ready  ;
wire  drbell_tx_valid  ;
wire  drbell_tx_start_packet  ;
wire  drbell_tx_end_packet  ;
wire  drbell_tx_error  ;
wire  [3 - 1:0] drbell_tx_empty  ;
wire  [64 - 1:0] drbell_tx_data  ;
wire  [6 - 1:0] drbell_tx_size  ;
wire  drbell_rx_ready  ;
wire  drbell_rx_valid  ;
wire  drbell_rx_start_packet  ;
wire  drbell_rx_end_packet  ;
wire  [3 - 1:0] drbell_rx_empty  ;
wire  [64 - 1:0] drbell_rx_data  ;
wire  [6 - 1:0] drbell_rx_size  ;
wire  gen_txena  ;
wire  gen_txval  ;
wire  gen_txsop  ;
wire  gen_txeop  ;
wire  gen_txerr  ;
wire  [3 - 1:0] gen_txmty  ;
wire  [64 - 1:0] gen_txdat  ;
wire  gen_rxena  ;
wire  gen_rxval  ;
wire  gen_rxsop  ;
wire  gen_rxeop  ;
wire  [3 - 1:0] gen_rxmty  ;
wire  [64 - 1:0] gen_rxdat  ;
wire  [6 - 1:0] gen_rxsize  ;
 altera_rapidio_tx_transport_tl_small_x2_x4_pt_db /* vx2 no_prefix */   tx_transport(.clk(sysclk),
// input
.reset_n(reset_n), // input
.tx_data_status(tx_data_status), // input
.tx_valid(tx_valid), // output
.tx_start_packet(tx_start_packet), // output
.tx_end_packet(tx_end_packet), // output
.tx_error(tx_error), // output
.tx_empty(tx_empty), // output
.tx_data(tx_data), // output
.mnt_tx_packet_available(mnt_tx_packet_available), // input
.mnt_tx_ready(mnt_tx_ready), // output
.mnt_tx_valid(mnt_tx_valid), // input
.mnt_tx_start_packet(mnt_tx_start_packet), // input
.mnt_tx_end_packet(mnt_tx_end_packet), // input
.mnt_tx_error(mnt_tx_error), // input
.mnt_tx_empty(mnt_tx_empty), // input
.mnt_tx_data(mnt_tx_data), // input
.mnt_tx_size(mnt_tx_size), // input
.io_m_tx_packet_available(io_m_tx_packet_available), // input
.io_m_tx_ready(io_m_tx_ready), // output
.io_m_tx_valid(io_m_tx_valid), // input
.io_m_tx_start_packet(io_m_tx_start_packet), // input
.io_m_tx_end_packet(io_m_tx_end_packet), // input
.io_m_tx_error(io_m_tx_error), // input
.io_m_tx_empty(io_m_tx_empty), // input
.io_m_tx_data(io_m_tx_data), // input
.io_m_tx_size(io_m_tx_size), // input
.io_s_tx_packet_available(io_s_tx_packet_available), // input
.io_s_tx_ready(io_s_tx_ready), // output
.io_s_tx_valid(io_s_tx_valid), // input
.io_s_tx_start_packet(io_s_tx_start_packet), // input
.io_s_tx_end_packet(io_s_tx_end_packet), // input
.io_s_tx_error(io_s_tx_error), // input
.io_s_tx_empty(io_s_tx_empty), // input
.io_s_tx_data(io_s_tx_data), // input
.io_s_tx_size(io_s_tx_size), // input
.drbell_tx_packet_available(drbell_tx_packet_available), // input
.drbell_tx_ready(drbell_tx_ready), // output
.drbell_tx_valid(drbell_tx_valid), // input
.drbell_tx_start_packet(drbell_tx_start_packet), // input
.drbell_tx_end_packet(drbell_tx_end_packet), // input
.drbell_tx_error(drbell_tx_error), // input
.drbell_tx_empty(drbell_tx_empty), // input
.drbell_tx_data(drbell_tx_data), // input
.drbell_tx_size(drbell_tx_size),
// input
//,.gen_txdav (1'b0)      // input - use (gen_txval && gen_txsop) instead.
.gen_txena(gen_txena), // output
.gen_txval(gen_txval), // input
.gen_txsop(gen_txsop), // input
.gen_txeop(gen_txeop), // input
.gen_txerr(gen_txerr), // input
.gen_txmty(gen_txmty), // input
.gen_txdat(gen_txdat), // input
.atxwlevel(atxwlevel)// input
);
/*CALL*/
 altera_rapidio_rx_transport_tl_small_x2_x4_pt_db /* vx2 no_prefix */   rx_transport(.clk(sysclk),
// input
.reset_n(reset_n), // input
.rx_packet_available(rx_packet_available), // input
.rx_ready(rx_ready), // output
.rx_valid(rx_valid), // input
.rx_start_packet(rx_start_packet), // input
.rx_end_packet(rx_end_packet), // input
.rx_error(rx_error), // input
.rx_empty(rx_empty), // input
.rx_data(rx_data), // input
.mnt_rx_ready(mnt_rx_ready), // input
.mnt_rx_valid(mnt_rx_valid), // output
.mnt_rx_start_packet(mnt_rx_start_packet), // output
.mnt_rx_end_packet(mnt_rx_end_packet), // output
.mnt_rx_empty(mnt_rx_empty), // output
.mnt_rx_data(mnt_rx_data), // output
.mnt_rx_size(mnt_rx_size), // output
.io_m_rx_ready(io_m_rx_ready), // input
.io_m_rx_valid(io_m_rx_valid), // output
.io_m_rx_start_packet(io_m_rx_start_packet), // output
.io_m_rx_end_packet(io_m_rx_end_packet), // output
.io_m_rx_empty(io_m_rx_empty), // output
.io_m_rx_data(io_m_rx_data), // output
.io_m_rx_size(io_m_rx_size), // output
.io_s_rx_ready(io_s_rx_ready), // input
.io_s_rx_valid(io_s_rx_valid), // output
.io_s_rx_start_packet(io_s_rx_start_packet), // output
.io_s_rx_end_packet(io_s_rx_end_packet), // output
.io_s_rx_empty(io_s_rx_empty), // output
.io_s_rx_data(io_s_rx_data), // output
.io_s_rx_size(io_s_rx_size), // output
.drbell_rx_ready(drbell_rx_ready), // input
.drbell_rx_valid(drbell_rx_valid), // output
.drbell_rx_start_packet(drbell_rx_start_packet), // output
.drbell_rx_end_packet(drbell_rx_end_packet), // output
.drbell_rx_empty(drbell_rx_empty), // output
.drbell_rx_data(drbell_rx_data), // output
.drbell_rx_size(drbell_rx_size), // output
.gen_rxena(gen_rxena), // input
.gen_rxval(gen_rxval), // output
.gen_rxsop(gen_rxsop), // output
.gen_rxeop(gen_rxeop), // output
.gen_rxmty(gen_rxmty), // output
.gen_rxdat(gen_rxdat), // output
.gen_rxsize(gen_rxsize), // output
.device_id(device_id), // input
.promiscuous_mode(promiscuous_mode)// input hard coded for ACS patch.
);

defparam rx_transport.port_write=rx_port_write;

endmodule

/*Vx2, V2.1.5
Released 2006-10-10
Checked out from CVS as $Header: //acds/main/ip/infrastructure/tools/lib/ToolVersion.pm#1 $
*/// vx_version verilog
/*
******************************************************

MODULE_NAME =  tx_transport
COMPANY =      Altera Corporation
WEB =          www.altera.com
EMAIL =

FUNCTIONAL_DESCRIPTION :
 Transport layer transmit side round robin scheduler.
END_FUNCTIONAL_DESCRIPTION

SUB_MODULES = <call>

REVISION = $Id: //acds/main/ip/rapidio/rio/hw/src/rtl/transport/tx_transport.vx.erp#3 

LEGAL :
Copyright 2005 - 2009 Altera Corporation.  All rights reserved.
END_LEGAL

******************************************************
*/
module  altera_rapidio_tx_transport_tl_small_x2_x4_pt_db /* vx2 no_prefix */  (
clk,
reset_n,
atxwlevel,
tx_data_status,
tx_valid,
tx_start_packet,
tx_end_packet,
tx_error,
tx_empty,
tx_data,
mnt_tx_packet_available,
mnt_tx_ready,
mnt_tx_valid,
mnt_tx_start_packet,
mnt_tx_end_packet,
mnt_tx_error,
mnt_tx_empty,
mnt_tx_data,
mnt_tx_size,
io_m_tx_packet_available,
io_m_tx_ready,
io_m_tx_valid,
io_m_tx_start_packet,
io_m_tx_end_packet,
io_m_tx_error,
io_m_tx_empty,
io_m_tx_data,
io_m_tx_size,
io_s_tx_packet_available,
io_s_tx_ready,
io_s_tx_valid,
io_s_tx_start_packet,
io_s_tx_end_packet,
io_s_tx_error,
io_s_tx_empty,
io_s_tx_data,
io_s_tx_size,
drbell_tx_packet_available,
drbell_tx_ready,
drbell_tx_valid,
drbell_tx_start_packet,
drbell_tx_end_packet,
drbell_tx_error,
drbell_tx_empty,
drbell_tx_data,
drbell_tx_size,
gen_txena,
gen_txval,
gen_txsop,
gen_txeop,
gen_txerr,
gen_txmty,
gen_txdat);

// Ports and local variables. 
// '_F' indicates an auxiliary variable for flip-flops
// '_S' indicates an auxiliary variable for combinational signals
// '_W' indicates a VX2-created wire
parameter mnt_block = 3'b000;
parameter io_m_block = 3'b001;
parameter io_s_block = 3'b010;
parameter drbell_block = 3'b011;
parameter gen_block = 3'b100;
input clk;
input reset_n;
input[9 - 1:0] atxwlevel;
input tx_data_status;
output tx_valid;
output tx_start_packet;
output tx_end_packet;
output tx_error;
output[3 - 1:0] tx_empty;
output[64 - 1:0] tx_data;
input mnt_tx_packet_available;
output mnt_tx_ready;
input mnt_tx_valid;
input mnt_tx_start_packet;
input mnt_tx_end_packet;
input mnt_tx_error;
input[3 - 1:0] mnt_tx_empty;
input[64 - 1:0] mnt_tx_data;
input[6 - 1:0] mnt_tx_size;
input io_m_tx_packet_available;
output io_m_tx_ready;
input io_m_tx_valid;
input io_m_tx_start_packet;
input io_m_tx_end_packet;
input io_m_tx_error;
input[3 - 1:0] io_m_tx_empty;
input[64 - 1:0] io_m_tx_data;
input[6 - 1:0] io_m_tx_size;
input io_s_tx_packet_available;
output io_s_tx_ready;
input io_s_tx_valid;
input io_s_tx_start_packet;
input io_s_tx_end_packet;
input io_s_tx_error;
input[3 - 1:0] io_s_tx_empty;
input[64 - 1:0] io_s_tx_data;
input[6 - 1:0] io_s_tx_size;
input drbell_tx_packet_available;
output drbell_tx_ready;
input drbell_tx_valid;
input drbell_tx_start_packet;
input drbell_tx_end_packet;
input drbell_tx_error;
input[3 - 1:0] drbell_tx_empty;
input[64 - 1:0] drbell_tx_data;
input[6 - 1:0] drbell_tx_size;
output gen_txena;
input gen_txval;
input gen_txsop;
input gen_txeop;
input gen_txerr;
input[3 - 1:0] gen_txmty;
input[64 - 1:0] gen_txdat;
// **************************************************************
// **************************************************************
// internal_variables (flop, signal, reg, wire, etc.)
wire  clk ;
wire  reset_n ;
wire  [9 - 1:0] atxwlevel  ;
wire  tx_data_status  ; // Interface to physical layer
wire  tx_valid  ;
wire  tx_start_packet  ;
wire  tx_end_packet  ;
wire  tx_error  ;
wire  [3 - 1:0] tx_empty  ;
wire  [64 - 1:0] tx_data  ; // Interface to logical layer module mnt
wire  mnt_tx_packet_available  ;
wire  mnt_tx_ready  ;
wire  mnt_tx_valid  ;
wire  mnt_tx_start_packet  ;
wire  mnt_tx_end_packet  ;
wire  mnt_tx_error  ;
wire  [3 - 1:0] mnt_tx_empty  ;
wire  [64 - 1:0] mnt_tx_data  ;
wire  [6 - 1:0] mnt_tx_size  ;
// Interface to logical layer module io_m
wire  io_m_tx_packet_available  ;
wire  io_m_tx_ready  ;
wire  io_m_tx_valid  ;
wire  io_m_tx_start_packet  ;
wire  io_m_tx_end_packet  ;
wire  io_m_tx_error  ;
wire  [3 - 1:0] io_m_tx_empty  ;
wire  [64 - 1:0] io_m_tx_data  ;
wire  [6 - 1:0] io_m_tx_size  ;
// Interface to logical layer module io_s
wire  io_s_tx_packet_available  ;
wire  io_s_tx_ready  ;
wire  io_s_tx_valid  ;
wire  io_s_tx_start_packet  ;
wire  io_s_tx_end_packet  ;
wire  io_s_tx_error  ;
wire  [3 - 1:0] io_s_tx_empty  ;
wire  [64 - 1:0] io_s_tx_data  ;
wire  [6 - 1:0] io_s_tx_size  ;
// Interface to logical layer module drbell
wire  drbell_tx_packet_available  ;
wire  drbell_tx_ready  ;
wire  drbell_tx_valid  ;
wire  drbell_tx_start_packet  ;
wire  drbell_tx_end_packet  ;
wire  drbell_tx_error  ;
wire  [3 - 1:0] drbell_tx_empty  ;
wire  [64 - 1:0] drbell_tx_data  ;
wire  [6 - 1:0] drbell_tx_size  ;
// Pass-through interface
//input       gen_txdav,
reg  gen_txena, _Fgen_txena  ;
wire  gen_txval  ;
wire  gen_txsop  ;
wire  gen_txeop  ;
wire  gen_txerr  ;
wire  [3 - 1:0] gen_txmty  ;
wire  [64 - 1:0] gen_txdat  ;
reg  [2:0] block_select  ;
// The following flops must be present even if
// the block does not exist.

reg[2:0] _Fblock_select;
reg  mnt_available, _Fmnt_available  ;
reg  io_m_available, _Fio_m_available  ;
reg  io_s_available, _Fio_s_available  ;
reg  drbell_available, _Fdrbell_available  ;
reg  gen_available, _Fgen_available  ;
wire  [4:0] pkt_available  ;
assign pkt_available = {mnt_available, io_m_available, io_s_available,
    drbell_available, gen_available};


parameter st_idle = 1'b0;
parameter st_proc = 1'b1; // define next valid block
parameter mnt_next = io_m_block;
parameter mnt_mask = 5'b01111;
parameter io_m_next = io_s_block;
parameter io_m_mask = 5'b10111;
parameter io_s_next = drbell_block;
parameter io_s_mask = 5'b11011;
parameter drbell_next = gen_block;
parameter drbell_mask = 5'b11101;
parameter gen_next = mnt_block;
parameter gen_mask = 5'b11110; // Atlantic I Aliases
reg  mnt_state, _Fmnt_state  ;
reg  io_m_state, _Fio_m_state  ;
reg  io_s_state, _Fio_s_state  ;
reg  drbell_state, _Fdrbell_state  ;
reg  gen_state, _Fgen_state  ;
reg  txena, _Ftxena  ;
reg  txsop, _Ftxsop  ;
reg  txeop, _Ftxeop  ;
reg  txerr, _Ftxerr  ;
reg  [3 - 1:0] txmty, _Ftxmty  ;
reg  [64 - 1:0] txdat, _Ftxdat  ;
assign tx_valid = txena;

assign tx_start_packet = txsop;

assign tx_end_packet = txeop;

assign tx_error = txerr;

assign tx_empty = txmty;

assign tx_data = txdat;

wire mnt_txdav;

reg  mnt_txena, _Fmnt_txena  ;
wire  mnt_txsop  ;
wire  mnt_txeop  ;
wire  mnt_txerr  ;
wire  mnt_txval  ;
wire  [3 - 1:0] mnt_txmty  ;
wire  [64 - 1:0] mnt_txdat  ;
assign mnt_txdav = mnt_tx_packet_available;

assign mnt_tx_ready = mnt_txena;// output


assign mnt_txsop = mnt_tx_start_packet;

assign mnt_txeop = mnt_tx_end_packet;

assign mnt_txerr = mnt_tx_error;

assign mnt_txval = mnt_tx_valid;

assign mnt_txmty = mnt_tx_empty;

assign mnt_txdat = mnt_tx_data;


reg  mnt_txena_d1, _Fmnt_txena_d1  ;
wire  io_m_txdav  ;
reg  io_m_txena, _Fio_m_txena  ;
wire  io_m_txsop  ;
wire  io_m_txeop  ;
wire  io_m_txerr  ;
wire  io_m_txval  ;
wire  [3 - 1:0] io_m_txmty  ;
wire  [64 - 1:0] io_m_txdat  ;
assign io_m_txdav = io_m_tx_packet_available;

assign io_m_tx_ready = io_m_txena;// output


assign io_m_txsop = io_m_tx_start_packet;

assign io_m_txeop = io_m_tx_end_packet;

assign io_m_txerr = io_m_tx_error;

assign io_m_txval = io_m_tx_valid;

assign io_m_txmty = io_m_tx_empty;

assign io_m_txdat = io_m_tx_data;


reg  io_m_txena_d1, _Fio_m_txena_d1  ;
wire  io_s_txdav  ;
reg  io_s_txena, _Fio_s_txena  ;
wire  io_s_txsop  ;
wire  io_s_txeop  ;
wire  io_s_txerr  ;
wire  io_s_txval  ;
wire  [3 - 1:0] io_s_txmty  ;
wire  [64 - 1:0] io_s_txdat  ;
assign io_s_txdav = io_s_tx_packet_available;

assign io_s_tx_ready = io_s_txena;// output


assign io_s_txsop = io_s_tx_start_packet;

assign io_s_txeop = io_s_tx_end_packet;

assign io_s_txerr = io_s_tx_error;

assign io_s_txval = io_s_tx_valid;

assign io_s_txmty = io_s_tx_empty;

assign io_s_txdat = io_s_tx_data;


reg  io_s_txena_d1, _Fio_s_txena_d1  ;
wire  drbell_txdav  ;
reg  drbell_txena, _Fdrbell_txena  ;
wire  drbell_txsop  ;
wire  drbell_txeop  ;
wire  drbell_txerr  ;
wire  drbell_txval  ;
wire  [3 - 1:0] drbell_txmty  ;
wire  [64 - 1:0] drbell_txdat  ;
assign drbell_txdav = drbell_tx_packet_available;

assign drbell_tx_ready = drbell_txena;// output


assign drbell_txsop = drbell_tx_start_packet;

assign drbell_txeop = drbell_tx_end_packet;

assign drbell_txerr = drbell_tx_error;

assign drbell_txval = drbell_tx_valid;

assign drbell_txmty = drbell_tx_empty;

assign drbell_txdat = drbell_tx_data;


reg  drbell_txena_d1, _Fdrbell_txena_d1  ;
reg  gen_txena_d1, _Fgen_txena_d1  ;
reg  gen_txdav, _Fgen_txdav  ;
reg  gen_txsop_f, _Fgen_txsop_f  ;
reg  gen_txeop_f, _Fgen_txeop_f  ;
reg  [64 - 1:0] gen_txdat_f, _Fgen_txdat_f  ;
reg  [3 - 1:0] gen_txmty_f, _Fgen_txmty_f  ;
reg  gen_txerr_f, _Fgen_txerr_f  ;
reg  txbuf_almost_full  ;
// **************************************************************
// structural_code
// **************************************************************
// procedural_code
// combinational_block

reg _Ftxbuf_almost_full;

always @( * )  begin
// initialize flip-flop and combinational regs
    _Fgen_txena = gen_txena;
    _Fblock_select = block_select;
    _Fmnt_available = mnt_available;
    _Fio_m_available = io_m_available;
    _Fio_s_available = io_s_available;
    _Fdrbell_available = drbell_available;
    _Fgen_available = gen_available;
    _Fmnt_state = mnt_state;
    _Fio_m_state = io_m_state;
    _Fio_s_state = io_s_state;
    _Fdrbell_state = drbell_state;
    _Fgen_state = gen_state;
    _Ftxena = txena;
    _Ftxsop = txsop;
    _Ftxeop = txeop;
    _Ftxerr = txerr;
    _Ftxmty = txmty;
    _Ftxdat = txdat;
    _Fmnt_txena = mnt_txena;
    _Fmnt_txena_d1 = mnt_txena_d1;
    _Fio_m_txena = io_m_txena;
    _Fio_m_txena_d1 = io_m_txena_d1;
    _Fio_s_txena = io_s_txena;
    _Fio_s_txena_d1 = io_s_txena_d1;
    _Fdrbell_txena = drbell_txena;
    _Fdrbell_txena_d1 = drbell_txena_d1;
    _Fgen_txena_d1 = gen_txena_d1;
    _Fgen_txdav = gen_txdav;
    _Fgen_txsop_f = gen_txsop_f;
    _Fgen_txeop_f = gen_txeop_f;
    _Fgen_txdat_f = gen_txdat_f;
    _Fgen_txmty_f = gen_txmty_f;
    _Fgen_txerr_f = gen_txerr_f;
    _Ftxbuf_almost_full = txbuf_almost_full;

// mainline code
    begin 
        _Ftxbuf_almost_full = 1'b0;
        if (atxwlevel <= 9'ha) begin 
            _Ftxbuf_almost_full = 1'b1;
        end 
        _Fmnt_txena = 1'b0;
        _Fmnt_txena_d1 = mnt_txena;
        _Fio_m_txena = 1'b0;
        _Fio_m_txena_d1 = io_m_txena;
        _Fio_s_txena = 1'b0;
        _Fio_s_txena_d1 = io_s_txena;
        _Fdrbell_txena = 1'b0;
        _Fdrbell_txena_d1 = drbell_txena;
        _Fgen_txena = 1'b0;
        _Fgen_txena_d1 = gen_txena;// Poll generic Avalon-ST port and create dav equivalent
        if (! gen_txena && ! gen_txdav && ! (gen_txena_d1 && gen_txval)) begin 
            _Fgen_txena = 1'b1;
        end // Capture start of packet on generic port
        if (gen_txena_d1 && gen_txval && gen_txsop) begin 
            _Fgen_txsop_f = gen_txsop;// Always 1
            _Fgen_txeop_f = gen_txeop;
            _Fgen_txdat_f = gen_txdat;
            _Fgen_txmty_f = gen_txmty;
            _Fgen_txerr_f = gen_txerr;
            _Fgen_txdav = 1'b1;
        end //////////////////////
        // mnt block
        //////////////////////
        _Fmnt_available = (mnt_txdav | (mnt_txval & mnt_txsop));
        if (block_select == mnt_block) begin 
            _Ftxsop = mnt_txsop;
            _Ftxeop = mnt_txeop;
            _Ftxerr = mnt_txerr;
            _Ftxmty = mnt_txmty;
            _Ftxdat = mnt_txdat;
            _Ftxena = 1'b0;
            case (mnt_state)
                st_idle:
                    begin 
                        if
                        (! txbuf_almost_full || (mnt_txena && mnt_txsop && mnt_txval)
                        // Low in space but we must use the sop or lose it.
                        // We don't risk overflowing the tx buffer because we gave ourself two packets of margin and we won't start the next one.
) begin 
                            if (mnt_txdav || (mnt_txsop && mnt_txval)) begin 
                                _Fmnt_txena = 1'b1;
                                if (mnt_txsop && mnt_txval) begin // Wait until the packet starts to actually commit to it.
                                // So that if mnt_txdav gets de-asserted before a packet starts we can select another block

                                    _Fmnt_state = st_proc;
                                end 
                                if (mnt_txena && mnt_txsop && mnt_txval) begin 
                                    _Ftxena = 1'b1;// Use the sop before it is gone.
                                    if (mnt_txeop) begin // Single word packet, move on to next.

                                        _Fblock_select = mnt_next;// switch block
                                        _Fmnt_state = st_idle;
                                        _Fmnt_txena = 1'b0;// no packet available in other blocks
                                        if (! (pkt_available & mnt_mask) && ! txbuf_almost_full && mnt_txdav) begin 
                                            _Fmnt_txena = 1'b1;
                                            _Fmnt_state = st_idle;
                                            _Fblock_select = block_select;
                                        end 
                                    end // if ( mnt_txeop )
                                end 
                            end 
                            else
                            begin // current block has no packets, switch to
                            // another block

                                _Fmnt_txena = 1'b0;
                                _Fblock_select = mnt_next;
                            end 
                        end 
                    end // In this state, phy layer is always assumed to have
                    // space for current packet.
                st_proc:
                    begin 
                        _Fmnt_txena = 1'b1;
                        if (mnt_txval) begin // mnt_txena_d1 garantied here ?

                            _Ftxena = 1'b1;
                            if (mnt_txeop) begin 
                                _Fblock_select = mnt_next;// switch block
                                _Fmnt_state = st_idle;
                                _Fmnt_txena = 1'b0;// no packet available in other blocks
                                if (! (pkt_available & mnt_mask) && ! txbuf_almost_full && mnt_txdav) begin 
                                    _Fmnt_txena = 1'b1;// Not redundant
                                    _Fmnt_state = st_idle;
                                    _Fblock_select = block_select;
                                end 
                            end // mnt_txeop
                        end // mnt_txval
                    end // st_proc
            endcase
        end // block select
        //////////////////////
        // io_m block
        //////////////////////
        _Fio_m_available = (io_m_txdav | (io_m_txval & io_m_txsop));
        if (block_select == io_m_block) begin 
            _Ftxsop = io_m_txsop;
            _Ftxeop = io_m_txeop;
            _Ftxerr = io_m_txerr;
            _Ftxmty = io_m_txmty;
            _Ftxdat = io_m_txdat;
            _Ftxena = 1'b0;
            case (io_m_state)
                st_idle:
                    begin 
                        if
                        (! txbuf_almost_full || (io_m_txena && io_m_txsop && io_m_txval)
                        // Low in space but we must use the sop or lose it.
                        // We don't risk overflowing the tx buffer because we gave ourself two packets of margin and we won't start the next one.
) begin 
                            if (io_m_txdav || (io_m_txsop && io_m_txval)) begin 
                                _Fio_m_txena = 1'b1;
                                if (io_m_txsop && io_m_txval) begin // Wait until the packet starts to actually commit to it.
                                // So that if io_m_txdav gets de-asserted before a packet starts we can select another block

                                    _Fio_m_state = st_proc;
                                end 
                                if (io_m_txena && io_m_txsop && io_m_txval) begin 
                                    _Ftxena = 1'b1;// Use the sop before it is gone.
                                    if (io_m_txeop) begin // Single word packet, move on to next.

                                        _Fblock_select = io_m_next;// switch block
                                        _Fio_m_state = st_idle;
                                        _Fio_m_txena = 1'b0;// no packet available in other blocks
                                        if (! (pkt_available & io_m_mask) && ! txbuf_almost_full && io_m_txdav) begin 
                                            _Fio_m_txena = 1'b1;
                                            _Fio_m_state = st_idle;
                                            _Fblock_select = block_select;
                                        end 
                                    end // if ( io_m_txeop )
                                end 
                            end 
                            else
                            begin // current block has no packets, switch to
                            // another block

                                _Fio_m_txena = 1'b0;
                                _Fblock_select = io_m_next;
                            end 
                        end 
                    end // In this state, phy layer is always assumed to have
                    // space for current packet.
                st_proc:
                    begin 
                        _Fio_m_txena = 1'b1;
                        if (io_m_txval) begin // io_m_txena_d1 garantied here ?

                            _Ftxena = 1'b1;
                            if (io_m_txeop) begin 
                                _Fblock_select = io_m_next;// switch block
                                _Fio_m_state = st_idle;
                                _Fio_m_txena = 1'b0;// no packet available in other blocks
                                if (! (pkt_available & io_m_mask) && ! txbuf_almost_full && io_m_txdav) begin 
                                    _Fio_m_txena = 1'b1;// Not redundant
                                    _Fio_m_state = st_idle;
                                    _Fblock_select = block_select;
                                end 
                            end // io_m_txeop
                        end // io_m_txval
                    end // st_proc
            endcase
        end // block select
        //////////////////////
        // io_s block
        //////////////////////
        _Fio_s_available = (io_s_txdav | (io_s_txval & io_s_txsop));
        if (block_select == io_s_block) begin 
            _Ftxsop = io_s_txsop;
            _Ftxeop = io_s_txeop;
            _Ftxerr = io_s_txerr;
            _Ftxmty = io_s_txmty;
            _Ftxdat = io_s_txdat;
            _Ftxena = 1'b0;
            case (io_s_state)
                st_idle:
                    begin 
                        if
                        (! txbuf_almost_full || (io_s_txena && io_s_txsop && io_s_txval)
                        // Low in space but we must use the sop or lose it.
                        // We don't risk overflowing the tx buffer because we gave ourself two packets of margin and we won't start the next one.
) begin 
                            if (io_s_txdav || (io_s_txsop && io_s_txval)) begin 
                                _Fio_s_txena = 1'b1;
                                if (io_s_txsop && io_s_txval) begin // Wait until the packet starts to actually commit to it.
                                // So that if io_s_txdav gets de-asserted before a packet starts we can select another block

                                    _Fio_s_state = st_proc;
                                end 
                                if (io_s_txena && io_s_txsop && io_s_txval) begin 
                                    _Ftxena = 1'b1;// Use the sop before it is gone.
                                    if (io_s_txeop) begin // Single word packet, move on to next.

                                        _Fblock_select = io_s_next;// switch block
                                        _Fio_s_state = st_idle;
                                        _Fio_s_txena = 1'b0;// no packet available in other blocks
                                        if (! (pkt_available & io_s_mask) && ! txbuf_almost_full && io_s_txdav) begin 
                                            _Fio_s_txena = 1'b1;
                                            _Fio_s_state = st_idle;
                                            _Fblock_select = block_select;
                                        end 
                                    end // if ( io_s_txeop )
                                end 
                            end 
                            else
                            begin // current block has no packets, switch to
                            // another block

                                _Fio_s_txena = 1'b0;
                                _Fblock_select = io_s_next;
                            end 
                        end 
                    end // In this state, phy layer is always assumed to have
                    // space for current packet.
                st_proc:
                    begin 
                        _Fio_s_txena = 1'b1;
                        if (io_s_txval) begin // io_s_txena_d1 garantied here ?

                            _Ftxena = 1'b1;
                            if (io_s_txeop) begin 
                                _Fblock_select = io_s_next;// switch block
                                _Fio_s_state = st_idle;
                                _Fio_s_txena = 1'b0;// no packet available in other blocks
                                if (! (pkt_available & io_s_mask) && ! txbuf_almost_full && io_s_txdav) begin 
                                    _Fio_s_txena = 1'b1;// Not redundant
                                    _Fio_s_state = st_idle;
                                    _Fblock_select = block_select;
                                end 
                            end // io_s_txeop
                        end // io_s_txval
                    end // st_proc
            endcase
        end // block select
        //////////////////////
        // drbell block
        //////////////////////
        _Fdrbell_available = (drbell_txdav | (drbell_txval & drbell_txsop));
        if (block_select == drbell_block) begin 
            _Ftxsop = drbell_txsop;
            _Ftxeop = drbell_txeop;
            _Ftxerr = drbell_txerr;
            _Ftxmty = drbell_txmty;
            _Ftxdat = drbell_txdat;
            _Ftxena = 1'b0;
            case (drbell_state)
                st_idle:
                    begin 
                        if
                        (! txbuf_almost_full || (drbell_txena && drbell_txsop && drbell_txval)
                        // Low in space but we must use the sop or lose it.
                        // We don't risk overflowing the tx buffer because we gave ourself two packets of margin and we won't start the next one.
) begin 
                            if (drbell_txdav || (drbell_txsop && drbell_txval)) begin 
                                _Fdrbell_txena = 1'b1;
                                if (drbell_txsop && drbell_txval) begin // Wait until the packet starts to actually commit to it.
                                // So that if drbell_txdav gets de-asserted before a packet starts we can select another block

                                    _Fdrbell_state = st_proc;
                                end 
                                if (drbell_txena && drbell_txsop && drbell_txval) begin 
                                    _Ftxena = 1'b1;// Use the sop before it is gone.
                                    if (drbell_txeop) begin // Single word packet, move on to next.

                                        _Fblock_select = drbell_next;// switch block
                                        _Fdrbell_state = st_idle;
                                        _Fdrbell_txena = 1'b0;// no packet available in other blocks
                                        if
                                        (! (pkt_available & drbell_mask) && ! txbuf_almost_full && drbell_txdav) begin 
                                            _Fdrbell_txena = 1'b1;
                                            _Fdrbell_state = st_idle;
                                            _Fblock_select = block_select;
                                        end 
                                    end // if ( drbell_txeop )
                                end 
                            end 
                            else
                            begin // current block has no packets, switch to
                            // another block

                                _Fdrbell_txena = 1'b0;
                                _Fblock_select = drbell_next;
                            end 
                        end 
                    end // In this state, phy layer is always assumed to have
                    // space for current packet.
                st_proc:
                    begin 
                        _Fdrbell_txena = 1'b1;
                        if (drbell_txval) begin // drbell_txena_d1 garantied here ?

                            _Ftxena = 1'b1;
                            if (drbell_txeop) begin 
                                _Fblock_select = drbell_next;// switch block
                                _Fdrbell_state = st_idle;
                                _Fdrbell_txena = 1'b0;// no packet available in other blocks
                                if
                                (! (pkt_available & drbell_mask) && ! txbuf_almost_full && drbell_txdav) begin 
                                    _Fdrbell_txena = 1'b1;// Not redundant
                                    _Fdrbell_state = st_idle;
                                    _Fblock_select = block_select;
                                end 
                            end // drbell_txeop
                        end // drbell_txval
                    end // st_proc
            endcase
        end // block select
        //////////////////////
        // gen block
        //////////////////////
        _Fgen_available = (gen_txdav | (gen_txval & gen_txsop));
        if (block_select == gen_block) begin 
            _Ftxsop = gen_txsop;
            _Ftxeop = gen_txeop;
            _Ftxerr = gen_txerr;
            _Ftxmty = gen_txmty;
            _Ftxdat = gen_txdat;
            _Ftxena = 1'b0;
            case (gen_state)
                st_idle:
                    begin 
                        if (! txbuf_almost_full) begin 
                            if (gen_txdav || (gen_txena_d1 && gen_txval && gen_txsop)) begin 
                                _Fgen_txena = 1'b1;
                                _Fgen_state = st_proc;
                                if (gen_txdav) begin // Use captured values

                                    _Ftxsop = gen_txsop_f;
                                    _Ftxeop = gen_txeop_f;
                                    _Ftxerr = gen_txerr_f;
                                    _Ftxmty = gen_txmty_f;
                                    _Ftxdat = gen_txdat_f;
                                end 
                                _Ftxena = 1'b1;
                                _Fgen_txdav = 1'b0;// In all cases.
                                if ((gen_txdav && gen_txeop_f) || (! gen_txdav && gen_txeop)) begin // Single word packet, move on to next.

                                    _Fblock_select = gen_next;// switch block
                                    _Fgen_state = st_idle;
                                    _Fgen_txena = 1'b0;// no packet available in other blocks
                                    //                      if (!(pkt_available & gen_mask) && !txbuf_almost_full /*&& gen_txdav*/) begin
                                    //                         gen_txena <- 1'b1;
                                    //                         gen_state <- st_proc;
                                    //                         block_select <- block_select;
                                    //                      end
                                end 
                            end 
                            else
                            begin // current block has no packets, switch to
                            // another block

                                _Fblock_select = gen_next;
                            end 
                        end 
                    end // In this state, phy layer is always assumed to have
                    // space for current packet.
                st_proc:
                    begin 
                        _Fgen_txena = 1'b1;
                        if (gen_txena_d1 && gen_txval) begin 
                            _Ftxena = 1'b1;
                            if (gen_txeop) begin 
                                _Fblock_select = gen_next;// switch block
                                _Fgen_state = st_idle;
                                _Fgen_txena = 1'b0;// no packet available in other blocks
                                //                if (!(pkt_available & gen_mask) && !txbuf_almost_full /*&& gen_txdav*/) begin
                                //                   gen_txena <- 1'b1;
                                //                   gen_state <- st_proc;
                                //                   block_select <- block_select;
                                //                end
                            end // gen_txeop
                        end // gen_txval
                    end // st_proc
            endcase
        end // block select
    end // always
    // sequential_blocks


// update regs for combinational signals
// The non-blocking assignment causes the always block to 
// re-stimulate if the signal has changed
end
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        gen_txena<=0;
        block_select<=mnt_block;
        mnt_available<=1'b0;
        io_m_available<=1'b0;
        io_s_available<=1'b0;
        drbell_available<=1'b0;
        gen_available<=1'b0;
        mnt_state<=0;
        io_m_state<=0;
        io_s_state<=0;
        drbell_state<=0;
        gen_state<=0;
        txena<=0;
        txsop<=0;
        txeop<=0;
        txerr<=0;
        txmty<=0;
        txdat<=0;
        mnt_txena<=0;
        mnt_txena_d1<=0;
        io_m_txena<=0;
        io_m_txena_d1<=0;
        io_s_txena<=0;
        io_s_txena_d1<=0;
        drbell_txena<=0;
        drbell_txena_d1<=0;
        gen_txena_d1<=0;
        gen_txdav<=1'b0;
        gen_txsop_f<=1'b0;
        gen_txeop_f<=1'b0;
        gen_txdat_f<=64'd0;
        gen_txmty_f<=3'd0;
        gen_txerr_f<=1'b0;
        txbuf_almost_full<=0;
    end else begin
        gen_txena<=_Fgen_txena;
        block_select<=_Fblock_select;
        mnt_available<=_Fmnt_available;
        io_m_available<=_Fio_m_available;
        io_s_available<=_Fio_s_available;
        drbell_available<=_Fdrbell_available;
        gen_available<=_Fgen_available;
        mnt_state<=_Fmnt_state;
        io_m_state<=_Fio_m_state;
        io_s_state<=_Fio_s_state;
        drbell_state<=_Fdrbell_state;
        gen_state<=_Fgen_state;
        txena<=_Ftxena;
        txsop<=_Ftxsop;
        txeop<=_Ftxeop;
        txerr<=_Ftxerr;
        txmty<=_Ftxmty;
        txdat<=_Ftxdat;
        mnt_txena<=_Fmnt_txena;
        mnt_txena_d1<=_Fmnt_txena_d1;
        io_m_txena<=_Fio_m_txena;
        io_m_txena_d1<=_Fio_m_txena_d1;
        io_s_txena<=_Fio_s_txena;
        io_s_txena_d1<=_Fio_s_txena_d1;
        drbell_txena<=_Fdrbell_txena;
        drbell_txena_d1<=_Fdrbell_txena_d1;
        gen_txena_d1<=_Fgen_txena_d1;
        gen_txdav<=_Fgen_txdav;
        gen_txsop_f<=_Fgen_txsop_f;
        gen_txeop_f<=_Fgen_txeop_f;
        gen_txdat_f<=_Fgen_txdat_f;
        gen_txmty_f<=_Fgen_txmty_f;
        gen_txerr_f<=_Fgen_txerr_f;
        txbuf_almost_full<=_Ftxbuf_almost_full;
    end
end
endmodule

/*Vx2, V2.1.5
Released 2006-10-10
Checked out from CVS as $Header: //acds/main/ip/infrastructure/tools/lib/ToolVersion.pm#1 $
*/// vx_version verilog
/*
******************************************************

MODULE_NAME =  rx_transport
COMPANY =      Altera Corporation, Altera Ottawa Technology Center
WEB =          www.altera.com
EMAIL =        otc_technical@altera.com

FUNCTIONAL_DESCRIPTION :

END_FUNCTIONAL_DESCRIPTION

SUB_MODULES = <call>

REVISION = $Id: //acds/main/ip/rapidio/rio/hw/src/rtl/transport/rx_transport.vx.erp#10 

LEGAL :
Copyright 2005-2008 Altera Corporation.  All rights reserved.
END_LEGAL

******************************************************
*/
module  altera_rapidio_rx_transport_tl_small_x2_x4_pt_db /* vx2 no_prefix */  (
clk,
reset_n,
rx_packet_available,
rx_ready,
rx_valid,
rx_start_packet,
rx_end_packet,
rx_error,
rx_empty,
rx_data,
mnt_rx_ready,
mnt_rx_valid,
mnt_rx_start_packet,
mnt_rx_end_packet,
mnt_rx_empty,
mnt_rx_data,
mnt_rx_size,
io_m_rx_ready,
io_m_rx_valid,
io_m_rx_start_packet,
io_m_rx_end_packet,
io_m_rx_empty,
io_m_rx_data,
io_m_rx_size,
io_s_rx_ready,
io_s_rx_valid,
io_s_rx_start_packet,
io_s_rx_end_packet,
io_s_rx_empty,
io_s_rx_data,
io_s_rx_size,
drbell_rx_ready,
drbell_rx_valid,
drbell_rx_start_packet,
drbell_rx_end_packet,
drbell_rx_empty,
drbell_rx_data,
drbell_rx_size,
gen_rxena,
gen_rxval,
gen_rxsop,
gen_rxeop,
gen_rxmty,
gen_rxdat,
gen_rxsize,
device_id,
promiscuous_mode);

// Ports and local variables. 
// '_F' indicates an auxiliary variable for flip-flops
// '_S' indicates an auxiliary variable for combinational signals
// '_W' indicates a VX2-created wire
parameter port_write = 1'b0;
parameter st_proc = 1'b0;
parameter st_store = 1'b1;
input clk;
input reset_n;
input rx_packet_available;
output rx_ready;
input rx_valid;
input rx_start_packet;
input rx_end_packet;
input rx_error;
input[3 - 1:0] rx_empty;
input[64 - 1:0] rx_data;
input mnt_rx_ready;
output mnt_rx_valid;
output mnt_rx_start_packet;
output mnt_rx_end_packet;
output[3 - 1:0] mnt_rx_empty;
output[64 - 1:0] mnt_rx_data;
output[6 - 1:0] mnt_rx_size;
input io_m_rx_ready;
output io_m_rx_valid;
output io_m_rx_start_packet;
output io_m_rx_end_packet;
output[3 - 1:0] io_m_rx_empty;
output[64 - 1:0] io_m_rx_data;
output[6 - 1:0] io_m_rx_size;
input io_s_rx_ready;
output io_s_rx_valid;
output io_s_rx_start_packet;
output io_s_rx_end_packet;
output[3 - 1:0] io_s_rx_empty;
output[64 - 1:0] io_s_rx_data;
output[6 - 1:0] io_s_rx_size;
input drbell_rx_ready;
output drbell_rx_valid;
output drbell_rx_start_packet;
output drbell_rx_end_packet;
output[3 - 1:0] drbell_rx_empty;
output[64 - 1:0] drbell_rx_data;
output[6 - 1:0] drbell_rx_size;
input gen_rxena;
output gen_rxval;
output gen_rxsop;
output gen_rxeop;
output[3 - 1:0] gen_rxmty;
output[64 - 1:0] gen_rxdat;
output[6 - 1:0] gen_rxsize;
input[7:0] device_id;
input promiscuous_mode;
// **************************************************************
// internal_variables (flop, signal, reg, wire, etc.)
// 31/7/2009 [HLONG]: 5G
// the comparison is shifted to the rx_sfbuffer, so, the parameter is declared
// in rx_sfbuffer
wire  clk ;
wire  reset_n ;
wire  rx_packet_available  ;
wire  rx_ready  ;
wire  rx_valid  ;
wire  rx_start_packet  ;
wire  rx_end_packet  ;
wire  rx_error  ;
wire  [3 - 1:0] rx_empty  ;
wire  [64 - 1:0] rx_data  ;
wire  mnt_rx_ready  ;
wire  mnt_rx_valid  ;
wire  mnt_rx_start_packet  ;
wire  mnt_rx_end_packet  ;
wire  [3 - 1:0] mnt_rx_empty  ;
wire  [64 - 1:0] mnt_rx_data  ;
wire  [6 - 1:0] mnt_rx_size  ;
wire  io_m_rx_ready  ;
wire  io_m_rx_valid  ;
wire  io_m_rx_start_packet  ;
wire  io_m_rx_end_packet  ;
wire  [3 - 1:0] io_m_rx_empty  ;
wire  [64 - 1:0] io_m_rx_data  ;
wire  [6 - 1:0] io_m_rx_size  ;
wire  io_s_rx_ready  ;
wire  io_s_rx_valid  ;
wire  io_s_rx_start_packet  ;
wire  io_s_rx_end_packet  ;
wire  [3 - 1:0] io_s_rx_empty  ;
wire  [64 - 1:0] io_s_rx_data  ;
wire  [6 - 1:0] io_s_rx_size  ;
wire  drbell_rx_ready  ;
wire  drbell_rx_valid  ;
wire  drbell_rx_start_packet  ;
wire  drbell_rx_end_packet  ;
wire  [3 - 1:0] drbell_rx_empty  ;
wire  [64 - 1:0] drbell_rx_data  ;
wire  [6 - 1:0] drbell_rx_size  ;
wire  gen_rxena  ;
reg  gen_rxval, _Fgen_rxval  ;
reg  gen_rxsop, _Fgen_rxsop  ;
reg  gen_rxeop, _Fgen_rxeop  ;
reg  [3 - 1:0] gen_rxmty, _Fgen_rxmty  ;
reg  [64 - 1:0] gen_rxdat, _Fgen_rxdat  ;
reg  [6 - 1:0] gen_rxsize, _Fgen_rxsize  ;
wire  [7:0] device_id  ;
wire  promiscuous_mode  ;
reg  dis_dat, _Sdis_dat  ;
reg  claim_packet, _Sclaim_packet  ;
reg  token  ;
// 31/7/2009 [HLONG]: 5G
// all the valid_type is shifted to the rx_sfbuffer, except generic port

reg _Ftoken;
reg  gen_valid_type, _Sgen_valid_type  ;
wire  mnt_valid_type  ;
wire  mnt_flag1  ;
wire  mnt_flag2  ;
wire  io_m_valid_type  ;
wire  io_m_flag1  ;
wire  io_m_flag2  ;
wire  io_s_valid_type  ;
wire  io_s_flag1  ;
wire  io_s_flag2  ;
wire  drbell_valid_type  ;
wire  drbell_flag1  ;
wire  drbell_flag2  ;
wire  gen_flag1  ;
wire  gen_flag2  ;
// 5G timing optimization Stage2:
// add signal _claimed_signal and token_signal to make comparison with signals in rx_sfbuffer,
// and then flop the comparison output to use in rx_transport - flop _flag1 and _flag2.  
reg  mnt_claimed_signal  ;
// 5G timing optimization Stage2:
// add signal _claimed_signal and token_signal to make comparison with signals in rx_sfbuffer,
// and then flop the comparison output to use in rx_transport - flop _flag1 and _flag2.  

reg _Smnt_claimed_signal;
reg  io_m_claimed_signal  ;
// 5G timing optimization Stage2:
// add signal _claimed_signal and token_signal to make comparison with signals in rx_sfbuffer,
// and then flop the comparison output to use in rx_transport - flop _flag1 and _flag2.  

reg _Sio_m_claimed_signal;
reg  io_s_claimed_signal  ;
// 5G timing optimization Stage2:
// add signal _claimed_signal and token_signal to make comparison with signals in rx_sfbuffer,
// and then flop the comparison output to use in rx_transport - flop _flag1 and _flag2.  

reg _Sio_s_claimed_signal;
reg  drbell_claimed_signal  ;
// 5G timing optimization Stage2:
// add signal _claimed_signal and token_signal to make comparison with signals in rx_sfbuffer,
// and then flop the comparison output to use in rx_transport - flop _flag1 and _flag2.  

reg _Sdrbell_claimed_signal;
reg  gen_claimed_signal, _Sgen_claimed_signal  ;
reg  token_signal, _Stoken_signal  ;
reg  mnt_state, _Fmnt_state  ;
reg  mnt_claimed, _Fmnt_claimed  ;
reg  io_m_state, _Fio_m_state  ;
reg  io_m_claimed, _Fio_m_claimed  ;
reg  io_s_state, _Fio_s_state  ;
reg  io_s_claimed, _Fio_s_claimed  ;
reg  drbell_state, _Fdrbell_state  ;
reg  drbell_claimed, _Fdrbell_claimed  ;
reg  gen_state, _Fgen_state  ;
reg  gen_claimed  ;
// 31/7/2009 [HLONG]: 5G
// the comparison is shifted to the rx_sfbuffer, so, the wires are declared
// in rx_sfbuffer

reg _Fgen_claimed;
reg  dat_ena, _Sdat_ena  ;
wire  dat_val  ;
wire  dat_sop  ;
wire  dat_eop  ;
wire  [3 - 1:0] dat_mty  ;
wire  [64 - 1:0] dat  ;
wire  [6 - 1:0] dat_size  ; // Atlantic I aliases
wire  mnt_rxena  ;
reg  mnt_rxval, _Fmnt_rxval  ;
reg  mnt_rxsop, _Fmnt_rxsop  ;
reg  mnt_rxeop, _Fmnt_rxeop  ;
reg  [3 - 1:0] mnt_rxmty, _Fmnt_rxmty  ;
reg  [64 - 1:0] mnt_rxdat, _Fmnt_rxdat  ;
reg  [6 - 1:0] mnt_rxsize, _Fmnt_rxsize  ;
assign mnt_rxena = mnt_rx_ready;

assign mnt_rx_valid = mnt_rxval;

assign mnt_rx_start_packet = mnt_rxsop;

assign mnt_rx_end_packet = mnt_rxeop;

assign mnt_rx_empty = mnt_rxmty;

assign mnt_rx_size = mnt_rxsize;

assign mnt_rx_data = mnt_rxdat;

wire io_m_rxena;

reg  io_m_rxval, _Fio_m_rxval  ;
reg  io_m_rxsop, _Fio_m_rxsop  ;
reg  io_m_rxeop, _Fio_m_rxeop  ;
reg  [3 - 1:0] io_m_rxmty, _Fio_m_rxmty  ;
reg  [64 - 1:0] io_m_rxdat, _Fio_m_rxdat  ;
reg  [6 - 1:0] io_m_rxsize, _Fio_m_rxsize  ;
assign io_m_rxena = io_m_rx_ready;

assign io_m_rx_valid = io_m_rxval;

assign io_m_rx_start_packet = io_m_rxsop;

assign io_m_rx_end_packet = io_m_rxeop;

assign io_m_rx_empty = io_m_rxmty;

assign io_m_rx_size = io_m_rxsize;

assign io_m_rx_data = io_m_rxdat;

wire io_s_rxena;

reg  io_s_rxval, _Fio_s_rxval  ;
reg  io_s_rxsop, _Fio_s_rxsop  ;
reg  io_s_rxeop, _Fio_s_rxeop  ;
reg  [3 - 1:0] io_s_rxmty, _Fio_s_rxmty  ;
reg  [64 - 1:0] io_s_rxdat, _Fio_s_rxdat  ;
reg  [6 - 1:0] io_s_rxsize, _Fio_s_rxsize  ;
assign io_s_rxena = io_s_rx_ready;

assign io_s_rx_valid = io_s_rxval;

assign io_s_rx_start_packet = io_s_rxsop;

assign io_s_rx_end_packet = io_s_rxeop;

assign io_s_rx_empty = io_s_rxmty;

assign io_s_rx_size = io_s_rxsize;

assign io_s_rx_data = io_s_rxdat;

wire drbell_rxena;

reg  drbell_rxval, _Fdrbell_rxval  ;
reg  drbell_rxsop, _Fdrbell_rxsop  ;
reg  drbell_rxeop, _Fdrbell_rxeop  ;
reg  [3 - 1:0] drbell_rxmty, _Fdrbell_rxmty  ;
reg  [64 - 1:0] drbell_rxdat, _Fdrbell_rxdat  ;
reg  [6 - 1:0] drbell_rxsize, _Fdrbell_rxsize  ;
assign drbell_rxena = drbell_rx_ready;

assign drbell_rx_valid = drbell_rxval;

assign drbell_rx_start_packet = drbell_rxsop;

assign drbell_rx_end_packet = drbell_rxeop;

assign drbell_rx_empty = drbell_rxmty;

assign drbell_rx_size = drbell_rxsize;

assign drbell_rx_data = drbell_rxdat;// **************************************************************
// structural_code
/*CALL*/

 altera_rapidio_rx_sfbuffer_tl_small_x2_x4_pt_db /* vx2 no_prefix */   rx_sfbuffer(.clk(clk),
// input
.reset_n(reset_n), // input
.srcdav(rx_packet_available), // input
.srcena(rx_ready), // output
.srcval(rx_valid), // input
.srcsop(rx_start_packet), // input
.srceop(rx_end_packet), // input
.srcmty(rx_empty), // input
.srcerr(rx_error), // input
.srcdat(rx_data), // input
.snkena(dat_ena), // input
.snkval(dat_val), // output
.snksop(dat_sop), // output
.snkeop(dat_eop), // output
.snkmty(dat_mty), // output
.snkdat(dat), // output
.snksize(dat_size), // output
.device_id(device_id), //input
.promiscuous_mode(promiscuous_mode),
//input
// 5G timing optimization Stage2
.token_signal(token_signal), //input
.mnt_valid_type(mnt_valid_type),
//output
// 5G timing optimization Stage2
.mnt_flag1(mnt_flag1), //output
.mnt_flag2(mnt_flag2), //output
.mnt_claimed_signal(mnt_claimed_signal), //input
.io_m_valid_type(io_m_valid_type),
//output
// 5G timing optimization Stage2
.io_m_flag1(io_m_flag1), //output
.io_m_flag2(io_m_flag2), //output
.io_m_claimed_signal(io_m_claimed_signal), //input
.io_s_valid_type(io_s_valid_type),
//output
// 5G timing optimization Stage2
.io_s_flag1(io_s_flag1), //output
.io_s_flag2(io_s_flag2), //output
.io_s_claimed_signal(io_s_claimed_signal), //input
.drbell_valid_type(drbell_valid_type),
//output
// 5G timing optimization Stage2
.drbell_flag1(drbell_flag1), //output
.drbell_flag2(drbell_flag2), //output
.drbell_claimed_signal(drbell_claimed_signal),
//input
// 5G timing optimization Stage2
.gen_flag1(gen_flag1), //output
.gen_flag2(gen_flag2), //output
.gen_claimed_signal(gen_claimed_signal)//input
);

defparam rx_sfbuffer.port_write=port_write;
// **************************************************************
// procedural_code
// combinational_block
// 31/7/2009 [HLONG]: 5G
// the wires are assigned in the rx_sfbuffer


always @( * )  begin
// initialize flip-flop and combinational regs
    _Fgen_rxval = gen_rxval;
    _Fgen_rxsop = gen_rxsop;
    _Fgen_rxeop = gen_rxeop;
    _Fgen_rxmty = gen_rxmty;
    _Fgen_rxdat = gen_rxdat;
    _Fgen_rxsize = gen_rxsize;
    _Sdis_dat = 0;
    _Sclaim_packet = 0;
    _Ftoken = token;
    _Sgen_valid_type = 0;
    _Smnt_claimed_signal = 0;
    _Sio_m_claimed_signal = 0;
    _Sio_s_claimed_signal = 0;
    _Sdrbell_claimed_signal = 0;
    _Sgen_claimed_signal = 0;
    _Stoken_signal = 0;
    _Fmnt_state = mnt_state;
    _Fmnt_claimed = mnt_claimed;
    _Fio_m_state = io_m_state;
    _Fio_m_claimed = io_m_claimed;
    _Fio_s_state = io_s_state;
    _Fio_s_claimed = io_s_claimed;
    _Fdrbell_state = drbell_state;
    _Fdrbell_claimed = drbell_claimed;
    _Fgen_state = gen_state;
    _Fgen_claimed = gen_claimed;
    _Sdat_ena = 0;
    _Fmnt_rxval = mnt_rxval;
    _Fmnt_rxsop = mnt_rxsop;
    _Fmnt_rxeop = mnt_rxeop;
    _Fmnt_rxmty = mnt_rxmty;
    _Fmnt_rxdat = mnt_rxdat;
    _Fmnt_rxsize = mnt_rxsize;
    _Fio_m_rxval = io_m_rxval;
    _Fio_m_rxsop = io_m_rxsop;
    _Fio_m_rxeop = io_m_rxeop;
    _Fio_m_rxmty = io_m_rxmty;
    _Fio_m_rxdat = io_m_rxdat;
    _Fio_m_rxsize = io_m_rxsize;
    _Fio_s_rxval = io_s_rxval;
    _Fio_s_rxsop = io_s_rxsop;
    _Fio_s_rxeop = io_s_rxeop;
    _Fio_s_rxmty = io_s_rxmty;
    _Fio_s_rxdat = io_s_rxdat;
    _Fio_s_rxsize = io_s_rxsize;
    _Fdrbell_rxval = drbell_rxval;
    _Fdrbell_rxsop = drbell_rxsop;
    _Fdrbell_rxeop = drbell_rxeop;
    _Fdrbell_rxmty = drbell_rxmty;
    _Fdrbell_rxdat = drbell_rxdat;
    _Fdrbell_rxsize = drbell_rxsize;

// mainline code
    begin 
        _Sdis_dat = 1'b0;
        _Sclaim_packet = 1'b0;
        _Sdat_ena = 1'b1;
        if (dis_dat) begin 
            _Sdat_ena = 1'b0;
        end // 5G timing optimization Stage2
        _Stoken_signal = token;// 31/7/2009 [HLONG]: 5G
        // the comparison logic are done in the rx_sfbuffer
        _Sgen_valid_type = ! claim_packet;////////////////////////////
        // mnt block
        ////////////////////////////
        // assume no valid data when rxena is asserted
        // if rxena is not asserted, rxval will be held
        if (mnt_rxena) begin 
            _Fmnt_rxval = 1'b0;
        end // 5G timing optimization Stage2
        // the comparison _flag1 and _flag2 are done in rx_sfbuffer
        _Smnt_claimed_signal = mnt_claimed;
        if (mnt_flag1 || mnt_flag2) begin 
            _Sclaim_packet = 1'b1;// signal to inform generic port
            _Ftoken = 1'b1;
            _Fmnt_claimed = 1'b1;// 5G timing optimization Stage2
            _Stoken_signal = 1'b1;
            _Smnt_claimed_signal = 1'b1;
            if (mnt_rxena) begin 
                _Fmnt_rxval = 1'b1;
                {_Fmnt_rxsop, _Fmnt_rxeop, _Fmnt_rxmty, _Fmnt_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fmnt_rxsize = dat_size;
                _Fmnt_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fmnt_claimed = 1'b0;// 5G timing optimization Stage2
                    _Stoken_signal = 1'b0;
                    _Smnt_claimed_signal = 1'b0;
                end 
            end // !mnt_rxena
            else
            begin 
                _Sdis_dat = 1'b1;// mnt_state <- st_store;
            end 
        end ////////////////////////////
        // io_m block
        ////////////////////////////
        // assume no valid data when rxena is asserted
        // if rxena is not asserted, rxval will be held
        if (io_m_rxena) begin 
            _Fio_m_rxval = 1'b0;
        end // 5G timing optimization Stage2
        // the comparison _flag1 and _flag2 are done in rx_sfbuffer
        _Sio_m_claimed_signal = io_m_claimed;
        if (io_m_flag1 || io_m_flag2) begin 
            _Sclaim_packet = 1'b1;// signal to inform generic port
            _Ftoken = 1'b1;
            _Fio_m_claimed = 1'b1;// 5G timing optimization Stage2
            _Stoken_signal = 1'b1;
            _Sio_m_claimed_signal = 1'b1;
            if (io_m_rxena) begin 
                _Fio_m_rxval = 1'b1;
                {_Fio_m_rxsop, _Fio_m_rxeop, _Fio_m_rxmty, _Fio_m_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fio_m_rxsize = dat_size;
                _Fio_m_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fio_m_claimed = 1'b0;// 5G timing optimization Stage2
                    _Stoken_signal = 1'b0;
                    _Sio_m_claimed_signal = 1'b0;
                end 
            end // !io_m_rxena
            else
            begin 
                _Sdis_dat = 1'b1;// io_m_state <- st_store;
            end 
        end ////////////////////////////
        // io_s block
        ////////////////////////////
        // assume no valid data when rxena is asserted
        // if rxena is not asserted, rxval will be held
        if (io_s_rxena) begin 
            _Fio_s_rxval = 1'b0;
        end // 5G timing optimization Stage2
        // the comparison _flag1 and _flag2 are done in rx_sfbuffer
        _Sio_s_claimed_signal = io_s_claimed;
        if (io_s_flag1 || io_s_flag2) begin 
            _Sclaim_packet = 1'b1;// signal to inform generic port
            _Ftoken = 1'b1;
            _Fio_s_claimed = 1'b1;// 5G timing optimization Stage2
            _Stoken_signal = 1'b1;
            _Sio_s_claimed_signal = 1'b1;
            if (io_s_rxena) begin 
                _Fio_s_rxval = 1'b1;
                {_Fio_s_rxsop, _Fio_s_rxeop, _Fio_s_rxmty, _Fio_s_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fio_s_rxsize = dat_size;
                _Fio_s_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fio_s_claimed = 1'b0;// 5G timing optimization Stage2
                    _Stoken_signal = 1'b0;
                    _Sio_s_claimed_signal = 1'b0;
                end 
            end // !io_s_rxena
            else
            begin 
                _Sdis_dat = 1'b1;// io_s_state <- st_store;
            end 
        end ////////////////////////////
        // drbell block
        ////////////////////////////
        // assume no valid data when rxena is asserted
        // if rxena is not asserted, rxval will be held
        if (drbell_rxena) begin 
            _Fdrbell_rxval = 1'b0;
        end // 5G timing optimization Stage2
        // the comparison _flag1 and _flag2 are done in rx_sfbuffer
        _Sdrbell_claimed_signal = drbell_claimed;
        if (drbell_flag1 || drbell_flag2) begin 
            _Sclaim_packet = 1'b1;// signal to inform generic port
            _Ftoken = 1'b1;
            _Fdrbell_claimed = 1'b1;// 5G timing optimization Stage2
            _Stoken_signal = 1'b1;
            _Sdrbell_claimed_signal = 1'b1;
            if (drbell_rxena) begin 
                _Fdrbell_rxval = 1'b1;
                {_Fdrbell_rxsop, _Fdrbell_rxeop, _Fdrbell_rxmty,
                _Fdrbell_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fdrbell_rxsize = dat_size;
                _Fdrbell_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fdrbell_claimed = 1'b0;// 5G timing optimization Stage2
                    _Stoken_signal = 1'b0;
                    _Sdrbell_claimed_signal = 1'b0;
                end 
            end // !drbell_rxena
            else
            begin 
                _Sdis_dat = 1'b1;// drbell_state <- st_store;
            end 
        end ////////////////////////////
        // gen block
        ////////////////////////////
        // New Avalon-ST spec requires that the valid signal be cleared on non-ready cycles.
        _Fgen_rxval = 1'b0;// 5G timing optimization Stage2
        // the comparison _flag1 and _flag2 are done in rx_sfbuffer
        _Sgen_claimed_signal = gen_claimed;// 5G timing optimization Stage2
        // for gen_flag1 only
        if ((gen_flag1 && gen_valid_type) || gen_flag2) begin 
            _Ftoken = 1'b1;
            _Fgen_claimed = 1'b1;// 5G timing optimization Stage2
            _Stoken_signal = 1'b1;
            _Sgen_claimed_signal = 1'b1;
            if (gen_rxena) begin 
                _Fgen_rxval = 1'b1;
                {_Fgen_rxsop, _Fgen_rxeop, _Fgen_rxmty, _Fgen_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fgen_rxsize = dat_size;
                _Fgen_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fgen_claimed = 1'b0;// 5G timing optimization Stage2
                    _Stoken_signal = 1'b0;
                    _Sgen_claimed_signal = 1'b0;
                end 
            end // !gen_rxena
            else
            begin 
                _Sdis_dat = 1'b1;// gen_state <- st_store;
            end 
        end 
    end // sequential_blocks


// update regs for combinational signals
// The non-blocking assignment causes the always block to 
// re-stimulate if the signal has changed
    dis_dat <= _Sdis_dat;
    claim_packet <= _Sclaim_packet;
    gen_valid_type <= _Sgen_valid_type;
    mnt_claimed_signal <= _Smnt_claimed_signal;
    io_m_claimed_signal <= _Sio_m_claimed_signal;
    io_s_claimed_signal <= _Sio_s_claimed_signal;
    drbell_claimed_signal <= _Sdrbell_claimed_signal;
    gen_claimed_signal <= _Sgen_claimed_signal;
    token_signal <= _Stoken_signal;
    dat_ena <= _Sdat_ena;
end
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        gen_rxval<=0;
        gen_rxsop<=0;
        gen_rxeop<=0;
        gen_rxmty<=0;
        gen_rxdat<=0;
        gen_rxsize<=0;
        token<=0;
        mnt_state<=0;
        mnt_claimed<=0;
        io_m_state<=0;
        io_m_claimed<=0;
        io_s_state<=0;
        io_s_claimed<=0;
        drbell_state<=0;
        drbell_claimed<=0;
        gen_state<=0;
        gen_claimed<=0;
        mnt_rxval<=0;
        mnt_rxsop<=0;
        mnt_rxeop<=0;
        mnt_rxmty<=0;
        mnt_rxdat<=0;
        mnt_rxsize<=0;
        io_m_rxval<=0;
        io_m_rxsop<=0;
        io_m_rxeop<=0;
        io_m_rxmty<=0;
        io_m_rxdat<=0;
        io_m_rxsize<=0;
        io_s_rxval<=0;
        io_s_rxsop<=0;
        io_s_rxeop<=0;
        io_s_rxmty<=0;
        io_s_rxdat<=0;
        io_s_rxsize<=0;
        drbell_rxval<=0;
        drbell_rxsop<=0;
        drbell_rxeop<=0;
        drbell_rxmty<=0;
        drbell_rxdat<=0;
        drbell_rxsize<=0;
    end else begin
        gen_rxval<=_Fgen_rxval;
        gen_rxsop<=_Fgen_rxsop;
        gen_rxeop<=_Fgen_rxeop;
        gen_rxmty<=_Fgen_rxmty;
        gen_rxdat<=_Fgen_rxdat;
        gen_rxsize<=_Fgen_rxsize;
        token<=_Ftoken;
        mnt_state<=_Fmnt_state;
        mnt_claimed<=_Fmnt_claimed;
        io_m_state<=_Fio_m_state;
        io_m_claimed<=_Fio_m_claimed;
        io_s_state<=_Fio_s_state;
        io_s_claimed<=_Fio_s_claimed;
        drbell_state<=_Fdrbell_state;
        drbell_claimed<=_Fdrbell_claimed;
        gen_state<=_Fgen_state;
        gen_claimed<=_Fgen_claimed;
        mnt_rxval<=_Fmnt_rxval;
        mnt_rxsop<=_Fmnt_rxsop;
        mnt_rxeop<=_Fmnt_rxeop;
        mnt_rxmty<=_Fmnt_rxmty;
        mnt_rxdat<=_Fmnt_rxdat;
        mnt_rxsize<=_Fmnt_rxsize;
        io_m_rxval<=_Fio_m_rxval;
        io_m_rxsop<=_Fio_m_rxsop;
        io_m_rxeop<=_Fio_m_rxeop;
        io_m_rxmty<=_Fio_m_rxmty;
        io_m_rxdat<=_Fio_m_rxdat;
        io_m_rxsize<=_Fio_m_rxsize;
        io_s_rxval<=_Fio_s_rxval;
        io_s_rxsop<=_Fio_s_rxsop;
        io_s_rxeop<=_Fio_s_rxeop;
        io_s_rxmty<=_Fio_s_rxmty;
        io_s_rxdat<=_Fio_s_rxdat;
        io_s_rxsize<=_Fio_s_rxsize;
        drbell_rxval<=_Fdrbell_rxval;
        drbell_rxsop<=_Fdrbell_rxsop;
        drbell_rxeop<=_Fdrbell_rxeop;
        drbell_rxmty<=_Fdrbell_rxmty;
        drbell_rxdat<=_Fdrbell_rxdat;
        drbell_rxsize<=_Fdrbell_rxsize;
    end
end
endmodule

/*Vx2, V2.1.5
Released 2006-10-10
Checked out from CVS as $Header: //acds/main/ip/infrastructure/tools/lib/ToolVersion.pm#1 $
*/// vx_version verilog
/*
******************************************************

MODULE_NAME =  rx_sfbuffer
COMPANY =      Altera Corporation
WEB =          www.altera.com

FUNCTIONAL_DESCRIPTION :

Rx Store and Forward module

This module is used to filter out bad packets. It uses a circular
buffer to store incoming packets. A write pointer (waddr) and a read
pointer (raddr) are used. The read pointer always advances. The
write pointer advances only on good data. A bad packet is dropped
by resetting write pointer to packet start. 
Packet size (in words) is counted and passed to upper layer modules.
For 32-bit data path, ttype and TID fields are also captured and sent to upper
layer.
The buffers are sized to be able to hold at least 2N packet data words or N+1 packets,
where N is the number of words in a maximum size packect.

src - master input
snk - slave output

END_FUNCTIONAL_DESCRIPTION

SUB_MODULES = <call>

REVISION = $Id: //acds/main/ip/rapidio/rio/hw/src/rtl/transport/rx_sfbuffer.vx.erp#18 

LEGAL :
Copyright 2005 - 2011 Altera Corporation.  All rights reserved.
END_LEGAL

******************************************************
*/
//altera message_off 10270 
module  altera_rapidio_rx_sfbuffer_tl_small_x2_x4_pt_db /* vx2 no_prefix */  (
clk,
reset_n,
srcdav,
srcena,
srcval,
srcsop,
srceop,
srcmty,
srcerr,
srcdat,
snkena,
snkval,
snksop,
snkeop,
snkmty,
snkdat,
snksize,
device_id,
token_signal,
promiscuous_mode,
mnt_valid_type,
mnt_flag1,
mnt_flag2,
mnt_claimed_signal,
io_m_valid_type,
io_m_flag1,
io_m_flag2,
io_m_claimed_signal,
io_s_valid_type,
io_s_flag1,
io_s_flag2,
io_s_claimed_signal,
drbell_valid_type,
drbell_flag1,
drbell_flag2,
drbell_claimed_signal,
gen_flag1,
gen_flag2,
gen_claimed_signal);

// Ports and local variables. 
// '_F' indicates an auxiliary variable for flip-flops
// '_S' indicates an auxiliary variable for combinational signals
// '_W' indicates a VX2-created wire
parameter port_write = 1'b0;
// **************************************************************
// internal_variables (flop, signal, reg, wire, etc.)
// 31/7/2009 [HLONG]: 5G 
// Packet format types (ftype)
parameter ft_request = 4'd2; // Request Class
parameter ft_write = 4'd5; // Write Class
parameter ft_swrite = 4'd6; // Streaming-Write Class
parameter ft_maintain = 4'd8; // Maintenance Class
parameter ft_drbell = 4'd10; // Doorbell Class
parameter ft_response = 4'd13;
// Response Class
// Request packets transaction type (ttype)
parameter tt_mnt_read_req = 4'b0000; // Maintenance read request
parameter tt_mnt_write_req = 4'b0001; // Maintenance write request
parameter tt_port_write = 4'b0100;
// Maintenance port write request
// Response packets transaction type (ttype)
parameter tt_no_payload = 4'b0000; // Response without payload
parameter tt_payload = 4'b1000; // Response with payload
parameter crc_cnt = 6'd10;
input clk;
input reset_n;
input srcdav;
output srcena;
input srcval;
input srcsop;
input srceop;
input[3 - 1:0] srcmty;
input srcerr;
input[64 - 1:0] srcdat;
input snkena;
output snkval;
output snksop;
output snkeop;
output[3 - 1:0] snkmty;
output[64 - 1:0] snkdat;
output[6 - 1:0] snksize;
input[7:0] device_id;
input token_signal;
input promiscuous_mode;
output mnt_valid_type;
output mnt_flag1;
output mnt_flag2;
input mnt_claimed_signal;
output io_m_valid_type;
output io_m_flag1;
output io_m_flag2;
input io_m_claimed_signal;
output io_s_valid_type;
output io_s_flag1;
output io_s_flag2;
input io_s_claimed_signal;
output drbell_valid_type;
output drbell_flag1;
output drbell_flag2;
input drbell_claimed_signal;
output gen_flag1;
output gen_flag2;
input gen_claimed_signal;
// **************************************************************
wire  clk ;
wire  reset_n ;
wire  srcdav  ;
reg  srcena, _Fsrcena  ;
wire  srcval  ;
wire  srcsop  ;
wire  srceop  ;
wire  [3 - 1:0] srcmty  ;
wire  srcerr  ;
wire  [64 - 1:0] srcdat  ;
wire  snkena  ;
reg  snkval, _Fsnkval  ;
reg  snksop, _Fsnksop  ;
reg  snkeop, _Fsnkeop  ;
reg  [3 - 1:0] snkmty, _Fsnkmty  ;
reg  [64 - 1:0] snkdat, _Fsnkdat  ;
reg  [6 - 1:0] snksize  // packet word size, valid only if snksop is asserted
;
reg[6 - 1:0] _Fsnksize;
wire  [7:0] device_id  // 5G timing optimization Stage2:
// 1. add 'signal' for snkval, snksop and _valid_type to make comparison one clk in advanced 
// 2. _flag1 and _flag2 are comparison output to rx_transport
;
wire  token_signal  ;
wire  promiscuous_mode  ;
reg  mnt_valid_type  // 5G timing optimization Stage2
;
reg _Fmnt_valid_type;
reg  mnt_flag1, _Fmnt_flag1  ;
reg  mnt_flag2, _Fmnt_flag2  ;
wire  mnt_claimed_signal  ;
reg  io_m_valid_type  // 5G timing optimization Stage2
;
reg _Fio_m_valid_type;
reg  io_m_flag1, _Fio_m_flag1  ;
reg  io_m_flag2, _Fio_m_flag2  ;
wire  io_m_claimed_signal  ;
reg  io_s_valid_type  // 5G timing optimization Stage2
;
reg _Fio_s_valid_type;
reg  io_s_flag1, _Fio_s_flag1  ;
reg  io_s_flag2, _Fio_s_flag2  ;
wire  io_s_claimed_signal  ;
reg  drbell_valid_type  // 5G timing optimization Stage2
;
reg _Fdrbell_valid_type;
reg  drbell_flag1, _Fdrbell_flag1  ;
reg  drbell_flag2, _Fdrbell_flag2  ;
wire  drbell_claimed_signal  // 5G timing optimization Stage2
;
reg  gen_flag1, _Fgen_flag1  ;
reg  gen_flag2, _Fgen_flag2  ;
wire  gen_claimed_signal  ;
wire  [3:0] ftype  ; // Format type
wire  [1:0] tt  ; // Transport type
wire  [3:0] ttype  ; // Transaction type
wire  [7:0] destination_id  ;
wire  [7:0] transaction_id  ; // 5G timing optimization Stage2
reg  snkval_signal, _Ssnkval_signal  ;
reg  snksop_signal, _Ssnksop_signal  ;
reg  mnt_valid_type_signal, _Smnt_valid_type_signal  ;
reg  io_m_valid_type_signal, _Sio_m_valid_type_signal  ;
reg  io_s_valid_type_signal, _Sio_s_valid_type_signal  ;
reg  drbell_valid_type_signal  ;
// 5G timing optimization Stage3:
// make comparison 1 clk in advanced and register the comparison output.

reg _Sdrbell_valid_type_signal;
reg  pktcnt_neq_0, _Fpktcnt_neq_0  ;
reg  srcena_d1, _Fsrcena_d1  ;
wire  valid_data  ;
reg  wren, _Fwren  ;
reg  [7 - 1:0] waddr, _Fwaddr  ;
reg  [69 - 1:0] wdat, _Fwdat  ;
wire  [69 - 1:0] rdat  ;
reg  [7 - 1:0] raddr, _Sraddr  ;
reg  [7 - 1:0] raddr_current, _Fraddr_current  ;
reg  [7 - 1:0] start_waddr, _Fstart_waddr  ;
wire  rdsop  ;
wire  rdeop  ;
wire  [64 - 1:0] rddat  ;
wire  [3 - 1:0] rdmty  ;
wire  [6 - 1:0] wordcnt_signal  ;
reg  [6 - 1:0] wordcnt, _Fwordcnt  ;
reg  save_wordcnt, _Ssave_wordcnt  ;
reg  [6 - 1:0] wr_index, _Fwr_index  ;
reg  [6 - 1:0] rd_index, _Frd_index  ;
wire  [6 - 1:0] rdcnt  ;
//yhmoh: fix SPR:336145////////
//Fix for issue when a packet is follows immediately after short packet (completed in one clk cycle), 
//the outputs from rx_save_wordcnt and rx_sf_ttype_tid have one clock latency. 
//So the outputs need to be read in advanced. 
//Note: the above issue is fixed if the output data of the specific address is available and ready during read.
reg  [6 - 1:0] rd_index_advanced, _Frd_index_advanced  ;
wire  [6 - 1:0] rdcnt_advanced  ;
reg  shortpkt, _Fshortpkt  ;
reg  shortpkt_signal  ; ///////////////////////////////

reg _Sshortpkt_signal;
reg  [6 - 1:0] pktcnt, _Fpktcnt  ;
reg  inc_pktcnt, _Finc_pktcnt  ;
reg  inc_pktcnt_dly  ;
// AA Used to delay incrementing the packet count for single clock cycle packets so that the first and only word of the packet has time to propagate through the memory.

reg _Finc_pktcnt_dly;
reg  dec_pktcnt  ; // variables for CRC removal

reg _Sdec_pktcnt;
reg  plus80, _Fplus80  ;
reg  [64 - 17:0] wbuff, _Fwbuff  ;
reg  [3 - 1:0] wmty_buff, _Fwmty_buff  ;
reg  last_word, _Flast_word  ;
reg  [64 - 1:0] wdat_in, _Swdat_in  ;
reg  [3 - 1:0] wmty_in, _Swmty_in  ;
reg  wsop_in, _Swsop_in  ;
reg  weop_in, _Sweop_in  ;
reg  sop_flag  ;
// AA Asserted when we processed the last/current srcsop to avoid processing it multiple times. 

reg _Fsop_flag;
reg  just_got_eop, _Fjust_got_eop  ;
reg  [7 - 1:0] rx_sfdpram_fill_level, _Frx_sfdpram_fill_level  ;
reg  dummy_bit  ;
// **************************************************************
// structural_code
/*CALL*/
reg _Fdummy_bit;
 altera_rapidio_rx_sfdpram_tl_small_x2_x4_pt_db /* vx2 no_prefix */   rx_sfdpram(.data(wdat),
.wren(wren), .wraddress(waddr), .rdaddress(raddr), .clock(clk), .q(rdat));
//yhmoh: fix SPR:336145////////
/*CALL*/
 altera_rapidio_rx_save_wordcnt_tl_small_x2_x4_pt_db /* vx2 no_prefix */   rx_save_wordcnt(.data(wordcnt_signal),
.wren(save_wordcnt), .wraddress(wr_index), .rdaddress_a(rd_index),
.rdaddress_b(rd_index_advanced), .clock(clk), .qa(rdcnt),
.qb(rdcnt_advanced));
//yhmoh: fix SPR:336145////////
// **************************************************************
// procedural_code
// combinational_block
assign rdsop = rdat[68];

assign rdeop = rdat[67];

assign rdmty = rdat[66:64];

assign rddat = rdat[64 -1:0];

assign valid_data = (srcena_d1 & srcval) | (srcsop & srcval & ! sop_flag);// 31/7/2009 [HLONG]: 5G 
// only have the 4x assignment here


assign tt = rddat[64 -11:64 -12];

assign ftype = rddat[64 -13:64 -16];

assign destination_id = rddat[64 -17:64 -24];

assign ttype = rddat[64 -33:64 -36];

assign transaction_id = rddat[64 -41:64 -48];

assign wordcnt_signal = wordcnt + 1'd1;


always @( * )  begin
// initialize flip-flop and combinational regs
    _Fsrcena = srcena;
    _Fsnkval = snkval;
    _Fsnksop = snksop;
    _Fsnkeop = snkeop;
    _Fsnkmty = snkmty;
    _Fsnkdat = snkdat;
    _Fsnksize = snksize;
    _Fmnt_valid_type = mnt_valid_type;
    _Fmnt_flag1 = mnt_flag1;
    _Fmnt_flag2 = mnt_flag2;
    _Fio_m_valid_type = io_m_valid_type;
    _Fio_m_flag1 = io_m_flag1;
    _Fio_m_flag2 = io_m_flag2;
    _Fio_s_valid_type = io_s_valid_type;
    _Fio_s_flag1 = io_s_flag1;
    _Fio_s_flag2 = io_s_flag2;
    _Fdrbell_valid_type = drbell_valid_type;
    _Fdrbell_flag1 = drbell_flag1;
    _Fdrbell_flag2 = drbell_flag2;
    _Fgen_flag1 = gen_flag1;
    _Fgen_flag2 = gen_flag2;
    _Ssnkval_signal = 0;
    _Ssnksop_signal = 0;
    _Smnt_valid_type_signal = 0;
    _Sio_m_valid_type_signal = 0;
    _Sio_s_valid_type_signal = 0;
    _Sdrbell_valid_type_signal = 0;
    _Fpktcnt_neq_0 = pktcnt_neq_0;
    _Fsrcena_d1 = srcena_d1;
    _Fwren = wren;
    _Fwaddr = waddr;
    _Fwdat = wdat;
    _Sraddr = 0;
    _Fraddr_current = raddr_current;
    _Fstart_waddr = start_waddr;
    _Fwordcnt = wordcnt;
    _Ssave_wordcnt = 0;
    _Fwr_index = wr_index;
    _Frd_index = rd_index;
    _Frd_index_advanced = rd_index_advanced;
    _Fshortpkt = shortpkt;
    _Sshortpkt_signal = 0;
    _Fpktcnt = pktcnt;
    _Finc_pktcnt = inc_pktcnt;
    _Finc_pktcnt_dly = inc_pktcnt_dly;
    _Sdec_pktcnt = 0;
    _Fplus80 = plus80;
    _Fwbuff = wbuff;
    _Fwmty_buff = wmty_buff;
    _Flast_word = last_word;
    _Swdat_in = 0;
    _Swmty_in = 0;
    _Swsop_in = 0;
    _Sweop_in = 0;
    _Fsop_flag = sop_flag;
    _Fjust_got_eop = just_got_eop;
    _Frx_sfdpram_fill_level = rx_sfdpram_fill_level;
    _Fdummy_bit = dummy_bit;

// mainline code
    begin // 31/7/2009 [HLONG]: 5G 
    // check valid ftype, ttype, Destination ID and Transaction ID, then, flop the
    // result to be used in rx_transport

        if (port_write == 1'b0) begin 
            _Fmnt_valid_type = (ftype == ft_maintain) & (ttype != tt_port_write) & (tt == 2'b00) & ((device_id
            == destination_id) | (promiscuous_mode & ((ttype ==
            tt_port_write) | (ttype == tt_mnt_read_req) | (ttype ==
            tt_mnt_write_req))))
            // In promiscuous mode, ignore DestinationID of request packets.
;
        end 
        else
        begin 
            _Fmnt_valid_type = (ftype == ft_maintain) & (tt == 2'b00) & ((device_id == destination_id)
            | (promiscuous_mode & ((ttype == tt_port_write) | (ttype ==
            tt_mnt_read_req) | (ttype == tt_mnt_write_req))))
            // In promiscuous mode, ignore DestinationID of request packets.
;
        end 
        _Fio_m_valid_type = ((ftype == ft_request) | (ftype == ft_write) | (ftype == ft_swrite)) & (tt
        == 2'b00) & ((device_id == destination_id) | promiscuous_mode);// In promiscuous mode, ignore DestinationID of request packets.
        _Fio_s_valid_type = (ftype == ft_response) & (transaction_id[7:6] == 2'b01) & ((ttype ==
        tt_no_payload) | (ttype == tt_payload)) & (tt == 2'b00) & (device_id
        == destination_id) // 63 < TargetTID < 128  
;// DestinationID of response packets are checked, even in promiscuous mode.
        _Fdrbell_valid_type = ((ftype == ft_drbell) | ((ftype == ft_response) & (transaction_id[7:4]
        == 4'b1000) & (ttype == tt_no_payload))) & (tt == 2'b00) & ((device_id
        == destination_id) | (promiscuous_mode & (ftype == ft_drbell)))
        // 127 < TargetTID < 144  
;// 5G timing optimization Stage2
        _Ssnkval_signal = snkval;
        _Ssnksop_signal = snksop;
        _Smnt_valid_type_signal = mnt_valid_type;
        _Fmnt_flag1 = (! token_signal && snkval_signal && snksop_signal &&
        mnt_valid_type_signal);
        _Fmnt_flag2 = (mnt_claimed_signal && snkval_signal);
        _Sio_m_valid_type_signal = io_m_valid_type;
        _Fio_m_flag1 = (! token_signal && snkval_signal && snksop_signal &&
        io_m_valid_type_signal);
        _Fio_m_flag2 = (io_m_claimed_signal && snkval_signal);
        _Sio_s_valid_type_signal = io_s_valid_type;
        _Fio_s_flag1 = (! token_signal && snkval_signal && snksop_signal &&
        io_s_valid_type_signal);
        _Fio_s_flag2 = (io_s_claimed_signal && snkval_signal);
        _Sdrbell_valid_type_signal = drbell_valid_type;
        _Fdrbell_flag1 = (! token_signal && snkval_signal && snksop_signal &&
        drbell_valid_type_signal);
        _Fdrbell_flag2 = (drbell_claimed_signal && snkval_signal);// 5G timing optimization Stage2
        // for gen_flag1 only
        _Fgen_flag1 = (! token_signal && snkval_signal && snksop_signal);
        _Fgen_flag2 = (gen_claimed_signal && snkval_signal);
        if (port_write == 1'b0) begin 
            _Smnt_valid_type_signal = (ftype == ft_maintain) & (ttype != tt_port_write) & (tt == 2'b00) & ((device_id
            == destination_id) | (promiscuous_mode & ((ttype ==
            tt_port_write) | (ttype == tt_mnt_read_req) | (ttype ==
            tt_mnt_write_req))))
            // In promiscuous mode, ignore DestinationID of request packets.
;
        end 
        else
        begin 
            _Smnt_valid_type_signal = (ftype == ft_maintain) & (tt == 2'b00) & ((device_id == destination_id)
            | (promiscuous_mode & ((ttype == tt_port_write) | (ttype ==
            tt_mnt_read_req) | (ttype == tt_mnt_write_req))))
            // In promiscuous mode, ignore DestinationID of request packets.
;
        end 
        _Sio_m_valid_type_signal = ((ftype == ft_request) | (ftype == ft_write) | (ftype == ft_swrite)) & (tt
        == 2'b00) & ((device_id == destination_id) | promiscuous_mode);// In promiscuous mode, ignore DestinationID of request packets.
        _Sio_s_valid_type_signal = (ftype == ft_response) & (transaction_id[7:6] == 2'b01) & ((ttype ==
        tt_no_payload) | (ttype == tt_payload)) & (tt == 2'b00) & (device_id
        == destination_id) // 63 < TargetTID < 128  
;// DestinationID of response packets are checked, even in promiscuous mode.
        _Sdrbell_valid_type_signal = ((ftype == ft_drbell) | ((ftype == ft_response) & (transaction_id[7:4]
        == 4'b1000) & (ttype == tt_no_payload))) & (tt == 2'b00) & ((device_id
        == destination_id) | (promiscuous_mode & (ftype == ft_drbell)))
        // 127 < TargetTID < 144  
;//**********************
        // store data in buffer
        _Fsrcena_d1 = srcena;
        _Fsrcena = 1'b1;//yhmoh fix SPR:336145 ///// 
        _Fshortpkt = shortpkt_signal;////////////////////////////
        // Compute rx_sfdpram FIFO fill level
        {_Fdummy_bit, _Frx_sfdpram_fill_level} = {1'b1, waddr} - {1'b0, raddr};// Determine if it is too full.
        if (rx_sfdpram_fill_level > 7'd120) begin 
            _Fsrcena = 1'b0;
        end 
        if (pktcnt > 6'd56) begin 
            _Fsrcena = 1'b0;
        end 
        _Fjust_got_eop = valid_data & srceop;// add a layer of flops to improve timing, but
        // latency is increased. The flops can be removed by
        // always setting wren to 1.
        _Fwdat = {wsop_in, weop_in, wmty_in, wdat_in};
        _Swmty_in = srcmty;
        _Swdat_in = srcdat;
        _Swsop_in = srcsop;
        _Sweop_in = srceop;
        _Fwren = 1'b0;
        if (wren) begin 
            _Fwaddr = waddr + 7'h1;
        end 
        _Finc_pktcnt_dly = 1'b0;
        _Finc_pktcnt = inc_pktcnt_dly;
        if (valid_data & ! last_word) begin 
            if (! srcerr) begin 
                _Fwren = 1'b1;
                _Fwordcnt = wordcnt + 6'h1;
                if (srcsop) begin 
                    _Fstart_waddr = waddr + wren;// AA Need to add one when packets are back to back.
                    _Fsop_flag = 1'b1;
                end 
                if (srceop) begin // single word packet

                    if (srcsop) begin 
                        _Finc_pktcnt_dly = 1'b1;
                        _Fsop_flag = 1'b1;// AA redundant.
                    end 
                    else
                    begin 
                        _Finc_pktcnt = 1'b1;// 5G timing optimization Stage3
                        _Fsop_flag = 1'b0;
                    end 
                    _Ssave_wordcnt = 1'b1;
                    _Fwordcnt = 0;//sop_flag <- 1'b0; // AA Why was this commented out ? Because it should stay set if both sop and eop are asserted.
                end // CRC removal
                _Fwbuff = srcdat[64 - 17:0];
                if (wordcnt == crc_cnt) begin 
                    _Fwren = 1'b0;
                    _Fplus80 = 1'b1;
                    if (srceop) begin 
                        _Fwren = 1'b1;
                        if (srcmty == 0) begin 
                            _Swdat_in = {srcdat[64 - 17:0], 16'h0};
                            _Swmty_in = 3'd2;
                        end 
                        _Fplus80 = 1'b0;
                    end 
                end 
                if (plus80) begin 
                    _Swdat_in = {wbuff, srcdat[64 - 1:64 - 16]};
                    _Sweop_in = 1'b0;
                    if (srceop) begin 
                        _Swmty_in = 3'h0;
                        _Fwmty_buff = srcmty;
                        _Fplus80 = 1'b0;
                        _Flast_word = 1'b1;
                        _Fsrcena = 1'b0;// throttle data flow
                    end 
                end 
            end 
            else
            begin // !srcerr
            // packet is terminated by error
            // drop packet by resetting write pointer

                _Fwordcnt = 0;
                _Fplus80 = 1'b0;// AA Should we also clear or set sop_flag ? I think we should clear it if(!srcsop)
                if (! srcsop) begin // AA Can srcsop and srcerr actually be asserted simultaneously ? Maybe, but then srceop would also need to be asserted.

                    _Fwaddr = start_waddr;
                end 
            end 
        end // valid_data
        // Last word for packet larger than 80 bytes
        if (last_word) begin 
            _Fwren = 1'b1;
            _Swmty_in = wmty_buff + 3'd2;// This never adds up to 0 as the original mty is always 0 mod 4
            _Swdat_in = {wbuff, 16'h0};
            _Swsop_in = 1'b0;
            _Sweop_in = 1'b1;
            _Flast_word = 1'b0;
        end 
        if (save_wordcnt) begin 
            _Fwr_index = wr_index + 6'h1;
        end //************************
        // read data from buffer
        //************************
        _Sdec_pktcnt = 1'b0;
        _Sraddr = raddr_current;
        if (snkena) begin // 5G timing optimization Stage3

            if (pktcnt_neq_0) begin 
                _Fraddr_current = raddr_current + 7'h1;
                _Sraddr = raddr_current + 7'h1;
                _Fsnkval = 1'b1;
                _Fsnksop = rdsop;// 5G timing optimization Stage2
                _Ssnkval_signal = 1'b1;
                _Ssnksop_signal = rdsop;
                _Fsnkeop = rdeop;
                _Fsnkmty = rdmty;
                _Fsnkdat = rddat;
                if (rdsop) begin //yhmoh: fix for SPR:336145//////
                //if both rdsop & rdeop are asserted high, assert shortpkt_signal.
                //outputs of rx_save_wordcnt and rx_sf_ttype_tid are read one clock in advanced.

                    if (rdeop) begin 
                        _Sshortpkt_signal = 1'b1;
                    end 
                    _Frd_index = rd_index + 6'h1;
                    _Frd_index_advanced = rd_index + 6'h2;
                    if (shortpkt) begin 
                        _Fsnksize = rdcnt_advanced;
                    end 
                    else
                    begin 
                        _Fsnksize = rdcnt;
                    end 
                end 
                if (rdeop) begin 
                    _Sdec_pktcnt = 1'b1;
                end 
            end // no new packet data available
            else
            begin 
                _Fsnkval = 1'b0;// 5G timing optimization Stage2
                _Ssnkval_signal = 1'b0;
            end 
        end //snkena
        if (inc_pktcnt && ! dec_pktcnt) begin 
            _Fpktcnt = pktcnt + 6'h1;// 5G timing optimization Stage3
            _Fpktcnt_neq_0 = 1'b1;
        end 
        else
            if (! inc_pktcnt && dec_pktcnt) begin 
                _Fpktcnt = pktcnt - 6'h1;// 5G timing optimization Stage3
                _Fpktcnt_neq_0 = (pktcnt != 6'd1);
            end 
    end 


// update regs for combinational signals
// The non-blocking assignment causes the always block to 
// re-stimulate if the signal has changed
    snkval_signal <= _Ssnkval_signal;
    snksop_signal <= _Ssnksop_signal;
    mnt_valid_type_signal <= _Smnt_valid_type_signal;
    io_m_valid_type_signal <= _Sio_m_valid_type_signal;
    io_s_valid_type_signal <= _Sio_s_valid_type_signal;
    drbell_valid_type_signal <= _Sdrbell_valid_type_signal;
    raddr <= _Sraddr;
    save_wordcnt <= _Ssave_wordcnt;
    shortpkt_signal <= _Sshortpkt_signal;
    dec_pktcnt <= _Sdec_pktcnt;
    wdat_in <= _Swdat_in;
    wmty_in <= _Swmty_in;
    wsop_in <= _Swsop_in;
    weop_in <= _Sweop_in;
end
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        srcena<=0;
        snkval<=0;
        snksop<=0;
        snkeop<=0;
        snkmty<=0;
        snkdat<=0;
        snksize<=0;
        mnt_valid_type<=0;
        mnt_flag1<=0;
        mnt_flag2<=0;
        io_m_valid_type<=0;
        io_m_flag1<=0;
        io_m_flag2<=0;
        io_s_valid_type<=0;
        io_s_flag1<=0;
        io_s_flag2<=0;
        drbell_valid_type<=0;
        drbell_flag1<=0;
        drbell_flag2<=0;
        gen_flag1<=0;
        gen_flag2<=0;
        pktcnt_neq_0<=0;
        srcena_d1<=0;
        wren<=0;
        waddr<=0;
        wdat<=0;
        raddr_current<=0;
        start_waddr<=0;
        wordcnt<=0;
        wr_index<=0;
        rd_index<=0;
        rd_index_advanced<=0;
        shortpkt<=0;
        pktcnt<=0;
        inc_pktcnt<=0;
        inc_pktcnt_dly<=0;
        plus80<=0;
        wbuff<=0;
        wmty_buff<=0;
        last_word<=0;
        sop_flag<=0;
        just_got_eop<=0;
        rx_sfdpram_fill_level<=0;
        dummy_bit<=0;
    end else begin
        srcena<=_Fsrcena;
        snkval<=_Fsnkval;
        snksop<=_Fsnksop;
        snkeop<=_Fsnkeop;
        snkmty<=_Fsnkmty;
        snkdat<=_Fsnkdat;
        snksize<=_Fsnksize;
        mnt_valid_type<=_Fmnt_valid_type;
        mnt_flag1<=_Fmnt_flag1;
        mnt_flag2<=_Fmnt_flag2;
        io_m_valid_type<=_Fio_m_valid_type;
        io_m_flag1<=_Fio_m_flag1;
        io_m_flag2<=_Fio_m_flag2;
        io_s_valid_type<=_Fio_s_valid_type;
        io_s_flag1<=_Fio_s_flag1;
        io_s_flag2<=_Fio_s_flag2;
        drbell_valid_type<=_Fdrbell_valid_type;
        drbell_flag1<=_Fdrbell_flag1;
        drbell_flag2<=_Fdrbell_flag2;
        gen_flag1<=_Fgen_flag1;
        gen_flag2<=_Fgen_flag2;
        pktcnt_neq_0<=_Fpktcnt_neq_0;
        srcena_d1<=_Fsrcena_d1;
        wren<=_Fwren;
        waddr<=_Fwaddr;
        wdat<=_Fwdat;
        raddr_current<=_Fraddr_current;
        start_waddr<=_Fstart_waddr;
        wordcnt<=_Fwordcnt;
        wr_index<=_Fwr_index;
        rd_index<=_Frd_index;
        rd_index_advanced<=_Frd_index_advanced;
        shortpkt<=_Fshortpkt;
        pktcnt<=_Fpktcnt;
        inc_pktcnt<=_Finc_pktcnt;
        inc_pktcnt_dly<=_Finc_pktcnt_dly;
        plus80<=_Fplus80;
        wbuff<=_Fwbuff;
        wmty_buff<=_Fwmty_buff;
        last_word<=_Flast_word;
        sop_flag<=_Fsop_flag;
        just_got_eop<=_Fjust_got_eop;
        rx_sfdpram_fill_level<=_Frx_sfdpram_fill_level;
        dummy_bit<=_Fdummy_bit;
    end
end
endmodule

/*Vx2, V2.1.5
Released 2006-10-10
Checked out from CVS as $Header: //acds/main/ip/infrastructure/tools/lib/ToolVersion.pm#1 $
*/// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module  altera_rapidio_rx_save_wordcnt_tl_small_x2_x4_pt_db /* vx2 no_prefix */  (
clock,
data,
rdaddress_a,
rdaddress_b,
wraddress,
wren,
qa,
qb);
input clock;
input[6 - 1:0] data;
input[6 - 1:0] rdaddress_a;
input[6 - 1:0] rdaddress_b;
input[6 - 1:0] wraddress;
input wren;
output[6 - 1:0] qa;
output[6 - 1:0] qb;
wire  clock  ;
wire  [6 - 1:0] data  ;
wire  [6 - 1:0] rdaddress_a  ;
wire  [6 - 1:0] rdaddress_b  ;
wire  [6 - 1:0] wraddress  ;
wire  wren  ;
wire  [6 - 1:0] sub_wire0  ;
wire  [6 - 1:0] sub_wire1  ;
wire  [6 - 1:0] qa = sub_wire0[6 - 1:0]  ;
//unregistered output because cannot bear with additional latency
wire  [6 - 1:0] qb = sub_wire1[6 - 1:0]  ;
//unregistered output because cannot bear with additional latency
 custom_alt3pram_width_6 /* vx2 no_prefix */ custom_alt3pram_width_6_component(.wren(wren),
.clock(clock), .data(data), .rdaddress_a(rdaddress_a),
.wraddress(wraddress), .rdaddress_b(rdaddress_b), .q_a(sub_wire0),
.q_b(sub_wire1)// synopsys translate_off

                                // synopsys translate_on

);

endmodule

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module  altera_rapidio_rx_sf_ttype_tid_tl_small_x2_x4_pt_db /* vx2 no_prefix */  (
clock,
data,
rdaddress_a,
rdaddress_b,
wraddress,
wren,
qa,
qb);
input clock;
input[12 - 1:0] data;
input[7 - 1:0] rdaddress_a;
input[7 - 1:0] rdaddress_b;
input[7 - 1:0] wraddress;
input wren;
output[12 - 1:0] qa;
output[12 - 1:0] qb;
wire  clock  ;
wire  [12 - 1:0] data  ;
wire  [7 - 1:0] rdaddress_a  ;
wire  [7 - 1:0] rdaddress_b  ;
wire  [7 - 1:0] wraddress  ;
wire  wren  ;
wire  [12 - 1:0] sub_wire0  ;
wire  [12 - 1:0] sub_wire1  ;
wire  [12 - 1:0] qa = sub_wire0[12 - 1:0]  ;
//unregistered output because cannot bear with additional latency
wire  [12 - 1:0] qb = sub_wire1[12 - 1:0]  ;
//unregistered output because cannot bear with additional latency
 custom_alt3pram_width_12 /* vx2 no_prefix */ custom_alt3pram_width_12_component(.wren(wren),
.clock(clock), .data(data), .rdaddress_a(rdaddress_a),
.wraddress(wraddress), .rdaddress_b(rdaddress_b), .q_a(sub_wire0),
.q_b(sub_wire1)// synopsys translate_off
                                // synopsys translate_on

);

endmodule

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module  altera_rapidio_rx_sfdpram_tl_small_x2_x4_pt_db /* vx2 no_prefix */  (
data,
wren,
wraddress,
rdaddress,
clock,
q);
input[69 - 1:0] data;
input wren;
input[7 - 1:0] wraddress;
input[7 - 1:0] rdaddress;
input clock;
output[69 - 1:0] q;
wire  [69 - 1:0] data  ;
wire  wren  ;
wire  [7 - 1:0] wraddress  ;
wire  [7 - 1:0] rdaddress  ;
wire  clock  ;
wire  [69 - 1:0] sub_wire0  ;
wire  [69 - 1:0] q = sub_wire0[69 - 1:0]  ;
 altsyncram /* vx2 no_prefix */ altsyncram_component(.wren_a(wren),
.clock0(clock), .address_a(wraddress), .address_b(rdaddress),
.rden_b(1'b1), .data_a(data), .q_b(sub_wire0), .aclr0(1'b0),
.aclr1(1'b0), .addressstall_a(1'b0), .addressstall_b(1'b0),
.byteena_a(1'b1), .byteena_b(1'b1), .clock1(1'b1), .clocken0(1'b1),
.clocken1(1'b1), .data_b({69 {1'b1}}), .q_a(), .wren_b(1'b0));

defparam altsyncram_component.clock_enable_input_a="BYPASS",
altsyncram_component.clock_enable_input_b="BYPASS",
altsyncram_component.clock_enable_output_b="BYPASS",
altsyncram_component.address_reg_b="CLOCK0",
altsyncram_component.intended_device_family="Stratix V",
altsyncram_component.lpm_type="altsyncram",
altsyncram_component.numwords_a=128,
altsyncram_component.numwords_b=128,
altsyncram_component.operation_mode="DUAL_PORT",
altsyncram_component.outdata_aclr_b="NONE",
//altsyncram_component.outdata_reg_b = "CLOCK0",

altsyncram_component.outdata_reg_b="UNREGISTERED",
altsyncram_component.power_up_uninitialized="FALSE",
altsyncram_component.rdcontrol_aclr_b="NONE",
altsyncram_component.rdcontrol_reg_b="CLOCK0",
altsyncram_component.read_during_write_mode_mixed_ports="DONT_CARE",
altsyncram_component.widthad_a=7,
altsyncram_component.widthad_b=7,
altsyncram_component.width_a=69,
altsyncram_component.width_b=69,
altsyncram_component.width_byteena_a=1;

endmodule

