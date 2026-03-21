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


// altera message_off 10230
module dual_clock_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input              areset,

    input              read_clk,
    output [WIDTH-1:0] read_data,
    input              read,

    input              write_clk,
    input  [WIDTH-1:0] write_data,
    input              write,

    output             empty,
    output             full
);

    localparam ADDR_BITS = $clog2(DEPTH);
    localparam PTR_BITS  = ADDR_BITS + 1;

    wire [PTR_BITS-1:0]  write_ptr, write_ptr_sync;
    wire [PTR_BITS-1:0]  read_ptr, read_ptr_sync;
    wire [ADDR_BITS-1:0] write_addr = write_ptr[ADDR_BITS-1:0];
    wire [ADDR_BITS-1:0] read_addr  = read_ptr[ADDR_BITS-1:0];
    wire [PTR_BITS-1:0]  read_ptr_when_empty = write_ptr_sync;
    wire [PTR_BITS-1:0]  write_ptr_when_full = read_ptr_sync + DEPTH;

    assign empty = (read_ptr  == read_ptr_when_empty);
    assign full  = (write_ptr == write_ptr_when_full);

    dual_port_sram #(
        .WIDTH      (WIDTH),
        .DEPTH      (DEPTH)
    ) ram (
        .read_clk    (read_clk),
        .read_addr   (read_addr),
        .read        (read),
        .read_data   (read_data),
        .write_clk   (write_clk),
        .write_addr  (write_addr),
        .write       (write),
        .write_data  (write_data)
    );

    wire write_rstn_sync;
    reset_synchronizer rst_sync_wr (
        .clk            (write_clk),
        .resetn         (~areset),
        .resetn_sync    (write_rstn_sync)
    );

    binary_counter #(
        .WIDTH  (PTR_BITS)
    ) write_addr_counter (
        .clk    (write_clk),
        .reset  (~write_rstn_sync),
        .incr   (write),
        .count  (write_ptr)
    );

    wire read_rstn_sync;
    reset_synchronizer rst_sync_rd (
        .clk            (read_clk),
        .resetn         (~areset),
        .resetn_sync    (read_rstn_sync)
    );

    binary_counter #(
        .WIDTH  (PTR_BITS)
    ) read_addr_counter (
        .clk    (read_clk),
        .reset  (~read_rstn_sync),
        .incr   (read),
        .count  (read_ptr)
    );

    pointer_synchronizer #(
        .WIDTH      (PTR_BITS)
    ) wr_ptr_sync (
        .input_clk  (write_clk),
        .input_ptr  (write_ptr),
        .output_clk (read_clk),
        .output_ptr (write_ptr_sync)
    );

    pointer_synchronizer #(
        .WIDTH      (PTR_BITS)
    ) rd_ptr_sync (
        .input_clk  (read_clk),
        .input_ptr  (read_ptr),
        .output_clk (write_clk),
        .output_ptr (read_ptr_sync)
    );
endmodule
