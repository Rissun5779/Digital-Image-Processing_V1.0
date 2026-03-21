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


// This module uses a fifo to store the read addresses, in order to
// use them to determine when to generate the next read compare data.
// If consecutive addresses are the same, we are doing multiple reads
// to the same address and hence should not update the read compare data.
// The status checker also uses this address to report at which address a
// failure occurred.

module altera_emif_avl_tg_2_compare_addr_gen # (
   parameter AMM_WORD_ADDRESS_WIDTH      = "",
   parameter ADDR_FIFO_DEPTH             = "",
   parameter AMM_BURSTCOUNT_WIDTH        = "",
   parameter READ_RPT_COUNT_WIDTH        = "",
   parameter READ_COUNT_WIDTH            = "",
   parameter READ_LOOP_COUNT_WIDTH       = ""
) (
    // Clock and reset
   input                               clk,
   input                               rst,

   input                               emergency_brake_asserted,

   //signals the traffic gen is starting new run
   input                               tg_restart,

    //read counters needed by status checker to know when all reads received
   input [READ_COUNT_WIDTH-1:0]        num_read_bursts,
   input [READ_LOOP_COUNT_WIDTH-1:0]   num_read_loops,
   input                               is_repeat_test,

   input [31:0]                        cmp_read_rpt_cnt,

   // Avalon read data
   input                               rdata_valid,

   output                              fifo_almost_full,
   output logic                        next_read_data_en,

   input [AMM_WORD_ADDRESS_WIDTH-1:0]  read_addr,
   input                               read_addr_valid,

   input [AMM_BURSTCOUNT_WIDTH-1:0]    burst_length,
   output logic [AMM_WORD_ADDRESS_WIDTH-1:0]       current_written_addr,

   //address outputs from the read address fifo
   output   logic [AMM_WORD_ADDRESS_WIDTH-1:0]     read_addr_fifo_out,

   output logic                        check_in_prog
);

   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   // FIFO address width
   localparam FIFO_WIDTHU = ceil_log2(ADDR_FIFO_DEPTH);
   // Actual FIFO size
   localparam FIFO_NUMWORDS = 2 ** FIFO_WIDTHU;

   // Read/write data registers
   logic                         rdata_valid_r;

   logic [AMM_BURSTCOUNT_WIDTH-1:0] burst_length_counter;
   logic [READ_COUNT_WIDTH-1:0]     burst_num_counter;

   reg [READ_LOOP_COUNT_WIDTH-1:0] loop_cntr;

   logic  burst_mode;
   assign burst_mode = (burst_length > 1'b1);
   logic fifo_read_req;
   logic fifo_write_req;
   logic fifo_empty;
   logic fifo_full;
   logic [FIFO_WIDTHU-1:0] words_in_fifo;

   reg [READ_LOOP_COUNT_WIDTH-1:0] num_read_loops_r;


   // A separate data generator is used to re-generate the written data/mask for read comparison.
   // This saves us from the need of instantiating a FIFO to record the write data
   always_ff @(posedge clk)
   begin
      if (rdata_valid) begin
         if (burst_length_counter == '0) begin
            current_written_addr <= read_addr_fifo_out;
         end
         else begin
            current_written_addr <= current_written_addr + 1'b1;
         end
      end
   end

   always_ff @(posedge clk, posedge rst)
   begin
      if (rst) begin
         check_in_prog <= 1'b0;
         rdata_valid_r <= 1'b0;
      end else begin
         if (!check_in_prog) begin
            // When tg_restart is set, checking begins
            check_in_prog <= tg_restart;
         end else if (emergency_brake_asserted & (burst_length_counter == '0)) begin
            check_in_prog <= ~fifo_empty;
         end else if (loop_cntr != num_read_loops_r && num_read_bursts > 0) begin
            // Checking continues until the desired number of loops is reached
            check_in_prog <= 1'b1;
         end else begin
            check_in_prog <= |(words_in_fifo);
         end
         rdata_valid_r <= rdata_valid;
      end
   end

   // Enable data/be generator to generate the next item
   always_ff @(posedge clk, posedge rst)
   begin
      if (rst)
         next_read_data_en <= 1'b0;
      else
         next_read_data_en <= rdata_valid_r & (burst_mode | (cmp_read_rpt_cnt == 32'h1) | fifo_empty);
   end

   //In order to report the address of a failure, a fifo is required to store the read addresses
   //due to the ability to read multiple times from the same address
   //This fifo is also used to tell the data generator when to produce the next data for comparison
   //by comparing whether the top 2 addresses of the fifo are the same or not

   //when the fifo is almost full, waitrequest is issued to the traffic generator so that no more
   //operations are issued until the read data comes back from the controller
   assign fifo_write_req = read_addr_valid;

   //once the count of the number of burst equals the number of read bursts issued, the last starting address will
   //already have been dequeued from the fifo. reading from it again will read from an empty fifo
   //we also only need to get the next address once per burst, as it is the start address of the burst
   assign fifo_read_req  = rdata_valid & (burst_length_counter == '0); //burst_length);

   //count the length of the burst, only get next addr once per burst
   always_ff @(posedge clk, posedge rst)
   begin
      if (rst) begin
         burst_length_counter <= '0; 
      end else begin
         if (tg_restart) begin
            burst_length_counter <= '0; 
         end else if (rdata_valid) begin
            if (burst_length_counter == burst_length - 1'b1) begin
               burst_length_counter <= '0; 
            end else begin
               burst_length_counter <= burst_length_counter + 1'b1;
            end
         end else begin
            burst_length_counter <= burst_length_counter;
         end
      end
   end

   //also count number of reads completed to know when stage is complete
   //when there are more reads to go, the traffic generator should not be allowed to be configured
   //and start a new run
   //this means need to count length of burst, number of repeats, number of bursts, and number of loops
   //burst mode and read repeats are mutually exclusive

   always_ff @(posedge clk, posedge rst)
   begin
      if (rst) begin
         burst_num_counter <= '0;
         loop_cntr <= '0;
      end else begin
         if (tg_restart) begin
            burst_num_counter <= '0;
            loop_cntr <= '0;
         end else if (burst_mode) begin
            if (rdata_valid_r) begin
               if (burst_length_counter == '0) begin //on last cycle of each burst
                  burst_num_counter <= burst_num_counter + 1'b1;
                  if (burst_num_counter == num_read_bursts - 1'b1) begin //done 1 loop
                     loop_cntr <= loop_cntr + 1'b1;
                     burst_num_counter <= '0;
                  end
               end
            end
         end else begin  //not burst, could have repeats
            if (rdata_valid_r & ((!is_repeat_test) || (cmp_read_rpt_cnt == 32'h2))) begin
               burst_num_counter <= burst_num_counter + 1'b1;
               if (burst_num_counter == num_read_bursts - 1'b1) begin //done 1 loop
                  loop_cntr <= loop_cntr + 1'b1;
                  burst_num_counter <= '0;
               end
            end
         end
      end
   end

   always_ff @ (posedge clk, posedge rst)
   begin
      if (rst) begin
         num_read_loops_r   <= '0;
      end
      else if (tg_restart) begin
         num_read_loops_r   <= num_read_loops;
      end
   end

   //read address fifo
   scfifo # (
         .lpm_width                (AMM_WORD_ADDRESS_WIDTH), //width of data (addr)
         .lpm_widthu               (FIFO_WIDTHU), //width of used
         .lpm_numwords             (FIFO_NUMWORDS), //depth
         .lpm_showahead            ("ON"),
         .almost_full_value        (FIFO_NUMWORDS > 2 ? FIFO_NUMWORDS-2 : 1),
         .use_eab                  ("OFF"),
         .overflow_checking        ("OFF"),
         .underflow_checking       ("OFF")
      ) read_addr_fifo (
         .rdreq                    (fifo_read_req & ~fifo_empty),
         .aclr                     (rst),
         .clock                    (clk),
         .wrreq                    (fifo_write_req),
         .data                     (read_addr),
         .full                     (fifo_full),
         .q                        (read_addr_fifo_out),
         .sclr                     (),
         .usedw                    (words_in_fifo),
         .empty                    (fifo_empty),
         .almost_full              (fifo_almost_full),
         .almost_empty             ()
      );

endmodule
