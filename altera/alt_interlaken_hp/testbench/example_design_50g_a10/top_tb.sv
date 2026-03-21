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


// This testbench is used to run example design

`timescale 1 ps / 1 ps

module top_tb ();

   reg pll_ref_clk = 1'b0;
   reg clk50       = 1'b0;
   parameter TX_PKTMOD_ONLY      = 0; //Set to 1, testbench will generate traffic in packet mode. Otherwise will be segment mode.

   parameter INT_TX_CLK_DIV      = 1;
   parameter NUM_LANES           = 8;
   parameter METALEN             = 128;
   parameter SYS_CLK_PERIOD      = 20000;
   parameter NUM_CHAN            = 8'h4;
   parameter CALENDAR_PAGES      = 1;
   parameter LOG_CALENDAR_PAGES  = 1;
   parameter DATA_RATE           = "6250.0 Mbps";
   parameter PLL_OUT_FREQ        = "3125.0 MHz";
   parameter PLL_REFCLK_FREQ     = "312.5 MHz"; // PLL reference clock frequency; should match the one in ilk_core
   parameter REF_CLK_PERIOD      = (PLL_REFCLK_FREQ == "156.25 MHz")     ? 6400 : // PLL reference clock period;
                                   (PLL_REFCLK_FREQ == "195.3125 MHz")   ? 5120 : // PLL reference clock period;
                                   (PLL_REFCLK_FREQ == "250.0 MHz")      ? 4000 : // PLL reference clock period;								  
                                   (PLL_REFCLK_FREQ == "312.5 MHz")      ? 3200 : // PLL reference clock period;
                                   (PLL_REFCLK_FREQ == "390.625 MHz")    ? 2560 : // PLL reference clock period;									  
                                   (PLL_REFCLK_FREQ == "500.0 MHz")      ? 2000 : // PLL reference clock period;
                                   (PLL_REFCLK_FREQ == "625.0 MHz")      ? 1600 : // PLL reference clock period;								  
                                   1;                   // PLL reference clock frequency either not set or set to wrong value

   wire [NUM_LANES-1:0] tx_pin;
   wire [NUM_LANES-1:0] rx_pin;
   wire                 clk_sys;
   wire                 sys_pll_locked;
   wire                 reconfig_done;
   wire [19:0]          checker_errors;
   wire [NUM_LANES-1:0] crc32_err;
   wire                 crc24_err;
   wire                 itx_ready;


   // loopback
   assign rx_pin = tx_pin;

   example_design dut (.*);
      defparam dut.TX_PKTMOD_ONLY  = TX_PKTMOD_ONLY;
      defparam dut.SIM_MODE        = 1'b1;

   always #(SYS_CLK_PERIOD/2) clk50 = ~clk50;
   always #(REF_CLK_PERIOD/2) pll_ref_clk = ~pll_ref_clk;

   initial begin
     $vcdplusfile("waves.vpd") ;
     $vcdpluson ;
   end



endmodule

