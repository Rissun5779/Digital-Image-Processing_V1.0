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


module sc_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input               clk,
    input               reset,
    input               read,
    output [WIDTH-1:0]  read_data,
    input               write,
    input  [WIDTH-1:0]  write_data,
    output              empty,
    output              half_full,
    output              full
);

    localparam PTR_BITS = $clog2(DEPTH);
    localparam FULL_COUNT = DEPTH - 1;

    // Read pointer
    wire [PTR_BITS-1:0] read_ptr;
    binary_counter #(
        .WIDTH  (PTR_BITS)
    ) rd_ptr (
        .clk    (clk),
        .reset  (reset),
        .incr   (read),
        .count  (read_ptr)
    );

    // Write pointer
    wire [PTR_BITS-1:0] write_ptr;
    binary_counter #(
        .WIDTH  (PTR_BITS)
    ) wr_ptr (
        .clk    (clk),
        .reset  (reset),
        .incr   (write),
        .count  (write_ptr)
    );

    // Memory
    sram #(
        .WIDTH      (WIDTH),
        .DEPTH      (DEPTH)
    ) sr (
        .clk        (clk),
        .read       (read),
        .read_addr  (read_ptr),
        .read_data  (read_data),
        .write      (write),
        .write_addr (write_ptr),
        .write_data (write_data)
    );

    // Fill count
    wire [PTR_BITS-1:0] fill_count;
    ud_counter #(
        .WIDTH  (PTR_BITS)
    ) udc (
        .clk    (clk),
        .reset  (reset),
        .incr   (write),
        .dec    (read),
        .count  (fill_count)
    );

    assign empty     = (fill_count == 'd0);
    assign full      = (fill_count == FULL_COUNT);
    assign half_full =  fill_count[PTR_BITS-1];     // MSB = 1
endmodule
