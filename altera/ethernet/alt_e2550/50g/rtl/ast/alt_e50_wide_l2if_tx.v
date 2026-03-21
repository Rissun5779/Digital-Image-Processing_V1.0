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


///////////////////////////////////////////////////////////////////////////////
//
// Description: Logic for Avalon Interface Conversion and Ready Latency 0/3 
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module alt_e50_wide_l2if_tx #(
    parameter TARGET_CHIP = 5,
    parameter SYNOPT_READY_LATENCY = 0,
    parameter SYNOPT_PREAMBLE_PASS = 1'b0,
    parameter SIM_EMULATE = 1'b0,
    parameter WIDTH = 64,
    parameter WORDS = 2
)(
//--- ports
input                      sclr,
input                      clk,                // User clock

//From the user side
input    [WIDTH-1:0]       tx_usr_preamble,
input    [WORDS*WIDTH-1:0] tx_usr_d,           // 2 lane payload data
input                      tx_usr_sop,
input                      tx_usr_eop,
input         [3:0]        tx_usr_eop_empty,
input                      tx_usr_valid,    
input                      tx_usr_error,
output                     tx_usr_ready,

//To the MAC side
output   [WIDTH-1:0]       tx_mac_preamble,        // 2 lane payload to send
output   [WORDS*WIDTH-1:0] tx_mac_dout,        // 2 lane payload to send
output      [WORDS-1:0]    tx_mac_sop,         // 2 lane start position
output      [WORDS-1:0]    tx_mac_idle,        // 2 lane idle
output      [WORDS-1:0]    tx_mac_eop,         // 2 lane end of packet
output    [WORDS*3-1:0]    tx_mac_eop_empty,   // 2 lane # of empty bytes at eop word
output      [WORDS-1:0]    tx_mac_error,
input                      tx_mac_ready     
);

wire [63:0]           PREAMBLE = 64'hfb555555555555d5;

generate
if (SYNOPT_READY_LATENCY==0)
begin

    wire [139:0] dat_i1, dat_o1;

    reg                    err_r; 
    reg                    sop_r;
    reg                    eop_r;
    reg  [3:0]             eop_empty_r;
    reg  [WORDS*WIDTH-1:0] d_r;

    reg                    valid_r;
    reg  [WIDTH-1:0]       preamble_r;

    wire [WORDS-1:0]       tx_mac_sop_x;
    wire [WORDS-1:0]       tx_mac_eop_x;
    wire [WORDS-1:0]       tx_mac_error_x;
    wire [WORDS*3-1:0]     tx_mac_eop_empty_x;

    wire                   skid_valid;

    always @(posedge clk) begin
        valid_r     <= tx_usr_valid;
        sop_r       <= tx_usr_sop;
        eop_r       <= tx_usr_eop;
        err_r       <= tx_usr_error;
        eop_empty_r <= tx_usr_eop_empty;
        d_r         <= tx_usr_d;
    end

    assign dat_i1 = {{sop_r && valid_r, 1'b0},
                    {eop_r && valid_r && eop_empty_r[3], eop_r && valid_r && !eop_empty_r[3]},
                    {err_r && valid_r && eop_empty_r[3], err_r && valid_r && !eop_empty_r[3]},
                    {3{eop_r && valid_r && eop_empty_r[3]}} & eop_empty_r[2:0],
                    {3{eop_r && valid_r && !eop_empty_r[3]}} & eop_empty_r[2:0],
                    d_r};

    assign {tx_mac_sop_x, tx_mac_eop_x, tx_mac_error_x, tx_mac_eop_empty_x, tx_mac_dout} = dat_o1;

    alt_e2550_ready_skid #(
        .WIDTH(140)
    ) txskid1 (
        .clk(clk),
        .sclr(sclr),

        .valid_i(1'b1), // input
        .dat_i(dat_i1),
        .ready_i(), // output

        .valid_o(skid_valid), // output
        .dat_o(dat_o1), // output
        .ready_o(tx_mac_ready) //input
    );

    assign tx_mac_idle      = 2'b00;
    assign tx_usr_ready     = tx_mac_ready;
    assign tx_mac_sop       = tx_mac_sop_x       & {WORDS{skid_valid}};
    assign tx_mac_eop       = tx_mac_eop_x       & {WORDS{skid_valid}};
    assign tx_mac_error     = tx_mac_error_x     & {WORDS{skid_valid}};
    assign tx_mac_eop_empty = tx_mac_eop_empty_x & {WORDS*3{skid_valid}};

    if (SYNOPT_PREAMBLE_PASS) begin
        always @(posedge clk) preamble_r <= tx_usr_preamble;
        alt_e2550_ready_skid #(
            .WIDTH(64)
        ) txskid_p1 (
            .clk(clk),
            .sclr(sclr),

            .valid_i(1'b1), // input
            .dat_i(preamble_r),
            .ready_i(), // output

            .valid_o(), // output
            .dat_o(tx_mac_preamble), // output
            .ready_o(tx_mac_ready) //input
        );
    end
    else begin
        assign tx_mac_preamble = PREAMBLE;
    end

end

else begin // READY_LATENCY!=0 (=3)

    wire [135:0] dat_i0, dat_o0;
    wire [139:0] dat_i1, dat_o1;
    wire [139:0] dat_o2;

    wire [WORDS-1:0]       tx_mac_sop_y;
    wire [WORDS-1:0]       tx_mac_eop_y;
    wire [WORDS-1:0]       tx_mac_error_y;
    wire [WORDS*3-1:0]     tx_mac_eop_empty_y;

    wire                   err_x; 
    wire                   sop_x;
    wire                   eop_x;
    wire [3:0]             eop_empty_x;
    wire [WORDS*WIDTH-1:0] d_x;

    wire                   valid_x;
    wire [WIDTH-1:0]       preamble_x;
    wire                   tx_mac_ready_1;
    wire                   tx_mac_ready_2;
    wire                   skid_valid;

    assign dat_i0 = {tx_usr_valid,
                    tx_usr_sop,
                    tx_usr_eop,
                    tx_usr_error,
                    tx_usr_eop_empty,
                    tx_usr_d};
    assign {valid_x, sop_x, eop_x, err_x, eop_empty_x, d_x} = dat_o0;

    wire [3:0] unused_4b;

    alt_e2550_ready_skid #(
        .WIDTH(140)
    ) txskid0 (
        .clk(clk),
        .sclr(sclr),

        .valid_i(1'b1), // input
        .dat_i({4'b0, dat_i0}),
        .ready_i(), // output

        .valid_o(), // output
        .dat_o({unused_4b, dat_o0}), // output
        .ready_o(tx_mac_ready_2) //input
    );


    assign dat_i1 = {{sop_x && valid_x, 1'b0},
                    {eop_x && valid_x && eop_empty_x[3], eop_x && valid_x && !eop_empty_x[3]},
                    {err_x && valid_x && eop_empty_x[3], err_x && valid_x && !eop_empty_x[3]},
                    {3{eop_x && valid_x && eop_empty_x[3]}} & eop_empty_x[2:0],
                    {3{eop_x && valid_x && !eop_empty_x[3]}} & eop_empty_x[2:0],
                    d_x};

    alt_e2550_ready_skid #(
        .WIDTH(140)
    ) txskid1 (
        .clk(clk),
        .sclr(sclr),

        .valid_i(1'b1), // input
        .dat_i(dat_i1),
        .ready_i(tx_mac_ready_2), // output

        .valid_o(), // output
        .dat_o(dat_o1), // output
        .ready_o(tx_mac_ready_1) //input
    );


    assign {tx_mac_sop_y, tx_mac_eop_y, tx_mac_error_y, tx_mac_eop_empty_y, tx_mac_dout} = dat_o2;

    alt_e2550_ready_skid #(
        .WIDTH(140)
    ) txskid2 (
        .clk(clk),
        .sclr(sclr),

        .valid_i(1'b1), // input
        .dat_i(dat_o1),
        .ready_i(tx_mac_ready_1), // output

        .valid_o(skid_valid), // output
        .dat_o(dat_o2), // output
        .ready_o(tx_mac_ready) //input
    );

    assign tx_mac_idle      = 2'b00;
    assign tx_usr_ready     = tx_mac_ready;
    assign tx_mac_sop       = tx_mac_sop_y       & {WORDS{skid_valid}};
    assign tx_mac_eop       = tx_mac_eop_y       & {WORDS{skid_valid}};
    assign tx_mac_error     = tx_mac_error_y     & {WORDS{skid_valid}};
    assign tx_mac_eop_empty = tx_mac_eop_empty_y & {WORDS*3{skid_valid}};



    if (SYNOPT_PREAMBLE_PASS) begin
        wire [63:0] tx_usr_preamble_1;
        wire [63:0] tx_usr_preamble_2;
        wire        tx_mac_ready_p2;
        wire        tx_mac_ready_p1;

    alt_e2550_ready_skid #(
        .WIDTH(64)
    ) txskid_p0 (
        .clk(clk),
        .sclr(sclr),

        .valid_i(1'b1), // input
        .dat_i(tx_usr_preamble),
        .ready_i(), // output

        .valid_o(), // output
        .dat_o(tx_usr_preamble_1), // output
        .ready_o(tx_mac_ready_p2) //input
    );

    alt_e2550_ready_skid #(
        .WIDTH(64)
    ) txskid_p1 (
        .clk(clk),
        .sclr(sclr),

        .valid_i(1'b1), // input
        .dat_i(tx_usr_preamble_1),
        .ready_i(tx_mac_ready_p2), // output

        .valid_o(), // output
        .dat_o(tx_usr_preamble_2), // output
        .ready_o(tx_mac_ready_p1) //input
    );

    alt_e2550_ready_skid #(
        .WIDTH(64)
    ) txskid_p2 (
        .clk(clk),
        .sclr(sclr),

        .valid_i(1'b1), // input
        .dat_i(tx_usr_preamble_2),
        .ready_i(tx_mac_ready_p1), // output

        .valid_o(), // output
        .dat_o(tx_mac_preamble), // output
        .ready_o(tx_mac_ready) //input
    );
    end
    else begin
        assign tx_mac_preamble = PREAMBLE;
    end

end

endgenerate

endmodule

