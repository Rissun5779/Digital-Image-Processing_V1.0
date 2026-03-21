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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altr_smb_txout (
    input           clk,
    input           rst_n,
    input [15:0]    thddat,
    input           slv_tx_sda_out,
    input           slv_rx_sda_out,
    input           slv_tx_scl_out,
    input           slv_rx_scl_out,
    input           scl_edge_hl,

    output          smb_data_oe,
    output          smb_clk_oe

);

reg         data_oe;
reg         clk_oe;
reg [15:0]  sda_hold_cnt;
reg [15:0]  sda_hold_cnt_nxt;

wire        data_oe_nxt;
wire        clk_oe_nxt;
wire        load_sda_hold_cnt;
wire        sda_hold_en;

assign data_oe_nxt  =   ~slv_tx_sda_out |
                        ~slv_rx_sda_out;

assign clk_oe_nxt   =   ~slv_tx_scl_out |
                        ~slv_rx_scl_out;

assign load_sda_hold_cnt    = scl_edge_hl;
assign sda_hold_en          = (sda_hold_cnt_nxt != 16'h0);

assign smb_data_oe  = data_oe;
assign smb_clk_oe   = clk_oe;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_oe <= 1'b0;
    else if (sda_hold_en)
        data_oe <= data_oe;
    else
        data_oe <= data_oe_nxt;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clk_oe <= 1'b0;
    else
        clk_oe <= clk_oe_nxt;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sda_hold_cnt <= 16'h0;
    else
        sda_hold_cnt <= sda_hold_cnt_nxt;
end

always @* begin
    if (load_sda_hold_cnt)
        sda_hold_cnt_nxt = (thddat - 16'h1);
    else if (sda_hold_cnt != 16'h0)
        sda_hold_cnt_nxt = sda_hold_cnt - 16'h1;
    else
        sda_hold_cnt_nxt = sda_hold_cnt;
end

endmodule
