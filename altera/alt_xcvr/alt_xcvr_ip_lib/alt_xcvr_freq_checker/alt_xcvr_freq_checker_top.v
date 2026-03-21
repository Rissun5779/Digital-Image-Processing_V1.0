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


//-------------------------------------------------------------------
// Filename    : alt_xcvr_atx_tester_top.v
//
// Description : Generic frequency checker
//
// In the default mode, this module is used to measure the frequency at
// the 'measured_clock input' port. Feed a reference clock to the ref_clock
// port and set parameter 'COUNT' to the value of the ref_clock frequency 
// in MHz. For example, if ref_clock is 100MHz then count is 100. Feed the
// clock that needs to be measured at the "measured_clock" port. clkout_freq
// reports the value of the 'measured_clock' in MHz.
//
// If the measured clock is generated from a TX PLL (e.g. ATX/CMU/FPLL in 
// transceiver mode), you must connect the clock to the
// 'measured_clock_tx_serial' port.
//
// Limitation  : None
//
// Authors     : dunnikri
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

(* ALTERA_ATTRIBUTE = {"-name SDC_STATEMENT \"set_false_path -from [get_registers *freq_check*\|master_count\[*\]] -to [get_registers *freq_check*\|clkout_freq_count\[*\]]\"; -name SDC_STATEMENT \"set_false_path -from [get_registers *freq_check*\|master_count\[*\]] -to [get_registers *freq_check*\|freq_measure_done]\"; -name SDC_STATEMENT \"set_false_path -to [get_registers *freq_check*\|clkout_freq_count\[*\]]\"; -name SDC_STATEMENT \"set_false_path -to [get_registers *freq_check*\|master_count\[*\]]\"; -name SDC_STATEMENT \"set_false_path -to [get_registers *freq_check*\|freq_measure_done]\""} *)

module alt_xcvr_freq_checker_top #(
    parameter CHANNELS=1,
    parameter COUNT=156
) (
   input                           ref_clock,
   input [CHANNELS-1:0]            measured_clock,  
   input [CHANNELS-1:0]            start_freq_check,
   output [CHANNELS*16-1:0]        clkout_freq,
   output [CHANNELS*16-1:0]        master_freq,
   output [CHANNELS-1:0]           freq_measured
);

    wire [15:0]        clkout_f[CHANNELS-1:0];
    wire [15:0]        master_f[CHANNELS-1:0];

    genvar i;
    generate 
        for(i=0;i<CHANNELS;i=i+1) begin:freq_check
            alt_xcvr_freq_checker #(
                .COUNT(COUNT)            
            ) checker_inst (
                .ref_clock          (ref_clock),
                .measured_clock     (measured_clock[i]),
                .reset_freq_count   (!start_freq_check[i]),
                .start_master_count (start_freq_check[i]),
                .clkout_freq        (clkout_f[i]),
                .master_freq        (master_f[i]),
                .freq_measured      (freq_measured[i])
            );

            assign clkout_freq[16*(i+1)-1:16*i] = clkout_f[i];
            assign master_freq[16*(i+1)-1:16*i] = master_f[i];
        end
    endgenerate  
endmodule // freq_check
