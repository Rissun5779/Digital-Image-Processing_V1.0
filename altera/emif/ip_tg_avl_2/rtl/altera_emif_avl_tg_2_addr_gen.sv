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
// This module is a wrapper for the address generators.  The generators'
// outputs are multiplexed in this module using the select signals.
// The address generation modes are sequential (from a given start address),
// random, random sequential which produces sequential addresses from a
// random start address, and one-hot
//////////////////////////////////////////////////////////////////////////////
module altera_emif_avl_tg_2_addr_gen # (
   parameter AMM_WORD_ADDRESS_WIDTH                = "",
   parameter AMM_BURSTCOUNT_WIDTH                  = "",
   // width of the row address bits
   parameter ROW_ADDR_WIDTH                        = "",
   //bit location of the LSB of the row address within the total address
   parameter ROW_ADDR_LSB                          = "",

   parameter SEQ_CNT_WIDTH                         = "",
   parameter RAND_SEQ_CNT_WIDTH                    = "",
   parameter SEQ_ADDR_INCR_WIDTH                   = "",

   parameter RANK_ADDR_WIDTH                 = "",
   parameter RANK_ADDR_LSB                   = "",
   parameter BANK_ADDR_WIDTH                 = "",
   parameter BANK_ADDR_LSB                   = "",
   parameter BANK_GROUP_WIDTH                = "",
   parameter BANK_GROUP_LSB                  = "",
   parameter RANK_ADDR_WIDTH_LOCAL           = "",
   parameter BANK_GROUP_WIDTH_LOCAL          = "",
   parameter AMM_BURST_COUNT_DIVISIBLE_BY    = "",
   parameter AMM_WORD_ADDRESS_DIVISIBLE_BY   = "",

   // If set to true, the unix_id will be added to the MSB bit of the generated address.
   // This is usefull to avoid address overlapping when more than one traffic generator being connected to the same slave
   parameter ENABLE_UNIX_ID                        = 0,
   parameter USE_UNIX_ID                           = 3'b000
) (
   // Clock and reset
   input                                           clk,
   input                                           rst,

   // Control and status
   input                                           enable,

   input                                           start,
   input [AMM_WORD_ADDRESS_WIDTH-1:0]              start_addr,
   input [1:0]                                     addr_gen_mode,

   //for sequential mode
   input                                           seq_return_to_start_addr,
   input [SEQ_CNT_WIDTH-1:0]                       seq_addr_num,

   //for random sequential mode
   input [RAND_SEQ_CNT_WIDTH-1:0]                  rand_seq_num_seq_addr,

   //increment size for sequential and random sequential addressing
   //increments avalon address
   input [SEQ_ADDR_INCR_WIDTH-1:0]                 seq_addr_increment,

   // Address generator outputs
   output [AMM_WORD_ADDRESS_WIDTH-1:0]             addr_out,

   input [1:0] rank_mask_en,
   input [1:0] bank_mask_en,
   input [1:0] row_mask_en,
   input [1:0] bankgroup_mask_en,
   input [RANK_ADDR_WIDTH_LOCAL-1:0]  rank_mask,
   input [BANK_ADDR_WIDTH-1:0]  bank_mask,
   input [ROW_ADDR_WIDTH-1:0]   row_mask,
   input [BANK_GROUP_WIDTH_LOCAL-1:0] bankgroup_mask,
   input [AMM_BURSTCOUNT_WIDTH-1:0] burstcount
);
   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   logic [AMM_WORD_ADDRESS_WIDTH-1:0]      addr;

   // Sequential address generator signals
   logic                                   seq_addr_gen_enable;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0]      seq_addr_gen_addr;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0]      seq_start_addr;

   // Random address generator signals
   logic                                   rand_addr_gen_enable;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0]      rand_addr_gen_addr;

   //one-hot address generator signals
   logic                                   one_hot_addr_gen_enable;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0]      one_hot_addr_gen_addr;

   //masking for constraining or cycling row, bank, rank, bank group (DDR4)
   logic [ROW_ADDR_WIDTH-1:0] row_mask_reg;
   logic [BANK_ADDR_WIDTH-1:0] bank_mask_reg;
   logic [RANK_ADDR_WIDTH_LOCAL-1:0] rank_mask_reg;
   logic [BANK_GROUP_WIDTH_LOCAL-1:0] bankgroup_mask_reg;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0] addr_row_masked;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0] addr_rank_masked;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0] addr_bank_masked;
   logic [AMM_WORD_ADDRESS_WIDTH-1:0] addr_bg_masked;

   assign addr_out = (ENABLE_UNIX_ID == 1) ? {USE_UNIX_ID[2:0], 1'b0, addr_bg_masked[AMM_WORD_ADDRESS_WIDTH-5:0]} : addr_bg_masked;

   always_comb
   begin
      case (addr_gen_mode)
         TG_ADDR_SEQ:
         begin
            addr  = seq_addr_gen_addr;
         end
         TG_ADDR_RAND:
         begin
            addr  = rand_addr_gen_addr;
         end
         TG_ADDR_ONE_HOT:
         begin
            addr = one_hot_addr_gen_addr;
         end
         TG_ADDR_RAND_SEQ:
         begin
            addr  = rand_addr_gen_addr;
         end
         default: addr = 'x;
      endcase
   end

   // Address generator inputs
   assign seq_addr_gen_enable      = enable & (addr_gen_mode == TG_ADDR_SEQ);
   assign rand_addr_gen_enable     = enable & (addr_gen_mode == TG_ADDR_RAND || addr_gen_mode == TG_ADDR_RAND_SEQ);
   assign one_hot_addr_gen_enable  = enable & (addr_gen_mode == TG_ADDR_ONE_HOT);

   //the sequential start address should be the input start address for sequential mode
   assign seq_start_addr = start_addr;

   always_ff @ (posedge clk, posedge rst)
   begin
      if (rst) begin
         row_mask_reg       <= '0;
         bank_mask_reg      <= '0;
         rank_mask_reg      <= '0;
         bankgroup_mask_reg <= '0;

      end else begin
         if (start) begin
            row_mask_reg       <= row_mask;
            bank_mask_reg      <= bank_mask;
            rank_mask_reg      <= rank_mask;
            bankgroup_mask_reg <= bankgroup_mask;
         end
         else if (enable) begin
            if (rank_mask_en == TG_MASK_FULL_CYCLING) begin
               rank_mask_reg <= rank_mask_reg + 1'b1;
            end
            //bank cycling
            //option of cycling all banks (8) or just 3 for improved efficiency since
            //only 3 banks can remain open at once
            if (bank_mask_en & TG_MASK_FULL_CYCLING) begin
               //default to cycling all banks
               bank_mask_reg <= bank_mask_reg + 1'b1;
               //go back to starting bank after 3 if enabled
               if (bank_mask_en == TG_MASK_PARTIAL_CYCLING && bank_mask_reg == bank_mask + 2'h2) begin
                  bank_mask_reg <= bank_mask;
               end
            end
            if (row_mask_en == TG_MASK_FULL_CYCLING) begin
               row_mask_reg <= row_mask_reg + 1'b1;
            end
            if (bankgroup_mask_en == TG_MASK_FULL_CYCLING) begin
               bankgroup_mask_reg <= bankgroup_mask_reg + 1'b1;
            end
         end
      end
   end
   //apply masks
   generate
   always @ (*) begin
      if (RANK_ADDR_WIDTH > 0) begin
         addr_rank_masked = (rank_mask_en == TG_MASK_DISABLED) ? addr : ((addr & {{(AMM_WORD_ADDRESS_WIDTH-RANK_ADDR_WIDTH-RANK_ADDR_LSB){1'b1}},{RANK_ADDR_WIDTH{1'b0}},{RANK_ADDR_LSB{1'b1}}}) | {{rank_mask_reg}, {(RANK_ADDR_LSB){1'b0}}});
      end else begin
         addr_rank_masked = addr;
      end

      if (ROW_ADDR_WIDTH > 0) begin
         addr_row_masked = (row_mask_en == TG_MASK_DISABLED) ? addr_rank_masked : ((addr_rank_masked & {{(AMM_WORD_ADDRESS_WIDTH-ROW_ADDR_WIDTH-ROW_ADDR_LSB){1'b1}},{ROW_ADDR_WIDTH{1'b0}},{ROW_ADDR_LSB{1'b1}}}) | {{row_mask_reg}, {(ROW_ADDR_LSB){1'b0}}});
      end else begin
         addr_row_masked = addr_rank_masked;
      end

      if (BANK_ADDR_WIDTH > 0) begin
         addr_bank_masked = (bank_mask_en == TG_MASK_DISABLED) ? addr_row_masked : ((addr_row_masked & {{(AMM_WORD_ADDRESS_WIDTH-BANK_ADDR_WIDTH-BANK_ADDR_LSB){1'b1}},{BANK_ADDR_WIDTH{1'b0}},{BANK_ADDR_LSB{1'b1}}}) | {{bank_mask_reg}, {(BANK_ADDR_LSB){1'b0}}});
      end else begin
         addr_bank_masked = addr_row_masked;
      end

      if (BANK_GROUP_WIDTH > 0) begin
         addr_bg_masked = (bankgroup_mask_en == TG_MASK_DISABLED) ? addr_bank_masked : ((addr_bank_masked & {{(AMM_WORD_ADDRESS_WIDTH-BANK_GROUP_WIDTH-BANK_GROUP_LSB){1'b1}},{BANK_GROUP_WIDTH{1'b0}},{BANK_GROUP_LSB{1'b1}}}) | {{bankgroup_mask_reg}, {(BANK_GROUP_LSB){1'b0}}});
      end else begin
         addr_bg_masked = addr_bank_masked;
      end
   end
   endgenerate


   // Sequential address generator
   altera_emif_avl_tg_2_seq_addr_gen # (
      .ADDR_WIDTH                      (AMM_WORD_ADDRESS_WIDTH),
      .SEQ_CNT_WIDTH                   (SEQ_CNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY)
   ) seq_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (seq_addr_gen_enable),
      .seq_addr                     (seq_addr_gen_addr),
      .start_addr                   (seq_start_addr),
      .start                        (start),
      .return_to_start_addr         (seq_return_to_start_addr),
      .seq_addr_increment           (seq_addr_increment),
      .num_seq_addr                 (seq_addr_num)
   );

   // Random address generator
   altera_emif_avl_tg_2_rand_seq_addr_gen # (
      .ADDR_WIDTH                      (AMM_WORD_ADDRESS_WIDTH),
      .AMM_BURSTCOUNT_WIDTH            (AMM_BURSTCOUNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH),
      //width for number of sequential addresses between each random address
      .NUM_SEQ_ADDR_WIDTH              (RAND_SEQ_CNT_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY)
   ) rand_seq_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (rand_addr_gen_enable),
      .addr_out                     (rand_addr_gen_addr),
      .start                        (start),
      //number of sequential addresses between each random address
      //for full random mode, set to 1
      .num_seq_addr                 (addr_gen_mode == TG_ADDR_RAND_SEQ ? rand_seq_num_seq_addr : 1'b1 ),
      //increment size for sequential addresses
      .seq_addr_increment           (seq_addr_increment),
      .burstcount                   (burstcount)
   );

   altera_emif_avl_tg_2_one_hot_addr_gen # (
      .ADDR_WIDTH                      (AMM_WORD_ADDRESS_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY)
   ) one_hot_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (one_hot_addr_gen_enable),
      .one_hot_addr                 (one_hot_addr_gen_addr),
      .start                        (start)
   );

endmodule

