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



///////////////////////////////////////////////////////////////////////////////
// EMIF Simulation Checker for Avl Traffic Generator
//
///////////////////////////////////////////////////////////////////////////////

module altera_emif_sim_checker # (
   parameter NUM_OF_TG_IFS = 1,
   parameter NUM_OF_EMIF_IFS = 1
) (
   input logic traffic_gen_pass_0,
   input logic traffic_gen_fail_0,
   input logic traffic_gen_timeout_0,
   input logic traffic_gen_pass_1,
   input logic traffic_gen_fail_1,
   input logic traffic_gen_timeout_1,
   input logic traffic_gen_pass_2,
   input logic traffic_gen_fail_2,
   input logic traffic_gen_timeout_2,
   input logic traffic_gen_pass_3,
   input logic traffic_gen_fail_3,
   input logic traffic_gen_timeout_3,
   input logic traffic_gen_pass_4,
   input logic traffic_gen_fail_4,
   input logic traffic_gen_timeout_4,
   input logic traffic_gen_pass_5,
   input logic traffic_gen_fail_5,
   input logic traffic_gen_timeout_5,
   input logic traffic_gen_pass_6,
   input logic traffic_gen_fail_6,
   input logic traffic_gen_timeout_6,
   input logic traffic_gen_pass_7,
   input logic traffic_gen_fail_7,
   input logic traffic_gen_timeout_7,
   input logic traffic_gen_pass_8,
   input logic traffic_gen_fail_8,
   input logic traffic_gen_timeout_8,
   input logic traffic_gen_pass_9,
   input logic traffic_gen_fail_9,
   input logic traffic_gen_timeout_9,
   input logic traffic_gen_pass_10,
   input logic traffic_gen_fail_10,
   input logic traffic_gen_timeout_10,
   input logic traffic_gen_pass_11,
   input logic traffic_gen_fail_11,
   input logic traffic_gen_timeout_11,
   input logic traffic_gen_pass_12,
   input logic traffic_gen_fail_12,
   input logic traffic_gen_timeout_12,
   input logic traffic_gen_pass_13,
   input logic traffic_gen_fail_13,
   input logic traffic_gen_timeout_13,
   input logic traffic_gen_pass_14,
   input logic traffic_gen_fail_14,
   input logic traffic_gen_timeout_14,
   input logic traffic_gen_pass_15,
   input logic traffic_gen_fail_15,
   input logic traffic_gen_timeout_15,

   input logic  local_cal_success_0,
   input logic  local_cal_fail_0,
   input logic  local_cal_success_1,
   input logic  local_cal_fail_1,
   input logic  local_cal_success_2,
   input logic  local_cal_fail_2,
   input logic  local_cal_success_3,
   input logic  local_cal_fail_3,
   input logic  local_cal_success_4,
   input logic  local_cal_fail_4,
   input logic  local_cal_success_5,
   input logic  local_cal_fail_5,
   input logic  local_cal_success_6,
   input logic  local_cal_fail_6,
   input logic  local_cal_success_7,
   input logic  local_cal_fail_7,
   input logic  local_cal_success_8,
   input logic  local_cal_fail_8,
   input logic  local_cal_success_9,
   input logic  local_cal_fail_9,
   input logic  local_cal_success_10,
   input logic  local_cal_fail_10,
   input logic  local_cal_success_11,
   input logic  local_cal_fail_11,
   input logic  local_cal_success_12,
   input logic  local_cal_fail_12,
   input logic  local_cal_success_13,
   input logic  local_cal_fail_13,
   input logic  local_cal_success_14,
   input logic  local_cal_fail_14,
   input logic  local_cal_success_15,
   input logic  local_cal_fail_15,

   output logic traffic_gen_pass,
   output logic traffic_gen_fail,
   output logic traffic_gen_timeout,

   output logic local_cal_success,
   output logic local_cal_fail
);
   timeunit 1ns;
   timeprecision 1ps;

   logic pass_all;
   logic fail_any;
   logic timeout_any;
   logic cal_pass_all;
   logic cal_fail_any;

   logic [15:0] pass_vec;
   logic [15:0] fail_vec;
   logic [15:0] timeout_vec;
   logic [15:0] cal_pass_vec;
   logic [15:0] cal_fail_vec;

   assign pass_vec    = { (NUM_OF_TG_IFS > 15) ? traffic_gen_pass_15 : 1'b1,
                          (NUM_OF_TG_IFS > 14) ? traffic_gen_pass_14 : 1'b1,
                          (NUM_OF_TG_IFS > 13) ? traffic_gen_pass_13 : 1'b1,
                          (NUM_OF_TG_IFS > 12) ? traffic_gen_pass_12 : 1'b1,
                          (NUM_OF_TG_IFS > 11) ? traffic_gen_pass_11 : 1'b1,
                          (NUM_OF_TG_IFS > 10) ? traffic_gen_pass_10 : 1'b1,
                          (NUM_OF_TG_IFS >  9) ? traffic_gen_pass_9  : 1'b1,
                          (NUM_OF_TG_IFS >  8) ? traffic_gen_pass_8  : 1'b1,
                          (NUM_OF_TG_IFS >  7) ? traffic_gen_pass_7  : 1'b1,
                          (NUM_OF_TG_IFS >  6) ? traffic_gen_pass_6  : 1'b1,
                          (NUM_OF_TG_IFS >  5) ? traffic_gen_pass_5  : 1'b1,
                          (NUM_OF_TG_IFS >  4) ? traffic_gen_pass_4  : 1'b1,
                          (NUM_OF_TG_IFS >  3) ? traffic_gen_pass_3  : 1'b1,
                          (NUM_OF_TG_IFS >  2) ? traffic_gen_pass_2  : 1'b1,
                          (NUM_OF_TG_IFS >  1) ? traffic_gen_pass_1  : 1'b1,
                          (NUM_OF_TG_IFS >  0) ? traffic_gen_pass_0  : 1'b1 };

   assign fail_vec    = { (NUM_OF_TG_IFS > 15) ? traffic_gen_fail_15 : 1'b0,
                          (NUM_OF_TG_IFS > 14) ? traffic_gen_fail_14 : 1'b0,
                          (NUM_OF_TG_IFS > 13) ? traffic_gen_fail_13 : 1'b0,
                          (NUM_OF_TG_IFS > 12) ? traffic_gen_fail_12 : 1'b0,
                          (NUM_OF_TG_IFS > 11) ? traffic_gen_fail_11 : 1'b0,
                          (NUM_OF_TG_IFS > 10) ? traffic_gen_fail_10 : 1'b0,
                          (NUM_OF_TG_IFS >  9) ? traffic_gen_fail_9  : 1'b0,
                          (NUM_OF_TG_IFS >  8) ? traffic_gen_fail_8  : 1'b0,
                          (NUM_OF_TG_IFS >  7) ? traffic_gen_fail_7  : 1'b0,
                          (NUM_OF_TG_IFS >  6) ? traffic_gen_fail_6  : 1'b0,
                          (NUM_OF_TG_IFS >  5) ? traffic_gen_fail_5  : 1'b0,
                          (NUM_OF_TG_IFS >  4) ? traffic_gen_fail_4  : 1'b0,
                          (NUM_OF_TG_IFS >  3) ? traffic_gen_fail_3  : 1'b0,
                          (NUM_OF_TG_IFS >  2) ? traffic_gen_fail_2  : 1'b0,
                          (NUM_OF_TG_IFS >  1) ? traffic_gen_fail_1  : 1'b0,
                          (NUM_OF_TG_IFS >  0) ? traffic_gen_fail_0  : 1'b0 };

   assign timeout_vec = { (NUM_OF_TG_IFS > 15) ? traffic_gen_timeout_15 : 1'b0,
                          (NUM_OF_TG_IFS > 14) ? traffic_gen_timeout_14 : 1'b0,
                          (NUM_OF_TG_IFS > 13) ? traffic_gen_timeout_13 : 1'b0,
                          (NUM_OF_TG_IFS > 12) ? traffic_gen_timeout_12 : 1'b0,
                          (NUM_OF_TG_IFS > 11) ? traffic_gen_timeout_11 : 1'b0,
                          (NUM_OF_TG_IFS > 10) ? traffic_gen_timeout_10 : 1'b0,
                          (NUM_OF_TG_IFS >  9) ? traffic_gen_timeout_9  : 1'b0,
                          (NUM_OF_TG_IFS >  8) ? traffic_gen_timeout_8  : 1'b0,
                          (NUM_OF_TG_IFS >  7) ? traffic_gen_timeout_7  : 1'b0,
                          (NUM_OF_TG_IFS >  6) ? traffic_gen_timeout_6  : 1'b0,
                          (NUM_OF_TG_IFS >  5) ? traffic_gen_timeout_5  : 1'b0,
                          (NUM_OF_TG_IFS >  4) ? traffic_gen_timeout_4  : 1'b0,
                          (NUM_OF_TG_IFS >  3) ? traffic_gen_timeout_3  : 1'b0,
                          (NUM_OF_TG_IFS >  2) ? traffic_gen_timeout_2  : 1'b0,
                          (NUM_OF_TG_IFS >  1) ? traffic_gen_timeout_1  : 1'b0,
                          (NUM_OF_TG_IFS >  0) ? traffic_gen_timeout_0  : 1'b0 };

   assign cal_pass_vec= { (NUM_OF_EMIF_IFS > 15) ? local_cal_success_15 : 1'b1,
                          (NUM_OF_EMIF_IFS > 14) ? local_cal_success_14 : 1'b1,
                          (NUM_OF_EMIF_IFS > 13) ? local_cal_success_13 : 1'b1,
                          (NUM_OF_EMIF_IFS > 12) ? local_cal_success_12 : 1'b1,
                          (NUM_OF_EMIF_IFS > 11) ? local_cal_success_11 : 1'b1,
                          (NUM_OF_EMIF_IFS > 10) ? local_cal_success_10 : 1'b1,
                          (NUM_OF_EMIF_IFS >  9) ? local_cal_success_9  : 1'b1,
                          (NUM_OF_EMIF_IFS >  8) ? local_cal_success_8  : 1'b1,
                          (NUM_OF_EMIF_IFS >  7) ? local_cal_success_7  : 1'b1,
                          (NUM_OF_EMIF_IFS >  6) ? local_cal_success_6  : 1'b1,
                          (NUM_OF_EMIF_IFS >  5) ? local_cal_success_5  : 1'b1,
                          (NUM_OF_EMIF_IFS >  4) ? local_cal_success_4  : 1'b1,
                          (NUM_OF_EMIF_IFS >  3) ? local_cal_success_3  : 1'b1,
                          (NUM_OF_EMIF_IFS >  2) ? local_cal_success_2  : 1'b1,
                          (NUM_OF_EMIF_IFS >  1) ? local_cal_success_1  : 1'b1,
                          (NUM_OF_EMIF_IFS >  0) ? local_cal_success_0  : 1'b1 };

   assign cal_fail_vec= { (NUM_OF_EMIF_IFS > 15) ? local_cal_fail_15 : 1'b0,
                          (NUM_OF_EMIF_IFS > 14) ? local_cal_fail_14 : 1'b0,
                          (NUM_OF_EMIF_IFS > 13) ? local_cal_fail_13 : 1'b0,
                          (NUM_OF_EMIF_IFS > 12) ? local_cal_fail_12 : 1'b0,
                          (NUM_OF_EMIF_IFS > 11) ? local_cal_fail_11 : 1'b0,
                          (NUM_OF_EMIF_IFS > 10) ? local_cal_fail_10 : 1'b0,
                          (NUM_OF_EMIF_IFS >  9) ? local_cal_fail_9  : 1'b0,
                          (NUM_OF_EMIF_IFS >  8) ? local_cal_fail_8  : 1'b0,
                          (NUM_OF_EMIF_IFS >  7) ? local_cal_fail_7  : 1'b0,
                          (NUM_OF_EMIF_IFS >  6) ? local_cal_fail_6  : 1'b0,
                          (NUM_OF_EMIF_IFS >  5) ? local_cal_fail_5  : 1'b0,
                          (NUM_OF_EMIF_IFS >  4) ? local_cal_fail_4  : 1'b0,
                          (NUM_OF_EMIF_IFS >  3) ? local_cal_fail_3  : 1'b0,
                          (NUM_OF_EMIF_IFS >  2) ? local_cal_fail_2  : 1'b0,
                          (NUM_OF_EMIF_IFS >  1) ? local_cal_fail_1  : 1'b0,
                          (NUM_OF_EMIF_IFS >  0) ? local_cal_fail_0  : 1'b0 };

   assign pass_all    = &pass_vec;
   assign fail_any    = |fail_vec;
   assign timeout_any = |timeout_vec;
   assign cal_pass_all= &cal_pass_vec;
   assign cal_fail_any= |cal_fail_vec;

   assign traffic_gen_pass    = pass_all;
   assign traffic_gen_fail    = fail_any;
   assign traffic_gen_timeout = timeout_any;

   assign local_cal_success = cal_pass_all;
   assign local_cal_fail = cal_fail_any;

   // synthesis translate_off
   always @(posedge pass_all)
   begin
      $display("          --- SIMULATION PASSED --- ");
      $finish;
   end

   always @(posedge fail_any)
   begin
      $display("          --- SIMULATION FAILED ON R/W --- ");
      $finish;
   end

   always @(posedge timeout_any)
   begin
      $display("          --- SIMULATION FAILED ON TIMEOUT --- ");
      $finish;
   end

   always @(posedge cal_pass_all)
   begin
      $display("          --- CALIBRATION PASSED --- ");
   end
   always @(posedge cal_fail_any)
   begin
      $display("          --- CALIBRATION FAILED --- ");
      $finish;
   end
   // synthesis translate_on
endmodule
