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


module reset_gen #(parameter CNTR_WIDTH = 8) (
    input   logic pb_resetn,
    input   logic clk,
    output  logic reset,
    output  logic reset_n
);

    bit local_reset;
    bit [CNTR_WIDTH-1:0] cntr;
    
    reset_sync #(.ASYNC_RESET_ACTIVE_HI(1'b0))
    reset_sync (
        .clk            (clk),
        .async_reset    (pb_resetn),
        .sync_reset     (local_reset)
    );

 
    always_ff @ (posedge clk or posedge local_reset) begin
        if (local_reset) begin
            reset   <= 1'b1;
            reset_n <= 1'b0;
            cntr    <= {CNTR_WIDTH{1'b0}};
        end else begin
            reset   <= ~cntr[CNTR_WIDTH-1];
            reset_n <=  cntr[CNTR_WIDTH-1];
            if (reset) begin
                cntr <= cntr + 1'b1;
            end
        end
    end



endmodule
