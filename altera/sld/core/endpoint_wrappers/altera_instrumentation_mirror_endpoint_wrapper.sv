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


// altera_instrumentation_mirror_endpoint.sv

`timescale 1 ns / 1 ns

package altera_instrumentation_mirror_endpoint_wpackage;

function integer nonzero;
input value;
begin
	nonzero = (value > 0) ? value : 1;
end
endfunction

endpackage

module altera_instrumentation_mirror_endpoint_wrapper
    import altera_instrumentation_mirror_endpoint_wpackage::nonzero;
#(
    parameter COUNT          = 1,
    parameter WIDTH          = 8,
    parameter NODES          = "",
    parameter CLOCKS         = ""
) (
    input  [WIDTH-1:0] mirror_send,
    output [WIDTH-1:0] mirror_receive
);

	altera_instrumentation_mirror_endpoint #(
        .COUNT          (COUNT),
        .WIDTH          (WIDTH),
        .NODES          (NODES),
        .CLOCKS         (CLOCKS)
) inst (
        .mirror_send    (mirror_send),
        .mirror_receive (mirror_receive)
	
	);

endmodule

// synthesis translate_off
// Empty module definition to allow simulation compilation.
module altera_instrumentation_mirror_endpoint
    import altera_instrumentation_mirror_endpoint_wpackage::nonzero;
#(
    parameter COUNT          = 1,
    parameter WIDTH          = 8,
    parameter NODES          = "",
    parameter CLOCKS         = ""
) (
    input  [WIDTH-1:0] mirror_send,
    output [WIDTH-1:0] mirror_receive
);
endmodule
// synthesis translate_on

