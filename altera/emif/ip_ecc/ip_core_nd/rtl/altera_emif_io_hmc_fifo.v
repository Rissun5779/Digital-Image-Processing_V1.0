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


`timescale 1 ps / 1 ps

module altera_emif_io_hmc_fifo #
    ( parameter
        CFG_ADDR_WIDTH        = 10,
        CFG_DATA_WIDTH        = 32,
        CFG_REGISTERED_OUTPUT = 0,
        CFG_SHOWAHEAD         = 0
    )
    (
        ctl_clk,
        ctl_reset_n,
        write_request,
        write_data,
        read_request,
        read_data,
        read_data_valid,
        fifo_empty,
        fifo_full
    );

localparam SCFIFO_DEPTH             = 2 ** CFG_ADDR_WIDTH;
localparam SCFIFO_REGISTERED_OUTPUT = CFG_REGISTERED_OUTPUT ? "ON" : "OFF";
localparam SCFIFO_SHOWAHEAD         = CFG_SHOWAHEAD         ? "ON" : "OFF";

input                           ctl_clk;
input                           ctl_reset_n;

input                           write_request;
input  [CFG_DATA_WIDTH - 1 : 0] write_data;

input                           read_request;
output [CFG_DATA_WIDTH - 1 : 0] read_data;
output                          read_data_valid;

output                          fifo_empty;
output                          fifo_full;

    wire [CFG_DATA_WIDTH - 1 : 0] read_data;
    wire                          read_data_valid;
    wire                          fifo_empty;
    wire                          fifo_full;
    wire zero;
    
    assign zero            =  1'b0;
    assign read_data_valid = ~fifo_empty;

    scfifo #
    (
        .add_ram_output_register    (SCFIFO_REGISTERED_OUTPUT   ),
        .intended_device_family     ("Stratix IV"               ),
        .lpm_numwords               (SCFIFO_DEPTH               ),
        .lpm_showahead              (SCFIFO_SHOWAHEAD           ),
        .lpm_type                   ("scfifo"                   ),
        .lpm_width                  (CFG_DATA_WIDTH             ),
        .lpm_widthu                 (CFG_ADDR_WIDTH             ),
        .overflow_checking          ("OFF"                      ),
        .underflow_checking         ("OFF"                      ),
        .use_eab                    ("ON"                       )
    )
    scfifo_inst
    (
        .aclr                       (~ctl_reset_n               ),
        .clock                      ( ctl_clk                   ),
        .data                       ( write_data                ),
        .rdreq                      ( read_request              ),
        .wrreq                      ( write_request             ),
        .empty                      ( fifo_empty                ),
        .full                       ( fifo_full                 ),
        .q                          ( read_data                 ),
        .almost_empty               (                           ),
        .almost_full                (                           ),
        .sclr                       ( zero                      ),
        .usedw                      (                           )
    );

endmodule
