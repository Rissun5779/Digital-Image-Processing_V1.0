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




module altera_emif_ctrl_rld2_bank_timer # (
   // tRC in controller cycles
   parameter CTL_T_RC   = 0
) (
   input   logic  clk,
   input   logic  reset_n,
   input   logic  do_access,
   output  logic  can_access
);
   timeunit 1ps;
   timeprecision 1ps;

   //////////////////////////////////////////////////////////////////////////////
   // BEGIN LOCALPARAM SECTION

   // tRC timer reset value
   // Subtract two cycles to compensate for latency with the FSM
   localparam TIMER_RESET_VALUE   = CTL_T_RC - 2;
   // The width of the tRC timer
   localparam TIMER_WIDTH         = max(1, ceil_log2(TIMER_RESET_VALUE + 1));

   // END LOCALPARAM SECTION
   //////////////////////////////////////////////////////////////////////////////

   reg   [TIMER_WIDTH-1:0]   timer;

   // Timer logic
   always_ff @(posedge clk or negedge reset_n)
   begin
      if (!reset_n) begin
         timer <= TIMER_RESET_VALUE[TIMER_WIDTH-1:0];
         can_access <= (TIMER_RESET_VALUE[TIMER_WIDTH-1:0] == 0);
      end else begin
         if (do_access) begin
            timer <= TIMER_RESET_VALUE[TIMER_WIDTH-1:0];
            can_access <= (TIMER_RESET_VALUE[TIMER_WIDTH-1:0] == 0);
         end else if (timer != 0) begin
            timer <= timer - 1'b1;
            can_access <= (timer == 1);
         end else begin
            can_access <= (timer == 0);
         end
      end
   end


   // Returns the maximum of two numbers
   function integer max;
      input integer a;
      input integer b;
      begin
         max = (a > b) ? a : b;
      end
   endfunction


   // Calculate the ceiling of log_2 of the input value
   function integer ceil_log2;
      input integer value;
      begin
         value = value - 1;
         for (ceil_log2 = 0; value > 0; ceil_log2 = ceil_log2 + 1)
            value = value >> 1;
      end
   endfunction


   // Simulation assertions
   // synthesis translate_off
   initial
   begin
      assert (CTL_T_RC > 0) else $error ("Invalid tRC");
   end

   always_ff @(posedge clk)
   begin
      if (reset_n)
      begin
         if (!can_access)
            assert (!do_access) else $error ("tRC requirement violation");
      end
   end
   // synthesis translate_on


endmodule

