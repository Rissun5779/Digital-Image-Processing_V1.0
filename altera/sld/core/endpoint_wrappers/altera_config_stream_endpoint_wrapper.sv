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


// altera_config_stream_endpoint.sv

`timescale 1 ns / 1 ns

package altera_config_stream_endpoint_wpackage;

function integer nonzero;
input value;
begin
	nonzero = (value > 0) ? value : 1;
end
endfunction

endpackage

module altera_config_stream_endpoint_wrapper
    import altera_config_stream_endpoint_wpackage::nonzero;
#(
    parameter READY_LATENCY          = 0,
    parameter HAS_URGENT             = 0,
    parameter HAS_STREAM             = 0,
    parameter MAX_SIZE               = 256,
    parameter STREAM_WIDTH           = 64,
    parameter CLOCK_RATE_CLK         = 0
) (
    input         clk,
    input         reset,
    output        command_ready,
    input         command_valid,
    input  [32-1:0] command_data,
    input         command_startofpacket,
    input         command_endofpacket,
    input         response_ready,
    output        response_valid,
    output [32-1:0] response_data,
    output        response_startofpacket,
    output        response_endofpacket,
    output        urgent_ready,
    input         urgent_valid,
    input  [32-1:0] urgent_data,
    output        stream_ready,
    input         stream_valid,
    input  [STREAM_WIDTH-1:0] stream_data,
    output        stream_active
);

	altera_config_stream_endpoint #(
        .READY_LATENCY          (READY_LATENCY),
        .HAS_URGENT             (HAS_URGENT),
        .HAS_STREAM             (HAS_STREAM),
        .MAX_SIZE               (MAX_SIZE),
        .STREAM_WIDTH           (STREAM_WIDTH),
        .CLOCK_RATE_CLK         (CLOCK_RATE_CLK)
) inst (
        .clk                    (clk),
        .reset                  (reset),
        .command_ready          (command_ready),
        .command_valid          (command_valid),
        .command_data           (command_data),
        .command_startofpacket  (command_startofpacket),
        .command_endofpacket    (command_endofpacket),
        .response_ready         (response_ready),
        .response_valid         (response_valid),
        .response_data          (response_data),
        .response_startofpacket (response_startofpacket),
        .response_endofpacket   (response_endofpacket),
        .urgent_ready           (urgent_ready),
        .urgent_valid           (urgent_valid),
        .urgent_data            (urgent_data),
        .stream_ready           (stream_ready),
        .stream_valid           (stream_valid),
        .stream_data            (stream_data),
        .stream_active          (stream_active)
	
	);

endmodule

// synthesis translate_off
// Empty module definition to allow simulation compilation.
module altera_config_stream_endpoint
    import altera_config_stream_endpoint_wpackage::nonzero;
#(
    parameter READY_LATENCY          = 0,
    parameter HAS_URGENT             = 0,
    parameter HAS_STREAM             = 0,
    parameter MAX_SIZE               = 256,
    parameter STREAM_WIDTH           = 64,
    parameter CLOCK_RATE_CLK         = 0
) (
    input         clk,
    input         reset,
    output        command_ready,
    input         command_valid,
    input  [32-1:0] command_data,
    input         command_startofpacket,
    input         command_endofpacket,
    input         response_ready,
    output        response_valid,
    output [32-1:0] response_data,
    output        response_startofpacket,
    output        response_endofpacket,
    output        urgent_ready,
    input         urgent_valid,
    input  [32-1:0] urgent_data,
    output        stream_ready,
    input         stream_valid,
    input  [STREAM_WIDTH-1:0] stream_data,
    output        stream_active
);
endmodule
// synthesis translate_on

