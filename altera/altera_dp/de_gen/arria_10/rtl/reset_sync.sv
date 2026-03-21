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


//
//
module reset_sync #(parameter logic ASYNC_RESET_ACTIVE_HI = 1'b1)
(
    input   logic clk,
    input   logic async_reset,
    output  logic sync_reset
);


    logic [1:0] reset_pipe;
    logic active_high_reset;

    assign active_high_reset = ASYNC_RESET_ACTIVE_HI ? async_reset : ~async_reset;
    always_ff @(posedge clk or posedge active_high_reset) begin
        if (active_high_reset) begin
            reset_pipe <= 2'b11;
        end else begin
            reset_pipe <= {reset_pipe[0], 1'b0};
        end
    end

    assign sync_reset = reset_pipe[1];

endmodule

