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
// This test is used for both single write/read test stage and the block write/read
// test stage. The single write read stage performs a parametrizable number of
// interleaving write and read operation.  The number of write/read cycles
// that various address generators are used are parametrizable.
// The block write/read test stage performs a parametrizable number of write
// operations, followed by the same number of read operations to the same
// addresses.  The write/read cycle repeats for a parametrizable number of
// times.  The number of write/read cycles that various address generators
// are used are also parametrizable.
// If stress_mode is enabled, this stage issues data patterns designed to stress
// the signal integrity of the interface.
//////////////////////////////////////////////////////////////////////////////

module altera_emif_avl_tg_2_rw_stage # (

   // The number of write/read cycles that each address generator is used
   parameter TG_TEST_DURATION               = "SHORT",
   parameter NUMBER_OF_DATA_GENERATORS      = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS   = "",
   parameter DATA_PATTERN_LENGTH            = "",
   parameter BYTE_EN_PATTERN_LENGTH         = "",
   parameter BURSTCOUNT_WIDTH               = "",
   parameter AMM_BURST_COUNT_DIVISIBLE_BY   = "",
   parameter MEM_ADDR_WIDTH                 = "",
   parameter PORT_TG_CFG_ADDRESS_WIDTH      = 1,
   parameter PORT_TG_CFG_RDATA_WIDTH        = 1,
   parameter PORT_TG_CFG_WDATA_WIDTH        = 1,
   parameter WRITE_GROUP_WIDTH              = 1
) (
   // Clock and reset
   input                                          clk,
   input                                          rst,

   input                                          enable,
   input                                          block_rw_mode,
   input                                          repeat_mode,
   input                                          stress_mode,
   output                                         stage_complete,
   input                                          amm_cfg_waitrequest,
   output logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]   amm_cfg_address,
   output logic [PORT_TG_CFG_WDATA_WIDTH-1:0]     amm_cfg_writedata,
   output logic                                   amm_cfg_write,
   output logic                                   amm_cfg_read,

   input                                          emergency_brake_active,

   output                                         rand_burstcount_en,
   input [BURSTCOUNT_WIDTH-1:0]                   rand_burstcount

);

   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   localparam ADDR_COUNT            = (TG_TEST_DURATION == "SHORT") ? 32 : 256;
   localparam NUM_RAND_SEQ_ADDRS    = (TG_TEST_DURATION == "SHORT") ? 8 : 64;
   localparam NUM_STRESS_PATTERNS   = 6;
   localparam integer STRESS_DATA [NUM_STRESS_PATTERNS-1 : 0] = '{32'h5A5A5A5A, 32'hA5A5A5A5, 32'hB7B7B7B7, 32'hECECECEC, 32'h48484848, 32'h12121212};
   localparam STRESS_BURSTCOUNT     = (TG_TEST_DURATION == "SHORT") ? 2 : 32;

   logic [ceil_log2(NUMBER_OF_DATA_GENERATORS):0] data_gen_cfg_cnt;
   logic [ceil_log2(NUMBER_OF_BYTE_EN_GENERATORS):0] be_gen_cfg_cnt;
   logic [ceil_log2(NUMBER_OF_DATA_GENERATORS):0] data_gen_in_group_cfg_cnt;
   logic [ceil_log2(NUMBER_OF_DATA_GENERATORS):0] victim_in_group_cfg_cnt;
   logic [ceil_log2(NUM_STRESS_PATTERNS):0] stress_pattern_cfg_cnt;

   logic [31:0] block_size;
   assign block_size = (block_rw_mode | repeat_mode) ? ((TG_TEST_DURATION == "SHORT") ? 8 : 16): 1;
   logic [31:0] num_repeats;
   assign num_repeats = repeat_mode ? ((TG_TEST_DURATION == "SHORT") ? 10 : 1000) : 1;
   logic [31:0] stress_pattern;

   typedef enum int unsigned {
      INIT_SEQ, INIT_RAND, INIT_RAND_SEQ,
      DONE_SEQ, DONE_RAND, DONE, WAIT,
      CFG_ADDR_WR_L, CFG_ADDR_WR_H, CFG_ADDR_MODE_WR_SEQ,
      CFG_ADDR_RD_L, CFG_ADDR_RD_H, CFG_ADDR_MODE_RD_SEQ,
      CFG_SEQ_ADDR_INCR,
      CFG_LOAD_STRESS_PATTERN,
      CFG_DATA_SEED, CFG_DATA_MODE,
      CFG_DATA_SEED_STRESS, CFG_DATA_MODE_STRESS,
      STRESS_TEST_IN_PROG,
      CFG_BYTEEN_SEED, CFG_BYTEEN_MODE,
      CFG_LOOP_COUNT, CFG_WRITE_COUNT, CFG_READ_COUNT,
      CFG_WRITE_REPEAT_COUNT, CFG_READ_REPEAT_COUNT, CFG_BURST_LENGTH,
      CFG_START_SEQ,
      CFG_ADDR_MODE_WR_RAND, CFG_ADDR_MODE_RD_RAND, CFG_LOOP_COUNT_1, CFG_BURST_LENGTH_1, CFG_SEQ_ADDR_INCR_1,
      CFG_START_RAND,
      CFG_ADDR_MODE_WR_RAND_SEQ, CFG_ADDR_MODE_RD_RAND_SEQ,
      CFG_RAND_SEQ_ADDRS_WR, CFG_RAND_SEQ_ADDRS_RD,
      CFG_START_RAND_SEQ,
      TEST_IN_PROG
   } cfg_state_t;

   cfg_state_t state;
   reg [1:0]         wait_counter;

   always_ff @(posedge clk, posedge rst)
   begin
      if (rst) begin
         state         <= INIT_SEQ;
         amm_cfg_write <= 1'b0;
         amm_cfg_read  <= 1'b0;
         be_gen_cfg_cnt    <= '0;
         data_gen_cfg_cnt  <= '0;
         data_gen_in_group_cfg_cnt <= '0;
         victim_in_group_cfg_cnt <= '0;
         stress_pattern_cfg_cnt <= '0;
         amm_cfg_address   <= '0;
         amm_cfg_writedata <= '0;
         wait_counter  <= '0;
         stress_pattern <= '0;
      end
      else begin
         case (state)
            INIT_SEQ:
            begin
               amm_cfg_write    <= 1'b0;
               amm_cfg_read     <= 1'b0;
               be_gen_cfg_cnt   <= '0;
               data_gen_cfg_cnt <= '0;
               data_gen_in_group_cfg_cnt <= '0;
               victim_in_group_cfg_cnt <= '0;
               stress_pattern_cfg_cnt <= '0;
               stress_pattern <= '0;
               amm_cfg_address  <= '0;
               amm_cfg_writedata <= '0;
               // Standby until this stage is signaled to start
               if (enable && ~amm_cfg_waitrequest) begin
                  state <= CFG_ADDR_WR_L;
               end
            end
            CFG_ADDR_WR_L:
            begin
               amm_cfg_write      <= 1'b1;
               amm_cfg_address    <= TG_SEQ_START_ADDR_WR_L;
               amm_cfg_writedata  <= 32'h0;
               if (MEM_ADDR_WIDTH > 'd32) begin
                  state           <= CFG_ADDR_WR_H;
               end else begin
                  state           <= CFG_ADDR_MODE_WR_SEQ;
               end
            end
            CFG_ADDR_WR_H:
            begin
               amm_cfg_address    <= TG_SEQ_START_ADDR_WR_H;
               amm_cfg_writedata  <= 32'h0;
               state              <= CFG_ADDR_MODE_WR_SEQ;
            end
            CFG_ADDR_MODE_WR_SEQ:
            begin
               amm_cfg_address    <= TG_ADDR_MODE_WR;
               amm_cfg_writedata  <= TG_ADDR_SEQ;
               state              <= CFG_ADDR_RD_L;
            end
            CFG_ADDR_RD_L:
            begin
               amm_cfg_address    <= TG_SEQ_START_ADDR_RD_L;
               amm_cfg_writedata  <= 32'h0;
               if (MEM_ADDR_WIDTH > 'd32) begin
                  state           <= CFG_ADDR_RD_H;
               end else begin
                  state           <= CFG_ADDR_MODE_RD_SEQ;
               end
            end
            CFG_ADDR_RD_H:
            begin
               amm_cfg_address    <= TG_SEQ_START_ADDR_RD_H;
               amm_cfg_writedata  <= 32'h0;
               state              <= CFG_ADDR_MODE_RD_SEQ;
            end
            CFG_ADDR_MODE_RD_SEQ:
            begin
               amm_cfg_address    <= TG_ADDR_MODE_RD;
               amm_cfg_writedata  <= TG_ADDR_SEQ;
               state              <= CFG_SEQ_ADDR_INCR;
            end
            CFG_SEQ_ADDR_INCR:
            begin
               amm_cfg_address    <= TG_SEQ_ADDR_INCR;
               amm_cfg_writedata  <= stress_mode ? STRESS_BURSTCOUNT : rand_burstcount;
               state              <= stress_mode ? CFG_LOAD_STRESS_PATTERN : CFG_DATA_MODE;
            end


            CFG_DATA_MODE:
            begin
                  amm_cfg_address                              <= TG_DATA_MODE;
                  amm_cfg_writedata[1:0]                       <= TG_PATTERN_PRBS;
                  state              <= CFG_BYTEEN_SEED;
            end

            CFG_LOAD_STRESS_PATTERN:
            begin
               amm_cfg_write <= 1'b0;
               if (stress_pattern_cfg_cnt < NUM_STRESS_PATTERNS) begin
                  stress_pattern <= STRESS_DATA[stress_pattern_cfg_cnt];
                  stress_pattern_cfg_cnt <= stress_pattern_cfg_cnt + 1'b1;
                  state <= CFG_DATA_SEED_STRESS;
               end else begin
                  stress_pattern_cfg_cnt <= '0;
                  state <= DONE;
               end
            end
            CFG_DATA_SEED_STRESS:
            begin
               amm_cfg_write <= 1'b1;
                if (data_gen_cfg_cnt < NUMBER_OF_DATA_GENERATORS) begin
                  if (data_gen_in_group_cfg_cnt == victim_in_group_cfg_cnt) begin
                     amm_cfg_writedata <= stress_pattern;
                  end else begin
                     amm_cfg_writedata <= ~stress_pattern;
                  end
                  amm_cfg_address                            <= TG_DATA_SEED + data_gen_cfg_cnt;
                  data_gen_cfg_cnt                           <= data_gen_cfg_cnt + 1'b1;
                  if (data_gen_in_group_cfg_cnt == WRITE_GROUP_WIDTH - 1) begin
                     data_gen_in_group_cfg_cnt <= '0;
                  end else begin
                     data_gen_in_group_cfg_cnt <= data_gen_in_group_cfg_cnt + 1'b1;
                  end
               end
               else begin
                  state              <= CFG_DATA_MODE_STRESS;
                  data_gen_cfg_cnt   <= '0;
                  data_gen_in_group_cfg_cnt <= '0;
                  stress_pattern_cfg_cnt <= stress_pattern_cfg_cnt + 1'b1;
               end
            end

            CFG_DATA_MODE_STRESS:
            begin
                  amm_cfg_address                              <= TG_DATA_MODE;
                  amm_cfg_writedata[1:0]                       <= TG_PATTERN_FIXED;
                  state              <= CFG_BYTEEN_SEED;
            end

            CFG_BYTEEN_SEED:
            begin
               //configure all be generators -> all enabled
               if (be_gen_cfg_cnt < NUMBER_OF_BYTE_EN_GENERATORS) begin
                  amm_cfg_address                            <= TG_BYTEEN_SEED + be_gen_cfg_cnt;
                  amm_cfg_writedata[BYTE_EN_PATTERN_LENGTH-1:0] <= '1 ;  //seed, all enabled
                  be_gen_cfg_cnt                             <= be_gen_cfg_cnt + 1'b1;
               end
               else begin
                  state              <= CFG_BYTEEN_MODE;
                  be_gen_cfg_cnt     <= '0;
               end
            end

            CFG_BYTEEN_MODE:
            begin
               //configure all be generators -> all enabled
                  amm_cfg_address                            <= TG_BYTEEN_MODE;
                  amm_cfg_writedata[1:0]                     <= TG_PATTERN_FIXED;
                  state              <= CFG_LOOP_COUNT;
            end

            CFG_LOOP_COUNT:
            begin
               amm_cfg_address   <= TG_LOOP_COUNT;
               amm_cfg_writedata <= ADDR_COUNT;
               state             <= CFG_WRITE_COUNT;
            end
            CFG_WRITE_COUNT:
            begin
               amm_cfg_address   <= TG_WRITE_COUNT;
               amm_cfg_writedata <= block_size;
               state             <= CFG_READ_COUNT;
            end
            CFG_READ_COUNT:
            begin
               amm_cfg_address   <= TG_READ_COUNT;
               amm_cfg_writedata <= block_size;
               state             <= CFG_BURST_LENGTH;
            end
            CFG_BURST_LENGTH:
            begin
               amm_cfg_address   <= TG_BURST_LENGTH;
               amm_cfg_writedata <= (repeat_mode)? 32'h1 : rand_burstcount;
               state             <= CFG_WRITE_REPEAT_COUNT;
            end
            CFG_WRITE_REPEAT_COUNT:
            begin
               amm_cfg_address   <= TG_WRITE_REPEAT_COUNT;
               amm_cfg_writedata <= num_repeats;
               state             <= CFG_READ_REPEAT_COUNT;
            end
            CFG_READ_REPEAT_COUNT:
            begin
               amm_cfg_address   <= TG_READ_REPEAT_COUNT;
               amm_cfg_writedata <= num_repeats;
               state             <= CFG_START_SEQ;
            end
            CFG_START_SEQ:
            begin
               amm_cfg_address   <= TG_START;
               state             <= DONE_SEQ;
            end
            DONE_SEQ:
            begin
               amm_cfg_write   <= 1'b0;
               state           <= stress_mode ? STRESS_TEST_IN_PROG : INIT_RAND;
            end

            STRESS_TEST_IN_PROG:
            begin
               amm_cfg_write   <= 1'b0;
               if (~amm_cfg_waitrequest) begin
                  if (wait_counter == 2'b11) begin
                     if (victim_in_group_cfg_cnt == WRITE_GROUP_WIDTH - 1) begin
                        state <= CFG_LOAD_STRESS_PATTERN;
                     end else begin
                        victim_in_group_cfg_cnt <= victim_in_group_cfg_cnt + 1'b1;
                        state <= CFG_DATA_SEED_STRESS;
                     end
                     wait_counter <= 1'b0;
                  end else begin
                     wait_counter <= wait_counter + 1'b1;
                  end
               end
            end

            INIT_RAND:
            begin
               // Standby until this stage is signaled to start
               if (enable && ~amm_cfg_waitrequest) begin
                  if (wait_counter == 2'b11) begin
                     state <= (emergency_brake_active)? TEST_IN_PROG : CFG_ADDR_MODE_WR_RAND;
                     wait_counter <= 1'b0;
                  end else begin
                     wait_counter   <= wait_counter + 1'b1;
                  end
               end
            end
            CFG_ADDR_MODE_WR_RAND:
            begin
               amm_cfg_write      <= 1'b1;
               amm_cfg_address    <= TG_ADDR_MODE_WR;
               amm_cfg_writedata  <= TG_ADDR_RAND;
               state              <= CFG_ADDR_MODE_RD_RAND;
            end
            CFG_ADDR_MODE_RD_RAND:
            begin
               amm_cfg_address    <= TG_ADDR_MODE_RD;
               amm_cfg_writedata  <= TG_ADDR_RAND;
               state              <= CFG_LOOP_COUNT_1;
            end

            CFG_LOOP_COUNT_1:
            begin
               amm_cfg_address   <= TG_LOOP_COUNT;
               amm_cfg_writedata <= ADDR_COUNT;
               state             <= CFG_BURST_LENGTH_1;
            end
            // In random/random sequential mode, restrict burst length
            // and sequential address increment in order to prevent
            // overlapping writes.
            CFG_BURST_LENGTH_1:
            begin
               amm_cfg_address   <= TG_BURST_LENGTH;
               amm_cfg_writedata <= AMM_BURST_COUNT_DIVISIBLE_BY;
               state             <= CFG_SEQ_ADDR_INCR_1;
            end
            CFG_SEQ_ADDR_INCR_1:
            begin
               amm_cfg_address    <= TG_SEQ_ADDR_INCR;
               amm_cfg_writedata  <= AMM_BURST_COUNT_DIVISIBLE_BY;
               state              <= CFG_START_RAND;
            end

            CFG_START_RAND:
            begin
               amm_cfg_address   <= TG_START;
               state             <= DONE_RAND;
            end
            DONE_RAND:
            begin
               amm_cfg_write   <= 1'b0;
               state           <= INIT_RAND_SEQ;
            end

            INIT_RAND_SEQ:
            begin
               // Standby until this stage is signaled to start
               if (enable && ~amm_cfg_waitrequest) begin
                  if (wait_counter == 2'b11) begin
                     state <= (emergency_brake_active)? TEST_IN_PROG : CFG_ADDR_MODE_WR_RAND_SEQ;
                     wait_counter <= 1'b0;
                  end else begin
                     wait_counter   <= wait_counter + 1'b1;
                  end
               end
            end
            CFG_ADDR_MODE_WR_RAND_SEQ:
            begin
               amm_cfg_write      <= 1'b1;
               amm_cfg_address    <= TG_ADDR_MODE_WR;
               amm_cfg_writedata  <= TG_ADDR_RAND_SEQ;
               state              <= CFG_RAND_SEQ_ADDRS_WR;
            end
            CFG_RAND_SEQ_ADDRS_WR:
            begin
               amm_cfg_address    <= TG_RAND_SEQ_ADDRS_WR;
               amm_cfg_writedata  <= NUM_RAND_SEQ_ADDRS;
               state              <= CFG_ADDR_MODE_RD_RAND_SEQ;
            end
            CFG_ADDR_MODE_RD_RAND_SEQ:
            begin
               amm_cfg_address    <= TG_ADDR_MODE_RD;
               amm_cfg_writedata  <= TG_ADDR_RAND_SEQ;
               state              <= CFG_RAND_SEQ_ADDRS_RD;
            end
            CFG_RAND_SEQ_ADDRS_RD:
            begin
               amm_cfg_address    <= TG_RAND_SEQ_ADDRS_RD;
               amm_cfg_writedata  <= NUM_RAND_SEQ_ADDRS;
               state              <= CFG_START_RAND_SEQ;
            end
            CFG_START_RAND_SEQ:
            begin
               amm_cfg_address   <= TG_START;
               state             <= TEST_IN_PROG;
            end
            TEST_IN_PROG:
            begin
               amm_cfg_write   <= 1'b0;
               if (~amm_cfg_waitrequest) begin
                  if (wait_counter == 2'b11) begin
                     state <= DONE;
                     wait_counter <= 1'b0;
                  end else begin
                     wait_counter <= wait_counter + 1'b1;
                  end
               end
            end
            DONE:
            begin
               state <= INIT_SEQ;
            end
         endcase
      end
   end

   //enable the random burstlength generator the cycle before we need it since it has latency of 1 cycle
   assign rand_burstcount_en = (state == CFG_ADDR_MODE_RD_SEQ);

   // Status outputs
   assign stage_complete = (state == DONE);
endmodule

