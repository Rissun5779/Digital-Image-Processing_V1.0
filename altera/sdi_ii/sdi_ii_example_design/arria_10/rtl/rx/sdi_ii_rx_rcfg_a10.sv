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
// Top-level SDI Rx PHY Reconfiguration Modules 
//**********************************************************************************
`timescale 1 ns / 1 ps

module sdi_ii_rx_rcfg_a10 
(
    input   wire        reconfig_clk,
    input   wire        reconfig_reset,
    input   wire        rx_analogreset_ack,
    input   wire        rx_cal_busy,
    input   wire [2:0]  cdr_reconfig_sel,
    input   wire        cdr_reconfig_req,
    output  wire        cdr_reconfig_busy,
    
    //------------------------------------------------
    // HSSI Reconfig Interface
    //------------------------------------------------
    output  wire         reconfig_write,
    output  wire         reconfig_read,
    output  wire  [9:0 ] reconfig_address, 
    output  wire  [31:0] reconfig_writedata,
    input   wire  [31:0] reconfig_readdata,
    input   wire         reconfig_waitrequest
);

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
    .clk(reconfig_clk),
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
    .clk(reconfig_clk),
    .reset_n(1'b1),
    .din(rx_analogreset_ack),
    .dout(rx_analogreset_ack_sync)
);

altera_std_synchronizer #(
    .depth(3)
) u_cdr_reconfig_req_sync (
    .clk(reconfig_clk),
    .reset_n(1'b1),
    .din(cdr_reconfig_req),
    .dout(cdr_reconfig_req_sync)
);

altera_std_synchronizer #(
    .depth(3)
) u_rx_cal_busy_sync (
    .clk(reconfig_clk),
    .reset_n(1'b1),
    .din(rx_cal_busy),
    .dout(rx_cal_busy_sync)
);

edge_detector #(
    .EDGE_DETECT ("POSEDGE")
) u_reconfig_req_posedge_det (
    .clk (reconfig_clk),
    .rst (reconfig_reset),
    .d (cdr_reconfig_req_sync & rx_analogreset_ack_sync),
    .q (reconfig_req_posedge)
);

edge_detector #(
    .EDGE_DETECT ("NEGEDGE")
) u_rx_cal_busy_negedge_det (
    .clk (reconfig_clk),
    .rst (reconfig_reset),
    .d (rx_cal_busy_sync),
    .q (rx_cal_busy_negedge)
);

rcfg_sdi_cdr #(
    .xcvr_rcfg_addr_width  (10), 
    .xcvr_rcfg_data_width  (32)
) u_rcfg_sdi_cdr (
    .clk                   (reconfig_clk               ),
    .reset                 (reconfig_reset             ),
    .cdr_reconfig_req      (reconfig_req_posedge            ),
    .cdr_reconfig_sel      (cdr_reconfig_sel_sync           ),
    .cdr_reconfig_busy     (cdr_reconfig_busy               ),
    .rx_cal_busy_negedge   (rx_cal_busy_negedge             ),
    .reconfig_write        (reconfig_write          ),
    .reconfig_address      (reconfig_address        ),
    .reconfig_read         (reconfig_read           ),
    .reconfig_writedata    (reconfig_writedata      ),
    .reconfig_readdata     (reconfig_readdata       ),
    .reconfig_waitrequest  (reconfig_waitrequest    )
);
   
endmodule
