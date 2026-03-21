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



module test_top();

  parameter DEVICE_FAMILY        = "Arria 10";   // Aria10
  parameter NUM_LANES            = 12;           // number of lanes
  parameter INTERNAL_WORDS       = 8;            // number of segment (words) in the user interface
  parameter REFCLK_PERIOD        = 3200;         // 312.5MHz for 6.25G and 12.5G
  parameter FIFTY_M_PERIOD       = 20000;        // 100Mhz

  reg refclk = 1'b0;
  always #(REFCLK_PERIOD/2)  refclk = ~refclk;

  reg clk50 = 1'b0;
  always #(FIFTY_M_PERIOD/2)  clk50  = ~clk50;


  wire [NUM_LANES-1:0] tx_pin;
  
  reg sys_reset_n;

  example_design #(
    .DEVICE_FAMILY        (DEVICE_FAMILY        ), // "Arria 10",    // Stratix V or Arria 10
    .NUM_LANES            (NUM_LANES            ),
    .SIM_MODE             (1),
    .INTERNAL_WORDS       (INTERNAL_WORDS       ) 
  ) inst_example_design (

    .sys_pll_reset_n      (sys_reset_n          ), // input                                
    .pll_ref_clk          (refclk               ), // input                                
    .clk50                (clk50                ),
  
    .tx_pin               (tx_pin               ), 
    .rx_pin               (                     ),                  // external loopback

    .test_failed_n        (test_failed_n        ),
    .test_success_n       (test_success_n       ),
    .test_done_n          (test_done_n          )
  
  );

initial begin
  sys_reset_n = 1'b1;
  wait (test_done_n == 1'b0);
  # 500 if (test_failed_n == 1'b0) $display ("TEST Failed!");
       else  $display ($time, " TEST Passed!");
  repeat (50) @clk50;
  sys_reset_n = 1'b0;
  repeat (50) @clk50;
  sys_reset_n = 1'b1;
  repeat (500) @clk50;
  wait (test_done_n == 1'b0);
  # 500 if (test_failed_n == 1'b0) $display ("TEST Failed!");
       else  $display ($time, " TEST Passed!");
  $finish;
end

endmodule
