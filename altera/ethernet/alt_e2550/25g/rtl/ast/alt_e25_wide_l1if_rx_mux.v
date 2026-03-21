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



`timescale 1ps / 1ps

module alt_e25_wide_l1if_rx_mux #(
    parameter TARGET_CHIP = 2,
    parameter WORDS = 5,
    parameter WIDTH = 64,
    parameter RXSIDEBANDWIDTH = 9
)(
    input sclr,
    input clk,            // MAC + PCS clock -390.625Mhz

    //Sop aligned  
    output  reg [WORDS*WIDTH-1:0]       rx_usr_dout,              // 2 lane payload data
    output  reg                         rx_usr_valid,
    output  reg                         rx_usr_sop,
    output  reg                         rx_usr_eop,
    output  reg [2:0]                   rx_usr_eop_empty,
    output  reg [RXSIDEBANDWIDTH-1:0]   rx_usr_sideband,

    input       [WORDS*WIDTH-1:0]       rx_mac_d,             // 2 lane payload to send
    input       [WORDS-1:0]             rx_mac_sop,           // 2 lane start position
    input       [WORDS-1:0]             rx_mac_idle,          // 2 lane idle position
    input       [WORDS-1:0]             rx_mac_eop,           // 2 lane eop position
    input       [WORDS*3-1:0]           rx_mac_eop_empty,     // 2 lane # of empty bytes
    input       [RXSIDEBANDWIDTH-1:0]   rx_mac_sideband,      // Any status signals that needs to pass to user bus
    input                               rx_mac_valid          // payload is accepted
);

localparam EXT_WIDTH = WIDTH + 1 + 1 + 3 + RXSIDEBANDWIDTH; /* data, sop, eop, eop_empty, error */

reg  [WORDS*WIDTH-1:0]     rx_mac_d_r;
reg  [WORDS-1:0]           rx_mac_sop_r;
reg  [WORDS-1:0]           rx_mac_idle_r;
reg  [WORDS-1:0]           rx_mac_eop_r;
reg  [WORDS*3-1:0]         rx_mac_eop_empty_r;
reg  [RXSIDEBANDWIDTH-1:0] rx_mac_sideband_r;
reg                        rx_mac_valid_r = 1'b0;
reg                        sop_at_bot_r = 1'b0;
reg                        last_sop_at_bot_r = 1'b0;
reg  [EXT_WIDTH*WORDS-1:0] exp_annot_r1;
reg                        rx_mac_valid_r1 = 1'b0;
reg                        shift_r1 = 1'b0;
reg                        extra_idle_r1 = 1'b0;
reg                        rx_mac_valid_r2 = 1'b0;
reg  [EXT_WIDTH-1:0]       e1_mux_r2, e0_mux_r2;

wire [EXT_WIDTH*WORDS-1:0] exp_annot;
wire [EXT_WIDTH-1:0]       e0, e1, e0_r1, e1_r1, e1_mux, e0_mux;

//Beef up the control signals with valid
always @(posedge clk) begin
//   if (rx_mac_valid) rx_mac_d_r  <= rx_mac_d;   //Stretch out to avoid garbage in non-valid cycle
     //The RX Mac output already stretch the data, no need to use valid anymore.
     rx_mac_d_r                  <= rx_mac_d;
     rx_mac_sop_r                <= rx_mac_sop & ({WORDS{rx_mac_valid & (~&rx_mac_idle)}}); 
     rx_mac_idle_r               <= rx_mac_idle;
     rx_mac_eop_r                <= rx_mac_eop & ({WORDS{rx_mac_valid & (~&rx_mac_idle)}});
     rx_mac_eop_empty_r          <= rx_mac_eop_empty;
     rx_mac_sideband_r           <= rx_mac_sideband & {RXSIDEBANDWIDTH{|rx_mac_eop}};
 
     if (sclr)   rx_mac_valid_r  <= 1'b0;
     else        rx_mac_valid_r  <= rx_mac_valid & (~&rx_mac_idle);

     if (rx_mac_sop[0]) sop_at_bot_r <= 1'b1;
     else if (/*PUNEET: |rx_mac_eop*/|rx_mac_eop_r) sop_at_bot_r <= 1'b0;
   
     last_sop_at_bot_r <= sop_at_bot_r;
     
end

genvar i;
generate
        for (i=0; i<WORDS; i= i+1) begin : exp_ann
                assign exp_annot [(i+1)*EXT_WIDTH-1:i*EXT_WIDTH] =
                        {       
                                rx_mac_sop_r[i],
                                rx_mac_eop_r[i],
                                rx_mac_eop_empty_r[i*3+2 : i*3],
                                rx_mac_sideband_r,
                                rx_mac_d_r[(i+1)*WIDTH-1:i*WIDTH]};
        end
endgenerate

 
always @(posedge clk) begin
     exp_annot_r1      <= exp_annot;
     shift_r1          <= sop_at_bot_r & ~rx_mac_eop_r[1];
     extra_idle_r1     <= last_sop_at_bot_r &  rx_mac_eop_r[1];

     if (sclr) rx_mac_valid_r1   <= 1'b0;
     else      rx_mac_valid_r1   <= rx_mac_valid_r;
end

always @(posedge clk) begin
     e1_mux_r2                <= e1_mux;
     e0_mux_r2                <= e0_mux;

     if (sclr) rx_mac_valid_r2  <= 1'b0;
     else      rx_mac_valid_r2  <= rx_mac_valid_r1 & ~extra_idle_r1; 
end

wire [EXT_WIDTH*WORDS-1:0] ext_dout;
assign ext_dout = {e1_mux_r2, e0_mux_r2};

wire [WORDS-1:0] rd_sop;
wire [WORDS-1:0] rd_eop;
wire [WORDS-1:0] rd_eop_empty2; 
wire [WORDS-1:0] rd_eop_empty1; 
wire [WORDS-1:0] rd_eop_empty0; 
wire [RXSIDEBANDWIDTH*WORDS-1:0] rd_sideband;
wire [WORDS*WIDTH-1:0] rd_dout;
generate
for (i=0; i<WORDS; i=i+1) begin : unpack
            assign {rd_sop[i],
                    rd_eop[i],
                    rd_eop_empty2[i],
                    rd_eop_empty1[i],
                    rd_eop_empty0[i],
                    rd_sideband[(i+1)*RXSIDEBANDWIDTH-1:i*RXSIDEBANDWIDTH],
                    rd_dout[(i+1)*WIDTH-1:i*WIDTH]} = 
                            ext_dout[(i+1)*EXT_WIDTH-1:i*EXT_WIDTH];
end
endgenerate

always @(posedge clk) begin

        rx_usr_dout <= rd_dout;

        if (sclr) begin
             rx_usr_valid     <= 1'b0;
             rx_usr_sop       <= 1'b0;
             rx_usr_sideband  <= {RXSIDEBANDWIDTH{1'b0}};
             rx_usr_eop       <= 1'b0;
             rx_usr_eop_empty <= 3'b0;
        end 
        else begin
             rx_usr_valid     <=  rx_mac_valid_r2;
             rx_usr_sop       <=  rd_sop[WORDS-1];
             if (rd_eop[1]) begin
                     rx_usr_eop <= rd_eop[1] & rx_mac_valid_r2;
                     rx_usr_eop_empty <= {1'b1, rd_eop_empty2[1], rd_eop_empty1[1], rd_eop_empty0[1]} & {4{rx_mac_valid_r2}};
                     rx_usr_sideband  <= rd_sideband[2*RXSIDEBANDWIDTH-1:RXSIDEBANDWIDTH] & {RXSIDEBANDWIDTH{rx_mac_valid_r2}};
             end
             else if (rd_eop[0]) begin
                     rx_usr_eop <= rd_eop[0] & rx_mac_valid_r2;
                     rx_usr_eop_empty <= {1'b0, rd_eop_empty2[0], rd_eop_empty1[0], rd_eop_empty0[0]} & {4{rx_mac_valid_r2}};
                     rx_usr_sideband  <= rd_sideband[RXSIDEBANDWIDTH-1:0] & {RXSIDEBANDWIDTH{rx_mac_valid_r2}};
             end
             else begin
                     rx_usr_eop <= 1'b0;
                     rx_usr_eop_empty <= 3'b0;
                     rx_usr_sideband  <= {RXSIDEBANDWIDTH{1'b0}};
             end
        end
end
endmodule
