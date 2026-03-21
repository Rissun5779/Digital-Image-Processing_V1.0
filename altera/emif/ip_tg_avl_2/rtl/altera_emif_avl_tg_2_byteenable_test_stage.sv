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


//This is a special test stage designed to test that data masking works correctly
//This test is reliant on a special configuration in the status checker, so the status checker
//must know this test is being run
//This is a 2 step test which first performs a set of writes, with byte enables fully unmasked,
//writing the same known data to each address. The status checker must be aware of this data.
//Following this, the byte enable generators as well as the data generators are configured to random
//and a set of writes is performed, followed by a set of reads to the same addresses
//The status checker is then responsible for verifying that the originally written data did not get
//overwritten according to the data masking, and that the remainder of the data did, and was then read
//correctly



module altera_emif_avl_tg_2_byteenable_test_stage #(
   parameter NUMBER_OF_DATA_GENERATORS    = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS = "",
   parameter DATA_PATTERN_LENGTH          = "",
   parameter BYTE_EN_PATTERN_LENGTH       = "",
   parameter TG_TEST_DURATION             = "SHORT",
   parameter BURSTCOUNT_WIDTH             = "",
   parameter MEM_ADDR_WIDTH               = "",
   parameter PORT_TG_CFG_ADDRESS_WIDTH    = 1,
   parameter PORT_TG_CFG_RDATA_WIDTH      = 1,
   parameter PORT_TG_CFG_WDATA_WIDTH      = 1
)(
   input                                           clk,
   input                                           rst,
   input                                           enable,
   input                                           amm_cfg_waitrequest,
   output logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]    amm_cfg_address,
   output logic [PORT_TG_CFG_WDATA_WIDTH-1:0]      amm_cfg_writedata,
   output logic                                    amm_cfg_write,
   output logic                                    amm_cfg_read,
   output                                          stage_complete,
   output                                          rand_burstcount_en,
   input [BURSTCOUNT_WIDTH-1:0]                    rand_burstcount
   );
   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   localparam RAND_ADDR_COUNT    = (TG_TEST_DURATION == "SHORT") ? 4 : 64;
   localparam NUM_REPEATS        = 1;

   // Config states definition
   typedef enum int unsigned {
      INIT, INIT_2,
      DONE, DONE_1, TEST_IN_PROG,
      CFG_ADDR_MODE_WR, CFG_DATA_SEED, CFG_DATA_MODE, CFG_BYTEEN_SEED, CFG_BYTEEN_MODE,
      CFG_LOOP_COUNT, CFG_WRITE_COUNT, CFG_READ_COUNT, CFG_WRITE_REPEAT_COUNT, CFG_READ_REPEAT_COUNT,
      CFG_BURST_LENGTH, CFG_BYTEEN_STAGE_ON, CFG_START,
      CFG_ADDR_MODE_RD, CFG_DATA_SEED_2, CFG_DATA_MODE_PRBS, CFG_BYTEEN_SEED_2, CFG_BYTEEN_MODE_PRBS,
      CFG_READ_COUNT_2, CFG_START_2, CFG_BYTEEN_STAGE_OFF
   } cfg_state_t;

   cfg_state_t state;
   logic [ceil_log2(NUMBER_OF_DATA_GENERATORS):0] data_gen_cfg_cnt;
   logic [ceil_log2(NUMBER_OF_BYTE_EN_GENERATORS):0] be_gen_cfg_cnt;

   reg [1:0]         wait_counter;
   always_ff @(posedge clk, posedge rst)
   begin
      if (rst) begin
         state         <= INIT;
         amm_cfg_write <= 1'b0;
         amm_cfg_read  <= 1'b0;
         amm_cfg_address <= 10'h0;
         amm_cfg_writedata <= 32'h0;
         wait_counter  <= '0;
      end
      else begin

         case (state)
            INIT:
            begin
               amm_cfg_write        <= 1'b0;
               amm_cfg_read         <= 1'b0;
               amm_cfg_address      <= 10'h0;
               amm_cfg_writedata    <= 32'h0;
               data_gen_cfg_cnt     <= '0;
               be_gen_cfg_cnt       <= '0;
               wait_counter         <= '0;
               // Standby until this stage is signaled to start
               if (enable && ~amm_cfg_waitrequest) begin
                  state <= CFG_ADDR_MODE_WR;
               end
            end

            //configuration command states

            CFG_ADDR_MODE_WR:
            begin
               amm_cfg_write      <= 1'b1;
               amm_cfg_address    <= TG_ADDR_MODE_WR;
               amm_cfg_writedata  <= TG_ADDR_RAND;
               state              <= CFG_DATA_SEED;
            end

            //the known seed for the first run with all be enabled is '1
            CFG_DATA_SEED:
            begin
               if (data_gen_cfg_cnt < NUMBER_OF_DATA_GENERATORS) begin
                  amm_cfg_address                            <= TG_DATA_SEED + data_gen_cfg_cnt;
                  amm_cfg_writedata[DATA_PATTERN_LENGTH-1:0] <= '1;
                  data_gen_cfg_cnt                           <= data_gen_cfg_cnt + 1'b1;
               end
               else begin
                  state  <= CFG_DATA_MODE;
                  data_gen_cfg_cnt <= '0;
               end
            end

            CFG_DATA_MODE:
            begin
                  amm_cfg_address                              <= TG_DATA_MODE;
                  amm_cfg_writedata                            <= TG_PATTERN_FIXED;
                  state                                        <= CFG_BYTEEN_SEED;
            end

            CFG_BYTEEN_SEED:
            begin
               if (be_gen_cfg_cnt < NUMBER_OF_BYTE_EN_GENERATORS) begin
                  amm_cfg_address                              <= TG_BYTEEN_SEED + be_gen_cfg_cnt;
                  amm_cfg_writedata[BYTE_EN_PATTERN_LENGTH-1:0]   <= '1 ;  //seed, all enabled
                  be_gen_cfg_cnt                               <= be_gen_cfg_cnt + 1'b1;
               end
               else begin
                  state <= CFG_BYTEEN_MODE;
                  be_gen_cfg_cnt <= '0;
               end
            end

            CFG_BYTEEN_MODE:
            begin
                  amm_cfg_address                            <= TG_BYTEEN_MODE;
                  amm_cfg_writedata                          <= TG_PATTERN_FIXED;
                  state              <= CFG_LOOP_COUNT;
            end

            CFG_LOOP_COUNT:
            begin
               amm_cfg_address   <= TG_LOOP_COUNT;
               amm_cfg_writedata <= 1'b1;
               state             <= CFG_WRITE_COUNT;
            end

            CFG_WRITE_COUNT:
            begin
               amm_cfg_address   <= TG_WRITE_COUNT;
               amm_cfg_writedata <= RAND_ADDR_COUNT;
               state             <= CFG_READ_COUNT;
            end

            CFG_READ_COUNT:
            begin
               amm_cfg_address   <= TG_READ_COUNT;
               amm_cfg_writedata <= 1'b0;
               state             <= CFG_WRITE_REPEAT_COUNT;
            end

            CFG_WRITE_REPEAT_COUNT:
            begin
               amm_cfg_address   <= TG_WRITE_REPEAT_COUNT;
               amm_cfg_writedata <= NUM_REPEATS;
               state             <= CFG_READ_REPEAT_COUNT;
            end
            CFG_READ_REPEAT_COUNT:
            begin
               amm_cfg_address   <= TG_READ_REPEAT_COUNT;
               amm_cfg_writedata <= NUM_REPEATS;
               state             <= CFG_BURST_LENGTH;
            end

            CFG_BURST_LENGTH:
            begin
               amm_cfg_address   <= TG_BURST_LENGTH;
               amm_cfg_writedata <= rand_burstcount;
               state             <= CFG_BYTEEN_STAGE_ON;
            end

            CFG_BYTEEN_STAGE_ON:
            begin
               amm_cfg_address   <= TG_TEST_BYTEEN;
               amm_cfg_writedata <= 32'h1;
               state             <= CFG_START;
            end

            CFG_START:
            begin
               amm_cfg_address   <= TG_START;
               state             <= DONE_1;
            end

            DONE_1:
            begin
               amm_cfg_write   <= 1'b0;
               state           <= INIT_2;
            end

            INIT_2:
            begin
               data_gen_cfg_cnt    <= '0;
               be_gen_cfg_cnt      <= '0;
               // Standby until this stage is signaled to start
               if (enable && ~amm_cfg_waitrequest) begin
                  if (wait_counter == 2'b11) begin
                     state <= CFG_ADDR_MODE_RD;
                     wait_counter   <= 1'b0;
                  end else begin
                     wait_counter   <= wait_counter + 1'b1;
                  end
               end
            end

            CFG_ADDR_MODE_RD:
            begin
               amm_cfg_write      <= 1'b1;
               amm_cfg_address    <= TG_ADDR_MODE_RD;
               amm_cfg_writedata  <= TG_ADDR_RAND;
               state              <= CFG_DATA_MODE_PRBS;
            end

//amm_cfg_writedata[DATA_PATTERN_LENGTH-1:0] <= data_gen_cfg_cnt + 1'b1;  //seed, all different
//data_gen_cfg_cnt                           <= data_gen_cfg_cnt + 1'b1;

            CFG_DATA_MODE_PRBS:
            begin
               amm_cfg_address    <= TG_DATA_MODE;
               amm_cfg_writedata  <= TG_PATTERN_PRBS;
               state              <= CFG_BYTEEN_MODE_PRBS;
            end

//amm_cfg_writedata[BYTE_EN_PATTERN_LENGTH-1:0] <= be_gen_cfg_cnt + 1'b1;  //seed, all different
//be_gen_cfg_cnt                             <= be_gen_cfg_cnt + 1'b1;

            CFG_BYTEEN_MODE_PRBS:
            begin
               amm_cfg_address    <= TG_BYTEEN_MODE;
               amm_cfg_writedata  <= TG_PATTERN_PRBS;
               state              <= CFG_READ_COUNT_2;
            end

            CFG_READ_COUNT_2:
            begin
               amm_cfg_address   <= TG_READ_COUNT;
               amm_cfg_writedata <= RAND_ADDR_COUNT;
               state             <= CFG_START_2;
            end

            CFG_START_2:
            begin
               amm_cfg_address   <= TG_START;
               state             <= TEST_IN_PROG;
            end

            TEST_IN_PROG:
            begin
               amm_cfg_write   <= 1'b0;
               //wait until the whole test is completed running in the traffic generator
               //this makes sure we stay in this test stage the whole duration
               if (~amm_cfg_waitrequest) begin
                  if (wait_counter == 2'b11) begin
                  state <= CFG_BYTEEN_STAGE_OFF;
                     wait_counter <= 1'b0;
                  end else begin
                     wait_counter <= wait_counter + 1'b1;
                  end
               end else begin
                  wait_counter <= 2'b11;
               end
            end

            CFG_BYTEEN_STAGE_OFF:
            begin
               amm_cfg_write     <= 1'b1;
               amm_cfg_address   <= TG_TEST_BYTEEN;
               amm_cfg_writedata <= 32'h0;
               state <= DONE;
            end

            DONE:
            begin
               amm_cfg_write <= 1'b0;
               state <= INIT;
            end

         endcase
      end
   end

   //enable the random burstlength generator the cycle before we need it since it has latency of 1 cycle
   assign rand_burstcount_en = ((state == CFG_READ_REPEAT_COUNT));

   // Status outputs
   assign stage_complete = (state == DONE);


endmodule



