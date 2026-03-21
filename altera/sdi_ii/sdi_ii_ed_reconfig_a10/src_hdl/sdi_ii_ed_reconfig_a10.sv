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


//**********************************************************************************
// Top-level SDI PHY Reconfiguration Modules 
//**********************************************************************************
`timescale 1 ns / 1 ps

module sdi_ii_ed_reconfig_a10 #(

    parameter XCVR_RCFG_IF_TYPE      = "channel",  //Reconfig interface type: "channel", "atx_pll", "cmu_fpll"
    parameter VIDEO_STANDARD         = "tr",
    parameter ED_TXPLL_SWITCH        = 0

) (
    input   wire        rx_analogreset_ack,
    input   wire        rx_cal_busy,
    input   wire [2:0]  cdr_reconfig_sel,
    input   wire        cdr_reconfig_req,
    output  wire        cdr_reconfig_busy,

    // tx_cal_busy is 2-bit wide when video standard = dl
    input   wire [(VIDEO_STANDARD == "dl"):0] tx_cal_busy,

    input   wire        tx_analogreset_ack,
    input   wire        pll_powerdown,
    input   wire        pll_sel,
    output  wire        pll_sw_busy,
    output  wire        rst_tx_phy,
    
    //------------------------------------------------
    // HSSI Reconfig Interface
    //------------------------------------------------
    input   wire         xcvr_reconfig_clk,
    input   wire         xcvr_reconfig_reset,
    output  wire         rx_xcvr_reconfig_write,
    output  wire         rx_xcvr_reconfig_read,
    output  wire  [9:0 ] rx_xcvr_reconfig_address, 
    output  wire  [31:0] rx_xcvr_reconfig_writedata,
    input   wire  [31:0] rx_xcvr_reconfig_readdata,
    input   wire         rx_xcvr_reconfig_waitrequest,
    output  wire         tx_xcvr_reconfig_write,
    output  wire         tx_xcvr_reconfig_read,
    output  wire  [9:0 ] tx_xcvr_reconfig_address, 
    output  wire  [31:0] tx_xcvr_reconfig_writedata,
    input   wire  [31:0] tx_xcvr_reconfig_readdata,
    input   wire         tx_xcvr_reconfig_waitrequest
);

 
  //*************************Local Params********************************

  localparam XCVR_RCFG_ADDR_WIDTH = 10;
  localparam XCVR_RCFG_DATA_WIDTH = 32;
  

  wire                             reconfig_write_from_cdr_reconfig;
  wire                             reconfig_read_from_cdr_reconfig;
  wire [XCVR_RCFG_ADDR_WIDTH-1:0 ] reconfig_address_from_cdr_reconfig; 
  wire [XCVR_RCFG_DATA_WIDTH-1:0]  reconfig_writedata_from_cdr_reconfig;
  wire [XCVR_RCFG_DATA_WIDTH-1:0]  reconfig_readdata_to_cdr_reconfig;
  wire                             reconfig_waitrequest_to_cdr_reconfig;

  wire                             reconfig_write_from_pll_sw;
  wire                             reconfig_read_from_pll_sw;
  wire [XCVR_RCFG_ADDR_WIDTH-1:0 ] reconfig_address_from_pll_sw; 
  wire [XCVR_RCFG_DATA_WIDTH-1:0]  reconfig_writedata_from_pll_sw;
  wire [XCVR_RCFG_DATA_WIDTH-1:0]  reconfig_readdata_to_pll_sw;
  wire                             reconfig_waitrequest_to_pll_sw;

  wire                             xcvr_reconfig_write;
  wire                             xcvr_reconfig_read;
  wire  [XCVR_RCFG_ADDR_WIDTH-1:0] xcvr_reconfig_address; 
  wire  [XCVR_RCFG_DATA_WIDTH-1:0] xcvr_reconfig_writedata;

  //*****************************************************************************
  // CDR reconfiguration logic
  //*****************************************************************************
    generate if (VIDEO_STANDARD == "mr" | VIDEO_STANDARD == "tr")
       begin : cdr_reconfiguration
          wire [2:0]   cdr_reconfig_sel_sync;
          wire         cdr_reconfig_req_sync;
          wire         rx_analogreset_ack_sync;
          wire         rx_cal_busy_sync;
          wire         reconfig_req_posedge;
          wire         rx_cal_busy_negedge;

          altera_std_synchronizer_bundle #(
            .width(3),
            .depth(3)
          ) u_cdr_reconfig_sel_sync (
             .clk(xcvr_reconfig_clk),
             .reset_n(1'b1),
             .din(cdr_reconfig_sel),
             .dout(cdr_reconfig_sel_sync)
          );

          // Wait until analogreset_ack asserted then only trigger internal req signal
          // to the state machine. This is to ensure that xcvr is in reset mode when 
          // doing reconfiguration after the added analogreset sequencer in 15.1.
          altera_std_synchronizer #(
            .depth(3)
          ) u_rx_analogreset_ack_sync (
             .clk(xcvr_reconfig_clk),
             .reset_n(1'b1),
             .din(rx_analogreset_ack),
             .dout(rx_analogreset_ack_sync)
          );

          altera_std_synchronizer #(
            .depth(3)
          ) u_cdr_reconfig_req_sync (
             .clk(xcvr_reconfig_clk),
             .reset_n(1'b1),
             .din(cdr_reconfig_req),
             .dout(cdr_reconfig_req_sync)
          );

          altera_std_synchronizer #(
            .depth(3)
          ) u_rx_cal_busy_sync (
             .clk(xcvr_reconfig_clk),
             .reset_n(1'b1),
             .din(rx_cal_busy),
             .dout(rx_cal_busy_sync)
          );

          edge_detector #(
             .EDGE_DETECT ("POSEDGE")
          ) u_reconfig_req_posedge_det (
             .clk (xcvr_reconfig_clk),
             .rst (xcvr_reconfig_reset),
             .d (cdr_reconfig_req_sync & rx_analogreset_ack_sync),
             .q (reconfig_req_posedge)
          );

          edge_detector #(
             .EDGE_DETECT ("NEGEDGE")
          ) u_rx_cal_busy_negedge_det (
             .clk (xcvr_reconfig_clk),
             .rst (xcvr_reconfig_reset),
             .d (rx_cal_busy_sync),
             .q (rx_cal_busy_negedge)
          );

          rcfg_sdi_cdr #(
             .xcvr_rcfg_if_type     (XCVR_RCFG_IF_TYPE     ),
             .xcvr_rcfg_addr_width  (XCVR_RCFG_ADDR_WIDTH  ), 
             .xcvr_rcfg_data_width  (XCVR_RCFG_DATA_WIDTH  )
          ) u_rcfg_sdi_cdr (
             .clk                   (xcvr_reconfig_clk                 ),
             .reset                 (xcvr_reconfig_reset               ),
             .cdr_reconfig_req      (reconfig_req_posedge              ),
             .cdr_reconfig_sel      (cdr_reconfig_sel_sync             ),
             .cdr_reconfig_busy     (cdr_reconfig_busy                    ),
             .rx_cal_busy_negedge   (rx_cal_busy_negedge                  ),
             .reconfig_write        (reconfig_write_from_cdr_reconfig     ),
             .reconfig_address      (reconfig_address_from_cdr_reconfig   ),
             .reconfig_read         (reconfig_read_from_cdr_reconfig      ),
             .reconfig_writedata    (reconfig_writedata_from_cdr_reconfig ),
             .reconfig_readdata     (reconfig_readdata_to_cdr_reconfig    ),
             .reconfig_waitrequest  (reconfig_waitrequest_to_cdr_reconfig )
          );
       end else begin
          assign cdr_reconfig_busy = 1'b0;
          assign reconfig_write_from_cdr_reconfig = 1'b0;
          assign reconfig_read_from_cdr_reconfig = 1'b0;
          assign reconfig_address_from_cdr_reconfig = 10'd0;
          assign reconfig_writedata_from_cdr_reconfig = 32'd0;
       end
    endgenerate

  //*****************************************************************************
  // Tx Dynamic Switching request and Transceiver Reset sequence
  //*****************************************************************************
    wire pll_sw_req;
    wire pll_sel_sync;
    generate if (ED_TXPLL_SWITCH != 0)
        begin : tx_clk_sw_req_rst
            reg     trig_tx_rst_ctrl;
            reg     pll_sel_prev;
            wire    pll_sw_busy_negedge;
            wire    xcvr_in_rst_sync;
            wire    xcvr_in_rst = (ED_TXPLL_SWITCH == 1) ? tx_analogreset_ack : pll_powerdown;

            altera_std_synchronizer #(
                .depth(3)
            ) u_pll_sel_sync (
                .clk(xcvr_reconfig_clk),
                .reset_n(1'b1),
                .din(pll_sel),
                .dout(pll_sel_sync)
            );

            altera_std_synchronizer #(
                .depth(3)
            ) u_pll_sw_req_sync (
                .clk(xcvr_reconfig_clk),
                .reset_n(1'b1),
                .din(xcvr_in_rst),
                .dout(xcvr_in_rst_sync)
            );

            edge_detector #(
                .EDGE_DETECT ("POSEDGE")
            ) u_pll_sw_req (
                .clk (xcvr_reconfig_clk),
                .rst (xcvr_reconfig_reset),
                .d (xcvr_in_rst_sync & trig_tx_rst_ctrl),
                .q (pll_sw_req)
            );
            
            edge_detector #(
                .EDGE_DETECT ("NEGEDGE")
            ) u_pll_sw_busy_negedge_det (
                .clk (xcvr_reconfig_clk),
                .rst (xcvr_reconfig_reset),
                .d (pll_sw_busy),
                .q (pll_sw_busy_negedge)
            );

            // Automatically assert Tx PHY reset control's reset when detected change in pll_sel signal.
            // Deassert the reset when pll_sw_busy or the whole reconfiguration process is done.
            always @ (posedge xcvr_reconfig_clk or posedge xcvr_reconfig_reset)
            begin
                if (xcvr_reconfig_reset) begin
                    pll_sel_prev <= 1'b0;
                    trig_tx_rst_ctrl <= 1'b0;
                end else begin
                    pll_sel_prev <= pll_sel_sync;
                    if (pll_sel_prev != pll_sel_sync) begin
                        trig_tx_rst_ctrl <= 1'b1;
                    end else if (pll_sw_busy_negedge) begin
                        trig_tx_rst_ctrl <= 1'b0;
                    end
                end
            end

            assign rst_tx_phy = trig_tx_rst_ctrl; 
        end else begin
            assign rst_tx_phy = 1'b0; 
        end
    endgenerate

  //*****************************************************************************
  // PLL Switch logic
  //*****************************************************************************
    generate if (ED_TXPLL_SWITCH == 1)
       begin : pll_switching
          wire   tx_cal_busy_negedge;

          rcfg_pll_sw #( 
            .xcvr_rcfg_if_type     (XCVR_RCFG_IF_TYPE     ),
            .xcvr_rcfg_addr_width  (XCVR_RCFG_ADDR_WIDTH  ), 
            .xcvr_rcfg_data_width  (XCVR_RCFG_DATA_WIDTH  )
          ) u_rcfg_pll_sw (
            .clk                   (xcvr_reconfig_clk               ),
            .reset                 (xcvr_reconfig_reset             ),
            .pll_sw_req            (pll_sw_req                      ),
            .pll_sel               (pll_sel_sync                    ),
            .pll_sw_busy           (pll_sw_busy                     ),
            .tx_cal_busy_negedge   (tx_cal_busy_negedge             ),
            .reconfig_write        (reconfig_write_from_pll_sw      ),
            .reconfig_address      (reconfig_address_from_pll_sw    ),
            .reconfig_read         (reconfig_read_from_pll_sw       ),
            .reconfig_writedata    (reconfig_writedata_from_pll_sw  ),
            .reconfig_readdata     (reconfig_readdata_to_pll_sw     ),
            .reconfig_waitrequest  (reconfig_waitrequest_to_pll_sw  )
          );

          if (VIDEO_STANDARD == "dl") begin
            // Tx Xcvr Reset Controller is controlling both Native PHYs in dual-link example design.
            // A single reset pulse to xcvr_rst_ctrl will trigger reset to both the channels, hence
            // we need to make sure that both channels are already done with the recalibration before resetting.
            // This part of logic here is trying to get the cal_busy from both PHYs and make sure that
            // both cal_busy are already deasserted, then deassert the pll_sw_busy output signal from this controller
            // on both channels at about the same time.        
            wire [1:0]  tx_cal_busy_sync;
            wire [1:0]  tx_cal_busy_negedge_temp;
            reg  [1:0]  tx_cal_busy_negedge_flag;

            altera_std_synchronizer_bundle #(
                .width(2),
                .depth(3)
            ) u_tx_cal_busy_sync (
                .clk(xcvr_reconfig_clk),
                .reset_n(1'b1),
                .din(tx_cal_busy[1:0]),
                .dout(tx_cal_busy_sync)
            );

            edge_detector #(
                .EDGE_DETECT ("NEGEDGE")
            ) u_tx_cal_busy0_negedge_det (
                .clk (xcvr_reconfig_clk),
                .rst (xcvr_reconfig_reset),
                .d (tx_cal_busy_sync[0]),
                .q (tx_cal_busy_negedge_temp[0])
            );

            edge_detector #(
                .EDGE_DETECT ("NEGEDGE")
            ) u_tx_cal_busy1_negedge_det (
                .clk (xcvr_reconfig_clk),
                .rst (xcvr_reconfig_reset),
                .d (tx_cal_busy_sync[1]),
                .q (tx_cal_busy_negedge_temp[1])
            );

            always @ (posedge xcvr_reconfig_clk or posedge xcvr_reconfig_reset)
            begin
                if (xcvr_reconfig_reset) begin
                    tx_cal_busy_negedge_flag <= 2'b00;
                end else begin
                    if (pll_sw_busy) begin
                        if (tx_cal_busy_negedge_temp[0]) begin
                            tx_cal_busy_negedge_flag[0] <= 1'b1;
                        end

                        if (tx_cal_busy_negedge_temp[1]) begin
                            tx_cal_busy_negedge_flag[1] <= 1'b1;
                        end
                    end else begin
                        tx_cal_busy_negedge_flag <= 2'b00;
                    end
                end
            end

            assign tx_cal_busy_negedge = &tx_cal_busy_negedge_flag;
          end else begin
            wire   tx_cal_busy_sync;
            altera_std_synchronizer #(
                .depth(3)
            ) u_tx_cal_busy_sync (
                .clk(xcvr_reconfig_clk),
                .reset_n(1'b1),
                .din(tx_cal_busy[0]),
                .dout(tx_cal_busy_sync)
            );

            edge_detector #(
                .EDGE_DETECT ("NEGEDGE")
            ) u_tx_cal_busy_negedge_det (
                .clk (xcvr_reconfig_clk),
                .rst (xcvr_reconfig_reset),
                .d (tx_cal_busy_sync),
                .q (tx_cal_busy_negedge)
            );
          end
  //*****************************************************************************
  // Refclk Switch logic
  //*****************************************************************************
       end else if (ED_TXPLL_SWITCH == 2)
       begin : refclk_switching
          rcfg_refclk_sw #( 
            .xcvr_rcfg_if_type     (XCVR_RCFG_IF_TYPE     ),
            .xcvr_rcfg_addr_width  (XCVR_RCFG_ADDR_WIDTH  ), 
            .xcvr_rcfg_data_width  (XCVR_RCFG_DATA_WIDTH  )
          ) u_rcfg_refclk_sw (
            .clk                   (xcvr_reconfig_clk               ),
            .reset                 (xcvr_reconfig_reset             ),
            .refclk_sw_req         (pll_sw_req                      ),
            .refclk_sel            (pll_sel_sync                    ),
            .refclk_sw_busy        (pll_sw_busy                     ),
            .reconfig_write        (reconfig_write_from_pll_sw      ),
            .reconfig_address      (reconfig_address_from_pll_sw    ),
            .reconfig_read         (reconfig_read_from_pll_sw       ),
            .reconfig_writedata    (reconfig_writedata_from_pll_sw  ),
            .reconfig_readdata     (reconfig_readdata_to_pll_sw     ),
            .reconfig_waitrequest  (reconfig_waitrequest_to_pll_sw  )
          );
       end else begin
          assign pll_sw_busy = 1'b0;
          assign reconfig_write_from_pll_sw = 1'b0;
          assign reconfig_read_from_pll_sw = 1'b0;
          assign reconfig_address_from_pll_sw = 10'd0;
          assign reconfig_writedata_from_pll_sw = 32'd0;
       end
    endgenerate
    
   //*****************************************************************************
   // AVMM Arbiter
   //*****************************************************************************
    a10_reconfig_arbiter #(
        .LANES                 (1),
        .DPRIO_ADDRESS_WIDTH  (XCVR_RCFG_ADDR_WIDTH), 
        .DPRIO_DATA_WIDTH     (XCVR_RCFG_DATA_WIDTH)
    ) u_rcfg_arb(
    // Clocks and reset
        .clk                            (xcvr_reconfig_clk),
        .reset                          (xcvr_reconfig_reset),
    // Inputs
        .rx_rcfg_en                     (cdr_reconfig_busy),
        .tx_rcfg_en                     (pll_sw_busy),
        .rx_rcfg_ch                     (2'b00),
        .tx_rcfg_ch                     (2'b00),
        .rx_reconfig_mgmt_write         (reconfig_write_from_cdr_reconfig),
        .rx_reconfig_mgmt_read          (reconfig_read_from_cdr_reconfig),
        .rx_reconfig_mgmt_address       (reconfig_address_from_cdr_reconfig),
        .rx_reconfig_mgmt_writedata     (reconfig_writedata_from_cdr_reconfig),
        .tx_reconfig_mgmt_write         (reconfig_write_from_pll_sw),
        .tx_reconfig_mgmt_read          (reconfig_read_from_pll_sw),
        .tx_reconfig_mgmt_address       (reconfig_address_from_pll_sw),
        .tx_reconfig_mgmt_writedata     (reconfig_writedata_from_pll_sw),
        .rx_reconfig_readdata           (rx_xcvr_reconfig_readdata),
        .rx_reconfig_waitrequest        (rx_xcvr_reconfig_waitrequest),
        .tx_reconfig_readdata           (tx_xcvr_reconfig_readdata),
        .tx_reconfig_waitrequest        (tx_xcvr_reconfig_waitrequest),
        .rx_cal_busy                    (1'b0),
        .tx_cal_busy                    (1'b0),

    // Outputs
        .rx_reconfig_mgmt_readdata      (reconfig_readdata_to_cdr_reconfig),
        .rx_reconfig_mgmt_waitrequest   (reconfig_waitrequest_to_cdr_reconfig),
        .tx_reconfig_mgmt_readdata      (reconfig_readdata_to_pll_sw),
        .tx_reconfig_mgmt_waitrequest   (reconfig_waitrequest_to_pll_sw),
        .reconfig_write                 (xcvr_reconfig_write),
        .reconfig_read                  (xcvr_reconfig_read),
        .reconfig_address               (xcvr_reconfig_address),
        .reconfig_writedata             (xcvr_reconfig_writedata),
        .rx_reconfig_cal_busy           (),
        .tx_reconfig_cal_busy           ()
    );

     assign rx_xcvr_reconfig_write      = xcvr_reconfig_write;
     assign rx_xcvr_reconfig_read       = xcvr_reconfig_read;
     assign rx_xcvr_reconfig_address    = xcvr_reconfig_address;
     assign rx_xcvr_reconfig_writedata  = xcvr_reconfig_writedata;
     assign tx_xcvr_reconfig_write      = xcvr_reconfig_write;
     assign tx_xcvr_reconfig_read       = xcvr_reconfig_read;
     assign tx_xcvr_reconfig_address    = xcvr_reconfig_address;
     assign tx_xcvr_reconfig_writedata  = xcvr_reconfig_writedata;
   
endmodule
