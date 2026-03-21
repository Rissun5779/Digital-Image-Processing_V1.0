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


// Dual port RAM module designed to
// infer a RAM block
module dual_port_sram #(
    parameter WIDTH     = 8,
    parameter DEPTH     = 16,
    parameter ADDR_BITS = $clog2(DEPTH)
) (
    input                   read_clk,
    input  [ADDR_BITS-1:0]  read_addr,
    input                   read,
    output reg [WIDTH-1:0]  read_data,

    input                   write_clk,
    input  [ADDR_BITS-1:0]  write_addr,
    input                   write,
    input  [WIDTH-1:0]      write_data
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge read_clk) begin
        read_data <= read_data;
        if (read) begin
            read_data <= mem[read_addr];
        end
    end

    genvar i;
    generate
        for (i=0; i<DEPTH; i=i+1) begin : word_loop
            always @(posedge write_clk) begin
                mem[i] <= mem[i];
                if (write) begin
                    if (write_addr == i) begin
                        mem[i] <= write_data;
                    end
                end
            end
        end
    endgenerate
endmodule
