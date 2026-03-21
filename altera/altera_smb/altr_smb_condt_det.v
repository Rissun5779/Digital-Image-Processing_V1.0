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

module altr_smb_condt_det (
    input           clk,
    input           rst_n,
    input           sda_in,
    input           scl_in,
    input           slv_tx_chk_ack,         // from tx shifter
    input [31:0]    tclklow_tmout,
    input           slvfsm_idle_state,
    input           smben,

    output          scl_edge_hl,
    output          scl_edge_lh,
    output          start_det,
    output reg      start_det_dly,
    output          stop_det,
    output reg      ack_det,
    output          set_clklow_tmout,
    output          sda_int

);

// Status Register bit definition


// wires & registers declaration
reg         sda_int_flp;
reg         scl_int_flp;
reg         ack_det_nxt;
reg [31:0]  clklow_cnt, clklow_cnt_nxt;
reg         sda_in_a, sda_in_b;
reg         scl_in_a, scl_in_b;
reg         clklow_cnt_zero_flp;
reg         disable_clklow_cnt;

wire        clklow_cnt_zero;
wire        clklow_cnt_notzero;
wire        scl_int;
wire        sda_edge_hl;
wire        sda_edge_lh;

assign sda_int = sda_in_b;
assign scl_int = scl_in_b;

// Double synchronizer for SDA and SCL line
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sda_in_a <= 1'b1;
        sda_in_b <= 1'b1;
        scl_in_a <= 1'b1;
        scl_in_b <= 1'b1;
    end
    else begin
        sda_in_a <= sda_in;
        sda_in_b <= sda_in_a;
        scl_in_a <= scl_in;
        scl_in_b <= scl_in_a;
    end
end


// sda,scl edge detector flops 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sda_int_flp <= 1'b1;
    else
        sda_int_flp <= sda_int;
end
 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        scl_int_flp <= 1'b1;
    else
        scl_int_flp <= scl_int;
end


// start_det; stop_det; scl_edge_hl; scl_edge_lh  
assign sda_edge_hl = sda_int_flp & ~sda_int;
assign sda_edge_lh = ~sda_int_flp & sda_int;
assign scl_edge_hl = scl_int_flp & ~scl_int;
assign scl_edge_lh = ~scl_int_flp & scl_int;

assign start_det    = scl_int & sda_edge_hl;
assign stop_det     = scl_int & sda_edge_lh;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        start_det_dly <= 1'b0;
    else
        start_det_dly <= start_det;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        ack_det <= 1'b0;
    else
        ack_det <= ack_det_nxt;
end

always @* begin
    case ({scl_edge_lh, slv_tx_chk_ack})
        2'b00: ack_det_nxt = 1'b0;
        2'b01: ack_det_nxt = ack_det;
        2'b10: ack_det_nxt = 1'b0;
        2'b11: ack_det_nxt = ~sda_int;
        default: ack_det_nxt = 1'bx;
    endcase
end

// Ttimeout,min generation
assign clklow_cnt_notzero   = | clklow_cnt;
assign clklow_cnt_zero      = ~clklow_cnt_notzero;
assign set_clklow_tmout     = clklow_cnt_zero & ~clklow_cnt_zero_flp; // to interrupt controller

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clklow_cnt <= 32'hffffffff;
    else
        clklow_cnt <= clklow_cnt_nxt;
end

always @* begin
    if (scl_int | disable_clklow_cnt)
        clklow_cnt_nxt = tclklow_tmout;
    else if (~scl_int & clklow_cnt_notzero)
        clklow_cnt_nxt = clklow_cnt - 32'h1;
    else
        clklow_cnt_nxt = clklow_cnt;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clklow_cnt_zero_flp <= 1'b0;
    else
        clklow_cnt_zero_flp <= clklow_cnt_zero;
end

// case:193140 Disable clock low timeout generation when DUT is not enabled.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        disable_clklow_cnt <= 1'b1;
    else if (smben)
        disable_clklow_cnt <= 1'b0;
    else if (~smben & slvfsm_idle_state)
        disable_clklow_cnt <= 1'b1;
end

endmodule

