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

module  altera_rapidio_transport_tl_small_x1_pt /* vx2 no_prefix */  (
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
mnt_rx_ttype,
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
output[2 - 1:0] tx_empty;
output[32 - 1:0] tx_data;
input rx_packet_available;
output rx_ready;
input rx_valid;
input rx_start_packet;
input rx_end_packet;
input rx_error;
input[2 - 1:0] rx_empty;
input[32 - 1:0] rx_data;
input mnt_tx_packet_available;
output mnt_tx_ready;
input mnt_tx_valid;
input mnt_tx_start_packet;
input mnt_tx_end_packet;
input mnt_tx_error;
input[2 - 1:0] mnt_tx_empty;
input[32 - 1:0] mnt_tx_data;
input[7 - 1:0] mnt_tx_size;
input mnt_rx_ready;
output mnt_rx_valid;
output mnt_rx_start_packet;
output mnt_rx_end_packet;
output[2 - 1:0] mnt_rx_empty;
output[32 - 1:0] mnt_rx_data;
output[7 - 1:0] mnt_rx_size;
output[3:0] mnt_rx_ttype;
input io_m_tx_packet_available;
output io_m_tx_ready;
input io_m_tx_valid;
input io_m_tx_start_packet;
input io_m_tx_end_packet;
input io_m_tx_error;
input[2 - 1:0] io_m_tx_empty;
input[32 - 1:0] io_m_tx_data;
input[7 - 1:0] io_m_tx_size;
input io_m_rx_ready;
output io_m_rx_valid;
output io_m_rx_start_packet;
output io_m_rx_end_packet;
output[2 - 1:0] io_m_rx_empty;
output[32 - 1:0] io_m_rx_data;
output[7 - 1:0] io_m_rx_size;
input io_s_tx_packet_available;
output io_s_tx_ready;
input io_s_tx_valid;
input io_s_tx_start_packet;
input io_s_tx_end_packet;
input io_s_tx_error;
input[2 - 1:0] io_s_tx_empty;
input[32 - 1:0] io_s_tx_data;
input[7 - 1:0] io_s_tx_size;
input io_s_rx_ready;
output io_s_rx_valid;
output io_s_rx_start_packet;
output io_s_rx_end_packet;
output[2 - 1:0] io_s_rx_empty;
output[32 - 1:0] io_s_rx_data;
output[7 - 1:0] io_s_rx_size;
output gen_txena;
input gen_txval;
input gen_txsop;
input gen_txeop;
input gen_txerr;
input[2 - 1:0] gen_txmty;
input[32 - 1:0] gen_txdat;
input gen_rxena;
output gen_rxval;
output gen_rxsop;
output gen_rxeop;
output[2 - 1:0] gen_rxmty;
output[32 - 1:0] gen_rxdat;
output[7 - 1:0] gen_rxsize;
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
wire  [2 - 1:0] tx_empty  ;
wire  [32 - 1:0] tx_data  ;
wire  rx_packet_available  ;
wire  rx_ready  ;
wire  rx_valid  ;
wire  rx_start_packet  ;
wire  rx_end_packet  ;
wire  rx_error  ;
wire  [2 - 1:0] rx_empty  ;
wire  [32 - 1:0] rx_data  ;
wire  mnt_tx_packet_available  ;
wire  mnt_tx_ready  ;
wire  mnt_tx_valid  ;
wire  mnt_tx_start_packet  ;
wire  mnt_tx_end_packet  ;
wire  mnt_tx_error  ;
wire  [2 - 1:0] mnt_tx_empty  ;
wire  [32 - 1:0] mnt_tx_data  ;
wire  [7 - 1:0] mnt_tx_size  ;
wire  mnt_rx_ready  ;
wire  mnt_rx_valid  ;
wire  mnt_rx_start_packet  ;
wire  mnt_rx_end_packet  ;
wire  [2 - 1:0] mnt_rx_empty  ;
wire  [32 - 1:0] mnt_rx_data  ;
wire  [7 - 1:0] mnt_rx_size  ;
wire  [3:0] mnt_rx_ttype  ;
wire  io_m_tx_packet_available  ;
wire  io_m_tx_ready  ;
wire  io_m_tx_valid  ;
wire  io_m_tx_start_packet  ;
wire  io_m_tx_end_packet  ;
wire  io_m_tx_error  ;
wire  [2 - 1:0] io_m_tx_empty  ;
wire  [32 - 1:0] io_m_tx_data  ;
wire  [7 - 1:0] io_m_tx_size  ;
wire  io_m_rx_ready  ;
wire  io_m_rx_valid  ;
wire  io_m_rx_start_packet  ;
wire  io_m_rx_end_packet  ;
wire  [2 - 1:0] io_m_rx_empty  ;
wire  [32 - 1:0] io_m_rx_data  ;
wire  [7 - 1:0] io_m_rx_size  ;
wire  io_s_tx_packet_available  ;
wire  io_s_tx_ready  ;
wire  io_s_tx_valid  ;
wire  io_s_tx_start_packet  ;
wire  io_s_tx_end_packet  ;
wire  io_s_tx_error  ;
wire  [2 - 1:0] io_s_tx_empty  ;
wire  [32 - 1:0] io_s_tx_data  ;
wire  [7 - 1:0] io_s_tx_size  ;
wire  io_s_rx_ready  ;
wire  io_s_rx_valid  ;
wire  io_s_rx_start_packet  ;
wire  io_s_rx_end_packet  ;
wire  [2 - 1:0] io_s_rx_empty  ;
wire  [32 - 1:0] io_s_rx_data  ;
wire  [7 - 1:0] io_s_rx_size  ;
wire  gen_txena  ;
wire  gen_txval  ;
wire  gen_txsop  ;
wire  gen_txeop  ;
wire  gen_txerr  ;
wire  [2 - 1:0] gen_txmty  ;
wire  [32 - 1:0] gen_txdat  ;
wire  gen_rxena  ;
wire  gen_rxval  ;
wire  gen_rxsop  ;
wire  gen_rxeop  ;
wire  [2 - 1:0] gen_rxmty  ;
wire  [32 - 1:0] gen_rxdat  ;
wire  [7 - 1:0] gen_rxsize  ;
 altera_rapidio_tx_transport_tl_small_x1_pt /* vx2 no_prefix */   tx_transport(.clk(sysclk),
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
.io_s_tx_size(io_s_tx_size),
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
 altera_rapidio_rx_transport_tl_small_x1_pt /* vx2 no_prefix */   rx_transport(.clk(sysclk),
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
.mnt_rx_ttype(mnt_rx_ttype), // output
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
module  altera_rapidio_tx_transport_tl_small_x1_pt /* vx2 no_prefix */  (
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
output[2 - 1:0] tx_empty;
output[32 - 1:0] tx_data;
input mnt_tx_packet_available;
output mnt_tx_ready;
input mnt_tx_valid;
input mnt_tx_start_packet;
input mnt_tx_end_packet;
input mnt_tx_error;
input[2 - 1:0] mnt_tx_empty;
input[32 - 1:0] mnt_tx_data;
input[7 - 1:0] mnt_tx_size;
input io_m_tx_packet_available;
output io_m_tx_ready;
input io_m_tx_valid;
input io_m_tx_start_packet;
input io_m_tx_end_packet;
input io_m_tx_error;
input[2 - 1:0] io_m_tx_empty;
input[32 - 1:0] io_m_tx_data;
input[7 - 1:0] io_m_tx_size;
input io_s_tx_packet_available;
output io_s_tx_ready;
input io_s_tx_valid;
input io_s_tx_start_packet;
input io_s_tx_end_packet;
input io_s_tx_error;
input[2 - 1:0] io_s_tx_empty;
input[32 - 1:0] io_s_tx_data;
input[7 - 1:0] io_s_tx_size;
output gen_txena;
input gen_txval;
input gen_txsop;
input gen_txeop;
input gen_txerr;
input[2 - 1:0] gen_txmty;
input[32 - 1:0] gen_txdat;
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
wire  [2 - 1:0] tx_empty  ;
wire  [32 - 1:0] tx_data  ; // Interface to logical layer module mnt
wire  mnt_tx_packet_available  ;
wire  mnt_tx_ready  ;
wire  mnt_tx_valid  ;
wire  mnt_tx_start_packet  ;
wire  mnt_tx_end_packet  ;
wire  mnt_tx_error  ;
wire  [2 - 1:0] mnt_tx_empty  ;
wire  [32 - 1:0] mnt_tx_data  ;
wire  [7 - 1:0] mnt_tx_size  ;
// Interface to logical layer module io_m
wire  io_m_tx_packet_available  ;
wire  io_m_tx_ready  ;
wire  io_m_tx_valid  ;
wire  io_m_tx_start_packet  ;
wire  io_m_tx_end_packet  ;
wire  io_m_tx_error  ;
wire  [2 - 1:0] io_m_tx_empty  ;
wire  [32 - 1:0] io_m_tx_data  ;
wire  [7 - 1:0] io_m_tx_size  ;
// Interface to logical layer module io_s
wire  io_s_tx_packet_available  ;
wire  io_s_tx_ready  ;
wire  io_s_tx_valid  ;
wire  io_s_tx_start_packet  ;
wire  io_s_tx_end_packet  ;
wire  io_s_tx_error  ;
wire  [2 - 1:0] io_s_tx_empty  ;
wire  [32 - 1:0] io_s_tx_data  ;
wire  [7 - 1:0] io_s_tx_size  ;
// Pass-through interface
//input       gen_txdav,
reg  gen_txena, _Fgen_txena  ;
wire  gen_txval  ;
wire  gen_txsop  ;
wire  gen_txeop  ;
wire  gen_txerr  ;
wire  [2 - 1:0] gen_txmty  ;
wire  [32 - 1:0] gen_txdat  ;
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
parameter io_s_next = gen_block;
parameter io_s_mask = 5'b11011;
parameter gen_next = mnt_block;
parameter gen_mask = 5'b11110; // Atlantic I Aliases
reg  mnt_state, _Fmnt_state  ;
reg  io_m_state, _Fio_m_state  ;
reg  io_s_state, _Fio_s_state  ;
reg  gen_state, _Fgen_state  ;
reg  txena, _Ftxena  ;
reg  txsop, _Ftxsop  ;
reg  txeop, _Ftxeop  ;
reg  txerr, _Ftxerr  ;
reg  [2 - 1:0] txmty, _Ftxmty  ;
reg  [32 - 1:0] txdat, _Ftxdat  ;
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
wire  [2 - 1:0] mnt_txmty  ;
wire  [32 - 1:0] mnt_txdat  ;
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
wire  [2 - 1:0] io_m_txmty  ;
wire  [32 - 1:0] io_m_txdat  ;
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
wire  [2 - 1:0] io_s_txmty  ;
wire  [32 - 1:0] io_s_txdat  ;
assign io_s_txdav = io_s_tx_packet_available;

assign io_s_tx_ready = io_s_txena;// output


assign io_s_txsop = io_s_tx_start_packet;

assign io_s_txeop = io_s_tx_end_packet;

assign io_s_txerr = io_s_tx_error;

assign io_s_txval = io_s_tx_valid;

assign io_s_txmty = io_s_tx_empty;

assign io_s_txdat = io_s_tx_data;


reg  io_s_txena_d1, _Fio_s_txena_d1  ;
reg  gen_txena_d1, _Fgen_txena_d1  ;
reg  gen_txdav, _Fgen_txdav  ;
reg  gen_txsop_f, _Fgen_txsop_f  ;
reg  gen_txeop_f, _Fgen_txeop_f  ;
reg  [32 - 1:0] gen_txdat_f, _Fgen_txdat_f  ;
reg  [2 - 1:0] gen_txmty_f, _Fgen_txmty_f  ;
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
        gen_txena_d1<=0;
        gen_txdav<=1'b0;
        gen_txsop_f<=1'b0;
        gen_txeop_f<=1'b0;
        gen_txdat_f<=32'd0;
        gen_txmty_f<=2'd0;
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
module  altera_rapidio_rx_transport_tl_small_x1_pt /* vx2 no_prefix */  (
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
mnt_rx_ttype,
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
input[2 - 1:0] rx_empty;
input[32 - 1:0] rx_data;
input mnt_rx_ready;
output mnt_rx_valid;
output mnt_rx_start_packet;
output mnt_rx_end_packet;
output[2 - 1:0] mnt_rx_empty;
output[32 - 1:0] mnt_rx_data;
output[7 - 1:0] mnt_rx_size;
output[3:0] mnt_rx_ttype;
input io_m_rx_ready;
output io_m_rx_valid;
output io_m_rx_start_packet;
output io_m_rx_end_packet;
output[2 - 1:0] io_m_rx_empty;
output[32 - 1:0] io_m_rx_data;
output[7 - 1:0] io_m_rx_size;
input io_s_rx_ready;
output io_s_rx_valid;
output io_s_rx_start_packet;
output io_s_rx_end_packet;
output[2 - 1:0] io_s_rx_empty;
output[32 - 1:0] io_s_rx_data;
output[7 - 1:0] io_s_rx_size;
input gen_rxena;
output gen_rxval;
output gen_rxsop;
output gen_rxeop;
output[2 - 1:0] gen_rxmty;
output[32 - 1:0] gen_rxdat;
output[7 - 1:0] gen_rxsize;
input[7:0] device_id;
input promiscuous_mode;
// **************************************************************
// internal_variables (flop, signal, reg, wire, etc.)
// Packet format types (ftype)
wire  clk ;
wire  reset_n ;
wire  rx_packet_available  ;
wire  rx_ready  ;
wire  rx_valid  ;
wire  rx_start_packet  ;
wire  rx_end_packet  ;
wire  rx_error  ;
wire  [2 - 1:0] rx_empty  ;
wire  [32 - 1:0] rx_data  ;
wire  mnt_rx_ready  ;
wire  mnt_rx_valid  ;
wire  mnt_rx_start_packet  ;
wire  mnt_rx_end_packet  ;
wire  [2 - 1:0] mnt_rx_empty  ;
wire  [32 - 1:0] mnt_rx_data  ;
wire  [7 - 1:0] mnt_rx_size  ;
wire  [3:0] mnt_rx_ttype  ;
wire  io_m_rx_ready  ;
wire  io_m_rx_valid  ;
wire  io_m_rx_start_packet  ;
wire  io_m_rx_end_packet  ;
wire  [2 - 1:0] io_m_rx_empty  ;
wire  [32 - 1:0] io_m_rx_data  ;
wire  [7 - 1:0] io_m_rx_size  ;
wire  io_s_rx_ready  ;
wire  io_s_rx_valid  ;
wire  io_s_rx_start_packet  ;
wire  io_s_rx_end_packet  ;
wire  [2 - 1:0] io_s_rx_empty  ;
wire  [32 - 1:0] io_s_rx_data  ;
wire  [7 - 1:0] io_s_rx_size  ;
wire  gen_rxena  ;
reg  gen_rxval, _Fgen_rxval  ;
reg  gen_rxsop, _Fgen_rxsop  ;
reg  gen_rxeop, _Fgen_rxeop  ;
reg  [2 - 1:0] gen_rxmty, _Fgen_rxmty  ;
reg  [32 - 1:0] gen_rxdat, _Fgen_rxdat  ;
reg  [7 - 1:0] gen_rxsize, _Fgen_rxsize  ;
wire  [7:0] device_id  ;
wire  promiscuous_mode  ;
reg  dis_dat, _Sdis_dat  ;
reg  claim_packet, _Sclaim_packet  ;
reg  token, _Ftoken  ;
reg  mnt_valid_type, _Smnt_valid_type  ;
reg  io_m_valid_type, _Sio_m_valid_type  ;
reg  io_s_valid_type, _Sio_s_valid_type  ;
reg  gen_valid_type, _Sgen_valid_type  ;
reg  mnt_state, _Fmnt_state  ;
reg  mnt_claimed, _Fmnt_claimed  ;
reg  io_m_state, _Fio_m_state  ;
reg  io_m_claimed, _Fio_m_claimed  ;
reg  io_s_state, _Fio_s_state  ;
reg  io_s_claimed, _Fio_s_claimed  ;
reg  gen_state, _Fgen_state  ;
reg  gen_claimed, _Fgen_claimed  ;
wire  [3:0] ftype  ; // Format type
wire  [1:0] tt  ; // Transport type
wire  [3:0] ttype  ; // Transaction type
wire  [7:0] destination_id  ;
wire  [7:0] transaction_id  ;
reg  dat_ena, _Sdat_ena  ;
wire  dat_val  ;
wire  dat_sop  ;
wire  dat_eop  ;
wire  [2 - 1:0] dat_mty  ;
wire  [32 - 1:0] dat  ;
wire  [7 - 1:0] dat_size  ;
wire  [3:0] dat_ttype  ;
wire  [7:0] dat_tid  ; // Atlantic I aliases
wire  mnt_rxena  ;
reg  mnt_rxval, _Fmnt_rxval  ;
reg  mnt_rxsop, _Fmnt_rxsop  ;
reg  mnt_rxeop, _Fmnt_rxeop  ;
reg  [2 - 1:0] mnt_rxmty, _Fmnt_rxmty  ;
reg  [32 - 1:0] mnt_rxdat, _Fmnt_rxdat  ;
reg  [7 - 1:0] mnt_rxsize, _Fmnt_rxsize  ;
reg  [3:0] mnt_rxttype, _Fmnt_rxttype  ;
assign mnt_rx_ttype = mnt_rxttype;

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
reg  [2 - 1:0] io_m_rxmty, _Fio_m_rxmty  ;
reg  [32 - 1:0] io_m_rxdat, _Fio_m_rxdat  ;
reg  [7 - 1:0] io_m_rxsize, _Fio_m_rxsize  ;
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
reg  [2 - 1:0] io_s_rxmty, _Fio_s_rxmty  ;
reg  [32 - 1:0] io_s_rxdat, _Fio_s_rxdat  ;
reg  [7 - 1:0] io_s_rxsize, _Fio_s_rxsize  ;
assign io_s_rxena = io_s_rx_ready;

assign io_s_rx_valid = io_s_rxval;

assign io_s_rx_start_packet = io_s_rxsop;

assign io_s_rx_end_packet = io_s_rxeop;

assign io_s_rx_empty = io_s_rxmty;

assign io_s_rx_size = io_s_rxsize;

assign io_s_rx_data = io_s_rxdat;// **************************************************************
// structural_code
/*CALL*/

 altera_rapidio_rx_sfbuffer_tl_small_x1_pt /* vx2 no_prefix */   rx_sfbuffer(.clk(clk),
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
.snkttype(dat_ttype), // output
.snktid(dat_tid)// output
);

defparam rx_sfbuffer.port_write=port_write;
// **************************************************************
// procedural_code
// combinational_block

assign tt = dat[32 -11:32 -12];

assign ftype = dat[32 -13:32 -16];

assign destination_id = dat[32 -17:32 -24];

assign ttype = dat_ttype;

assign transaction_id = dat_tid;


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
    _Smnt_valid_type = 0;
    _Sio_m_valid_type = 0;
    _Sio_s_valid_type = 0;
    _Sgen_valid_type = 0;
    _Fmnt_state = mnt_state;
    _Fmnt_claimed = mnt_claimed;
    _Fio_m_state = io_m_state;
    _Fio_m_claimed = io_m_claimed;
    _Fio_s_state = io_s_state;
    _Fio_s_claimed = io_s_claimed;
    _Fgen_state = gen_state;
    _Fgen_claimed = gen_claimed;
    _Sdat_ena = 0;
    _Fmnt_rxval = mnt_rxval;
    _Fmnt_rxsop = mnt_rxsop;
    _Fmnt_rxeop = mnt_rxeop;
    _Fmnt_rxmty = mnt_rxmty;
    _Fmnt_rxdat = mnt_rxdat;
    _Fmnt_rxsize = mnt_rxsize;
    _Fmnt_rxttype = mnt_rxttype;
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

// mainline code
    begin 
        _Sdis_dat = 1'b0;
        _Sclaim_packet = 1'b0;
        _Sdat_ena = 1'b1;
        if (dis_dat) begin 
            _Sdat_ena = 1'b0;
        end // check valid ftype, ttype, Destination ID and Transaction ID
        if (port_write == 1'b0) begin 
            _Smnt_valid_type = (ftype == ft_maintain) & (ttype != tt_port_write) & (tt == 2'b00) & ((device_id
            == destination_id) | (promiscuous_mode & ((ttype ==
            tt_port_write) | (ttype == tt_mnt_read_req) | (ttype ==
            tt_mnt_write_req))))
            // In promiscuous mode, ignore DestinationID of request packets.
;
        end 
        else
        begin 
            _Smnt_valid_type = (ftype == ft_maintain) & (tt == 2'b00) & ((device_id == destination_id)
            | (promiscuous_mode & ((ttype == tt_port_write) | (ttype ==
            tt_mnt_read_req) | (ttype == tt_mnt_write_req))))
            // In promiscuous mode, ignore DestinationID of request packets.
;
        end // End of port write
        _Sio_m_valid_type = ((ftype == ft_request) | (ftype == ft_write) | (ftype == ft_swrite)) & (tt
        == 2'b00) & ((device_id == destination_id) | promiscuous_mode);// In promiscuous mode, ignore DestinationID of request packets.
        _Sio_s_valid_type = (ftype == ft_response) & (transaction_id[7:6] == 2'b01) & ((ttype ==
        tt_no_payload) | (ttype == tt_payload)) & (tt == 2'b00) & (device_id
        == destination_id) // 63 < TargetTID < 128  
;// DestinationID of response packets are checked, even in promiscuous mode.
        _Sgen_valid_type = ! claim_packet;////////////////////////////
        // mnt block
        ////////////////////////////
        // assume no valid data when rxena is asserted
        // if rxena is not asserted, rxval will be held
        if (mnt_rxena) begin 
            _Fmnt_rxval = 1'b0;
        end 
        if
        ((! token && dat_val && dat_sop && mnt_valid_type) || (mnt_claimed &&
        dat_val)) begin 
            _Sclaim_packet = 1'b1;// signal to inform generic port
            _Ftoken = 1'b1;
            _Fmnt_claimed = 1'b1;
            if (mnt_rxena) begin 
                _Fmnt_rxval = 1'b1;
                {_Fmnt_rxsop, _Fmnt_rxeop, _Fmnt_rxmty, _Fmnt_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fmnt_rxsize = dat_size;
                _Fmnt_state = st_proc;
                _Fmnt_rxttype = dat_ttype;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fmnt_claimed = 1'b0;
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
        end 
        if
        ((! token && dat_val && dat_sop && io_m_valid_type) || (io_m_claimed &&
        dat_val)) begin 
            _Sclaim_packet = 1'b1;// signal to inform generic port
            _Ftoken = 1'b1;
            _Fio_m_claimed = 1'b1;
            if (io_m_rxena) begin 
                _Fio_m_rxval = 1'b1;
                {_Fio_m_rxsop, _Fio_m_rxeop, _Fio_m_rxmty, _Fio_m_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fio_m_rxsize = dat_size;
                _Fio_m_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fio_m_claimed = 1'b0;
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
        end 
        if
        ((! token && dat_val && dat_sop && io_s_valid_type) || (io_s_claimed &&
        dat_val)) begin 
            _Sclaim_packet = 1'b1;// signal to inform generic port
            _Ftoken = 1'b1;
            _Fio_s_claimed = 1'b1;
            if (io_s_rxena) begin 
                _Fio_s_rxval = 1'b1;
                {_Fio_s_rxsop, _Fio_s_rxeop, _Fio_s_rxmty, _Fio_s_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fio_s_rxsize = dat_size;
                _Fio_s_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fio_s_claimed = 1'b0;
                end 
            end // !io_s_rxena
            else
            begin 
                _Sdis_dat = 1'b1;// io_s_state <- st_store;
            end 
        end ////////////////////////////
        // gen block
        ////////////////////////////
        // New Avalon-ST spec requires that the valid signal be cleared on non-ready cycles.
        _Fgen_rxval = 1'b0;
        if
        ((! token && dat_val && dat_sop && gen_valid_type) || (gen_claimed &&
        dat_val)) begin 
            _Ftoken = 1'b1;
            _Fgen_claimed = 1'b1;
            if (gen_rxena) begin 
                _Fgen_rxval = 1'b1;
                {_Fgen_rxsop, _Fgen_rxeop, _Fgen_rxmty, _Fgen_rxdat} = {dat_sop, dat_eop, dat_mty, dat};
                _Fgen_rxsize = dat_size;
                _Fgen_state = st_proc;
                if (dat_eop) begin 
                    _Ftoken = 1'b0;
                    _Fgen_claimed = 1'b0;
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
    mnt_valid_type <= _Smnt_valid_type;
    io_m_valid_type <= _Sio_m_valid_type;
    io_s_valid_type <= _Sio_s_valid_type;
    gen_valid_type <= _Sgen_valid_type;
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
        gen_state<=0;
        gen_claimed<=0;
        mnt_rxval<=0;
        mnt_rxsop<=0;
        mnt_rxeop<=0;
        mnt_rxmty<=0;
        mnt_rxdat<=0;
        mnt_rxsize<=0;
        mnt_rxttype<=0;
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
        gen_state<=_Fgen_state;
        gen_claimed<=_Fgen_claimed;
        mnt_rxval<=_Fmnt_rxval;
        mnt_rxsop<=_Fmnt_rxsop;
        mnt_rxeop<=_Fmnt_rxeop;
        mnt_rxmty<=_Fmnt_rxmty;
        mnt_rxdat<=_Fmnt_rxdat;
        mnt_rxsize<=_Fmnt_rxsize;
        mnt_rxttype<=_Fmnt_rxttype;
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
module  altera_rapidio_rx_sfbuffer_tl_small_x1_pt /* vx2 no_prefix */  (
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
snkttype,
snktid);

// Ports and local variables. 
// '_F' indicates an auxiliary variable for flip-flops
// '_S' indicates an auxiliary variable for combinational signals
// '_W' indicates a VX2-created wire
parameter port_write = 1'b0;
// **************************************************************
// internal_variables (flop, signal, reg, wire, etc.)
parameter crc_cnt = 7'd20;
input clk;
input reset_n;
input srcdav;
output srcena;
input srcval;
input srcsop;
input srceop;
input[2 - 1:0] srcmty;
input srcerr;
input[32 - 1:0] srcdat;
input snkena;
output snkval;
output snksop;
output snkeop;
output[2 - 1:0] snkmty;
output[32 - 1:0] snkdat;
output[7 - 1:0] snksize;
output[3:0] snkttype;
output[7:0] snktid;
// **************************************************************
wire  clk ;
wire  reset_n ;
wire  srcdav  ;
reg  srcena, _Fsrcena  ;
wire  srcval  ;
wire  srcsop  ;
wire  srceop  ;
wire  [2 - 1:0] srcmty  ;
wire  srcerr  ;
wire  [32 - 1:0] srcdat  ;
wire  snkena  ;
reg  snkval, _Fsnkval  ;
reg  snksop, _Fsnksop  ;
reg  snkeop, _Fsnkeop  ;
reg  [2 - 1:0] snkmty, _Fsnkmty  ;
reg  [32 - 1:0] snkdat, _Fsnkdat  ;
reg  [7 - 1:0] snksize  // packet word size, valid only if snksop is asserted
;
reg[7 - 1:0] _Fsnksize;
reg  [3:0] snkttype, _Fsnkttype  ;
reg  [7:0] snktid, _Fsnktid  ;
reg  srcena_d1, _Fsrcena_d1  ;
wire  valid_data  ;
reg  wren, _Fwren  ;
reg  [8 - 1:0] waddr, _Fwaddr  ;
reg  [36 - 1:0] wdat, _Fwdat  ;
wire  [36 - 1:0] rdat  ;
reg  [8 - 1:0] raddr, _Sraddr  ;
reg  [8 - 1:0] raddr_current, _Fraddr_current  ;
reg  [8 - 1:0] start_waddr, _Fstart_waddr  ;
wire  rdsop  ;
wire  rdeop  ;
wire  [32 - 1:0] rddat  ;
wire  [2 - 1:0] rdmty  ;
wire  [7 - 1:0] wordcnt_signal  ;
reg  [7 - 1:0] wordcnt, _Fwordcnt  ;
reg  save_wordcnt, _Ssave_wordcnt  ;
reg  [7 - 1:0] wr_index, _Fwr_index  ;
reg  [7 - 1:0] rd_index, _Frd_index  ;
wire  [7 - 1:0] rdcnt  ;
//yhmoh: fix SPR:336145////////
//Fix for issue when a packet is follows immediately after short packet (completed in one clk cycle), 
//the outputs from rx_save_wordcnt and rx_sf_ttype_tid have one clock latency. 
//So the outputs need to be read in advanced. 
//Note: the above issue is fixed if the output data of the specific address is available and ready during read.
reg  [7 - 1:0] rd_index_advanced, _Frd_index_advanced  ;
wire  [7 - 1:0] rdcnt_advanced  ;
reg  shortpkt, _Fshortpkt  ;
reg  shortpkt_signal  ; ///////////////////////////////

reg _Sshortpkt_signal;
reg  [7 - 1:0] pktcnt, _Fpktcnt  ;
reg  inc_pktcnt, _Finc_pktcnt  ;
reg  inc_pktcnt_dly  ;
// AA Used to delay incrementing the packet count for single clock cycle packets so that the first and only word of the packet has time to propagate through the memory.

reg _Finc_pktcnt_dly;
reg  dec_pktcnt, _Sdec_pktcnt  ;
reg  [3:0] ttype_signal, _Sttype_signal  ;
reg  [7:0] tid_signal, _Stid_signal  ;
reg  [3:0] ttype0, _Fttype0  ;
reg  [3:0] ttype1, _Fttype1  ;
reg  [3:0] ttype2, _Fttype2  ;
reg  [3:0] ttype3, _Fttype3  ;
reg  [7:0] tid0, _Ftid0  ;
reg  [7:0] tid1, _Ftid1  ;
reg  [7:0] tid2, _Ftid2  ;
reg  [7:0] tid3, _Ftid3  ;
reg  save_ttype_and_tid, _Ssave_ttype_and_tid  ;
wire  [7:0] rdtid  ;
wire  [3:0] rdttype  ; //yhmoh: fix SPR:336145////////
wire  [7:0] rdtid_advanced  ;
wire  [3:0] rdttype_advanced  ;
///////////////////////////////
// variables for CRC removal
reg  plus80, _Fplus80  ;
reg  [32 - 17:0] wbuff, _Fwbuff  ;
reg  [2 - 1:0] wmty_buff, _Fwmty_buff  ;
reg  last_word, _Flast_word  ;
reg  [32 - 1:0] wdat_in, _Swdat_in  ;
reg  [2 - 1:0] wmty_in, _Swmty_in  ;
reg  wsop_in, _Swsop_in  ;
reg  weop_in, _Sweop_in  ;
reg  sop_flag  ;
// AA Asserted when we processed the last/current srcsop to avoid processing it multiple times. 

reg _Fsop_flag;
reg  just_got_eop, _Fjust_got_eop  ;
reg  [8 - 1:0] rx_sfdpram_fill_level, _Frx_sfdpram_fill_level  ;
reg  dummy_bit  ;
// **************************************************************
// structural_code
/*CALL*/
reg _Fdummy_bit;
 altera_rapidio_rx_sfdpram_tl_small_x1_pt /* vx2 no_prefix */   rx_sfdpram(.data(wdat),
.wren(wren), .wraddress(waddr), .rdaddress(raddr), .clock(clk), .q(rdat));
//yhmoh: fix SPR:336145////////
/*CALL*/
 altera_rapidio_rx_save_wordcnt_tl_small_x1_pt /* vx2 no_prefix */   rx_save_wordcnt(.data(wordcnt_signal),
.wren(save_wordcnt), .wraddress(wr_index), .rdaddress_a(rd_index),
.rdaddress_b(rd_index_advanced), .clock(clk), .qa(rdcnt),
.qb(rdcnt_advanced));
//yhmoh: fix SPR:336145////////
/*CALL*/
 altera_rapidio_rx_sf_ttype_tid_tl_small_x1_pt /* vx2 no_prefix */   rx_sf_ttype_tid(.data({ttype_signal, tid_signal}),
.wren(save_ttype_and_tid), .wraddress(wr_index), .rdaddress_a(rd_index),
.rdaddress_b(rd_index_advanced), .clock(clk), .qa({rdttype, rdtid}),
.qb({rdttype_advanced, rdtid_advanced}));
// **************************************************************
// procedural_code
// combinational_block
assign rdsop = rdat[35];

assign rdeop = rdat[34];

assign rdmty = rdat[33:32];

assign rddat = rdat[32 -1:0];

assign valid_data = (srcena_d1 & srcval) | (srcsop & srcval & ! sop_flag);

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
    _Fsnkttype = snkttype;
    _Fsnktid = snktid;
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
    _Sttype_signal = 0;
    _Stid_signal = 0;
    _Fttype0 = ttype0;
    _Fttype1 = ttype1;
    _Fttype2 = ttype2;
    _Fttype3 = ttype3;
    _Ftid0 = tid0;
    _Ftid1 = tid1;
    _Ftid2 = tid2;
    _Ftid3 = tid3;
    _Ssave_ttype_and_tid = 0;
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
    begin //**********************
    // store data in buffer

        _Fsrcena_d1 = srcena;
        _Fsrcena = 1'b1;//yhmoh fix SPR:336145 ///// 
        _Fshortpkt = shortpkt_signal;////////////////////////////
        // Compute rx_sfdpram FIFO fill level
        {_Fdummy_bit, _Frx_sfdpram_fill_level} = {1'b1, waddr} - {1'b0, raddr};// Determine if it is too full.
        if (rx_sfdpram_fill_level > 8'd248) begin 
            _Fsrcena = 1'b0;
        end 
        if (pktcnt > 7'd120) begin 
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
            _Fwaddr = waddr + 8'h1;
        end 
        _Finc_pktcnt_dly = 1'b0;
        _Finc_pktcnt = inc_pktcnt_dly;
        if (valid_data & ! last_word) begin 
            if (! srcerr) begin 
                _Fwren = 1'b1;
                _Fwordcnt = wordcnt + 7'h1;
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
                        _Finc_pktcnt = 1'b1;
                        _Fsop_flag = 1'b0;
                    end 
                    _Ssave_wordcnt = 1'b1;
                    _Fwordcnt = 0;//sop_flag <- 1'b0; // AA Why was this commented out ? Because it should stay set if both sop and eop are asserted.
                end 
                if (wordcnt == 7'h1) begin 
                    _Ssave_ttype_and_tid = 1;
                end // CRC removal
                _Fwbuff = srcdat[32 - 17:0];
                if (wordcnt == crc_cnt) begin 
                    _Fwren = 1'b0;
                    _Fplus80 = 1'b1;
                    if (srceop) begin 
                        _Fwren = 1'b1;
                        _Fplus80 = 1'b0;
                    end 
                end 
                if (plus80) begin 
                    _Swdat_in = {wbuff, srcdat[32 - 1:32 - 16]};
                    _Sweop_in = 1'b0;
                    if (srceop) begin 
                        _Swmty_in = 2'h0;
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
            _Swmty_in = wmty_buff + 2'd2;// This never adds up to 0 as the original mty is always 0 mod 4
            _Swdat_in = {wbuff, 16'h0};
            _Swsop_in = 1'b0;
            _Sweop_in = 1'b1;
            _Flast_word = 1'b0;
        end 
        if (save_wordcnt) begin 
            _Fwr_index = wr_index + 7'h1;
        end 
        if (save_ttype_and_tid) begin 
            _Sttype_signal = srcdat[32 - 1:32 - 4];
            _Stid_signal = srcdat[32 - 9:32 - 16];
        end //************************
        // read data from buffer
        //************************
        _Sdec_pktcnt = 1'b0;
        _Sraddr = raddr_current;
        if (snkena) begin 
            if (pktcnt != 7'h0) begin 
                _Fraddr_current = raddr_current + 8'h1;
                _Sraddr = raddr_current + 8'h1;
                _Fsnkval = 1'b1;
                _Fsnksop = rdsop;
                _Fsnkeop = rdeop;
                _Fsnkmty = rdmty;
                _Fsnkdat = rddat;
                if (rdsop) begin //yhmoh: fix for SPR:336145//////
                //if both rdsop & rdeop are asserted high, assert shortpkt_signal.
                //outputs of rx_save_wordcnt and rx_sf_ttype_tid are read one clock in advanced.

                    if (rdeop) begin 
                        _Sshortpkt_signal = 1'b1;
                    end 
                    _Frd_index = rd_index + 7'h1;
                    _Frd_index_advanced = rd_index + 7'h2;
                    if (shortpkt) begin 
                        _Fsnksize = rdcnt_advanced;
                    end 
                    else
                    begin 
                        _Fsnksize = rdcnt;
                    end 
                    if (shortpkt) begin 
                        _Fsnkttype = rdttype_advanced;
                        _Fsnktid = rdtid_advanced;
                    end 
                    else
                    begin 
                        _Fsnkttype = rdttype;
                        _Fsnktid = rdtid;
                    end 
                end 
                if (rdeop) begin 
                    _Sdec_pktcnt = 1'b1;
                end 
            end // no new packet data available
            else
            begin 
                _Fsnkval = 1'b0;
            end 
        end //snkena
        if (inc_pktcnt && ! dec_pktcnt) begin 
            _Fpktcnt = pktcnt + 7'h1;
        end 
        else
            if (! inc_pktcnt && dec_pktcnt) begin 
                _Fpktcnt = pktcnt - 7'h1;
            end 
    end 


// update regs for combinational signals
// The non-blocking assignment causes the always block to 
// re-stimulate if the signal has changed
    raddr <= _Sraddr;
    save_wordcnt <= _Ssave_wordcnt;
    shortpkt_signal <= _Sshortpkt_signal;
    dec_pktcnt <= _Sdec_pktcnt;
    ttype_signal <= _Sttype_signal;
    tid_signal <= _Stid_signal;
    save_ttype_and_tid <= _Ssave_ttype_and_tid;
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
        snkttype<=4'd0;
        snktid<=8'd0;
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
        ttype0<=0;
        ttype1<=0;
        ttype2<=0;
        ttype3<=0;
        tid0<=0;
        tid1<=0;
        tid2<=0;
        tid3<=0;
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
        snkttype<=_Fsnkttype;
        snktid<=_Fsnktid;
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
        ttype0<=_Fttype0;
        ttype1<=_Fttype1;
        ttype2<=_Fttype2;
        ttype3<=_Fttype3;
        tid0<=_Ftid0;
        tid1<=_Ftid1;
        tid2<=_Ftid2;
        tid3<=_Ftid3;
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

module  altera_rapidio_rx_save_wordcnt_tl_small_x1_pt /* vx2 no_prefix */  (
clock,
data,
rdaddress_a,
rdaddress_b,
wraddress,
wren,
qa,
qb);
input clock;
input[7 - 1:0] data;
input[7 - 1:0] rdaddress_a;
input[7 - 1:0] rdaddress_b;
input[7 - 1:0] wraddress;
input wren;
output[7 - 1:0] qa;
output[7 - 1:0] qb;
wire  clock  ;
wire  [7 - 1:0] data  ;
wire  [7 - 1:0] rdaddress_a  ;
wire  [7 - 1:0] rdaddress_b  ;
wire  [7 - 1:0] wraddress  ;
wire  wren  ;
wire  [7 - 1:0] sub_wire0  ;
wire  [7 - 1:0] sub_wire1  ;
wire  [7 - 1:0] qa = sub_wire0[7 - 1:0]  ;
//unregistered output because cannot bear with additional latency
wire  [7 - 1:0] qb = sub_wire1[7 - 1:0]  ;
//unregistered output because cannot bear with additional latency
 custom_alt3pram_width_7 /* vx2 no_prefix */ custom_alt3pram_width_7_component(.wren(wren),
.clock(clock), .data(data), .rdaddress_a(rdaddress_a),
.wraddress(wraddress), .rdaddress_b(rdaddress_b), .q_a(sub_wire0),
.q_b(sub_wire1)// synopsys translate_off

                                // synopsys translate_on

);

endmodule

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module  altera_rapidio_rx_sf_ttype_tid_tl_small_x1_pt /* vx2 no_prefix */  (
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

module  altera_rapidio_rx_sfdpram_tl_small_x1_pt /* vx2 no_prefix */  (
data,
wren,
wraddress,
rdaddress,
clock,
q);
input[36 - 1:0] data;
input wren;
input[8 - 1:0] wraddress;
input[8 - 1:0] rdaddress;
input clock;
output[36 - 1:0] q;
wire  [36 - 1:0] data  ;
wire  wren  ;
wire  [8 - 1:0] wraddress  ;
wire  [8 - 1:0] rdaddress  ;
wire  clock  ;
wire  [36 - 1:0] sub_wire0  ;
wire  [36 - 1:0] q = sub_wire0[36 - 1:0]  ;
 altsyncram /* vx2 no_prefix */ altsyncram_component(.wren_a(wren),
.clock0(clock), .address_a(wraddress), .address_b(rdaddress),
.rden_b(1'b1), .data_a(data), .q_b(sub_wire0), .aclr0(1'b0),
.aclr1(1'b0), .addressstall_a(1'b0), .addressstall_b(1'b0),
.byteena_a(1'b1), .byteena_b(1'b1), .clock1(1'b1), .clocken0(1'b1),
.clocken1(1'b1), .data_b({36 {1'b1}}), .q_a(), .wren_b(1'b0));

defparam altsyncram_component.clock_enable_input_a="BYPASS",
altsyncram_component.clock_enable_input_b="BYPASS",
altsyncram_component.clock_enable_output_b="BYPASS",
altsyncram_component.address_reg_b="CLOCK0",
altsyncram_component.intended_device_family="Stratix V",
altsyncram_component.lpm_type="altsyncram",
altsyncram_component.numwords_a=256,
altsyncram_component.numwords_b=256,
altsyncram_component.operation_mode="DUAL_PORT",
altsyncram_component.outdata_aclr_b="NONE",
//altsyncram_component.outdata_reg_b = "CLOCK0",

altsyncram_component.outdata_reg_b="UNREGISTERED",
altsyncram_component.power_up_uninitialized="FALSE",
altsyncram_component.rdcontrol_aclr_b="NONE",
altsyncram_component.rdcontrol_reg_b="CLOCK0",
altsyncram_component.read_during_write_mode_mixed_ports="DONT_CARE",
altsyncram_component.widthad_a=8,
altsyncram_component.widthad_b=8,
altsyncram_component.width_a=36,
altsyncram_component.width_b=36,
altsyncram_component.width_byteena_a=1;

endmodule

