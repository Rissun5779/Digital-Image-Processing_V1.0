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


module pointer_synchronizer #(
    parameter WIDTH = 8
) (
    input              input_clk,
    input  [WIDTH-1:0] input_ptr,

    input              output_clk,
    output [WIDTH-1:0] output_ptr
);
    wire [WIDTH-1:0] input_ptr_gray;
    bin_to_gray_reg #(
        .WIDTH      (WIDTH)
    ) b2g_input_ptr (
        .clk        (input_clk),
        .bin_value  (input_ptr),
        .gray_value (input_ptr_gray)
    );

    wire [WIDTH-1:0] input_ptr_gray_sync;
    alt_e2550_delay_reg #(
        .CYCLES (3),
        .WIDTH  (WIDTH)
    ) ptr_sync (
        .clk    (output_clk),
        .din    (input_ptr_gray),
        .dout   (input_ptr_gray_sync)
    );

    gray_to_bin_reg #(
        .WIDTH  (WIDTH)
    ) g2b_output_ptr (
        .clk        (output_clk),
        .gray_value (input_ptr_gray_sync),
        .bin_value  (output_ptr)
    );
endmodule
