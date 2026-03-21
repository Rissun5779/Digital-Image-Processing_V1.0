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
// The random sequential address generator generates sequential addresses from
// a random start address. The number of sequential addresses between each random
// address is configurable. This is set to 1 for full random mode.
// For simplicity in avoiding overlaps between sequential blocks, generate
// a random address for the upper part and zero the lower part.
//////////////////////////////////////////////////////////////////////////////
module altera_emif_avl_tg_2_rand_seq_addr_gen # (
   //total width of generated address
   parameter ADDR_WIDTH                           = "",
   parameter AMM_BURSTCOUNT_WIDTH                 = "",
   parameter SEQ_ADDR_INCR_WIDTH                  = "",
   parameter NUM_SEQ_ADDR_WIDTH                   = "",
   parameter AMM_BURST_COUNT_DIVISIBLE_BY         = "",
   parameter AMM_WORD_ADDRESS_DIVISIBLE_BY        = ""
) (
   input                             clk,
   input                             rst,
   input                             enable,
   input                             start,

   //number of sequential addresses between each random address
   input [NUM_SEQ_ADDR_WIDTH-1:0]    num_seq_addr,
   //increment size for sequential addresses
   input [SEQ_ADDR_INCR_WIDTH-1:0]   seq_addr_increment,
   input [AMM_BURSTCOUNT_WIDTH-1:0]  burstcount,

   output logic [ADDR_WIDTH-1:0]     addr_out
);
   timeunit 1ns;
   timeprecision 1ps;
   import avl_tg_defs::*;

   localparam ZERO_PAD_WIDTH = log2(AMM_WORD_ADDRESS_DIVISIBLE_BY);
   localparam RAND_ADDR_WIDTH = ADDR_WIDTH - ZERO_PAD_WIDTH;
   localparam LOWER_ADDR_WIDTH = NUM_SEQ_ADDR_WIDTH - ZERO_PAD_WIDTH;
   localparam UPPER_ADDR_WIDTH = RAND_ADDR_WIDTH - LOWER_ADDR_WIDTH;

   wire  [ADDR_WIDTH-1:0]           rand_seq_addr_out;

   logic [UPPER_ADDR_WIDTH-1:0]     upper_addr;
   logic [RAND_ADDR_WIDTH-1:0]      full_addr;
   logic [ADDR_WIDTH-1:0]           seq_addr;
   logic                            gen_rand_addr;
   logic [NUM_SEQ_ADDR_WIDTH-1:0]   seq_addr_cnt;
   logic [ADDR_WIDTH-1:0]           rand_addr_out;
   logic [UPPER_ADDR_WIDTH-1:0]     lfsr_init_val;

   assign rand_addr_out = {upper_addr, {LOWER_ADDR_WIDTH{1'b0}}, {ZERO_PAD_WIDTH{1'b0}}};

   always_ff @ (posedge clk)
   begin
      //go back to start address when starting a new series of reads or writes
      if (start) begin
         seq_addr_cnt <= num_seq_addr;
         seq_addr <= {lfsr_init_val, {LOWER_ADDR_WIDTH{1'b0}}, {ZERO_PAD_WIDTH{1'b0}}};
      end
      else if (enable) begin
         if (seq_addr_cnt > 1) begin
            seq_addr_cnt <= seq_addr_cnt - 1'b1;
            seq_addr     <= seq_addr + seq_addr_increment;
         end else begin
            seq_addr_cnt <= num_seq_addr;
            seq_addr     <= rand_addr_out;
         end
      end
   end

   assign rand_seq_addr_out = seq_addr;
   assign addr_out = (num_seq_addr == 1'b1 && burstcount == 1'b1) ? {full_addr, {ZERO_PAD_WIDTH{1'b0}}} : rand_seq_addr_out;

   assign gen_rand_addr = enable & (seq_addr_cnt <= 1);

   // LFSRs for random addresses
   altera_emif_avl_tg_2_lfsr # (
      .WIDTH     (UPPER_ADDR_WIDTH)
   ) rand_addr_high (
      .clk       (clk),
      .rst       (rst),
      .enable    (gen_rand_addr),
      .data      (upper_addr),
      .tg_start  (start),
      .init_val  (lfsr_init_val)
   );

   altera_emif_avl_tg_2_lfsr # (
      .WIDTH     (RAND_ADDR_WIDTH)
   ) rand_addr_full (
      .clk       (clk),
      .rst       (rst),
      .enable    (gen_rand_addr),
      .data      (full_addr),
      .tg_start  (start),
      .init_val  ()
   );

endmodule
