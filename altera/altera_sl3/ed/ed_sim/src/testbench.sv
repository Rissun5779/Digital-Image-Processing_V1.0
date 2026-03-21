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
`define  CONTINUOUS                       0
`define  BURST                            1
`include "testbench_defs.v"

module testbench #
(
   parameter                        USER_CLOCK_FREQUENCY       = 150.00e6,
   parameter                        LANES                      = 4,                       // Number of lanes on the link
   parameter                        DIRECTION                  = "Duplex",
   parameter                        ADVANCED_CLOCKING          = 0,
   parameter                        ECC_EN                     = 0,
   parameter                        LANE_SKEW_ENABLE           = 1,
   parameter                        TOTAL_SAMPLES_TO_TRANSFER  = 100000,                  // Total words transferred during the test (needed by included test files)
   parameter                        PLL_REF_FREQ               = 103.125e6,              // Numerical_value in MHz for Transceiver Reference clock frequency
   parameter real                   MGMT_CLK_PERIOD            = 10.000e3                 // Transceiver reconfig clock period in ps
)
(
   output reg                       source_user_clock,
   output reg                       source_user_clock_reset,
   output reg                       sink_user_clock,
   output reg                       sink_user_clock_reset,
   output reg                       sink_pll_ref_clk,
   output reg                       source_pll_ref_clk,
   output reg                       mgmt_clk,
   output reg                       sink_test_reset,
   output reg                       source_test_reset,
   output reg                       tc_enable,
   output reg                       tg_enable,
   output reg                       tg_test_mode,
   output reg                       tg_enable_stalls
);


   reg            [0:31]            tb_random_seed;
   integer                          temp_int;

   reg            [0:8*64-1]        test_name                  = "data_forwarding";
   reg                              test_found                 = 0;

   reg                              test_abort                 = 1'b0;
   reg            [0:8*64-1]        dump_mode                  = "off";              // Will dump file be generated, and when? The options are:
                                                                                    //
                                                                                    //   off - No dumpfile is generated.
                                                                                    //   on  - Dumpfile is generated for whole simulation.

   time                             sink_test_reset_delay;
   time                             source_test_reset_delay;

   time                             start_time;
   time                             end_time;
   time                             clock_period;

   integer                          timeout_count;
   integer                          test_timeout;

   time                             source_sample_time;
   reg            [(LANES*64)-1:0]  source_sample_data;

   time                             sink_sample_time;
   reg            [(LANES*64)-1:0]  sink_sample_data;

   time                             link_latency;
   reg                              sampling_done;

   integer                          bursts_received;
   integer                          samples_received;

   integer                          lane;
   integer                          test_lane;

   integer                          error_delay;
   integer                          error_delay_count;


   assign bursts_received  = test_env.tc_burst_count;
   assign samples_received = test_env.tc_words_transferred;


   //*************************************************************************
   //
   // Generate the transceiver reconfiguration clock
   //
   //*************************************************************************

   initial begin

      mgmt_clk = 1'b1;

      forever begin #(MGMT_CLK_PERIOD/2) mgmt_clk = ~mgmt_clk; end

   end


   //*************************************************************************
   //
   // Generate the source transceiver reference clock
   //
   //*************************************************************************

   real        source_pll_ref_clk_period;
   integer     source_pll_ref_clk_period_offset_dir;
   real        source_pll_ref_clk_period_offset_ppm;
   real        source_pll_ref_clk_period_offset;
   real        source_pll_ref_clk_period_actual;

   initial begin

      source_pll_ref_clk = 1'b1;

      source_pll_ref_clk_period             = 1e12/PLL_REF_FREQ; //We pass in the 10^6 parameter from the test_env.v


      source_pll_ref_clk_period_offset_dir  = $urandom_range(1, 0);
      source_pll_ref_clk_period_offset_ppm  = $itor($urandom_range(200, 0))-1e2;
      source_pll_ref_clk_period_offset      = (source_pll_ref_clk_period_offset_dir == 1) ? ((source_pll_ref_clk_period_offset_ppm)/1e6)*source_pll_ref_clk_period : ((source_pll_ref_clk_period_offset_ppm)/1e6)*source_pll_ref_clk_period*(-1);
      source_pll_ref_clk_period_actual      = source_pll_ref_clk_period + source_pll_ref_clk_period_offset;

      $write("\n");
      $write("   Initializing Source transceiver reference clock:\n");
      $write("      Source pll_ref_clk frequency      = %0e \n",      PLL_REF_FREQ);
      $write("      Nominal source pll_ref_clk period = %0e ps\n",  source_pll_ref_clk_period);
      $write("      Source pll_ref_clk period offset  = %0e ppm\n", source_pll_ref_clk_period_offset_ppm);
      $write("      Source pll_ref_clk period         = %0e ps\n",  source_pll_ref_clk_period_actual);

      forever begin #(source_pll_ref_clk_period_actual/2) source_pll_ref_clk = ~source_pll_ref_clk; end
			
	
   end

   //*************************************************************************
   //
   // Generate the source user clock
   //
   //*************************************************************************

	
	real source_user_clock_period;
	real source_user_clock_period_actual;
			
	
   initial begin
      $write("\n");
      $write("   Advanced Clocking Mode Enabled :\n");
      $write("   Generating the Source User Clock :\n");
			
      source_user_clock 							=	1'b1;
      source_user_clock_period 				= 1e12/USER_CLOCK_FREQUENCY; 
      source_user_clock_period_actual	=	source_user_clock_period + source_pll_ref_clk_period_offset;

      forever begin #(source_user_clock_period_actual/2) source_user_clock = ~source_user_clock; end
	end
		

   //*************************************************************************
   //
   // Generate the source Interface/User reset
   //
   //*************************************************************************

   assign	source_user_clock_reset = source_test_reset ;


   //*************************************************************************
   //
   // Generate the sink User clock - for Standard clocking mode
   //
   //*************************************************************************
   
   assign   sink_user_clock = source_user_clock;
   assign	sink_user_clock_reset = sink_test_reset ;
   
   //*************************************************************************
   //
   // Generate the sink transceiver reference clock
   //
   //*************************************************************************

   real        sink_pll_ref_clk_period;
   integer     sink_pll_ref_clk_period_offset_dir;
   real        sink_pll_ref_clk_period_offset_ppm;
   real        sink_pll_ref_clk_period_offset;
   real        sink_pll_ref_clk_period_actual;

   initial begin

      sink_pll_ref_clk = 1'b1;

    //  sink_pll_ref_clk_period             = (PLL_REF_FREQ == "644.53125 MHz") ? 1e12/644.53125e6 :
    //                                        (PLL_REF_FREQ == "103.125 MHz")   ? 1e12/103.125e6 :
    //                                        (PLL_REF_FREQ == "156.25 MHz")    ? 1e12/156.25e6 :
    //                                        (PLL_REF_FREQ == "125.000 MHz")   ? 1e12/125.000e6 : 0e0;

      sink_pll_ref_clk_period             = 1e12/PLL_REF_FREQ; //We pass in the 10^6 parameter from the test_env.v

      sink_pll_ref_clk_period_offset_dir  = $urandom_range(1, 0);
      sink_pll_ref_clk_period_offset_ppm  = $itor($urandom_range(200, 0))-1e2;
      sink_pll_ref_clk_period_offset      = (sink_pll_ref_clk_period_offset_dir == 1) ? ((sink_pll_ref_clk_period_offset_ppm)/1e6)*sink_pll_ref_clk_period : ((sink_pll_ref_clk_period_offset_ppm)/1e6)*sink_pll_ref_clk_period*(-1);
      sink_pll_ref_clk_period_actual      = sink_pll_ref_clk_period + sink_pll_ref_clk_period_offset;

      $write("\n");
      $write("   Initializing Sink transceiver reference clock:\n");
      $write("      Sink pll_ref_clk frequency        = %0e\n",      PLL_REF_FREQ);
      $write("      Nominal sink pll_ref_clk period   = %0e ps\n",  sink_pll_ref_clk_period);
      $write("      Sink pll_ref_clk period offset    = %0e ppm\n", sink_pll_ref_clk_period_offset_ppm);
      $write("      Sink pll_ref_clk period           = %0e ps\n",  sink_pll_ref_clk_period_actual);

      forever begin #(sink_pll_ref_clk_period_actual/2) sink_pll_ref_clk = ~sink_pll_ref_clk; end

   end


   //*************************************************************************
   //
   // Generate the sink core reset
   //
   //*************************************************************************

   initial begin

//    sink_test_reset_delay   = $urandom_range(10000, 0);
      sink_test_reset_delay   = 1000;

      sink_test_reset         = 1'b1;

      #sink_test_reset_delay;

      sink_test_reset         = 1'b0;

   end


   //*************************************************************************
   //
   // Generate the source core reset
   //
   //*************************************************************************

   initial begin

//    source_test_reset_delay   = $urandom_range(10000, 0);
      source_test_reset_delay = 10000;

      source_test_reset       = 1'b1;

      #source_test_reset_delay;

      source_test_reset       = 1'b0;

   end
	 


   //*************************************************************************
   //
   // Latency Characterization Process
   //
   //*************************************************************************

   initial begin

      source_sample_time   = 0;
      source_sample_data   = 0;
      sink_sample_time     = 0;
      sink_sample_data     = 0;
      sampling_done        = 1'b0;

      // Wait for the deassertion of sink_user_clock_reset
      @(posedge test_env.rx_user_clock);
      while (test_env.rx_user_clock_reset == 1'b1) @(posedge test_env.rx_user_clock);

      // Wait for the assertion of rx_valid
      @(posedge test_env.rx_user_clock);
      while (test_env.rx_valid == 1'b0) @(posedge test_env.rx_user_clock);

      // Sample data on the source user interface
      @(posedge test_env.tx_user_clock);
      source_sample_time = $time;
      source_sample_data = test_env.tx_data;

      // Wait for sample data to appear on the sink user interface
      @(posedge test_env.rx_user_clock);
      while (test_env.rx_data != source_sample_data) @(posedge test_env.rx_user_clock);

      sink_sample_time  = $time;

      link_latency   = sink_sample_time - source_sample_time;
      sampling_done  = 1'b1;

   end


   //*************************************************************************
   //
   // Source Error Logging Process
   //
   //*************************************************************************

   integer source_overflow_error_count;
   
   integer source_burst_gap_error_count;
   
   integer source_err_interrupt_count;

   
   initial begin

      source_overflow_error_count = 0;

      source_burst_gap_error_count = 0;

      source_err_interrupt_count = 0;

   end


   always @(posedge test_env.tx_user_clock) begin

      if (test_env.tx_error[0] == 1'b1) source_overflow_error_count = source_overflow_error_count + 1;

      if (test_env.tx_error[3] == 1'b1) source_burst_gap_error_count = source_burst_gap_error_count + 1;

	  if (test_env.tx_err_interrupt == 1'b1) source_err_interrupt_count = source_err_interrupt_count + 1;

   end


   //*************************************************************************
   //
   // Traffic Generator Link State Monitor Process
   //
   //*************************************************************************

   integer tx_link_up_state;


   initial begin

      tx_link_up_state = 0;

   end


   always @(posedge test_env.tx_user_clock) begin

      if ((tx_link_up_state == 0) && (test_env.tx_link_up == 1'b1)) begin

         $write("\n");
         $write("   Source link_up asserted at time %0t\n", $time);
         tx_link_up_state = 1;

      end else if ((tx_link_up_state == 1) && (test_env.tx_link_up == 1'b0)) begin

         $write("\n");
         $write("   Source link_up de-asserted at time %0t\n", $time);
         tx_link_up_state = 0;

      end

   end


   //*************************************************************************
   //
   // Sink Error Logging Process
   //
   //*************************************************************************

   integer sink_overflow_error_count;
   integer sink_underflow_error_count;
   integer sink_loss_of_alignment_normal_error_count;
   integer sink_meta_frame_crc_error_count[LANES];
   integer sink_err_interrupt_count;


   initial begin

      sink_overflow_error_count                 = 0;

      sink_underflow_error_count                = 0;

      sink_loss_of_alignment_normal_error_count = 0;

      sink_err_interrupt_count                  = 0;


      for (lane = 0; lane < LANES; ++lane) begin

         sink_meta_frame_crc_error_count[lane]  = 0;

      end

   end


   always @(posedge test_env.rx_user_clock) begin

      if (test_env.rx_error[LANES+2] == 1'b1)                 sink_overflow_error_count = sink_overflow_error_count + 1;

      if (test_env.rx_error[LANES+1] == 1'b1)                sink_underflow_error_count = sink_underflow_error_count + 1;

      if (test_env.rx_error[LANES] == 1'b1) sink_loss_of_alignment_normal_error_count = sink_loss_of_alignment_normal_error_count + 1;

      for (lane = 0; lane < LANES; ++lane) begin

         if (test_env.rx_error[LANES-(1+lane)] == 1'b1) sink_meta_frame_crc_error_count[lane] = sink_meta_frame_crc_error_count[lane] + 1;

      end

	  if (test_env.rx_err_interrupt == 1'b1) sink_err_interrupt_count = sink_err_interrupt_count + 1;

   end


   //*************************************************************************
   //
   // Traffic Checker Error Logging Process
   //
   //*************************************************************************

   integer lane_swap_error_count;
   integer lane_sequence_error_count;
   integer lane_alignment_error_count;


   initial begin

      lane_swap_error_count      = 0;
      lane_sequence_error_count  = 0;
      lane_alignment_error_count = 0;

   end


   always @(posedge test_env.rx_user_clock) begin

      if (test_env.tc_lane_swap_error      != {LANES{1'b0}})          lane_swap_error_count = lane_swap_error_count + 1;

      if (test_env.tc_lane_sequence_error  != {LANES{1'b0}})      lane_sequence_error_count = lane_sequence_error_count + 1;

      if (test_env.tc_lane_alignment_error != {(LANES){1'b0}}) lane_alignment_error_count = lane_alignment_error_count + 1;

   end


   //*************************************************************************
   //
   // Traffic Checker Link State Monitor Process
   //
   //*************************************************************************

   integer rx_link_up_state;


   initial begin

      rx_link_up_state = 0;

   end


   always @(posedge test_env.rx_user_clock) begin

      if ((rx_link_up_state == 0) && (test_env.rx_link_up == 1'b1)) begin

         $write("\n");
         $write("   Sink link_up asserted at time %0t\n", $time);
         rx_link_up_state = 1;

      end else if ((rx_link_up_state == 1) && (test_env.rx_link_up == 1'b0)) begin

         $write("\n");
         $write("   Sink link_up de-asserted at time %0t\n", $time);
         rx_link_up_state = 0;

      end

   end


   //*************************************************************************
   //
   // Main Test Process
   //
   //*************************************************************************

   initial begin

      timeout_count     = 0;
      test_timeout      = 0;

      tc_enable         = 1'b1;

      tg_enable         = 1'b0;
      tg_test_mode      = `CONTINUOUS;
      tg_enable_stalls  = 1'b0;

      //
      // Initialize the randomization functions.
      //

      // Initialize the random number generator
      $write("\n");
      $write("   Initializing random number generator:\n");

      if ($value$plusargs("random_seed=%d", tb_random_seed)) begin

         $write("      Using command line +random_seed value\n");

      end else begin


      $write ("        Generating random seed\n");
      tb_random_seed = $random;

      end

      $write("      Random number generator seed      = %0d\n", tb_random_seed);
      $write("\n");

      temp_int = $urandom(tb_random_seed);


      //
      // Get the test name from the command line.
      //

      if ($value$plusargs("test_name=%s", test_name)) begin

         $write("   Using command line +test_name value: %0s\n", test_name);

      end else begin

         $write("   Using default test_name: %0s\n", test_name);

      end


      //
      // Get the dump mode from the command line.
      //
      $value$plusargs("dump_mode=%s", dump_mode);

      if (dump_mode == "on") begin
         $dumpfile("mydump.vcd");
         $dumpvars(0, test_env);
         $dumplimit(1024*1024*1024*2);    // 2 GB limit on dumpfile size
         $dumpon;
      end


      // Delay to let other zero time initialization processes complete
      #1


      //
      // Configure the lane skew
      //

      $write("   \n");
      $write("   Inserted Lane Skew:\n");
      for (lane = 0; lane < LANES; ++lane) begin

         test_env.skew_insertion_inst.lane_skew[lane] = (LANE_SKEW_ENABLE == 1) ? $urandom_range(test_env.skew_insertion_inst.max_skew, 0) : 0;
         $write("      Lane %0d skew                       = %0d UI\n", lane, test_env.skew_insertion_inst.lane_skew[lane]);
         //Debugging Purposes
       //vcd  $write("      Lane %0d Delay skew                 = %0d \n", lane, test_env.skew_insertion.lane.delay_reg);
     //    $write("      Lane Rate  %0d                      = %0d \n", lane, test_env.skew_insertion_inst.lane_rate);
      end


      // Wait for the deassertion of source_user_clock_reset
      @(posedge test_env.tx_user_clock);
      while (test_env.tx_user_clock_reset == 1'b1) @(posedge test_env.tx_user_clock);
      $write("   \n");
      $write("   tx_user_clock_reset de-asserted at time %0t\n", $time);

      while(test_env.pll_locked != 1) @(posedge test_env.tx_user_clock);
      // This is for TEST_COMPONENT_EN = true
      //if (DIRECTION == "Duplex") begin
      //    while(test_env.duplex_inst.duplex_inst.altera_sl3_dup.inst_sl3_pll_wrapper.pll_locked != 1) @(posedge test_env.tx_user_clock);
      //end else begin

      //end


      // source user_clock frequency
      @(posedge test_env.tx_user_clock); start_time     = $time;
      @(posedge test_env.tx_user_clock); end_time       = $time;

      clock_period = end_time - start_time;

      $write("      source user_clock frequency              = %0e MHz\n", 10e5/clock_period);


      // sink user_clock frequency
      @(posedge test_env.rx_user_clock); start_time    = $time;
      @(posedge test_env.rx_user_clock); end_time      = $time;

      clock_period = end_time - start_time;

      $write("      sink user_clock frequency              = %0e MHz\n", 10e5/clock_period);



      $write("   \n");
      $write("   *************************************** Test Started *************************************\n");
      $write("   \n");
      $write("   Tests started at time %0t\n", $time);

      //
      // Include supported tests
      //
      `include "test_data_forwarding.v"
//LJHmask      `include "test_source_error.v"
//LJHmask      `ifndef ADVANCED_CLOCKING
//LJHmask          `include "test_sink_overflow_error.v"
//LJHmask          `include "test_sink_underflow_error.v"
//LJHmask      `endif
//LJHmask      `include "test_sink_crc32_error.v"
//LJHmask      `include "test_sink_lane_alignment_normal.v"

      //
      // Check for bad test name
      //
      if (test_found == 0) begin

         $write("   *** ERROR *** : Test named %0s is not a supported test\n", test_name);
         $write("   \n");
         test_abort = 1;

      end

      //
      // Summarize the test results.
      //
      $write("   \n");
      $write("   ************************************** Test Completed ************************************\n");
      $write("   \n");
      $write("   End time                       = %0t\n", $time);
      $write("   \n");
      $write("   Total words tranferred         = %0d\n", samples_received);
      $write("   \n");
      $write("   Number of bursts               = %0d\n", bursts_received);
      $write("   \n");
      $write("   Random number generator seed   = %0d\n", tb_random_seed);
      $write("   \n");
      $write("   Link Latency                   = %0t ns\n", link_latency/1000);
      $write("   \n");

      if (test_abort == 0 && samples_received >= 0 && bursts_received >= 0) begin

         $write("   *************************************** Test Passed **************************************\n");

      end else begin

         $write("   *************************************** Test Failed **************************************\n");

      end

      $write("\n");

      $write("\n");
      $write("   Post delay time                = %0t\n", $time);
      $write("\n");

      $finish;

   end

endmodule
