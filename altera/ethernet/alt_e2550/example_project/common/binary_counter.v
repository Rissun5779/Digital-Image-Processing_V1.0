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
module binary_counter #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   reset,
    input                   incr,
    output reg [WIDTH-1:0]  count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 'd0;
        end else begin
            if (incr) begin
                count <= count + 'd1;
            end else begin
                count <= count;
            end
        end
    end
endmodule
