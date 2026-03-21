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

module altera_emif_avl_tg_2_targetted_reads_test_stage # (

   // The number of write/read cycles that each address generator is used
   parameter TG_TEST_DURATION               = "SHORT",
   parameter NUMBER_OF_DATA_GENERATORS      = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS   = "",
   parameter DATA_PATTERN_LENGTH            = "",
   parameter BYTE_EN_PATTERN_LENGTH         = "",
   parameter BURSTCOUNT_WIDTH               = "",
   parameter MEM_ADDR_WIDTH                 = "",
   parameter PORT_TG_CFG_ADDRESS_WIDTH      = 1,
   parameter PORT_TG_CFG_RDATA_WIDTH        = 1,
   parameter PORT_TG_CFG_WDATA_WIDTH        = 1,
   parameter WRITE_GROUP_WIDTH              = 1
) (
   // Clock and reset
   input                                          clk,
   input                                          rst,

   input [MEM_ADDR_WIDTH-1:0]                     target_address,

   input                                          enable,
   output                                         stage_complete,
   input                                          amm_cfg_waitrequest,
   output logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]   amm_cfg_address,
   output logic [PORT_TG_CFG_WDATA_WIDTH-1:0]     amm_cfg_writedata,
   output logic                                   amm_cfg_write,
   output logic                                   amm_cfg_read

);

   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   localparam ADDR_H_BASE           = (MEM_ADDR_WIDTH > 'd32) ? 32: 0;
   localparam ADDR_L_TOP            = (MEM_ADDR_WIDTH < 'd32) ? MEM_ADDR_WIDTH - 1 : 31;
   localparam ADDR_COUNT            = (TG_TEST_DURATION == "SHORT") ? 1 : 1;

   logic [31:0] block_size;
   assign block_size = 32'h1;
   logic [31:0] num_read_repeats;
   logic [31:0] num_write_repeats;
   assign num_read_repeats = (TG_TEST_DURATION == "SHORT") ? 32'h1 : 32'h1;
   assign num_write_repeats = 32'h1;

   typedef enum int unsigned {
      INIT,
      CFG_ADDR_WR_L, CFG_ADDR_WR_H, CFG_ADDR_MODE_WR,
      CFG_ADDR_RD_L, CFG_ADDR_RD_H, CFG_ADDR_MODE_RD,
      CFG_SEQ_ADDR_INCR,
      CFG_DATA_SEED, CFG_DATA_MODE,
      CFG_BYTEEN_SEED, CFG_BYTEEN_MODE,
      CFG_LOOP_COUNT, CFG_WRITE_COUNT, CFG_READ_COUNT,
      CFG_WRITE_REPEAT_COUNT, CFG_READ_REPEAT_COUNT, CFG_BURST_LENGTH,
      CFG_WORM_TEST_ENABLE,
      CFG_START,
      TEST_IN_PROG,
      DONE
   } cfg_state_t;

   cfg_state_t state;
   reg [1:0]         wait_counter;

   always_ff @(posedge clk, posedge rst)
   begin
      if (rst) begin
         state         <= INIT;
         amm_cfg_write <= 1'b0;
         amm_cfg_read  <= 1'b0;
         amm_cfg_address   <= '0;
         amm_cfg_writedata <= '0;
         wait_counter  <= '0;
      end
      else begin
         case (state)
            INIT:
            begin
               amm_cfg_write    <= 1'b0;
               amm_cfg_read     <= 1'b0;
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
               amm_cfg_writedata  <= target_address[ADDR_L_TOP:0];
               if (MEM_ADDR_WIDTH > 'd32) begin
                  state           <= CFG_ADDR_WR_H;
               end else begin
                  state           <= CFG_ADDR_MODE_WR;
               end
            end
            CFG_ADDR_WR_H:
            begin
               amm_cfg_address    <= TG_SEQ_START_ADDR_WR_H;
               amm_cfg_writedata  <= target_address[MEM_ADDR_WIDTH-1:ADDR_H_BASE];
               state              <= CFG_ADDR_MODE_WR;
            end
            CFG_ADDR_MODE_WR:
            begin
               amm_cfg_address    <= TG_ADDR_MODE_WR;
               amm_cfg_writedata  <= TG_ADDR_SEQ;
               state              <= CFG_ADDR_RD_L;
            end

            CFG_ADDR_RD_L:
            begin
               amm_cfg_address    <= TG_SEQ_START_ADDR_RD_L;
               amm_cfg_writedata  <= target_address[ADDR_L_TOP:0];
               if (MEM_ADDR_WIDTH > 'd32) begin
                  state           <= CFG_ADDR_RD_H;
               end else begin
                  state           <= CFG_ADDR_MODE_RD;
               end
            end
            CFG_ADDR_RD_H:
            begin
               amm_cfg_address    <= TG_SEQ_START_ADDR_RD_H;
               amm_cfg_writedata  <= target_address[MEM_ADDR_WIDTH-1:ADDR_H_BASE];
               state              <= CFG_ADDR_MODE_RD;
            end
            CFG_ADDR_MODE_RD:
            begin
               amm_cfg_address    <= TG_ADDR_MODE_RD;
               amm_cfg_writedata  <= TG_ADDR_SEQ;
               state              <= CFG_SEQ_ADDR_INCR;
            end

            CFG_SEQ_ADDR_INCR:
            begin
               amm_cfg_address    <= TG_SEQ_ADDR_INCR;
               amm_cfg_writedata  <= 32'h0;
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
               amm_cfg_writedata <= 32'h0;
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
               amm_cfg_writedata <= 32'h1;
               state             <= CFG_WRITE_REPEAT_COUNT;
            end
            CFG_WRITE_REPEAT_COUNT:
            begin
               amm_cfg_address   <= TG_WRITE_REPEAT_COUNT;
               amm_cfg_writedata <= num_write_repeats;
               state             <= CFG_READ_REPEAT_COUNT;
            end
            CFG_READ_REPEAT_COUNT:
            begin
               amm_cfg_address   <= TG_READ_REPEAT_COUNT;
               amm_cfg_writedata <= num_read_repeats;
               state             <= CFG_START;
            end
            CFG_START:
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
               state <= INIT;
            end
         endcase
      end
   end

   // Status outputs
   assign stage_complete = (state == DONE);
endmodule

