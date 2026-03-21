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


// ---------------------------------------------
// Up-down counter that tracks the number of outstanding
// responses.
//
// There might be a potential fmax optimization if we
// use credits instead of an up-down counter.
// ---------------------------------------------
module alt_hiconnect_cmd_rsp_counter
#(
    parameter COUNTER_W = 4
)
(
    input       clk,
    input       reset,

    input       nonposted_cmd_accepted,
    input       response_accepted,

    output reg  has_pending_responses
);

    reg  [COUNTER_W-1 : 0]  pending_response_count;
    reg  [COUNTER_W-1 : 0]  next_pending_response_count;

    wire                    count_is_1;
    wire                    count_is_0;

    reg internal_sclr;

    always @(posedge clk) begin
        internal_sclr <= reset;
    end

    always @* begin
        next_pending_response_count = pending_response_count;

        if (nonposted_cmd_accepted)
            next_pending_response_count = pending_response_count + 1'b1;
        if (response_accepted)
            next_pending_response_count = pending_response_count - 1'b1;
        if (nonposted_cmd_accepted && response_accepted)
            next_pending_response_count = pending_response_count;
    end

    assign count_is_1 = (pending_response_count == 1);
    assign count_is_0 = (pending_response_count == 0);

    always @(posedge clk) begin
        if (internal_sclr) begin
            pending_response_count <= 0;
            has_pending_responses  <= 0;
        end
        else begin
            pending_response_count <= next_pending_response_count;
            has_pending_responses  <= has_pending_responses 
                && ~(count_is_1 && response_accepted && ~nonposted_cmd_accepted)
                || (count_is_0 && nonposted_cmd_accepted && ~response_accepted);
        end
    end

    // ---------------------------------------------
    // Assertions that detect the cases of counter overflow
    // and underflow. The counter probably needs to be wider
    // if any of these assertions are triggered.
    // ---------------------------------------------
    localparam MAX_CTR_VAL = (1 << COUNTER_W) - 1;

    ctr_overflow: 
        assert property (
            @(posedge clk) disable iff (reset)
            !((pending_response_count === MAX_CTR_VAL) && nonposted_cmd_accepted && !response_accepted)
        );

    ctr_underflow:  
        assert property (
            @(posedge clk) disable iff (reset)
            !((pending_response_count === 0) && response_accepted)
        );


endmodule
