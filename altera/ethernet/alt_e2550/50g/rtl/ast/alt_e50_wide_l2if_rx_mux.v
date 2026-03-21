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


/* This is a receiver adaptor for two words adaptor of 50G for non preamble pass through mode. 
*/
//Juzhang 3-13-2015
`timescale 1ps / 1ps

module alt_e50_wide_l2if_rx_mux #(
    parameter TARGET_CHIP = 2,
    parameter SIM_EMULATE = 1'b0,
    parameter WORDS = 2,
    parameter WIDTH = 64,
    parameter RXSIDEBANDWIDTH = 9,
    parameter SYNOPT_PREAMBLE_PASS = 1'b1
)(
    input sclr,
    input clk,            // MAC + PCS clock -390.625Mhz

    //Sop aligned  
    output  reg [WORDS*WIDTH-1:0]       rx_usr_dout,              // 2 lane payload data
    output  wire[WIDTH-1:0]             rx_usr_preamble, 
    output  reg                         rx_usr_valid,
    output  reg                         rx_usr_sop,
    output  reg                         rx_usr_eop,
    output  reg [3:0]                   rx_usr_eop_empty,
    output  reg [RXSIDEBANDWIDTH-1:0]   rx_usr_sideband,

    input       [WORDS*WIDTH-1:0]       rx_mac_d,             // 2 lane payload to send
    input       [WORDS-1:0]             rx_mac_sop,           // 2 lane start position
    input       [WORDS-1:0]             rx_mac_idle,          // 2 lane idle position
    input       [WORDS-1:0]             rx_mac_prb,
    input       [WORDS-1:0]             rx_mac_eop,           // 2 lane eop position
    input       [WORDS*3-1:0]           rx_mac_eop_empty,     // 2 lane # of empty bytes
    input       [RXSIDEBANDWIDTH-1:0]   rx_mac_sideband,      // Any status signals that needs to pass to user bus
    input                               rx_mac_valid          // payload is accepted
);

//This module is operated in non preamble pass through mode. The user side (sop aligned) and mac side operated
//at the same speed which is 390.625Mhz. Ram or FIFO is not needed in this mode since the assumption there are
//always at least one word gap (preamble plus idle) between the EOP and SOP. The bandwidth requirement at the 
//User side is less than the mac side at any moment.

localparam EXT_WIDTH = WIDTH + 1 + 1 +1 + 3 + RXSIDEBANDWIDTH; /* data, sop, eop, eop_empty, idle,  error */

reg  [WORDS*WIDTH-1:0]     rx_mac_d_sample;
reg  [WORDS-1:0]           rx_mac_sop_sample;
reg  [WORDS-1:0]           rx_mac_idle_sample;
reg  [WORDS-1:0]           rx_mac_eop_sample;
reg  [WORDS*3-1:0]         rx_mac_eop_empty_sample;
reg  [RXSIDEBANDWIDTH-1:0] rx_mac_sideband_sample;
reg                        rx_mac_valid_sample = 1'b0;


reg  [WORDS*WIDTH-1:0]     rx_mac_d_r;
reg  [WORDS-1:0]           rx_mac_sop_r;
reg  [WORDS-1:0]           rx_mac_idle_r;
reg  [WORDS-1:0]           rx_mac_eop_r;
reg  [WORDS*3-1:0]         rx_mac_eop_empty_r;
reg  [RXSIDEBANDWIDTH-1:0] rx_mac_sideband_r;
reg                        rx_valid_i = 1'b0;
wire                       rx_mac_valid_r;

reg  [WORDS*WIDTH-1:0]     last_rx_mac_d_r;
reg  [WORDS-1:0]           last_rx_mac_sop_r;
reg  [WORDS-1:0]           last_rx_mac_idle_r;
reg  [WORDS-1:0]           last_rx_mac_eop_r;
reg  [WORDS*3-1:0]         last_rx_mac_eop_empty_r;
reg  [RXSIDEBANDWIDTH-1:0] last_rx_mac_sideband_r;
reg                        last_rx_mac_valid_r = 1'b0;

reg                        sop_at_bot_r = 1'b0;
reg                        last_sop_at_bot_r = 1'b0;
reg                        shift_r1 = 1'b0;
reg                        extra_idle_r1 = 1'b0;
reg                        rx_mac_valid_r2 = 1'b0;
reg  [EXT_WIDTH-1:0]       e1_mux_r2, e0_mux_r2;
reg                        eop_valid_r;
reg                        eop_to_sop_gap;

wire [EXT_WIDTH*WORDS-1:0] exp_annot, exp_annot_r1;
wire [EXT_WIDTH-1:0]       e1, e0_r1, e1_r1, e1_mux, e0_mux;
reg                        rx_mac_valid_x=0;

//Clean up the interface 
always @(posedge clk) begin
    rx_mac_d_sample             <= rx_mac_d;
    rx_mac_sop_sample           <= rx_mac_sop & {2{rx_mac_valid}} & {2{!(&rx_mac_idle)}};
    rx_mac_idle_sample          <= rx_mac_idle;
    rx_mac_eop_sample           <= rx_mac_eop & {2{rx_mac_valid}} & {2{!(&rx_mac_idle)}};
    rx_mac_eop_empty_sample     <= rx_mac_eop_empty;
    rx_mac_sideband_sample      <= rx_mac_sideband;

    if (sclr)  rx_mac_valid_sample  <= 1'b0;
    else       rx_mac_valid_sample  <= rx_mac_valid & !(&rx_mac_idle);
    rx_mac_valid_x <= rx_mac_valid;
end

wire hide_holding = ~rx_mac_valid_sample;
assign rx_mac_valid_r = hide_holding ? 1'b0 : rx_valid_i;
always @(posedge clk) begin
     if (rx_mac_valid_sample)  begin
         rx_mac_d_r           <= rx_mac_d_sample;   //Stretch out to avoid garbage in non-valid cycle
         rx_mac_sop_r         <= rx_mac_sop_sample; 
         rx_mac_idle_r        <= rx_mac_idle_sample;
         rx_mac_eop_r         <= rx_mac_eop_sample;
         rx_mac_eop_empty_r   <= rx_mac_eop_empty_sample;
         rx_mac_sideband_r    <= rx_mac_sideband_sample;
     end


     if (sclr)                       rx_valid_i   <= 1'b0;
     else if (rx_mac_valid_sample)   rx_valid_i   <= rx_mac_valid_sample;

     if (rx_mac_sop_sample[0]) sop_at_bot_r <= 1'b1;
     else if (rx_mac_sop_sample[1]) sop_at_bot_r <= 1'b0;
   

     eop_valid_r <= rx_mac_valid_sample & (|rx_mac_eop_sample);

     if (sclr)
         eop_to_sop_gap <= 1'b0;
     else if (eop_valid_r & ~(|rx_mac_sop_sample))  
         eop_to_sop_gap <= 1'b1;
     else if (rx_mac_valid_sample & (|rx_mac_sop_sample))
         eop_to_sop_gap <= 1'b0; 

     if (rx_mac_valid_r | eop_valid_r) begin
       last_rx_mac_d_r           <= rx_mac_d_r;   //Stretch out to avoid garbage in non-valid cycle
       last_rx_mac_sop_r         <= rx_mac_sop_r;
       last_rx_mac_idle_r        <= rx_mac_idle_r;
       last_rx_mac_eop_r         <= rx_mac_eop_r;
       last_rx_mac_eop_empty_r   <= rx_mac_eop_empty_r;
       last_rx_mac_sideband_r    <= rx_mac_sideband_r;
       last_sop_at_bot_r         <= sop_at_bot_r;
     end

     last_rx_mac_valid_r         <= (rx_mac_valid_r | eop_valid_r) & ~eop_to_sop_gap;

end

//If sop start at bottom position, the whole packet shifted up 1 word.
//extra idle generated if eop is at top position and needed to shift to previous cycle

assign  e1            = exp_annot[2*EXT_WIDTH-1:EXT_WIDTH];
assign {e1_r1, e0_r1} = exp_annot_r1;

assign e1_mux = shift_r1 ? e0_r1 :  e1_r1;
assign e0_mux = shift_r1 ? e1    :  e0_r1;

genvar i;
generate
        for (i=0; i<WORDS; i= i+1) begin : exp_ann
                assign exp_annot [(i+1)*EXT_WIDTH-1:i*EXT_WIDTH] =
                        {       
                                rx_mac_sop_r[i],
                                rx_mac_eop_r[i],
                                rx_mac_eop_empty_r[i*3+2 : i*3],
                                rx_mac_idle_r[i],
                                rx_mac_sideband_r,
                                rx_mac_d_r[(i+1)*WIDTH-1:i*WIDTH]};

                assign exp_annot_r1 [(i+1)*EXT_WIDTH-1:i*EXT_WIDTH] =
                        {      
                                last_rx_mac_sop_r[i],
                                last_rx_mac_eop_r[i],
                                last_rx_mac_eop_empty_r[i*3+2 : i*3],
                                last_rx_mac_idle_r[i],
                                last_rx_mac_sideband_r,
                                last_rx_mac_d_r[(i+1)*WIDTH-1:i*WIDTH]};
        end
endgenerate

 
always @(posedge clk) begin
     shift_r1          <= sop_at_bot_r & ~rx_mac_eop_r[1];
     extra_idle_r1     <= last_sop_at_bot_r &  rx_mac_eop_r[1];
end

always @(posedge clk) begin
     e1_mux_r2                <= e1_mux;
     e0_mux_r2                <= e0_mux;

     if (sclr) rx_mac_valid_r2  <= 1'b0;
     else      rx_mac_valid_r2  <=   last_rx_mac_valid_r & ~extra_idle_r1; 
end

wire [EXT_WIDTH*WORDS-1:0] ext_dout;
assign ext_dout = {e1_mux_r2, e0_mux_r2};

wire [WORDS-1:0] rd_sop;
wire [WORDS-1:0] rd_eop;
wire [WORDS-1:0] rd_idle;
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
                    rd_idle[i],
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
             rx_usr_eop_empty <= 4'b0;
        end 
        else begin
             rx_usr_valid     <=  rx_mac_valid_r2 & ~(&rd_idle);
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
                     rx_usr_eop_empty <= 4'b0;
                     rx_usr_sideband  <= {RXSIDEBANDWIDTH{1'b0}};
             end
        end
end

generate
if (SYNOPT_PREAMBLE_PASS==1) 
begin
    reg  [WIDTH-1:0]           rx_mac_prev_r;
    reg  [WIDTH-1:0]           rx_usr_preamble_x;
    reg  [WIDTH-1:0]           rx_mac_preamble_r;
    always @(posedge clk) begin
        if (rx_mac_valid_x)       rx_mac_prev_r     <= rx_mac_d_sample[63:0];
        if (rx_mac_sop_sample[1]) rx_mac_preamble_r <= rx_mac_prev_r[63:0];
        if (rx_mac_sop_sample[0]) rx_mac_preamble_r <= rx_mac_d_sample[127:64];
        rx_usr_preamble_x <= rx_mac_preamble_r;
    end
    assign rx_usr_preamble = rx_usr_preamble_x;
end
else begin
    assign rx_usr_preamble = 64'h0;
end
endgenerate

endmodule
