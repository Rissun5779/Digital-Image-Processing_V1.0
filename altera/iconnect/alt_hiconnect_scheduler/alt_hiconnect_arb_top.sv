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


// ------------------------------------------
// Top level module for the arbitrator unit.
//
// Grants are issued one cycle after the requests.
// A sample timing diagram for a three-input arb:
//
// req   111 111 110 100 000 100 100
// grant 000 001 010 100 100 000 100
//                       *  
// * Note the possibility of a grant when there
//   are no requests
// ------------------------------------------
module alt_hiconnect_arb_top
#(
    parameter NUM_INPUTS = 2,
              MULTIBEAT_PACKETS = 1
)
(
    input                           clk,
    input                           reset,
    input      [NUM_INPUTS - 1 : 0] requests,
    input      [NUM_INPUTS - 1 : 0] eop,
    output reg [NUM_INPUTS - 1 : 0] grant
);

    wire [NUM_INPUTS - 1 : 0] winner;
    wire                      update_grant;
    wire                      update_priority;

    alt_hiconnect_rr_arb
    #(
        .NUM_REQUESTERS (NUM_INPUTS)
    )
    arb
    (
        .clk                    (clk),
        .reset                  (reset),
        .request                (requests),
        .grant                  (winner),
        .increment_top_priority (update_priority)
    );

    // ------------------------------------------
    // Register the grant signal and update the priority vector/matrix
    // in the arbitrator.
    //
    // Because we register the grant before using it, we preemptively
    // rotate priority whenever the arbitrator is idle, or on the last
    // beat of a packet. 
    //
    // There is one corner case when the state goes idle one cycle after  
    // the last beat, but the registered (delayed) grant selects a 
    // requesting input on that cycle which means it isn't idle. We handle 
    // this by only rotating if there are no valid grants.
    // ------------------------------------------
    reg                      idle;
    wire                     valid_grant;
    wire                     last_beat_of_grant;

    assign update_grant = MULTIBEAT_PACKETS ? 
                                (idle && !valid_grant) || last_beat_of_grant :
                                1'b1;

    assign update_priority = MULTIBEAT_PACKETS ? 
                                (idle && !valid_grant && |requests) || last_beat_of_grant :
                                1'b1;


    always @(posedge clk) begin
        if (reset) begin
            idle <= 1'b1;
        end else begin
            if (last_beat_of_grant)
                idle <= 1'b1;
            else if (|requests)
                idle <= 1'b0;
        end
    end

    assign valid_grant = |(requests & grant);
    assign last_beat_of_grant = |(requests & grant & eop);

    always @(posedge clk) begin
        if (update_grant)
            grant <= winner;
    end

    too_many_granted: 
        assert property (@(posedge clk) disable iff (reset)
            $onehot0(grant)
        );

endmodule
