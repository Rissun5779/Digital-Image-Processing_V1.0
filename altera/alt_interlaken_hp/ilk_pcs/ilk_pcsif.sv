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


// Copyright 2012 Altera Corporation. All rights reserved.
// Altera products are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an
// accommodation and therefore all warranties, representations or guarantees of
// any kind (whether express, implied or statutory) including, without
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module ilk_pcsif #(
    parameter           NUM_LANES          = 8,
    parameter           BITS_PER_LANE      = 64,
    parameter           INCLUDE_TEMP_SENSE = 1'b0,
    parameter           MM_CLK_KHZ         = 20'd100_000,           // 75_000 to 125_000
    parameter           MM_CLK_MHZ         = ( MM_CLK_KHZ / 1_000 ), // 75 to 125
    parameter           RECONF_ADDR        = (NUM_LANES == 24) ? 5 :(NUM_LANES == 12) ? 4 : (NUM_LANES == 8) ? 3 : 0,
    parameter           DIAG_ON            = 0,
    parameter           BYPASS_LOOSEFIFO   = 0
)(

    // config and status port
    input                               mm_clk,         // 75-125 MHz
    input                               mm_clk_locked,  // used as reset
    input                               mm_read,
    input                               mm_write,
    input       [15:0]                  mm_addr,
    output      [31:0]                  mm_rdata,
    output                              mm_rdata_valid,
    input       [31:0]                  mm_wdata,

    output wire                         clk_tx_common,
    input                               tx_digitalreset_0,  // reset ctrl
    output                              srst_tx_common,
    input       [NUM_LANES*64-1:0]      tx_din,
    input       [NUM_LANES-1:0]         tx_control,
    input                               tx_valid,
    output wire                         tx_cadence,

    output wire                         clk_rx_common,
    input                               rx_digitalreset_0,  // reset ctrl
    output                              srst_rx_common,
    output                              tx_lanes_aligned,
    output                              tx_pcsfifo_pfull,
    output                              tx_pcsfifo_pempty,
    output                              rx_lanes_aligned,
    output reg  [NUM_LANES*64-1:0]      rx_dout,
    output      [NUM_LANES-1:0]         rx_control,
    output reg  [NUM_LANES-1:0]         rx_valid,        // these should all be the same when operating normally

    input                               tx_pll_locked,   // to csr
    input                               pll_ref_clk,     // to csr
    
    //Native PHY interface
    output     [NUM_LANES-1:0]          local_serial_loopback,  //from csr to phy
    output                              rx_set_locktodata,      //from csr to phy
    output                              rx_set_locktoref,       //from csr to phy
    output                              soft_rst_rx,            //from csr to phy

    input      [NUM_LANES-1:0]          rx_is_lockedtodata,     //phy to csr
 
    input      [NUM_LANES*128-1:0]      rx_dout_np,             //from phy     
    output     [NUM_LANES*128-1:0]      tx_din_np,              //to phy     
 
    output                              tx_common,              //to phy
    output                              rx_common,              //to phy
    input      [NUM_LANES-1:0]          tx_clkout,              //from phy 
    input      [NUM_LANES-1:0]          rx_clkout,              //from phy 
   
    output     [NUM_LANES*18-1:0]       tx_control_np,          //to phy
    input      [NUM_LANES*20-1:0]       rx_control_np,          //from phy    
 
    output                              tx_force_fill,          //to phy
    output                              fake_tx_fifo_write,     //to phy
   
    input      [NUM_LANES-1:0]          tx_full,                //from phy
    input      [NUM_LANES-1:0]          tx_pfull,               //from phy
    input      [NUM_LANES-1:0]          tx_empty,               //from phy
    input      [NUM_LANES-1:0]          tx_pempty,              //from phy
 
    output                              rx_cadence,             //to phy 
    input      [NUM_LANES-1:0]          rx_valid_np,            //from phy
    input      [NUM_LANES-1:0]          rx_full,                //from phy
    input      [NUM_LANES-1:0]          rx_pfull,               //from phy
    input      [NUM_LANES-1:0]          rx_empty,               //from phy
    input      [NUM_LANES-1:0]          rx_pempty,              //from phy
    output                              rx_fifo_clr,            //to phy

    input      [NUM_LANES-1:0]          rx_wordlock,            //from phy
    input      [NUM_LANES-1:0]          rx_metalock,            //from phy
    input      [NUM_LANES-1:0]          rx_crc32err,            //from phy

    input      [NUM_LANES-1:0]          tx_frame,               //from phy
    output                              tx_from_fifo,           //to phy 
  
    output                              rx_prbs_err_clr,        //to phy
    input      [NUM_LANES-1:0]          rx_prbs_err,            //from phy
    input      [NUM_LANES-1:0]          rx_prbs_done,           //from phy

    //Reset Controller interface
    output                              system_reset,           //to reset contr
    output                              soft_rst_txrx           //to reset contr
);

// reset sync with mm_clk
ilk_rst_sync mm_reset_sync (
        .async_rst              ( !mm_clk_locked),
        .clk                    ( mm_clk ),
        .srst                   ( system_reset )
    );

// xcvr_reset_control 
wire    [NUM_LANES-1:0]         tx_pempty_s;

// lane alignment to status registers
wire                            any_tx_frame;
wire                            all_tx_full;
wire                            any_tx_full;
wire                            any_tx_empty;
wire    [2:0]                   txa_sm;

wire                            any_loss_of_meta;
wire                            any_control;     // any framing control word
wire                            all_control;     // all framing control word
wire    [4:0]                   rxa_timer;
wire    [1:0]                   rxa_sm;

// control registers
wire                            ignore_rx_analog;
wire                            ignore_rx_digital;
wire  [NUM_LANES-1:0]           tx_crc32err_inject_s_txc;

ilk_rst_sync srst_tx_common_sync (
        .async_rst              ( tx_digitalreset_0 ),
        .clk                    ( clk_tx_common ),
        .srst                   ( srst_tx_common )
    );

ilk_rst_sync srst_rx_common_sync (
        .async_rst              ( rx_digitalreset_0 & ~ignore_rx_digital ),
        .clk                    ( clk_rx_common ),
        .srst                   ( srst_rx_common )
    );

//////////////////////////////////////////////
// Tx Alignment and Rx Deskew
//////////////////////////////////////////////

assign tx_pcsfifo_pfull  = |tx_pfull;
assign tx_pcsfifo_pempty = |tx_pempty_s;

ilk_tx_aligner #(
        .NUM_LANES              ( NUM_LANES )
    ) ilk_tx_align_inst (

        //outputs
        .txa_sm                 ( txa_sm),
        .tx_from_fifo           ( tx_from_fifo),
        .tx_lanes_aligned       ( tx_lanes_aligned ),
        .tx_force_fill          ( tx_force_fill),
        .all_tx_full            ( all_tx_full),
        .any_tx_empty           ( any_tx_empty),
        .any_tx_frame           ( any_tx_frame),
        .any_tx_full            ( any_tx_full),
        .tx_cadence             ( tx_cadence ),
        .tx_pempty_s            ( tx_pempty_s),

        //inputs
        .tx_frame               ( tx_frame ),
        .tx_empty               ( tx_empty ),
        .tx_full                ( tx_full ),
        .tx_pempty              ( tx_pempty ),

        .clk_tx_common          ( clk_tx_common ),
        .srst_tx_common         ( srst_tx_common )

    ); // ilk_tx_aligner

//due to the difference sv and a10
wire [64*NUM_LANES-1:0]  rx_dout_rxa;       // input to ilk_rx_aligner 
wire [10*NUM_LANES-1:0]  rx_control_rxa;    // input to ilk_rx_aligner 
genvar k;
generate
   for (k=0;k<NUM_LANES;k=k+1) begin : np_bus_convert
     assign rx_dout_rxa[64*(k+1)-1 : 64*k]    = rx_dout_np[64*(2*k+1)-1 :64*2*k];
     assign rx_control_rxa[10*(k+1)-1 : 10*k] = rx_control_np[10*(2*k+1)-1 :10*2*k];
     assign tx_control_np[18*(k+1)-1:18*k]    = {9'b0,tx_crc32err_inject_s_txc[k],6'b0,tx_control[k],~tx_control[k]};
     assign tx_din_np[128*(k+1)-1:128*k]      = {64'b0,tx_din[64*(k+1)-1:64*k]};
   end
endgenerate

ilk_rx_aligner #(
        .NUM_LANES              ( NUM_LANES ),
        .BITS_PER_LANE          ( BITS_PER_LANE )
    ) ilk_rx_aligner_inst (
        //outputs
        .rx_lanes_aligned       ( rx_lanes_aligned),
        .rxa_sm                 ( rxa_sm ),
        .rx_cadence             ( rx_cadence ),
        .rx_valid               ( rx_valid ),
        .rx_control             ( rx_control ),
        .rx_dout                ( rx_dout ),
        .rx_fifo_clr            ( rx_fifo_clr ),
        .any_loss_of_meta       ( any_loss_of_meta ),
        .any_control            ( any_control ),
        .all_control            ( all_control ),
        .rxa_timer              ( rxa_timer ),
      

        //inputs
        .rx_pempty              ( rx_pempty ),
        .rx_pfull               ( rx_pfull),
        .rx_metalock            ( rx_metalock ),
        .rx_valid_np            ( rx_valid_np ),
        .rx_dout_np             ( rx_dout_rxa ),
        .rx_control_np          ( rx_control_rxa ),
        .clk_rx_common          ( clk_rx_common ),
        .srst_rx_common         ( srst_rx_common )
    ); //ilk_rx_aligner 

// we want these to go through an LCELL to become internal
// global clock lines.(/* synthesis keep */ removed)
wire tx_common_ena = 1'b1;
wire rx_common_ena = 1'b1;
assign tx_common     = tx_clkout [NUM_LANES >> 1'b1] & tx_common_ena;
assign rx_common     = rx_clkout [NUM_LANES >> 1'b1] & rx_common_ena;

assign clk_tx_common = tx_common;
assign clk_rx_common = rx_common;

ilk_hard_pcs_csr_a10 #(
        .NUM_LANES               ( NUM_LANES ),
        .INCLUDE_TEMP_SENSE      ( INCLUDE_TEMP_SENSE ),
        .DIAG_ON                 ( DIAG_ON),
        .MM_CLK_KHZ              ( MM_CLK_KHZ )
    ) ilk_hard_pcs_csr_inst (
        .mm_clk                  ( mm_clk ),
        .mm_clk_locked           ( !system_reset),
        .mm_read                 ( mm_read ),
        .mm_write                ( mm_write ),
        .mm_addr                 ( mm_addr ),
        .mm_rdata                ( mm_rdata ),
        .mm_rdata_valid          ( mm_rdata_valid ),
        .mm_wdata                ( mm_wdata ),

        // clocks to monitor
        .pll_ref_clk             ( pll_ref_clk ),
        .clk_rx_common           ( clk_rx_common ),
        .srst_rx_common          ( srst_rx_common ),
        .clk_tx_common           ( clk_tx_common ),

        // status inputs
        .tx_pll_locked           ( tx_pll_locked ),
        .tx_align_empty          ( tx_empty ),
        .tx_align_pempty         ( tx_pempty ),
        .tx_align_full           ( tx_full ),
        .tx_align_pfull          ( tx_pfull ),
        .any_tx_frame            ( any_tx_frame ),
        .all_tx_full             ( all_tx_full ),
        .any_tx_full             ( any_tx_full ),
        .any_tx_empty            ( any_tx_empty ),
        .txa_sm                  ( txa_sm ),
        .tx_lanes_aligned        ( tx_lanes_aligned ),

        .rx_deskew_empty         ( rx_empty ),
        .rx_deskew_pempty        ( rx_pempty ),
        .rx_deskew_full          ( rx_full ),
        .rx_deskew_pfull         ( rx_pfull ),
        .rx_is_lockedtodata      ( rx_is_lockedtodata ),
        .any_loss_of_meta        ( any_loss_of_meta ),
        .any_control             ( any_control ),
        .all_control             ( all_control ),
        .rxa_timer               ( rxa_timer ),
        .rxa_sm                  ( rxa_sm ),
        .rx_lanes_aligned        ( rx_lanes_aligned ),
        .rx_wordlock             ( rx_wordlock ),
        .rx_metalock             ( rx_metalock ),
        .rx_crc32err             ( rx_crc32err ),
        .rx_sh_err               ( {NUM_LANES{1'b0}} ),   // for A10
        .rx_prbs_err             ( rx_prbs_err ),
        .rx_prbs_done            ( rx_prbs_done ), 

        // control outputs
        .local_serial_loopback   ( local_serial_loopback ),
        .rx_set_locktodata       ( rx_set_locktodata ),
        .rx_set_locktoref        ( rx_set_locktoref ),
        .ignore_rx_analog        ( ignore_rx_analog ),
        .ignore_rx_digital       ( ignore_rx_digital ),
        .soft_rst_txrx           ( soft_rst_txrx ),
        .soft_rst_rx             ( soft_rst_rx ),
        .rx_prbs_err_clr         ( rx_prbs_err_clr ),
        .tx_crc32err_inject_s_txc( tx_crc32err_inject_s_txc )


    ); // ilk_hard_pcs_csr 

// NOTE: this is not a rigorous mathematical definition of LOG2(v).
// This function computes the number of bits required to represent "v".
// So log2(256) will be  9 rather than 8 (256 = 9'b1_0000_0000).

function integer log2;
   input integer val;
begin
   if (val == 0) begin
      log2 = 1;
   end
   else begin
      log2 = 0;
      while (val > 0) begin
         val  = val >> 1;
         log2 = log2 + 1;
      end
   end
end
endfunction

//generate fake write to tx fifo for low latency design
generate 
   if(BYPASS_LOOSEFIFO == 1) begin
      tx_fifo_write tx_fifo_write_inst (
          //output
          .tx_fifo_write(fake_tx_fifo_write),

          //input
          .tx_cadence (tx_cadence),
          .tx_lanes_aligned(tx_lanes_aligned),
          .tx_valid(tx_valid),
          .clk_tx_common(clk_tx_common),
          .srst_tx_common(srst_tx_common)
      );
   end
   else begin
      assign fake_tx_fifo_write = 1'b0; 
   end 
endgenerate

endmodule

