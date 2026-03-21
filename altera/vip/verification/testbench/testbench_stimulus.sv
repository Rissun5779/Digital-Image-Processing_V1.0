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


// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

`timescale 1ps/1ps

`include "../testbench/defines.sv"               

`include "av_mm_class.sv"         
`include "av_mm_control_classes.sv"         
`include "av_st_video_classes.sv"         
`include "av_st_video_file_io_class.sv"         

import avalon_mm_pkg::*;
import verbosity_pkg::*;
import av_mm_control_classes::*;
import av_st_video_classes::*;
import av_st_video_file_io_class::*;

module testbench_stimulus;

// Required for constrained random test.  
localparam TEST_INIT = 1;

bit av_st_reset_n;
bit av_st_clk;
bit av_mm_clk;

bit pass                 = 0;
bit compliance_test_done = 0;
bit clip1_test_done      = 0;
bit all_tests_complete   = 0;
int op_pkts_seen         = 0;

string  error_queue[$];
longint error_time[$];
int     error_severity[$];
int     severity = 0;

event event_constrained_random_generation;
event event_dut_output_analyzed;
   
initial
begin : reset_and_clocks
    av_st_clk <= 1'b0;
    av_mm_clk <= 1'b0;
    av_st_reset_n <= 1'b0;
    #10 @(posedge av_st_clk) av_st_reset_n <= 1'b1;

    `include "warning_banner.sv";

end

always
begin : clock_200mhz
    #2500 av_st_clk <= ~av_st_clk; //200 MHz
end

always
begin : clock_250mhz
    #2000 av_mm_clk <= ~av_mm_clk; //250 MHz
end

assign av_mm_rst = ~av_st_reset_n;

// Instantiate testbench  :
`define TESTBENCH testbench
testbench  `TESTBENCH (.av_mm_reset_reset_n(av_st_reset_n),
                .av_mm_clk_clk(av_mm_clk),
                .av_st_clk_clk(av_st_clk),
                .av_st_reset_reset_n(av_st_reset_n)
                );

///////// Av-MM and AV-ST BFM drivers : //////////

`include "../testbench/bfm_drivers.sv"
`include "av_mm_split_rw_bfm_driver_fnc.sv"

////////  Test code  ///////

bit [15:0] height, width;
int fields_read, r;
string video_format;

// This models the software running on NIOS to enable cores etc :            
`include "../testbench/nios_control_model.sv"

// This runs the actual test - which shall be different for constrained random versus real video :
`include "test.sv"

endmodule

