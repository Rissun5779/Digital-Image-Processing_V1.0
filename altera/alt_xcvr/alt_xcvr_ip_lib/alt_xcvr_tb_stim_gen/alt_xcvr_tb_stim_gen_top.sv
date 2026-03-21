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


`timescale 1ps/1ps

module alt_xcvr_tb_stim_gen_top #(
    parameter CHANNELS=1,
    parameter pll_ref_clk_period_ps=100,
    parameter mgmt_clk_period_ps=100,
    parameter reset_duration_ns=200,
    parameter simulation_duration_us=800
) (
   output                          pll_ref_clk,
   output                          mgmt_clk,
   output                          mgmt_reset,
   input  [CHANNELS-1:0]           tx_serial_data,  
   output [CHANNELS-1:0]           rx_serial_data,
   input                           pass
);

   localparam NS_TO_PS = 1000;
   localparam US_TO_PS = 1000000;

   localparam PLL_REF_CLK_HALF_PERIOD_PS = pll_ref_clk_period_ps/2; 
   localparam MGMT_CLK_HALF_PERIOD_PS = mgmt_clk_period_ps/2; 

   reg     pll_ref_clk_reg;
   reg     mgmt_clk_reg;
   reg     mgmt_reset_reg;
   
   assign pll_ref_clk = pll_ref_clk_reg;
   assign mgmt_clk    = mgmt_clk_reg;
   assign mgmt_reset  = mgmt_reset_reg;
      
   assign rx_serial_data = tx_serial_data;

   initial
     begin
	pll_ref_clk_reg = 0;
	forever
	  begin
	     #PLL_REF_CLK_HALF_PERIOD_PS                         pll_ref_clk_reg = ~pll_ref_clk_reg;
	     #(pll_ref_clk_period_ps-PLL_REF_CLK_HALF_PERIOD_PS) pll_ref_clk_reg = ~pll_ref_clk_reg;
	  end
     end

   initial
     begin
	mgmt_clk_reg = 0;
	forever
	  begin
	     #MGMT_CLK_HALF_PERIOD_PS                      mgmt_clk_reg = ~mgmt_clk_reg;
	     #(mgmt_clk_period_ps-MGMT_CLK_HALF_PERIOD_PS) mgmt_clk_reg = ~mgmt_clk_reg;
	  end
     end

   initial
     begin
        mgmt_reset_reg = 1'b1;
        #(reset_duration_ns*NS_TO_PS);
        mgmt_reset_reg = 1'b0;
     
        // Timeout thread, timeout if test_pass didn't go high in `TIMEOUT period
        fork:myblock
	   begin
	      //timeout thread
	      #(simulation_duration_us*US_TO_PS);
	      @(posedge mgmt_clk_reg) ;
	      $display ("TIMEOUT, test_pass didn't go high in %d us\n",simulation_duration_us);
	      disable myblock;
	   end
	   //wait for verifier_locks and freq measures are done
	   begin
             @(posedge pass) ;
              $display ("test_pass asserted at %t\n", $realtime);
              $display ("Test case passed\nSimulation passed");
              $display ("SUCCESS: Simulation stopped due to successful completion!");
              disable myblock;
           end
        join

        #30000;
        $finish;
     end


endmodule // freq_check
