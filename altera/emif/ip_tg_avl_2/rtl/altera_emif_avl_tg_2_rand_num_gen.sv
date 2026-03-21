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


//////////////////////////////////////////////////////////////////////////////
// The random number generator uses the LFSR module to generate random numbers
// within a parametrizable range.
//////////////////////////////////////////////////////////////////////////////
module altera_emif_avl_tg_2_rand_num_gen # (
   parameter RAND_NUM_WIDTH                    = "",
   parameter RAND_NUM_MIN                      = "",
   parameter RAND_NUM_MAX                      = "",
   parameter AMM_BURST_COUNT_DIVISIBLE_BY      = ""
) (
   // Clock and reset
   input                          clk,
   input                          rst,

   // Control and status
   input                         enable,
   output                        ready,

   // Random number generator output
   output[RAND_NUM_WIDTH-1:0]   rand_num
);
   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   // Derive LFSR parameters
   // Generate a number, then multiply by AMM_BURST_COUNT_DIVISIBLE_BY
   localparam RAND_NUM_SHIFT    = log2(AMM_BURST_COUNT_DIVISIBLE_BY);
   localparam LFSR_DATA_RANGE   = ((RAND_NUM_MAX - RAND_NUM_MIN) >> RAND_NUM_SHIFT) + 1;
   localparam LFSR_DATA_WIDTH   = ceil_log2(LFSR_DATA_RANGE);
   localparam LFSR_WIDTH        = max(2, ceil_log2(LFSR_DATA_RANGE + 1));

   generate
   if (RAND_NUM_MIN == RAND_NUM_MAX)
   begin : constant_gen
      // The max and min of the range equal
      // Simply output a constant number

      assign ready = 1'b1;
      assign rand_num = RAND_NUM_MIN;


   end else if (RAND_NUM_MIN < RAND_NUM_MAX)
   begin : random_gen
      // Instantiate the LFSR which is automatically run
      // until the output is within the specified range

      // Registered random number output
      logic                        rand_num_valid_reg;
      logic [RAND_NUM_WIDTH-1:0]   rand_num_reg;


      // LFSR output
      logic                        lfsr_valid;
      logic [LFSR_WIDTH-1:0]       lfsr_data;

      assign ready        = rand_num_valid_reg;
      assign rand_num     = rand_num_reg << RAND_NUM_SHIFT;

      // The LFSR output is valid if it is in the range of 0 and LFSR_DATA_RANGE
      assign lfsr_valid = lfsr_data[LFSR_DATA_WIDTH-1:0] <= LFSR_DATA_RANGE;

      // Output the number within range by adding RAND_NUM_MIN
      always_ff @(posedge clk, posedge rst)
      begin
         if (rst) begin
            rand_num_valid_reg <= 1'b0;
            rand_num_reg       <= '0;


         end else if ((!rand_num_valid_reg && lfsr_valid) || enable) begin
            rand_num_valid_reg <= lfsr_valid;
            rand_num_reg       <= lfsr_data[LFSR_DATA_WIDTH-1:0] + RAND_NUM_MIN[RAND_NUM_WIDTH-1:0];

         end
      end

      // The LFSR module
      altera_emif_avl_tg_2_lfsr # (
         .WIDTH    (LFSR_WIDTH)
      ) lfsr_inst (
         .clk      (clk),
         .rst      (rst),
         .enable   (~lfsr_valid | ~rand_num_valid_reg | enable),
         .data     (lfsr_data),
         .tg_start (),
         .init_val  ()
      );
   end
   endgenerate

   // Simulation assertions
   initial
   begin
      assert (RAND_NUM_MAX >= RAND_NUM_MIN) else $error ("Invalid random number range");
      assert (RAND_NUM_MAX < 2**RAND_NUM_WIDTH) else $error ("Invalid random number width");
   end
endmodule

