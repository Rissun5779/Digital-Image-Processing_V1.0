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


// \$Id: //acds/main/ip/pgm/altera_s10_mailbox_programmable_client/altera_s10_mailbox_programmable_client.sv.terp#2 $
// \$Revision: #2 $
// \$Date: 2016/05/01 $
// \$Author: tgngo $

// -------------------------------------------------------
// Generation parameters:
// length_info: $length_info
// cmd_info: $cmd_info
// debug: $debug
// -------------------------------------------------------

`timescale 1 ns / 1 ns
module altera_s10_temperature_sensor #(
        parameter CMD_WIDTH            = 6
    ) (
        input                   clk,
        input                   reset,

        output logic            cmd_ready,
        input                   cmd_valid,
        input [CMD_WIDTH-1:0]   cmd_data,

        output logic            rsp_valid,
        output logic [31:0]     rsp_data,
        output logic [3:0]      rsp_channel,
        output logic            rsp_startofpacket,
        output logic            rsp_endofpacket
    );

    programable_mailbox_client_inst mbox_client_inst_0 (
        .clk               (clk),
        .reset             (reset),
        .rsp_ready         (1'b1),
        .rsp_valid         (rsp_valid),
        .rsp_data          (rsp_data),
        .rsp_channel       (rsp_channel),
        .rsp_startofpacket (rsp_startofpacket),
        .rsp_endofpacket   (rsp_endofpacket),
        .cmd_valid         (cmd_valid),
        .cmd_ready         (cmd_ready),
        .cmd_data          (cmd_data)
    );

endmodule
