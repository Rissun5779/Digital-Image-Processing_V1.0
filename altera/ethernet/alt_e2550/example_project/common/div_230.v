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
module div_230 (
    input clk,
    input rst,

    output top_bit
);

parameter NBITS = 10;

reg [9:0] ctr1;
reg ctr1_max;
always @(posedge clk) begin
    if (rst) begin
        ctr1 <= 0;
        ctr1_max <= 0;
    end
    else begin
        ctr1 <= ctr1 + 1'b1;
        ctr1_max <= (ctr1 == 10'h3ff);
    end
end

reg [9:0] ctr2;
reg ctr2_max;
always @(posedge clk) begin
    if (rst) begin
        ctr2 <= 0;
        ctr2_max <= 0;
    end
    else begin
        if (ctr1_max) ctr2 <= ctr2 + 1'b1;
        ctr2_max <= (ctr2 == 10'h3ff);
    end
end

reg [9:0] ctr3;

wire inc_ctr3;
`ifdef SIM_MODE
assign inc_ctr3 = ctr1_max;
`else
assign inc_ctr3 = (ctr1_max & ctr2_max);
`endif

always @(posedge clk) begin
    if (rst) begin
        ctr3 <= 0;
    end
    else begin
        if (inc_ctr3) ctr3 <= ctr3 + 1'b1;
    end
end

assign top_bit = ctr3[NBITS - 1];

endmodule
