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


// 2 cycle delay
module frame_undersized (
    input clk,
    input [15:0] size,
    output reg undersized
);

    // size < 64
    // size[15:6] == 10'd0
    reg upper_half_zero;
    reg lower_half_zero;
    always @(posedge clk) begin
        upper_half_zero <= (size[15:11] == 5'b00000);
        lower_half_zero <= (size[10:6]  == 5'b00000);
        undersized <= upper_half_zero && lower_half_zero;
    end
endmodule
