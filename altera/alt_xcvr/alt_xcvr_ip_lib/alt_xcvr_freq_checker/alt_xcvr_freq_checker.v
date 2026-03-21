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


//Module: FREQUENCY CHECKER
//Description: This module is used to measure the tx_clkout frequency
// Feed a reference clock to the ref clock port
// Feed the clock to measured to the inclock port
// Set parameter count to the value of the ref_clock frequency in MHz. ie if ref_clock is 156MHz then count is 156
// Clkout freq port gives the value of the inclock frequency in MHz.


(* ALTERA_ATTRIBUTE = {"-name SDC_STATEMENT \"set_false_path -from [get_registers *freq_check*\|master_count\[*\]] -to [get_registers *freq_check*\|clkout_freq_count\[*\]]\"; -name SDC_STATEMENT \"set_false_path -from [get_registers *freq_check*\|master_count\[*\]] -to [get_registers *freq_check*\|freq_measure_done]\"; -name SDC_STATEMENT \"set_false_path -to [get_registers *freq_check*\|clkout_freq_count\[*\]]\"; -name SDC_STATEMENT \"set_false_path -to [get_registers *freq_check*\|master_count\[*\]]\"; -name SDC_STATEMENT \"set_false_path -to [get_registers *freq_check*\|freq_measure_done]\""} *)

module alt_xcvr_freq_checker
  (
   ref_clock,
   measured_clock,
   reset_freq_count,
   start_master_count,
   clkout_freq,
   master_freq,
   freq_measured
   );

   input ref_clock;
   input measured_clock;   
   input reset_freq_count;
   input start_master_count;

   output [15:0] clkout_freq;   
   output [15:0] master_freq;
   output 	 freq_measured;

   parameter COUNT = 16'd156;
   

   reg [15:0] 	 master_count =16'd0;
   reg [15:0] 	 clkout_freq_count = 16'd0;
   reg 		 freq_measure_done = 0;
     

   always@ (posedge ref_clock)
     begin
	if (reset_freq_count)
	  begin
	     master_count <= 16'd0;
	  end
	else if (start_master_count && (master_count < COUNT))
	  begin
	     master_count <= master_count+1'b1;
	  end
	else
	  master_count <= master_count;
     end // always@ (posedge ref_clock)

   always@ (posedge measured_clock)
     begin
	if (reset_freq_count)
	  begin
	     clkout_freq_count <= 16'd0;
	     freq_measure_done <= 1'b0;	     
	  end
	else if (start_master_count && (master_count < COUNT))
	  begin
	     clkout_freq_count <= clkout_freq_count+1'b1;
	  end
	else if (master_count == COUNT)
	  begin
	     clkout_freq_count <= clkout_freq_count;
	     freq_measure_done <= 1'b1;
	  end
	else
	  begin
	     clkout_freq_count <= clkout_freq_count;
	     freq_measure_done <= freq_measure_done;
	  end
     end // always@ (posedge measured_clock)


   assign clkout_freq = clkout_freq_count;
   assign master_freq = master_count;
   assign freq_measured = freq_measure_done;


endmodule // freq_check

   

   
		 
  	 
	     
   
