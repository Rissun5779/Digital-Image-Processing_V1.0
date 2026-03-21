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



`timescale 1 ps / 1 ps
//-----------------------------------------------------------------------------
// Title         : PCI Express BFM Root Port Avalon-ST Parameterized VC Interface
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcietb_bfm_vc_intf_param.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description :
// This entity interfaces between the root port transaction list processor
// and the root port module single VC interface. It handles the following basic
// functions:
// * Formating Tx Descriptors
// * Retrieving Tx Data as needed from the shared memory
// * Decoding Rx Descriptors
// * Storing Rx Data as needed to the shared memory
//-----------------------------------------------------------------------------

module altpcietb_bfm_vc_intf_param #
  (
   parameter VC_NUM  = 0,
   parameter AST_WIDTH = 256,
   parameter AST_SOP_WIDTH = 1,
   parameter AST_MTY_WIDTH = 2,
   parameter PACKED_MODE = 0
   )
   (
    input logic                        clk_in,
    input logic                        rstn,
    // Rx TLPs already monitored
    input                              altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct rx_tlp_snoop ,
    input bit                          rx_tlp_valid_snoop ,
    input bit                          rx_tlp_ack_snoop ,
    // To control flow of incoming TLPs
    output bit                         rx_st_ready ,
    // Tx Avalon-ST Interface to be driven
    output logic                       tx_st_valid,
    input logic                        tx_st_ready,
    output logic [(AST_WIDTH-1):0]     tx_st_data,
    output logic [(AST_SOP_WIDTH-1):0] tx_st_sop,
    output logic [(AST_SOP_WIDTH-1):0] tx_st_eop,
    output logic [(AST_MTY_WIDTH-1):0] tx_st_empty, // Needs correct mapping, see below
    output logic                       tx_err, // not currently used
    // Misc Signals
    output logic                       rx_mask, // not currently used, RP can always send completions
    input logic [35:0]                 tx_cred  // not currently used
    );

`include "altpcietb_g3bfm_constants.v"
`include "altpcietb_g3bfm_log.v"
`include "altpcietb_g3bfm_shmem.v"
`include "altpcietb_g3bfm_req_intf.v"

   import altpcietb_bfm_vc_intf_param_pkg::* ;

   // Interface between TLP processor module and Tx Interface Driver sub-modules
   altpcietb_tlp_struct tx_tlp ;
   bit    tx_tlp_valid ;
   bit    tx_tlp_ack ;

   // Drive the unused or constant outputs statically
   // Currently rx_st_ready is always asserted, future enhancement would be
   // to provide random control to provide backpressure to EP DUT
   assign rx_st_ready = 1'b1 ;
   assign rx_mask = 1'b0 ;

   // Sub-module to drive the Tx Interface
   altpcietb_bfm_vc_intf_tx_driver
     #(
       .AST_WIDTH(AST_WIDTH),
       .AST_SOP_WIDTH(AST_SOP_WIDTH),
       .AST_MTY_WIDTH(AST_MTY_WIDTH),
       .PACKED_MODE(PACKED_MODE),
       .INTERFACE_LABEL("Root Port Tx")
       )
   i_tx_drvr
     (
      .clk_in(clk_in),
      .rstn(rstn),
      // Tx Avalon-ST interface
      .tx_st_valid(tx_st_valid),
      .tx_st_ready(tx_st_ready),
      .tx_st_data(tx_st_data),
      .tx_st_sop(tx_st_sop),
      .tx_st_eop(tx_st_eop),
      .tx_st_empty(tx_st_empty),
      .tx_err(tx_err),
      // Packet Interface
      .tx_tlp(tx_tlp),
      .tx_tlp_valid(tx_tlp_valid),
      .tx_tlp_ack(tx_tlp_ack)
      ) ;

   // Sub-module to do all of the TLP work
   altpcietb_bfm_vc_intf_tlp_process i_tlp_process (.*) ;


endmodule
