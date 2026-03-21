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


//This is a sample driver control block for the traffic generator
//It coordinates the issuing of individual test stages, each of which will perform
//their own configuration of the traffic generator specific to a certain test case
//New test stages can easily be added
module altera_emif_avl_tg_2_bringup_dcb #(
   parameter NUMBER_OF_DATA_GENERATORS    = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS = "",
   parameter DATA_PATTERN_LENGTH          = "",
   parameter BYTE_EN_PATTERN_LENGTH       = "",
   parameter MEM_ADDR_WIDTH               = "",
   parameter BURSTCOUNT_WIDTH             = "",
   parameter TG_TEST_DURATION             = "SHORT",
   parameter PORT_TG_CFG_ADDRESS_WIDTH    = 1,
   parameter PORT_TG_CFG_RDATA_WIDTH      = 1,
   parameter PORT_TG_CFG_WDATA_WIDTH      = 1,
   parameter WRITE_GROUP_WIDTH            = 1,
   parameter BYPASS_DEFAULT_PATTERN       = 0,
   parameter BYPASS_USER_STAGE            = 0,
   parameter BYPASS_REPEAT_STAGE          = 1,
   parameter BYPASS_STRESS_STAGE          = 1,
   parameter AMM_BURST_COUNT_DIVISIBLE_BY = 1,
   parameter AMM_WORD_ADDRESS_WIDTH       = 1
   )(
   input                        clk,
   input                        rst,
   input                        amm_ctrl_ready,

   output                                      amm_cfg_in_waitrequest,
   input  [PORT_TG_CFG_ADDRESS_WIDTH-1:0]      amm_cfg_in_address,
   input  [PORT_TG_CFG_WDATA_WIDTH-1:0]        amm_cfg_in_writedata,
   input                                       amm_cfg_in_write,
   input                                       amm_cfg_in_read,
   output [PORT_TG_CFG_RDATA_WIDTH-1:0]        amm_cfg_in_readdata,
   output                                      amm_cfg_in_readdatavalid,

   input                                       amm_cfg_out_waitrequest,
   output [PORT_TG_CFG_ADDRESS_WIDTH-1:0]      amm_cfg_out_address,
   output [PORT_TG_CFG_WDATA_WIDTH-1:0]        amm_cfg_out_writedata,
   output                                      amm_cfg_out_write,
   output                                      amm_cfg_out_read,
   input  [PORT_TG_CFG_RDATA_WIDTH-1:0]        amm_cfg_out_readdata,
   input                                       amm_cfg_out_readdatavalid,

   input                        restart_default_traffic,
   output                       all_tests_issued,
   //bring in the failure report from the status checker, so that it can be used in multi step tests
   //with multiple runs of the traffic generator
   input                        stage_failure,
   input [AMM_WORD_ADDRESS_WIDTH-1:0]   first_fail_addr,
   input                        failure_occured,
   //output the final result at the end of all runs of the test stage
   output logic                 traffic_gen_fail,
   output logic                 target_stage_enable,

   input                         target_first_failing_addr

   );

   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   localparam NUM_DRIVER_LOOP  = (TG_TEST_DURATION == "INFINITE") ? 0    :
                                 (TG_TEST_DURATION == "MEDIUM")   ? 1000 :
                                 (TG_TEST_DURATION == "SHORT")    ? 1    : 1;

   // The burstcount is limited to keep the value reasonable for simulation purposes.
   localparam TG_MIN_BURSTCOUNT         = 1;
   localparam TG_MAX_BURSTCOUNT         = ((2**BURSTCOUNT_WIDTH < 64) ? 2**BURSTCOUNT_WIDTH : 64) - 1;

   // Test stages definition
   typedef enum int unsigned {
      INIT,
      DONE_DEFAULT_PATTERN, DONE,
      BYTEENABLE_STAGE,
      SINGLE_RW, BLOCK_RW,
      REPEAT_STAGE,
      STRESS_STAGE,
      TARGET_STAGE,
      WAIT_USER_STAGE,
      INIT_USER_STAGE,
      DONE_USER_LOOP
   } tst_stage_t;

   tst_stage_t stage;

   logic [31:0] loop_counter;
   reg [1:0]      wait_counter;

   // Byteenable stage signals
   wire [PORT_TG_CFG_ADDRESS_WIDTH-1:0] byteenable_test_stage_address;
   wire [PORT_TG_CFG_WDATA_WIDTH-1:0] byteenable_test_stage_writedata;
   wire byteenable_test_stage_write;
   wire byteenable_test_stage_read;
   wire byteenable_test_stage_complete;
   wire byteenable_test_stage_rand_num_en;

   //write/read stage signals
   wire [PORT_TG_CFG_ADDRESS_WIDTH-1:0] rw_stage_address;
   wire [PORT_TG_CFG_WDATA_WIDTH-1:0] rw_stage_writedata;
   wire rw_stage_write;
   wire rw_stage_read;
   wire rw_stage_complete;
   wire rw_stage_rand_num_en;

   // Byteenable stage signals
   wire [PORT_TG_CFG_ADDRESS_WIDTH-1:0] target_stage_address;
   wire [PORT_TG_CFG_WDATA_WIDTH-1:0] target_stage_writedata;
   wire target_stage_write;
   wire target_stage_read;
   wire target_stage_complete;
   wire target_stage_rand_num_en;

   wire emergency_brake_active;

   logic                       rand_num_enable;
   wire [BURSTCOUNT_WIDTH-1:0] rand_burstcount;

   logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]            w_amm_cfg_address;
   logic [PORT_TG_CFG_WDATA_WIDTH-1:0]           w_amm_cfg_writedata;
   logic                  w_amm_cfg_write;
   logic                  w_amm_cfg_read;

   wire user_cfg_start;
   assign user_cfg_start = ~amm_cfg_in_waitrequest && amm_cfg_in_write && amm_cfg_in_address == TG_START;
   wire user_cfg_start_default;
   assign user_cfg_start_default = ~amm_cfg_in_waitrequest && amm_cfg_in_write && amm_cfg_in_address == TG_RESTART_DEFAULT_TRAFFIC;

   wire use_amm_cfg_in;
   assign use_amm_cfg_in = stage == WAIT_USER_STAGE || stage == INIT_USER_STAGE || stage == DONE;

   assign                 amm_cfg_in_waitrequest   = use_amm_cfg_in ? amm_cfg_out_waitrequest : '1;
   assign                 amm_cfg_out_address      = use_amm_cfg_in ? amm_cfg_in_address : w_amm_cfg_address;
   assign                 amm_cfg_out_writedata    = use_amm_cfg_in ? amm_cfg_in_writedata : w_amm_cfg_writedata;
   assign                 amm_cfg_out_write        = use_amm_cfg_in ? amm_cfg_in_write : w_amm_cfg_write;
   assign                 amm_cfg_out_read         = use_amm_cfg_in ? amm_cfg_in_read : w_amm_cfg_read;
   assign                 amm_cfg_in_readdata      = use_amm_cfg_in ? amm_cfg_out_readdata : '0;
   assign                 amm_cfg_in_readdatavalid = use_amm_cfg_in ? amm_cfg_out_readdatavalid : '0;

   assign emergency_brake_active = failure_occured & target_first_failing_addr;

   // Test stages signals mux
   always @ *
   begin
      case (stage)
         BYTEENABLE_STAGE:
         begin
            w_amm_cfg_address   = byteenable_test_stage_address;
            w_amm_cfg_writedata = byteenable_test_stage_writedata;
            w_amm_cfg_write     = byteenable_test_stage_write;
            w_amm_cfg_read      = byteenable_test_stage_read;
            traffic_gen_fail  = stage_failure;
            rand_num_enable      = '0;
         end
         SINGLE_RW, REPEAT_STAGE, BLOCK_RW, STRESS_STAGE:
         begin
            w_amm_cfg_address   = rw_stage_address;
            w_amm_cfg_writedata = rw_stage_writedata;
            w_amm_cfg_write     = rw_stage_write;
            w_amm_cfg_read      = rw_stage_read;
            traffic_gen_fail    = stage_failure;
            rand_num_enable     = rw_stage_rand_num_en;
         end
         TARGET_STAGE:
         begin
            w_amm_cfg_address   = target_stage_address;
            w_amm_cfg_writedata = target_stage_writedata;
            w_amm_cfg_write     = target_stage_write;
            w_amm_cfg_read      = target_stage_read;
            traffic_gen_fail    = stage_failure;
            rand_num_enable     = '0;
         end
         default:
         begin
            w_amm_cfg_address      = '0;
            w_amm_cfg_writedata    = '0;
            w_amm_cfg_write        = 1'b0;
            w_amm_cfg_read         = 1'b0;
            traffic_gen_fail     = stage_failure;
            rand_num_enable      = '0;
         end
      endcase
   end

   // Test stages state machine
   always_ff @(posedge clk, posedge rst)
   begin
      if (rst) begin
         stage            <= INIT;
         loop_counter     <= '0;
         wait_counter     <= '0;
      end
      else begin
         case (stage)
            INIT:
            begin
               // Start test immediately after rst deasserted
               if(amm_ctrl_ready) begin
                  if (BYPASS_DEFAULT_PATTERN && BYPASS_REPEAT_STAGE && BYPASS_STRESS_STAGE) begin
                     stage <= WAIT_USER_STAGE;
                  end else begin
                     stage <= (!BYPASS_DEFAULT_PATTERN)  ?  SINGLE_RW      :
                              ((!BYPASS_REPEAT_STAGE)    ?  REPEAT_STAGE   :
                                                            STRESS_STAGE   );
                     loop_counter <= loop_counter + 1'b1;
                  end
               end
            end
            SINGLE_RW:
            begin
               if (rw_stage_complete)
                  stage <= emergency_brake_active              ?  TARGET_STAGE      :
                           ((NUMBER_OF_BYTE_EN_GENERATORS > 0) ?  BYTEENABLE_STAGE  :
                                                                  BLOCK_RW );
            end
            BYTEENABLE_STAGE:
            begin
               if (byteenable_test_stage_complete)
                  stage <= (emergency_brake_active) ? TARGET_STAGE : BLOCK_RW;
            end
            BLOCK_RW:
            begin
               if (rw_stage_complete)
                  stage <= emergency_brake_active  ?  TARGET_STAGE   :
                           ((!BYPASS_REPEAT_STAGE) ?  REPEAT_STAGE   :
                           ((!BYPASS_STRESS_STAGE) ?  STRESS_STAGE   :
                                                      DONE_DEFAULT_PATTERN ));
            end
            REPEAT_STAGE:
            begin
               if (rw_stage_complete)
                  stage <= emergency_brake_active  ?  TARGET_STAGE   :
                           ((!BYPASS_STRESS_STAGE) ?  STRESS_STAGE   :
                                                      DONE_DEFAULT_PATTERN );
            end
            STRESS_STAGE:
            begin
               if (rw_stage_complete)
                  stage <= emergency_brake_active  ?  TARGET_STAGE   :  DONE_DEFAULT_PATTERN;
            end
            TARGET_STAGE:
            begin
               loop_counter <= NUM_DRIVER_LOOP;
               if (target_stage_complete) begin
                  stage <= DONE;
               end
            end
            DONE_DEFAULT_PATTERN:
            begin
               if (NUM_DRIVER_LOOP == 0) begin
                  // A setting of 0 means loop forever
                  stage <= INIT;
               end else if (loop_counter < NUM_DRIVER_LOOP) begin
                  // The loop limit has not yet been reached
                  stage <= INIT;
               end else begin
                  // Pass control to the amm_cfg_in interface, unless bypassed
                  stage <= BYPASS_USER_STAGE ? DONE : WAIT_USER_STAGE;
               end
            end
            WAIT_USER_STAGE:
            begin
               if (user_cfg_start) begin
                  loop_counter      <= '0;
                  stage             <= INIT_USER_STAGE;
               end
            end
            INIT_USER_STAGE:
            begin
               loop_counter <= loop_counter + 1'b1;
               stage <= DONE_USER_LOOP;
            end
            DONE_USER_LOOP:
            begin
               if (~amm_cfg_out_waitrequest) begin
                  if (wait_counter == 2'b11) begin
                     if (NUM_DRIVER_LOOP == 0) begin
                        stage <= INIT_USER_STAGE;
                     end else if (loop_counter < NUM_DRIVER_LOOP) begin
                        stage <= INIT_USER_STAGE;
                     end else begin
                        stage <= DONE;
                     end
                     wait_counter <= 1'b0;
                  end else begin
                     wait_counter <= wait_counter + 1'b1;
                     stage <= DONE_USER_LOOP;
                  end
               end else begin
                  wait_counter <= wait_counter;
                  stage <= DONE_USER_LOOP;
               end
            end
            DONE:
            begin
               loop_counter <= '0;
               if (user_cfg_start) begin
                  stage <= INIT_USER_STAGE;
               end else if (user_cfg_start_default) begin
                  stage <= INIT;
               end else begin
                  stage <= DONE;
               end
            end
         endcase
      end
   end

   //status outputs
   assign all_tests_issued = (stage == DONE);

   // TEST STAGE MODULE INSTANTIATIONS
   // These modules should comply with the following protocol:
   // - when 'rst' is deasserted, it should idle and listen to 'stage_enable'
   // - it should proceed with the test operations when 'stage_enable' is asserted
   // - when the test completes, it should assert 'stage_complete' and properly
   //drive the stage failure output signal (usually just plugging back in the input stage failure
   //which comes from the status checker, unless it is a multi run test) -this could be done above

   altera_emif_avl_tg_2_byteenable_test_stage #(
      .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS),
      .DATA_PATTERN_LENGTH          (DATA_PATTERN_LENGTH),
      .BYTE_EN_PATTERN_LENGTH       (BYTE_EN_PATTERN_LENGTH),
      .TG_TEST_DURATION             (TG_TEST_DURATION),
      .BURSTCOUNT_WIDTH             (BURSTCOUNT_WIDTH),
      .MEM_ADDR_WIDTH               (MEM_ADDR_WIDTH),
      .PORT_TG_CFG_ADDRESS_WIDTH    (PORT_TG_CFG_ADDRESS_WIDTH),
      .PORT_TG_CFG_RDATA_WIDTH      (PORT_TG_CFG_RDATA_WIDTH),
      .PORT_TG_CFG_WDATA_WIDTH      (PORT_TG_CFG_WDATA_WIDTH)
   ) byteenable_test_stage_inst(
      .clk                          (clk),
      .rst                          (rst),
      .enable                       ((stage==BYTEENABLE_STAGE)),
      .amm_cfg_waitrequest          (amm_cfg_out_waitrequest),
      .amm_cfg_address              (byteenable_test_stage_address),
      .amm_cfg_writedata            (byteenable_test_stage_writedata),
      .amm_cfg_write                (byteenable_test_stage_write),
      .amm_cfg_read                 (byteenable_test_stage_read),
      .stage_complete               (byteenable_test_stage_complete),
      .rand_burstcount_en           (byteenable_test_stage_rand_num_en),
      .rand_burstcount              (rand_burstcount)
   );

   //read/write test stages
   altera_emif_avl_tg_2_rw_stage # (
      .TG_TEST_DURATION             (TG_TEST_DURATION),
      .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS),
      .DATA_PATTERN_LENGTH          (DATA_PATTERN_LENGTH),
      .BYTE_EN_PATTERN_LENGTH       (BYTE_EN_PATTERN_LENGTH),
      .BURSTCOUNT_WIDTH             (BURSTCOUNT_WIDTH),
      .AMM_BURST_COUNT_DIVISIBLE_BY (AMM_BURST_COUNT_DIVISIBLE_BY),
      .MEM_ADDR_WIDTH               (MEM_ADDR_WIDTH),
      .PORT_TG_CFG_ADDRESS_WIDTH    (PORT_TG_CFG_ADDRESS_WIDTH),
      .PORT_TG_CFG_RDATA_WIDTH      (PORT_TG_CFG_RDATA_WIDTH),
      .PORT_TG_CFG_WDATA_WIDTH      (PORT_TG_CFG_WDATA_WIDTH),
      .WRITE_GROUP_WIDTH            (WRITE_GROUP_WIDTH)
   ) rw_stage (
      .clk                             (clk),
      .rst                             (rst),
      .enable                          (stage == SINGLE_RW || stage == BLOCK_RW || stage == REPEAT_STAGE || stage == STRESS_STAGE),
      .block_rw_mode                   (stage == BLOCK_RW),
      .repeat_mode                     (stage == REPEAT_STAGE),
      .stress_mode                     (stage == STRESS_STAGE),
      .amm_cfg_waitrequest             (amm_cfg_out_waitrequest),
      .amm_cfg_address                 (rw_stage_address),
      .amm_cfg_writedata               (rw_stage_writedata),
      .amm_cfg_write                   (rw_stage_write),
      .amm_cfg_read                    (rw_stage_read),
      .stage_complete                  (rw_stage_complete),

      .emergency_brake_active          (emergency_brake_active),

      .rand_burstcount_en              (rw_stage_rand_num_en),
      .rand_burstcount                 (rand_burstcount)

   );

   assign target_stage_enable = (stage == TARGET_STAGE);

   //read/write test stages
   altera_emif_avl_tg_2_targetted_reads_test_stage # (
      .TG_TEST_DURATION             (TG_TEST_DURATION),
      .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS),
      .DATA_PATTERN_LENGTH          (DATA_PATTERN_LENGTH),
      .BYTE_EN_PATTERN_LENGTH       (BYTE_EN_PATTERN_LENGTH),
      .BURSTCOUNT_WIDTH             (BURSTCOUNT_WIDTH),
      .MEM_ADDR_WIDTH               (AMM_WORD_ADDRESS_WIDTH),
      .PORT_TG_CFG_ADDRESS_WIDTH    (PORT_TG_CFG_ADDRESS_WIDTH),
      .PORT_TG_CFG_RDATA_WIDTH      (PORT_TG_CFG_RDATA_WIDTH),
      .PORT_TG_CFG_WDATA_WIDTH      (PORT_TG_CFG_WDATA_WIDTH),
      .WRITE_GROUP_WIDTH            (WRITE_GROUP_WIDTH)
   ) target_reads (
      .clk                             (clk),
      .rst                             (rst),
      .enable                          (target_stage_enable),
      .amm_cfg_waitrequest             (amm_cfg_out_waitrequest),
      .amm_cfg_address                 (target_stage_address),
      .amm_cfg_writedata               (target_stage_writedata),
      .amm_cfg_write                   (target_stage_write),
      .amm_cfg_read                    (target_stage_read),
      .stage_complete                  (target_stage_complete),
      .target_address                  (first_fail_addr)
   );

   //random number generator that the test stages can use to generate random burst lengths within a range
   altera_emif_avl_tg_2_rand_num_gen # (
      .RAND_NUM_WIDTH               (BURSTCOUNT_WIDTH),
      .RAND_NUM_MIN                 (TG_MIN_BURSTCOUNT),
      .RAND_NUM_MAX                 (TG_MAX_BURSTCOUNT),
      .AMM_BURST_COUNT_DIVISIBLE_BY (AMM_BURST_COUNT_DIVISIBLE_BY)
   ) rand_burstcount_gen (
      .clk               (clk),
      .rst               (rst),
      .enable            (rand_num_enable),
      .ready             (),
      .rand_num          (rand_burstcount)
      );

endmodule
