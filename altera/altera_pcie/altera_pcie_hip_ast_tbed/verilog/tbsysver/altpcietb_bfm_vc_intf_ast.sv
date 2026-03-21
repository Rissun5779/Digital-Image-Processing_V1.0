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
// Title         : PCI Express BFM with Avalon-ST Root Port
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcietb_bfm_vc_intf_ast.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description :
// This entity is the entire PCI Ecpress Root Port BFM
//-----------------------------------------------------------------------------

module altpcietb_bfm_vc_intf_ast (clk_in, rstn,
                                  rx_mask,  rx_st_be,  rx_st_sop, rx_st_eop, rx_st_empty, rx_st_data, rx_st_valid, rx_st_ready,
                                  tx_cred, tx_st_ready, tx_st_sop, tx_st_eop, tx_st_empty, tx_st_valid, tx_st_data, tx_fifo_empty,
                                  cfg_io_bas, cfg_np_bas, cfg_pr_bas);


   parameter VC_NUM = 0;
   parameter AVALON_ST_256 = 0;
   parameter AVALON_ST_128 = 0;
   parameter ECRC_FORWARD_CHECK = 1;
   parameter ECRC_FORWARD_GENER = 1;
   // Define a parameter so we have an alternate way of overriding this if desired
   parameter USE_ENHANCED_VC_INTF = 1 ;
   parameter PACKED_MODE = 0 ;  // AST data PACKED means not QW aligned. PACKED only supported by vc_param

   // Should really make these localparams params and do the width all the way through
   localparam AST_WIDTH = (AVALON_ST_256 == 1) ? 256 : (AVALON_ST_128 == 1) ? 128 : 64 ;
   localparam AST_SOP_WIDTH = (AVALON_ST_256 == 1) ? 2 : 1 ;
   localparam AST_MTY_WIDTH = (AVALON_ST_256 == 1) ? 2 : 1 ;  // In 64b not used, but has to be 1


   input            clk_in;
   input            rstn;
   output           rx_mask;
   input[35:0]      tx_cred;
   input[19:0]      cfg_io_bas;
   input[11:0]      cfg_np_bas;
   input[43:0]      cfg_pr_bas;
   input [1:0]      rx_st_sop;
   input            rx_st_valid;
   output           rx_st_ready;
   input [1:0]      rx_st_eop;
   input [1:0]      rx_st_empty;
   input [255:0]    rx_st_data;
   input [15:0]      rx_st_be;
   input            tx_st_ready;
   output [1:0]     tx_st_sop;
   output [1:0]     tx_st_eop;
   output [1:0]     tx_st_empty;
   output           tx_st_valid;
   output [255:0]   tx_st_data;
   input            tx_fifo_empty;

   wire    [ 81: 0] rx_stream_data_0;
   wire    [ 81: 0] rx_stream_data_1;

   // RX
   wire [1:0]       rx_st_sop_int;
   wire [1:0]       rx_st_eop_int;
   wire [1:0]       rx_st_empty_int;
   wire [255:0]     rx_st_data_int;
   wire [15:0]      rx_st_be_int;
   wire             rx_st_ready_int;
   wire             rx_valid_int;
   wire [7:0]       rx_st_bardec;  assign rx_st_bardec = 8'h0;
   wire             empty;
   wire             almost_full;
   wire [19:0]      unused_st;

   wire             tx_st_ready_int;
   wire [255:0]     tx_st_data_int;
   wire [1:0]       tx_st_sop_int;
   wire [1:0]       tx_st_eop_int;
   wire [1:0]       tx_st_empty_int;
   wire             tx_st_valid_int;

   wire    [ 81: 0] rx_stream_data_0_int;
   wire    [ 81: 0] rx_stream_data_1_int;
   wire    [ 129:0] rx_stream_data_2_int;
   wire             rx_st_valid_int;
   wire             rx_st_ready_ecrc;


   wire             rx_ecrc_check_valid;
   wire [15:0]      ecrc_bad_cnt;
   reg              ecrc_err;

   altpcietb_bfm_vc_intf_param_pkg::altpcietb_tlp_struct rx_tlp_snoop ;
   bit    rx_tlp_valid_snoop ;
   bit    rx_tlp_ack_snoop ;

   always @ (posedge clk_in or negedge rstn) begin
       if (rstn==1'b0)
           ecrc_err <= 1'b0;
       else begin
           if (ecrc_bad_cnt > 0)
               ecrc_err <= 1'b1;    // assert and hold when ecrc error is detected
       end

   end



  //////////////////////////////////////////////////////////////
  // RECEIVE RX AVALON-ST INPUT
  // If ECRC Forwarding is enabled, then first route thru the
  // ECRC checker to remove ECRC from data stream.
  //////////////////////////////////////////////////////////////

   generate begin: rx_ecrc_genblk

       wire    [ 81: 0] rx_stream_data_0_ecrc;
       wire    [ 81: 0] rx_stream_data_1_ecrc;
       wire             rx_st_valid_ecrc;
       wire[15:0]       rx_st_be_ecrc;
       wire[7:0]        rx_st_bardec_ecrc;
       wire             rx_st_sop_ecrc;
       wire             rx_st_eop_ecrc;
       wire             rx_st_empty_ecrc;
       wire [139:0]     rx_st_data_ecrc;

       ///////////////////////////////////////////////
       // RX ECRC CHECKING
       // ECRC is checked and removed from the data
       ///////////////////////////////////////////////
       if (ECRC_FORWARD_CHECK==1) begin: rx_ecrc

           altpcierd_cdma_ecrc_check #(.AVALON_ST_128(AVALON_ST_128)) cdma_ecrc_check(
                // Input Avalon-ST prior to check ECRC
                .rxdata                ({rx_st_sop, 1'b0, rx_st_empty, rx_st_eop, rx_st_bardec, rx_st_data}),
                .rxdata_be             (rx_st_be),
                .rx_stream_ready0      (~almost_full),
                .rx_stream_valid0      (rx_st_valid),

                // Output Avalon-ST after checking ECRC
                .rxdata_ecrc           (rx_st_data_ecrc),
                .rxdata_be_ecrc        (rx_st_be_ecrc),
                .rx_stream_ready0_ecrc (rx_st_ready_ecrc),
                .rx_stream_valid0_ecrc (rx_st_valid_ecrc),

                .rx_ecrc_check_valid   (rx_ecrc_check_valid),
                .ecrc_bad_cnt          (ecrc_bad_cnt),
                .clk_in                (clk_in),
                .srst                  (~rstn)
               );

 /*
          // Simulation Monitor
           initial begin
               wait (rstn==1);
               wait (ecrc_bad_cnt==0);
               wait (ecrc_bad_cnt>0);
               $display (" >>>>  RP:  BAD ECRC RECEIVED <<<<");
           end
*/
           ///////////////////////////////////////////////
           // ECRC sources data to VCINTF (via RX FIFO)

           assign rx_st_bardec_ecrc = rx_st_data_ecrc[135:128];
           assign rx_st_sop_ecrc    = rx_st_data_ecrc[139];
           assign rx_st_eop_ecrc    = rx_st_data_ecrc[136];
           assign rx_st_empty_ecrc  = rx_st_data_ecrc[137];

           assign rx_stream_data_0_int =  {rx_st_be_ecrc[7:0], rx_st_sop_ecrc, rx_st_eop_ecrc, rx_st_bardec_ecrc, rx_st_data_ecrc[63:0]};
           assign rx_stream_data_1_int =  {rx_st_be_ecrc[15:8], 1'b0, rx_st_empty_ecrc, 8'h0, rx_st_data_ecrc[127:64]};
           assign rx_st_valid_int      =  rx_st_valid_ecrc;

       end

       ///////////////////////////
       //  NO ECRC FORWARDING
       ///////////////////////////
       else begin
           /////////////////////////////////////////////////////////////
           // Avalon-ST IO sources data to VCINTF (via RX FIFO)

           assign rx_stream_data_0_int =  {rx_st_be[7:0], rx_st_sop[0], rx_st_eop[0], rx_st_bardec, rx_st_data[63:0]};
           assign rx_stream_data_1_int =  {rx_st_be[15:8], rx_st_empty, 8'h0, rx_st_data[127:64]};
           assign rx_stream_data_2_int =  {rx_st_data[255:128], rx_st_sop[1], rx_st_eop[1]};
           assign rx_st_valid_int      =  rx_st_valid;
           assign rx_ecrc_check_valid  = 0;
           assign ecrc_bad_cnt         = 0;
           // rx_st_ready assigned in separate block
       end // else: !if(ECRC_FORWARD_CHECK==1)

   end // block: rx_ecrc_genblk

   endgenerate

   generate
      begin : rx_st_ready_genblk
         if (ECRC_FORWARD_CHECK==1)
           assign rx_st_ready          =  rx_st_ready_ecrc;
         else
           if (USE_ENHANCED_VC_INTF == 0)
             assign rx_st_ready          =  ~almost_full;
           else
             assign rx_st_ready          = rx_st_ready_int ;
      end
   endgenerate

   generate
      begin : st_rx_fifo_generate
         if (USE_ENHANCED_VC_INTF == 0)
           begin : rx_fifo_gen
              //////////////////////////////////////////////////////////////////////
              // RX FIFO
              // Avalon-ST data is held in a FIFO until RP (VC INTF) can process it
              // Only need this  FIFO if not using enhanced parameterized block
              //////////////////////////////////////////////////////////////////////


              // FIFO parameters
              parameter  RXFIFO_DEPTH = 32;
              parameter  RXFIFO_WIDTH = 294;
              parameter  RXFIFO_WIDTHU = 5;

              scfifo # (
                        .add_ram_output_register ("OFF")          ,
                        .intended_device_family  ("Stratix II GX"),
                        .lpm_numwords            (RXFIFO_DEPTH),
                        .lpm_showahead           ("ON")          ,
                        .lpm_type                ("scfifo")       ,
                        .lpm_width               (RXFIFO_WIDTH) ,
                        .lpm_widthu              (RXFIFO_WIDTHU),
                        .overflow_checking       ("OFF")           ,
                        .underflow_checking      ("OFF")           ,
                        .almost_full_value       (RXFIFO_DEPTH/2) ,
                        .use_eab                 ("OFF")

                        ) rx_data_fifo
                (
                 .clock ( clk_in),
                 .sclr  (~rstn ),

                 .data  ({rx_stream_data_2_int, rx_stream_data_1_int, rx_stream_data_0_int}),
                 .wrreq (rx_st_valid_int),

                 .rdreq (rx_st_ready_int & ~empty),
                 .q     ({  rx_st_data_int[255:128], rx_st_sop_int[1], rx_st_eop_int[1],
                            rx_st_be_int[15:8], rx_st_empty_int, unused_st[15:8], rx_st_data_int[127:64],
                            rx_st_be_int[7:0], rx_st_sop_int[0], rx_st_eop_int[0], unused_st[7:0], rx_st_data_int[63:0]
                            }),

                 .empty (empty),
                 .full  ( ),
                 .usedw ()
                 // synopsys translate_off
                 ,
                 .aclr (1'b0),
                 .almost_empty (),
                 .almost_full (almost_full)
                 // synopsys translate_on
                 );
           end // block: rx_fifo_gen
      end // block: st_rx_fifo_generate
   endgenerate

   // Instantiate the new monitor all the time
   altpcietb_bfm_vc_intf_mon
     #(
       .AST_WIDTH(AST_WIDTH),
       .AST_SOP_WIDTH(AST_SOP_WIDTH),
       .AST_MTY_WIDTH(AST_MTY_WIDTH),
       .PACKED_MODE(PACKED_MODE),
       .DOWNSTREAM_FACING(1),
       .INTERFACE_LABEL("Root Port")
       ) vc_intf_mon
       (
        .clk_in        (clk_in),
        .rstn          (rstn),
        // Tap Rx AST signals directly
        .rx_st_valid   (rx_st_valid),
        .rx_st_data    (rx_st_data[(AST_WIDTH-1):0]),
        .rx_st_sop     (rx_st_sop[(AST_SOP_WIDTH-1):0]),
        .rx_st_eop     (rx_st_eop[(AST_SOP_WIDTH-1):0]),
        .rx_st_empty   (rx_st_empty[(AST_MTY_WIDTH-1):0]),
        // Tap Tx AST signals directly
        .tx_st_data    (tx_st_data[(AST_WIDTH-1):0]),
        .tx_st_valid   (tx_st_valid),
        .tx_st_sop     (tx_st_sop[(AST_SOP_WIDTH-1):0]),
        .tx_st_eop     (tx_st_eop[(AST_SOP_WIDTH-1):0]),
        .tx_st_empty   (tx_st_empty[(AST_MTY_WIDTH-1):0]),
        // Use the Rx Snoop Signals for the Enhanced VC Interface Functionality
        .rx_tlp_snoop  (rx_tlp_snoop),
        .rx_tlp_valid_snoop (rx_tlp_valid_snoop),
        .rx_tlp_ack_snoop   (rx_tlp_ack_snoop),
        // Tx Snoop Signals not used
        .tx_tlp_snoop  (),
        .tx_tlp_valid_snoop (),
        .tx_tlp_ack_snoop   ()
        );



   ////////////////////////////////////////////////////////////////////////
   // VC INTERFACE MODULE
   // Receives, Generates, and Processes RP traffic.
   //
   // Instantiate 128-bit Avalon-ST version, or 64-bit Avalon-ST version.
   /////////////////////////////////////////////////////////////////////////


     assign rx_valid_int = rx_st_ready_int & ~empty;

     generate begin: vc_intf_genblk

        if (USE_ENHANCED_VC_INTF > 0) begin : vc_intf_param_genblk
           // The enhanced vc_intf_param block does not need the FIFO
           // This mode does not support the ECRC Forwarding (but that is not used anyway
           // So this block can connect right to the HIP interface signals
           altpcietb_bfm_vc_intf_param
             #(.VC_NUM (VC_NUM),
               .AST_WIDTH(AST_WIDTH),
               .AST_SOP_WIDTH(AST_SOP_WIDTH),
               .AST_MTY_WIDTH(AST_MTY_WIDTH),
               .PACKED_MODE(PACKED_MODE)
               ) vc_intf_param
               (
                .clk_in        (clk_in),
                .rstn          (rstn),
                // Tap Rx TLPs from monitor
                .rx_tlp_snoop  (rx_tlp_snoop),
                .rx_tlp_valid_snoop (rx_tlp_valid_snoop),
                .rx_tlp_ack_snoop (rx_tlp_ack_snoop),
                // To control flow of incoming TLPs
                .rx_st_ready   (rx_st_ready_int),  // Have to drive internal signal, selected elsewhere
                // Drive Tx AST signals directly
                .tx_st_valid   (tx_st_valid),
                .tx_st_ready   (tx_st_ready),
                .tx_st_data    (tx_st_data[(AST_WIDTH-1):0]),
                .tx_st_sop     (tx_st_sop[(AST_SOP_WIDTH-1):0]),
                .tx_st_eop     (tx_st_eop[(AST_SOP_WIDTH-1):0]),
                .tx_st_empty   (tx_st_empty[(AST_MTY_WIDTH-1):0]),
                .rx_mask       (rx_mask),
                .tx_cred       (tx_cred)
                );
        end // block: vc_intf_param_genblk
        else if (AVALON_ST_256==1) begin: vc_intf_256_genblk
           altpcietb_bfm_vc_intf_256 #(.VC_NUM (VC_NUM)) vc_intf_256(
           .clk_in        (clk_in),
           .rstn          (rstn),
           .rx_mask       (rx_mask),
           .rx_be         (rx_st_be_int),
           .tx_cred       (tx_cred),
           .tx_st_ready   (tx_st_ready_int),
           .rx_st_sop     (rx_st_sop_int),
           .rx_st_eop     (rx_st_eop_int),
           .rx_st_empty   (rx_st_empty_int),
           .rx_st_data    (rx_st_data_int),
           .rx_st_valid   (rx_valid_int),
           .rx_st_ready   (rx_st_ready_int),
           .tx_st_sop     (tx_st_sop_int),
           .tx_st_eop     (tx_st_eop_int),
           .tx_st_empty   (tx_st_empty_int),
           .tx_st_data    (tx_st_data_int),
           .tx_st_valid   (tx_st_valid_int),
           .tx_fifo_empty (tx_fifo_empty)
        );
     end
     else if (AVALON_ST_128==1) begin: vc_intf_128_genblk

         altpcietb_bfm_vc_intf_128 #(.VC_NUM (VC_NUM)) vc_intf_128(
           .clk_in        (clk_in),
           .rstn          (rstn),
           .rx_mask       (rx_mask),
           .rx_be         (rx_st_be_int),
           .rx_ecrc_err   (ecrc_err),
           .tx_cred       (tx_cred),
           .tx_st_ready   (tx_st_ready_int),
           .cfg_io_bas    (cfg_io_bas),
           .cfg_np_bas    (cfg_np_bas),
           .cfg_pr_bas    (cfg_pr_bas),
           .rx_st_sop     (rx_st_sop_int),
           .rx_st_eop     (rx_st_eop_int),
           .rx_st_empty   (rx_st_empty_int),
           .rx_st_data    (rx_st_data_int[127:0]),
           .rx_st_valid   (rx_valid_int),
           .rx_st_ready   (rx_st_ready_int),
           .tx_st_sop     (tx_st_sop_int),
           .tx_st_eop     (tx_st_eop_int),
           .tx_st_empty   (tx_st_empty_int),
           .tx_st_data    (tx_st_data_int),
           .tx_st_valid   (tx_st_valid_int),
           .tx_fifo_empty (tx_fifo_empty)
        );

     end
     else begin: vc_intf_64_genblk

        altpcietb_bfm_vc_intf_64 #(.VC_NUM (VC_NUM)) vc_intf_64(
           .clk_in        (clk_in),
           .rstn          (rstn),
           .rx_mask       (rx_mask),
           .rx_be         (rx_st_be_int),
           .rx_ecrc_err   (ecrc_err),
           .tx_cred       (tx_cred),
           .cfg_io_bas    (cfg_io_bas),
           .cfg_np_bas    (cfg_np_bas),
           .cfg_pr_bas    (cfg_pr_bas),
           .rx_st_sop     (rx_st_sop_int),
           .rx_st_eop     (rx_st_eop_int),
           .rx_st_empty   (rx_st_empty_int),
           .rx_st_data    (rx_st_data_int[63:0]),
           .rx_st_valid   (rx_valid_int),
           .rx_st_ready   (rx_st_ready_int),
           .tx_st_sop     (tx_st_sop_int),
           .tx_st_eop     (tx_st_eop_int),
           .tx_st_empty   (tx_st_empty_int),
           .tx_st_data    (tx_st_data_int[63:0]),
           .tx_st_valid   (tx_st_valid_int),
           .tx_st_ready   ((tx_st_ready_int)),
           .tx_fifo_empty (tx_fifo_empty)
        );

     end
    end
  endgenerate



  ////////////////////////////////////////////////////////////////
  // DRIVE AVALON-ST TX OUTPUT
  // If ECRC FORWARDING is enabled, then calculate and append
  // the ECRC to the Avalon-ST output.
  ///////////////////////////////////////////////////////////////

   generate begin: tx_ecrc_genblk
      ////////////////////////////////////////////////////////////
      // ECRC FORWARDING
      // ECRC is calculated and appended to the VC INTF traffic
      // if ECRC forwarding is enabled.

      if (ECRC_FORWARD_GENER==1) begin: tx_ecrc
          // ECRC output side
          wire[127:0] tx_st_data_ecrc;
          wire        tx_st_sop_ecrc;
          wire        tx_st_eop_ecrc;
          wire        tx_st_empty_ecrc;
          wire[73:0]  tx_st_data_ecrc0;
          wire[73:0]  tx_st_data_ecrc1;
          wire        tx_st_ready_ecrc;
          wire        tx_st_valid_ecrc;

          // ECRC input side
          reg[127:0]  user_data_reg;
          reg         user_valid_reg;
          reg         user_sop_reg;
          reg         user_eop_reg;
          reg         user_empty_reg;

          wire[127:0] user_data_ecrc;
          wire        user_valid_ecrc;
          wire        user_sop_ecrc;
          wire        user_eop_ecrc;
          wire        user_empty_ecrc;
          reg         tx_st_ready_ecrc_reg;

          ///////////////////////////////////////////////////////////////
          // Glue logic to hold the vc_intf signals until it is 'acked'
          // by the ecrc module  (via tx_st_ready_ecrc).
          /*
                   ECRC Interface:
                                        ________     ________________
                       tx_st_ready_ecrc (ack)   |___|
                                             ________________________
                       user_valid_ecrc  ____|
                                        ______________________________
                       user_data_ecrc   ____|_0_|_1_____|_2_|_3_|_4_|_
          */

          always @ (posedge clk_in or negedge rstn) begin
              if (rstn==1'b0) begin
                      user_data_reg  <= 0;
                      user_valid_reg <= 0;
                      user_sop_reg  <= 0;
                      user_eop_reg  <= 0;
                      user_empty_reg  <= 0;
                      tx_st_ready_ecrc_reg <= 0;
              end
              else begin
                  if ((tx_st_ready_ecrc==1'b0) & (tx_st_ready_ecrc_reg==1'b1)) begin
                      user_data_reg  <= {tx_st_data_int[31:0],tx_st_data_int[63:32], tx_st_data_int[95:64],tx_st_data_int[127:96]};
                      user_valid_reg <= tx_st_valid_int;
                      user_sop_reg   <= tx_st_sop_int;
                      user_eop_reg   <= tx_st_eop_int;
                      user_empty_reg <= tx_st_empty_int;
                  end
                  tx_st_ready_ecrc_reg <= tx_st_ready_ecrc;
              end
          end

          assign user_data_ecrc  = ((tx_st_ready_ecrc_reg==0) & (tx_st_ready_ecrc==1'b1)) ? user_data_reg :
                                   {tx_st_data_int[31:0],tx_st_data_int[63:32], tx_st_data_int[95:64],tx_st_data_int[127:96]} ;

          assign user_valid_ecrc = ((tx_st_ready_ecrc_reg==0) & (tx_st_ready_ecrc==1'b1)) ?  user_valid_reg :  tx_st_valid_int;

          assign user_sop_ecrc   = ((tx_st_ready_ecrc_reg==0) & (tx_st_ready_ecrc==1'b1)) ?  user_sop_reg :  tx_st_sop_int;

          assign user_eop_ecrc   = ((tx_st_ready_ecrc_reg==0) & (tx_st_ready_ecrc==1'b1)) ? user_eop_reg  : tx_st_eop_int;
          assign user_empty_ecrc = ((tx_st_ready_ecrc_reg==0) & (tx_st_ready_ecrc==1'b1)) ? user_empty_reg  : tx_st_empty_int;


          /////////////////////////////
          // TX ECRC MODULE
          // ecrc generate and append

          altpcierd_cdma_ecrc_gen  #(.AVALON_ST_128(AVALON_ST_128))
             cdma_ecrc_gen (
               .clk               (clk_in),
               .rstn              (rstn),
               .user_rd_req       (tx_st_ready_ecrc),
               .user_sop          (user_sop_ecrc),
               .user_eop          ({user_eop_ecrc, user_empty_ecrc}),
               .user_data         (user_data_ecrc),
               .user_valid        (user_valid_ecrc),
               .tx_stream_ready0  (tx_st_ready),
               .tx_stream_data0_0 (tx_st_data_ecrc0),
               .tx_stream_data0_1 (tx_st_data_ecrc1),
               .tx_stream_valid0  (tx_st_valid_ecrc));

           ///////////////////////////
           // Drive Avalon-ST output

           assign tx_st_data[63:0]   = {tx_st_data_ecrc0[31:0], tx_st_data_ecrc0[63:32]};
           assign tx_st_empty        = tx_st_data_ecrc0[73];
           assign tx_st_sop          = tx_st_data_ecrc0[72];
          // assign tx_st_data[132]  = 1'b0;
           assign tx_st_eop          = tx_st_data_ecrc1[73];
          // assign tx_st_data[129]  = tx_st_data_ecrc1[72];
           assign tx_st_data[127:64] = {tx_st_data_ecrc1[31:0], tx_st_data_ecrc1[63:32]};
           assign tx_st_ready_int    = tx_st_ready_ecrc;
           assign tx_st_valid        = tx_st_valid_ecrc;
      end

      ////////////////////////////////////////////////////
      // NO ECRC FORWARDING and not using the ENHANCED_VC_INTF
      // Wire directly from vc_intf

      else if (USE_ENHANCED_VC_INTF == 0)
        begin
           assign tx_st_data      =  tx_st_data_int;
           assign tx_st_eop       =  tx_st_eop_int;
           assign tx_st_sop       =  tx_st_sop_int;
           assign tx_st_empty     =  tx_st_empty_int;
           assign tx_st_ready_int =  tx_st_ready;
           assign tx_st_valid     =  tx_st_valid_int;
           // Instantiation of ENHANCED_VC_INTF connects directly to the the tx_st signals
        end
   end
   endgenerate

   initial
     begin
        if ( (USE_ENHANCED_VC_INTF > 0) && ( (ECRC_FORWARD_CHECK == 1) || (ECRC_FORWARD_GENER == 1) ) )
          begin
             // vc_intf_param probably would work with the ECRC forwarding if we hooked up the signals
             // right. But this module is never instantiated today (3/28/2014) with these parameters set
             // to 1, so no way to test it. ECRC forwarding is not going to be supported in the future
             // so let's just call out an error if someone tries to do it, then we would have a test
             // case to verify it being hooked up correctly and we could hook it up then.
             $display("FATAL ERROR: Enhanced VC Interface does not support use of ECRC Forwarding.") ;
`ifdef VCS
             $finish;
`else
             $stop ;
`endif
          end // if ( (ECRC_FORWARD_CHECK == 1) || (ECRC_FORWARD_GENER == 1) )
     end // initial begin


endmodule
