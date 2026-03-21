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


// altera_debug_master_endpoint.sv

`timescale 1 ns / 1 ns

package altera_debug_master_endpoint_wpackage;

function integer nonzero;
input value;
begin
	nonzero = (value > 0) ? value : 1;
end
endfunction

endpackage

module altera_debug_master_endpoint_wrapper
    import altera_debug_master_endpoint_wpackage::nonzero;
#(
    parameter ADDR_WIDTH                     = 10,
    parameter DATA_WIDTH                     = 32,
    parameter HAS_RDV                        = 1,
    parameter SLAVE_MAP                      = "",
    parameter PREFER_HOST                    = "",
    parameter CLOCK_RATE_CLK                 = 0
) (
    input         clk,
    input         reset,
    output        master_write,
    output        master_read,
    output [ADDR_WIDTH-1:0] master_address,
    output [DATA_WIDTH-1:0] master_writedata,
    input         master_waitrequest,
    input         master_readdatavalid,
    input  [DATA_WIDTH-1:0] master_readdata
);

	altera_debug_master_endpoint #(
        .ADDR_WIDTH                     (ADDR_WIDTH),
        .DATA_WIDTH                     (DATA_WIDTH),
        .HAS_RDV                        (HAS_RDV),
        .SLAVE_MAP                      (SLAVE_MAP),
        .PREFER_HOST                    (PREFER_HOST),
        .CLOCK_RATE_CLK                 (CLOCK_RATE_CLK)
) inst (
        .clk                            (clk),
        .reset                          (reset),
        .master_write                   (master_write),
        .master_read                    (master_read),
        .master_address                 (master_address),
        .master_writedata               (master_writedata),
        .master_waitrequest             (master_waitrequest),
        .master_readdatavalid           (master_readdatavalid),
        .master_readdata                (master_readdata)
	
	);

endmodule

// synthesis translate_off
// Empty module definition to allow simulation compilation.
module altera_debug_master_endpoint
    import altera_debug_master_endpoint_wpackage::nonzero;
#(
    parameter ADDR_WIDTH                     = 10,
    parameter DATA_WIDTH                     = 32,
    parameter HAS_RDV                        = 1,
    parameter SLAVE_MAP                      = "",
    parameter PREFER_HOST                    = "",
    parameter CLOCK_RATE_CLK                 = 0
) (
    input         clk,
    input         reset,
    output        master_write,
    output        master_read,
    output [ADDR_WIDTH-1:0] master_address,
    output [DATA_WIDTH-1:0] master_writedata,
    input         master_waitrequest,
    input         master_readdatavalid,
    input  [DATA_WIDTH-1:0] master_readdata
);
endmodule
// synthesis translate_on

