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


module gray_to_bin_reg #(
    parameter WIDTH = 8
) (
    input                   clk,
    input      [WIDTH-1:0]  gray_value,
    output reg [WIDTH-1:0]  bin_value
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i=i+1) begin : bit_loop
            always @(posedge clk) bin_value[i] <= ^gray_value[(WIDTH-1):i];
        end
    endgenerate
endmodule
