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
// Top-level SDI Tx Reconfiguration Modules 
//**********************************************************************************
`timescale 1 ns / 1 ps

module sdi_ii_tx_rcfg_a10 #(
    parameter XCVR_RCFG_IF_TYPE = "channel",
    parameter ED_TXPLL_SWITCH   = 0
) (
    input   wire        reconfig_clk,
    input   wire        reconfig_reset,
    input   wire        tx_analogreset_ack,
    input   wire        tx_cal_busy,
    input   wire        pll_powerdown,
    input   wire        pll_refclk_sel,
    output  wire        tx_reconfig_busy,
    output  reg         rst_tx_phy,
    
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

wire    pll_sw_req;
wire    pll_refclk_sel_sync;
wire    tx_rcfg_busy_negedge;
wire    xcvr_in_rst_sync;
wire    xcvr_in_rst = (ED_TXPLL_SWITCH == 1) ? tx_analogreset_ack : pll_powerdown;
reg     pll_refclk_sel_prev;

altera_std_synchronizer #(
    .depth(3)
) u_pll_refclk_sel_sync (
    .clk(reconfig_clk),
    .reset_n(1'b1),
    .din(pll_refclk_sel),
    .dout(pll_refclk_sel_sync)
);

altera_std_synchronizer #(
    .depth(3)
) u_xcvr_in_rst_sync (
    .clk(reconfig_clk),
    .reset_n(1'b1),
    .din(xcvr_in_rst),
    .dout(xcvr_in_rst_sync)
);

edge_detector #(
    .EDGE_DETECT ("POSEDGE")
) u_pll_sw_req (
    .clk (reconfig_clk),
    .rst (reconfig_reset),
    .d (xcvr_in_rst_sync & rst_tx_phy), //rst_tx_phy triggered when pll_refclk_sel changed
    .q (pll_sw_req)
);

edge_detector #(
    .EDGE_DETECT ("NEGEDGE")
) u_tx_rcfg_busy_negedge_det (
    .clk (reconfig_clk),
    .rst (reconfig_reset),
    .d (tx_reconfig_busy),
    .q (tx_rcfg_busy_negedge)
);           

// Automatically assert Tx PHY reset control's reset when detected change in pll_refclk_sel signal.
// Deassert the reset when tx_reconfig_busy or the whole reconfiguration process is done.
always @ (posedge reconfig_clk or posedge reconfig_reset)
begin
    if (reconfig_reset) begin
        pll_refclk_sel_prev <= 1'b0;
        rst_tx_phy <= 1'b0;
    end else begin
        pll_refclk_sel_prev <= pll_refclk_sel_sync;
        if (pll_refclk_sel_prev != pll_refclk_sel_sync) begin
            rst_tx_phy <= 1'b1;
        end else if (tx_rcfg_busy_negedge) begin
            rst_tx_phy <= 1'b0;
        end
    end
end

//*****************************************************************************
// PLL Switch logic
//*****************************************************************************
generate if (ED_TXPLL_SWITCH == 1)
begin : pll_switching
    wire   tx_cal_busy_sync;
    wire   tx_cal_busy_negedge;
    altera_std_synchronizer #(
        .depth(3)
    ) u_tx_cal_busy_sync (
        .clk(reconfig_clk),
        .reset_n(1'b1),
        .din(tx_cal_busy),
        .dout(tx_cal_busy_sync)
    );

    edge_detector #(
        .EDGE_DETECT ("NEGEDGE")
    ) u_tx_cal_busy_negedge_det (
        .clk (reconfig_clk),
        .rst (reconfig_reset),
        .d (tx_cal_busy_sync),
        .q (tx_cal_busy_negedge)
    );

    rcfg_pll_sw #( 
        .xcvr_rcfg_if_type     (XCVR_RCFG_IF_TYPE),
        .xcvr_rcfg_addr_width  (10), 
        .xcvr_rcfg_data_width  (32)
    ) u_rcfg_pll_sw (
        .clk                   (reconfig_clk            ),
        .reset                 (reconfig_reset          ),
        .pll_sw_req            (pll_sw_req              ),
        .pll_sel               (pll_refclk_sel_sync     ),
        .pll_sw_busy           (tx_reconfig_busy        ),
        .tx_cal_busy_negedge   (tx_cal_busy_negedge     ),
        .reconfig_write        (reconfig_write          ),
        .reconfig_address      (reconfig_address        ),
        .reconfig_read         (reconfig_read           ),
        .reconfig_writedata    (reconfig_writedata      ),
        .reconfig_readdata     (reconfig_readdata       ),
        .reconfig_waitrequest  (reconfig_waitrequest    )
    );
end else if (ED_TXPLL_SWITCH == 2)
begin : refclk_switching
  //*****************************************************************************
  // Refclk Switch logic
  //*****************************************************************************
    rcfg_refclk_sw #( 
        .xcvr_rcfg_if_type     (XCVR_RCFG_IF_TYPE),
        .xcvr_rcfg_addr_width  (10), 
        .xcvr_rcfg_data_width  (32)
    ) u_rcfg_refclk_sw (
        .clk                   (reconfig_clk            ),
        .reset                 (reconfig_reset          ),
        .refclk_sw_req         (pll_sw_req              ),
        .refclk_sel            (pll_refclk_sel_sync     ),
        .refclk_sw_busy        (tx_reconfig_busy        ),
        .reconfig_write        (reconfig_write          ),
        .reconfig_address      (reconfig_address        ),
        .reconfig_read         (reconfig_read           ),
        .reconfig_writedata    (reconfig_writedata      ),
        .reconfig_readdata     (reconfig_readdata       ),
        .reconfig_waitrequest  (reconfig_waitrequest    )
    );
end else begin
    assign tx_reconfig_busy = 1'b0;
    assign reconfig_write = 1'b0;
    assign reconfig_read = 1'b0;
    assign reconfig_address = 10'd0;
    assign reconfig_writedata = 32'd0;
end
endgenerate

endmodule
