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
// The is a highly simplified version of the driver. It performs writes and
// reads to address 0 with static data (0's and 1's) in a loop.
//////////////////////////////////////////////////////////////////////////////
module altera_emif_avl_tg_driver_simple # (

   parameter DEVICE_FAMILY                          = "",
   parameter PROTOCOL_ENUM                          = "",

   ////////////////////////////////////////////////////////////
   // AVALON SIGNAL WIDTHS
   ////////////////////////////////////////////////////////////
   parameter TG_AVL_ADDR_WIDTH                      = 33,
   parameter TG_AVL_WORD_ADDR_WIDTH                 = 27,
   parameter TG_AVL_SIZE_WIDTH                      = 7,
   parameter TG_AVL_DATA_WIDTH                      = 288,
   parameter TG_AVL_BE_WIDTH                        = 36,

   ////////////////////////////////////////////////////////////
   // DRIVER CONFIGURATION
   ////////////////////////////////////////////////////////////
   
   // Specifies alignment criteria for Avalon-MM word addresses and burst count
   parameter AMM_WORD_ADDRESS_DIVISIBLE_BY          = 1,
   parameter AMM_BURST_COUNT_DIVISIBLE_BY           = 1,
   
   // Indicates whether a separate interface exists for reads and writes.
   // Typically set to 1 for QDR-style interfaces where concurrent reads and
   // writes are possible
   parameter TG_SEPARATE_READ_WRITE_IFS             = 0
      
) (
   // Clock and reset
   input  logic                                     clk,
   input  logic                                     reset_n,

   // Avalon master signals 
   input  logic                                     avl_ready,
   output logic                                     avl_write_req,
   output logic                                     avl_read_req,
   output logic [TG_AVL_ADDR_WIDTH-1:0]             avl_addr,
   output logic [TG_AVL_SIZE_WIDTH-1:0]             avl_size,
   output logic [TG_AVL_BE_WIDTH-1:0]               avl_be,
   output logic [TG_AVL_DATA_WIDTH-1:0]             avl_wdata,
   input  logic                                     avl_rdata_valid,
   input  logic [TG_AVL_DATA_WIDTH-1:0]             avl_rdata,
   
   // Avalon master signals (Dedicated write interface for QDR-style where concurrent reads and writes are possible)
   input  logic                                     avl_ready_w,
   output logic [TG_AVL_ADDR_WIDTH-1:0]             avl_addr_w,
   output logic [TG_AVL_SIZE_WIDTH-1:0]             avl_size_w,

   // Driver status signals
   output logic                                     pass,
   output logic                                     fail,
   output logic                                     timeout,
   output logic [TG_AVL_DATA_WIDTH-1:0]             pnf_per_bit,
   output logic [TG_AVL_DATA_WIDTH-1:0]             pnf_per_bit_persist
) /* synthesis dont_merge syn_preserve = 1 */;
   timeunit 1ns;
   timeprecision 1ps;

   // Determines how many loops to perform. Number of loops = 2^LOOP_COUNTER_WIDTH.
   localparam LOOP_COUNT_WIDTH = 2;
   
   // Register read data signals to ease timing closure
   logic                           avl_rdata_valid_r;
   logic [TG_AVL_DATA_WIDTH-1:0]   avl_rdata_r;
   
   logic                           avl_ready_for_write;
   
   logic [TG_AVL_DATA_WIDTH-1:0]   nxt_golden_data;
   logic [TG_AVL_DATA_WIDTH-1:0]   nxt_pnf_per_bit;
   logic                           nxt_avl_write_req;
   logic                           nxt_avl_read_req;
   logic [TG_AVL_SIZE_WIDTH-1:0]   nxt_burst_count;
   logic [LOOP_COUNT_WIDTH-1:0]    nxt_loop_count;
   
   logic [TG_AVL_DATA_WIDTH-1:0]   golden_data;
   logic [TG_AVL_SIZE_WIDTH-1:0]   burst_count;
   logic [LOOP_COUNT_WIDTH-1:0]    loop_count;

   enum int unsigned {
      INIT,
      ISSUE_WRITE,
      WAIT_WRITE_DONE,
      ISSUE_READ,
      WAIT_READ_ACCEPTED,
      WAIT_READ_DONE,
      NEXT_LOOP,
      DONE_PASS,
      DONE_FAIL
   } state, nxt_state;
   
   ////////////////////////////////////////////////////////////////////////////
   // The following control or externally visible signals must be reset
   ////////////////////////////////////////////////////////////////////////////
   always_ff @(posedge clk or negedge reset_n)
   begin
      if (!reset_n) begin
         state             <= INIT;
         avl_write_req     <= 1'b0;
         avl_read_req      <= 1'b0; 
         avl_rdata_valid_r <= 1'b0;
         loop_count        <= '0;
         pnf_per_bit       <= '1;
      end else begin
         state             <= nxt_state;
         avl_write_req     <= nxt_avl_write_req;
         avl_read_req      <= nxt_avl_read_req;        
         avl_rdata_valid_r <= avl_rdata_valid;
         loop_count        <= nxt_loop_count;
         pnf_per_bit       <= nxt_pnf_per_bit;
      end
   end
   
   ////////////////////////////////////////////////////////////////////////////
   // The following data signals don't need to be reset
   ////////////////////////////////////////////////////////////////////////////
   always_ff @(posedge clk)
   begin
      avl_wdata    <= golden_data;
      avl_rdata_r  <= avl_rdata;
      burst_count  <= nxt_burst_count;
      golden_data  <= nxt_golden_data;
   end
   
   ////////////////////////////////////////////////////////////////////////////
   // The following are constant, to reduce the number of unnecessary C2P/P2C
   // connections.
   ////////////////////////////////////////////////////////////////////////////
   assign avl_addr       = '0;
   assign avl_be         = '1;
   assign avl_size       = AMM_BURST_COUNT_DIVISIBLE_BY[TG_AVL_SIZE_WIDTH-1:0];
   assign avl_addr_w     = avl_addr;
   assign avl_size_w     = avl_size;
   
   assign avl_ready_for_write = (TG_SEPARATE_READ_WRITE_IFS ? avl_ready_w : avl_ready);
   
   ////////////////////////////////////////////////////////////////////////////
   // Status signal logic
   ////////////////////////////////////////////////////////////////////////////
   assign pass                = (state == DONE_PASS);
   assign fail                = (state == DONE_FAIL);
   assign timeout             = '0;
   assign pnf_per_bit_persist = pnf_per_bit;
     
   ////////////////////////////////////////////////////////////////////////////
   // Next-state logic
   ////////////////////////////////////////////////////////////////////////////
   always_comb
   begin
      // Default values
      nxt_state          <= INIT;
      nxt_avl_write_req  <= 1'b0;
      nxt_avl_read_req   <= 1'b0;
      nxt_golden_data    <= golden_data;
      nxt_burst_count    <= burst_count;
      nxt_loop_count     <= loop_count;
      nxt_pnf_per_bit    <= pnf_per_bit;
         
      case (state)
         INIT:
            begin
               // update golden data, which is also the write data, and proceed to write
               nxt_state       <= ISSUE_WRITE;
               nxt_golden_data <= {TG_AVL_DATA_WIDTH{loop_count[0]}};
            end
      
         ISSUE_WRITE:
            begin
               // issue write command and proceed to wait for completion
               nxt_state          <= WAIT_WRITE_DONE;
               nxt_avl_write_req  <= 1'b1;
               nxt_burst_count    <= avl_size - 1'b1;
            end
      
         WAIT_WRITE_DONE:
            begin
               if (!avl_ready_for_write) begin
                  // write data not accepted, wait while holding Avalon signals constants
                  nxt_state         <= WAIT_WRITE_DONE;
                  nxt_avl_write_req <= 1'b1;
                  nxt_burst_count   <= burst_count;
                  
               end else if (burst_count == '0) begin
                  // command accepted and burst is done, proceed to do read
                  nxt_state <= ISSUE_READ;
                  
               end else begin
                  // command accepted but burst isn't done, send out the next beat
                  nxt_state          <= WAIT_WRITE_DONE;
                  nxt_avl_write_req  <= 1'b1;
                  nxt_burst_count    <= burst_count - 1'b1;
               end
            end
         
         ISSUE_READ:
            begin
               // issue read command and proceed to wait for command acceptance
               nxt_state          <= WAIT_READ_ACCEPTED;
               nxt_avl_read_req   <= 1'b1;
               nxt_burst_count    <= avl_size - 1'b1;
            end
            
         WAIT_READ_ACCEPTED:
            begin
               if (!avl_ready) begin
                  // command not yet accepted, wait while holding Avalon signals constants
                  nxt_state          <= WAIT_READ_ACCEPTED;
                  nxt_avl_read_req   <= 1'b1;
                  nxt_burst_count    <= avl_size - 1'b1;
               end else begin
                  // command accepted, wait for read data return
                  nxt_state          <= WAIT_READ_DONE;
                  nxt_burst_count    <= avl_size - 1'b1;
               end
            end
         
         WAIT_READ_DONE:
            begin
               if (avl_rdata_valid_r) begin
                  // data is available, compare against golden
                  if (avl_rdata_r == golden_data) begin
                     // correct data
                     if (burst_count == '0) begin
                        // last beat has been received, proceed to next iteration
                        nxt_state <= NEXT_LOOP;
                     end else begin
                        // not all data has come back, keep waiting
                        nxt_state <= WAIT_READ_DONE;
                        nxt_burst_count <= burst_count - 1'b1;
                     end
                  end else begin
                     // incorrect data, update pnf, and fail test
                     nxt_state <= DONE_FAIL;
                     nxt_pnf_per_bit <= ~(avl_rdata_r ^ golden_data);
                  end
               end else begin
                  // no valid data, keep waiting
                  nxt_state <= WAIT_READ_DONE;
                  nxt_burst_count <= burst_count;
               end
            end
            
         NEXT_LOOP:
            begin
               if (loop_count == '1) begin
                  // all iterations completed, pass test
                  nxt_state <= DONE_PASS;
               end else begin
                  // proceed to next iteration 
                  nxt_state <= INIT;
                  nxt_loop_count <= loop_count + 1'b1;
               end
            end
            
         DONE_PASS:
            begin
               nxt_state <= DONE_PASS;
            end
            
         DONE_FAIL:
            begin
               nxt_state <= DONE_FAIL;
            end
      endcase
   end
endmodule
