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


// Description: tx 1 lane to 1 lane conversion
//
`timescale 1ps / 1ps

module alt_e25_wide_l1if_tx #(
    parameter SYNOPT_READY_LATENCY = 3,
    parameter TARGET_CHIP = 5,
    parameter WIDTH = 64,
    parameter WORDS = 1,
    parameter SYNOPT_TSTAMP_FP_WIDTH = 4,
    parameter SYNOPT_ENABLE_PTP = 1'b0
)(
//--- ports
input                      sclr,
input                      clk,     // User clock

//From the user side
input    [WORDS*64-1:0]    tx_usr_d,        // 8 lane payload data
input                      tx_usr_sop,
input                      tx_usr_eop,
input         [2:0]        tx_usr_eop_empty,
input                      tx_usr_valid,    // This is the only signal that will qualify data 
                                          // Allow user to write extra cycles even when 
                                          // tx_usr_ready is low 
input                      tx_usr_error,
output                     tx_usr_ready,

//To the MAC side
output   [WORDS*WIDTH-1:0] tx_mac_dout,        // 4 lane payload to send
output      [WORDS-1:0]    tx_mac_sop,      // 4 lane start position
output      [WORDS-1:0]    tx_mac_eop,      // 4 lane end of packet
output    [WORDS*3-1:0]    tx_mac_eop_empty,// 4 lane # of empty bytes at eop word
output                     tx_mac_valid,    // Valid cycles
output      [WORDS-1:0]    tx_mac_error,
input                      tx_mac_ready,    // loose ready from MAC will pass that to user 
                                          // as ready signal
//ptp signal
input                               tx_usr_egress_timestamp_request_valid,
input [SYNOPT_TSTAMP_FP_WIDTH-1:0]  tx_usr_egress_timestamp_request_fingerprint,
input                               tx_usr_etstamp_ins_ctrl_timestamp_insert,
input                               tx_usr_etstamp_ins_ctrl_timestamp_format,
input                               tx_usr_etstamp_ins_ctrl_residence_time_update,
input [95:0]                        tx_usr_etstamp_ins_ctrl_ingress_timestamp_96b,
input [63:0]                        tx_usr_etstamp_ins_ctrl_ingress_timestamp_64b,
input                               tx_usr_etstamp_ins_ctrl_residence_time_calc_format,
input                               tx_usr_etstamp_ins_ctrl_checksum_zero,
input                               tx_usr_etstamp_ins_ctrl_checksum_correct,
input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_timestamp,
input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_correction_field,
input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_checksum_field,
input [15:0]                        tx_usr_etstamp_ins_ctrl_offset_checksum_correction,
input                               tx_usr_egress_asymmetry_update,

output                              tx_mac_egress_timestamp_request_valid,
output [SYNOPT_TSTAMP_FP_WIDTH-1:0] tx_mac_egress_timestamp_request_fingerprint,
output                              tx_mac_etstamp_ins_ctrl_timestamp_insert,
output                              tx_mac_etstamp_ins_ctrl_timestamp_format,
output                              tx_mac_etstamp_ins_ctrl_residence_time_update,
output [95:0]                       tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b,
output [63:0]                       tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b,
output                              tx_mac_etstamp_ins_ctrl_residence_time_calc_format,
output                              tx_mac_etstamp_ins_ctrl_checksum_zero,
output                              tx_mac_etstamp_ins_ctrl_checksum_correct,
output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_timestamp,
output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_correction_field,
output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_checksum_field,
output [15:0]                       tx_mac_etstamp_ins_ctrl_offset_checksum_correction,
output                              tx_mac_egress_asymmetry_update
);

    wire        tx_usr_sop_r1, tx_usr_eop_r1, tx_usr_error_r1;
    wire [2:0]  tx_usr_eop_empty_r1;
    wire [63:0] tx_usr_d_r1;

    wire        tx_usr_sop_r2, tx_usr_eop_r2, tx_usr_error_r2;
    wire [2:0]  tx_usr_eop_empty_r2;
    wire [63:0] tx_usr_d_r2;

    wire        tx_usr_sop_r3, tx_usr_eop_r3, tx_usr_error_r3;
    wire [2:0]  tx_usr_eop_empty_r3;
    wire [63:0] tx_usr_d_r3;

    wire [SYNOPT_TSTAMP_FP_WIDTH+96+64+64+8-1:0] ptp_bus_r1;
    wire [SYNOPT_TSTAMP_FP_WIDTH+96+64+64+8-1:0] ptp_bus_r2;
    wire [SYNOPT_TSTAMP_FP_WIDTH+96+64+64+8-1:0] ptp_bus_r3;
    
    wire tx_mac_ready_2;
    alt_e2550_ready_skid #(
        .WIDTH(70)
    ) txskid1 (
        .clk(clk),
        .sclr(sclr),
        .valid_i(1'b1), // input
        .dat_i({tx_usr_sop, tx_usr_eop, tx_usr_error, tx_usr_eop_empty, tx_usr_d}),
        .ready_i(), // output

        .valid_o(), // output
        .dat_o({tx_usr_sop_r1, tx_usr_eop_r1, tx_usr_error_r1, tx_usr_eop_empty_r1, tx_usr_d_r1}), // output
       .ready_o(tx_mac_ready_2) //input
    );

    wire tx_mac_ready_1;
    alt_e2550_ready_skid #(
        .WIDTH(70)
    ) txskid2 (
        .clk(clk),
        .sclr(sclr),
        .valid_i(1'b1), // input
        .dat_i({tx_usr_sop_r1, tx_usr_eop_r1, tx_usr_error_r1, tx_usr_eop_empty_r1, tx_usr_d_r1}),
        .ready_i(tx_mac_ready_2), // output

        .valid_o(), // output
        .dat_o({tx_usr_sop_r2, tx_usr_eop_r2, tx_usr_error_r2, tx_usr_eop_empty_r2, tx_usr_d_r2}), // output
       .ready_o(tx_mac_ready_1) //input
    );

    wire valid_o;
    wire tx_mac_sop_x;
    wire tx_mac_eop_x;
    alt_e2550_ready_skid #(
        .WIDTH(70)
    ) txskid3 (
        .clk(clk),
        .sclr(sclr),
        .valid_i(1'b1), // input
        .dat_i({tx_usr_sop_r2, tx_usr_eop_r2, tx_usr_error_r2, tx_usr_eop_empty_r2, tx_usr_d_r2}),
        .ready_i(tx_mac_ready_1), // output

        .valid_o(valid_o), // output
        .dat_o({tx_mac_sop_x, tx_mac_eop_x, tx_mac_error, tx_mac_eop_empty, tx_mac_dout}), // output
       .ready_o(tx_mac_ready) //input
    );

    assign tx_mac_valid = 1'b1;
    assign tx_usr_ready = tx_mac_ready;
    assign tx_mac_sop   = tx_mac_sop_x && valid_o;
    assign tx_mac_eop   = tx_mac_eop_x && valid_o;
    
    generate if (SYNOPT_ENABLE_PTP) begin:ptp_skid_buffer
        wire ptp_mac_ready_2;
        alt_e2550_ready_skid #(
            .WIDTH(SYNOPT_TSTAMP_FP_WIDTH+96+64+64+8)
        ) ptpskid1 (
            .clk(clk),
            .sclr(sclr),
            .valid_i(1'b1), // input
            .dat_i({tx_usr_egress_timestamp_request_valid,
                    tx_usr_egress_timestamp_request_fingerprint,
                    tx_usr_etstamp_ins_ctrl_timestamp_insert,
                    tx_usr_etstamp_ins_ctrl_timestamp_format,
                    tx_usr_etstamp_ins_ctrl_residence_time_update,
                    tx_usr_etstamp_ins_ctrl_ingress_timestamp_96b,
                    tx_usr_etstamp_ins_ctrl_ingress_timestamp_64b,
                    tx_usr_etstamp_ins_ctrl_residence_time_calc_format,
                    tx_usr_etstamp_ins_ctrl_checksum_zero,
                    tx_usr_etstamp_ins_ctrl_checksum_correct,
                    tx_usr_etstamp_ins_ctrl_offset_timestamp,
                    tx_usr_etstamp_ins_ctrl_offset_correction_field,
                    tx_usr_etstamp_ins_ctrl_offset_checksum_field,
                    tx_usr_etstamp_ins_ctrl_offset_checksum_correction,
                    tx_usr_egress_asymmetry_update}),//input
            .ready_i(), // output

            .valid_o(), // output
            .dat_o(ptp_bus_r1),//output
            .ready_o(ptp_mac_ready_2) //input
        );

        wire ptp_mac_ready_1;
        alt_e2550_ready_skid #(
            .WIDTH(SYNOPT_TSTAMP_FP_WIDTH+96+64+64+8)
        ) ptpskid2 (
            .clk(clk),
            .sclr(sclr),
            .valid_i(1'b1), // input
            .dat_i(ptp_bus_r1),//input
            .ready_i(ptp_mac_ready_2), // output

            .valid_o(), // output
            .dat_o(ptp_bus_r2),//output
            .ready_o(ptp_mac_ready_1) //input
        );

        alt_e2550_ready_skid #(
            .WIDTH(SYNOPT_TSTAMP_FP_WIDTH+96+64+64+8)
        ) ptpskid3 (
            .clk(clk),
            .sclr(sclr),
            .valid_i(1'b1), // input
            .dat_i(ptp_bus_r2),//output
            .ready_i(ptp_mac_ready_1), // output

            .valid_o(), // output
            .dat_o({tx_mac_egress_timestamp_request_valid,
                    tx_mac_egress_timestamp_request_fingerprint,
                    tx_mac_etstamp_ins_ctrl_timestamp_insert,
                    tx_mac_etstamp_ins_ctrl_timestamp_format,
                    tx_mac_etstamp_ins_ctrl_residence_time_update,
                    tx_mac_etstamp_ins_ctrl_ingress_timestamp_96b,
                    tx_mac_etstamp_ins_ctrl_ingress_timestamp_64b,
                    tx_mac_etstamp_ins_ctrl_residence_time_calc_format,
                    tx_mac_etstamp_ins_ctrl_checksum_zero,
                    tx_mac_etstamp_ins_ctrl_checksum_correct,
                    tx_mac_etstamp_ins_ctrl_offset_timestamp,
                    tx_mac_etstamp_ins_ctrl_offset_correction_field,
                    tx_mac_etstamp_ins_ctrl_offset_checksum_field,
                    tx_mac_etstamp_ins_ctrl_offset_checksum_correction,
                    tx_mac_egress_asymmetry_update}),//output
            .ready_o(tx_mac_ready) //input
        );
    end
    endgenerate

endmodule

