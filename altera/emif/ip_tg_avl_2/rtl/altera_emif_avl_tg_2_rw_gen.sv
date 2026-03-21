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


//-------------------------------------------------------------------------------
// Filename    : rw_gen.v
// Description : Read-Write Enable Generator. Issues a block of "num_writes"
//                writes to different addresses (which can be random, sequential,
//                etc), performing each write "num_write_repeats" times. Then,
//                issues a block of "num_reads" reads to the read addresses,
//                performing each read "num_read_repeats" times. This sequence
//                repeats "num_loops" times, with addresses and data different on
//                every iteration of the loop.
//                The operation_handler module manages the operation counters,
//                while the rw_gen module manages the FSM and the outer loop counter.
//                Repeats are managed in the higher level traffic generator module.
//-----------------------------------------------------------------------------

module altera_emif_avl_tg_2_rw_gen #(
   //counter widths
   parameter SEPARATE_READ_WRITE_IFS = "",
   parameter OPERATION_COUNT_WIDTH   = "",
   parameter LOOP_COUNT_WIDTH        = "",
   parameter AMM_BURSTCOUNT_WIDTH    = ""
   )(
   input        clk,
   input        rst,
   output       valid,
   output       read_enable,
   output       write_enable,

   //Signals to address generators to generate next read or write address
   //Asserted on last write of write_rpt_cntr, last read of read_rpt_cntr
   output       next_addr_read,
   output       next_addr_write,
   output       next_data_read,
   output       next_data_write,

   //backpressure to the configuration unit
   //reconfiguration cannot be performed during operations outside IDLE state
   output       waitrequest,

   //in the interest of generating new data signals, combines cases of repeat count
   //being met and the AMM interface being ready for another operation.
   input        read_ready,
   input        write_ready,

   input        emergency_brake_asserted,

   //configuration signals
   //Perform reconfiguration, restart operations with new inputs
   input start,

   //input configuration counter values
   //these get registered upon input to the higher level traffic generator module
   //and will remain stable outside of IDLE state, allowing them to be used for comparisons
   //number of times to duplicate each read or write operation - inner loop
   input [OPERATION_COUNT_WIDTH-1:0] num_writes,
   input [OPERATION_COUNT_WIDTH-1:0] num_reads,

   //number of loops over the total write-read block of operations - outer loop
   input [LOOP_COUNT_WIDTH-1:0] num_loops,

   input [AMM_BURSTCOUNT_WIDTH-1:0] burstlength

   );
   timeunit 1ns;
   timeprecision 1ps;

   //counters
   wire [OPERATION_COUNT_WIDTH-1:0] write_cntr;
   wire [OPERATION_COUNT_WIDTH-1:0] read_cntr;
   reg  [LOOP_COUNT_WIDTH-1:0]      loop_cntr;
   wire [AMM_BURSTCOUNT_WIDTH-1:0]  write_burst_cntr;

   wire have_reads;
   wire have_writes;

   //states
   typedef enum int unsigned {
      IDLE,
      WRITE,
      WAIT_FOR_WRITES,
      READ
   } state_t;
   state_t    state, read_state;

   //read and write handlers
   //handle write_cntr, read_cntr, write_rpt_cntr, read_rpt_cntr
   altera_emif_avl_tg_2_operation_handler #(OPERATION_COUNT_WIDTH, AMM_BURSTCOUNT_WIDTH)
   read_handler(
      .clk                 (clk),
      .ready               (read_ready),
      .enable              (read_enable),
      .load                (start),
      .load_operation_cntr (num_reads),
      .operation_cntr      (read_cntr),
      .have_operations     (have_reads),
      .next_addr_enable    (next_addr_read),
      .next_data_enable    (next_data_read),
      //reads are not concerned with burst length, status checker will handle addressing issues
      //since read must only be asserted for one cycle
      .burstlength         ({ {(AMM_BURSTCOUNT_WIDTH-1){1'b0}}, 1'b1 }),
      .burst_counter       ()
   );
   altera_emif_avl_tg_2_operation_handler #(OPERATION_COUNT_WIDTH, AMM_BURSTCOUNT_WIDTH)
   write_handler(
      .clk                 (clk),
      .ready               (write_ready),
      .enable              (write_enable),
      .load                (start),
      .load_operation_cntr (num_writes),
      .operation_cntr      (write_cntr),
      .have_operations     (have_writes),
      .next_addr_enable    (next_addr_write),
      .next_data_enable    (next_data_write),
      //writes need to be aware of burstlength for when to update the address generator
      //write must remain asserted for entirety of burst
      .burstlength         (burstlength),
      .burst_counter       (write_burst_cntr)
   );

   //State machine handling write and read enable states and looping of
   //consecutive read and write blocks
   always @(posedge clk, posedge rst)
   begin
      if (rst) begin
         state <= IDLE;
         //default to 1 loop
         loop_cntr <= 1'b1;
      end
      else begin
         case (state)

            IDLE:
               begin
                  if (start) begin
                     //flop in configurations
                     loop_cntr <= num_loops;

                     if ( have_writes & ~emergency_brake_asserted) begin //some writes to do
                        state <= WRITE;
                     end
                     else if (have_reads & ~emergency_brake_asserted) begin
                        state <= READ;
                     end
                  end
               end

            WRITE:
               begin
                  if (write_burst_cntr == 1 && write_ready) begin
                     if (emergency_brake_asserted) begin
                        loop_cntr <= 1'b1;
                        state    <= IDLE;
                     end
                     else if (write_cntr == 1) begin //last write of last set
                        if (have_reads && !SEPARATE_READ_WRITE_IFS) begin //if any reads to do, do them
                           state <= READ;
                        end
                        else begin //no reads
                           loop_cntr <= loop_cntr - 1'b1;
                           if (loop_cntr == 1) begin
                              state    <= IDLE;
                           end
                        end
                     end
                  end
               end

            READ:
               begin
                  if (emergency_brake_asserted) begin
                     loop_cntr <= 1'b1;
                     state    <= IDLE;
                  end
                  else if (read_cntr == 1 && read_ready) begin //last read of last set
                     loop_cntr <= loop_cntr - 1'b1;
                     if (loop_cntr > 1) begin
                        //if any writes to do, do them
                        if ( have_writes ) begin
                           state <= WRITE;
                        end  //otherwise stay for next loop of reads
                     end else begin //done all loops, done all operations
                        state    <= IDLE;
                     end
                  end
               end
         endcase
      end
   end

   // FSM for protocols which issue reads concurrently with writes.
   // Allow a read loop to be issued after its corresponding write loop is done.
   generate
   if (SEPARATE_READ_WRITE_IFS) begin
      logic  [LOOP_COUNT_WIDTH-1:0] read_loop_cntr;
      always @(posedge clk, posedge rst)
      begin
         if (rst) begin
            read_state <= IDLE;
            //default to 1 loop
            read_loop_cntr <= 1'b1;
         end
         else begin
            case (read_state)

               IDLE: begin
                  read_loop_cntr <= num_loops;
                  if (start && have_reads & ~emergency_brake_asserted) begin
                     read_state <= WAIT_FOR_WRITES;
                  end else begin
                     read_state <= IDLE;
                  end
               end

               WAIT_FOR_WRITES: begin
                  if (have_reads && read_loop_cntr > loop_cntr) begin
                     read_state <= READ;
                  end else begin
                     read_state <= WAIT_FOR_WRITES;
                  end
               end

               READ: begin
                  if (emergency_brake_asserted) begin
                     read_loop_cntr <= 1'b1;
                     read_state    <= IDLE;
                  end
                  else if (read_cntr == 1 && read_ready) begin //last read of last set
                     if (read_loop_cntr > 1) begin
                        read_loop_cntr <= read_loop_cntr - 1'b1;
                        if (!(read_loop_cntr > loop_cntr)) begin
                           read_state <= WAIT_FOR_WRITES;
                        end else begin
                           read_state <= READ;
                        end
                     end else begin //done all loops, done all operations
                        read_state    <= IDLE;
                     end
                  end
               end
            endcase
         end
      end
   end else begin
      assign read_state = state;
   end
   endgenerate

   assign valid = read_enable | write_enable;
   assign waitrequest = valid | rst | start;

   assign write_enable = (state == WRITE);
   assign read_enable  = ((SEPARATE_READ_WRITE_IFS ? read_state : state) == READ);

endmodule

module altera_emif_avl_tg_2_operation_handler #(
   parameter OPERATION_COUNT_WIDTH = "",
   parameter AMM_BURSTCOUNT_WIDTH  = ""
   )(
   input  clk,
   input  ready,
   input  enable,

   //new configurations available on inputs
   input  load,

   //input operation count values
   input  [OPERATION_COUNT_WIDTH-1:0] load_operation_cntr,

   //current counter values
   output reg [OPERATION_COUNT_WIDTH-1:0] operation_cntr,
   output reg [AMM_BURSTCOUNT_WIDTH-1:0]  burst_counter,

   output have_operations,
   //indicate repeat block of operations complete, update address
   output next_addr_enable,
   output next_data_enable,

   input [AMM_BURSTCOUNT_WIDTH-1:0] burstlength
   );
   timeunit 1ns;
   timeprecision 1ps;

   assign have_operations = load_operation_cntr > 0;

   always @ (posedge clk)
   begin
      if (load) begin
         //flop in configurations
         operation_cntr     <= load_operation_cntr;
         burst_counter      <= burstlength;
      end
      else if ((enable) && ready) begin

         //count the length of the burst
         burst_counter <= burst_counter - 1'b1;
         //when done burst, reset count and decrement repeats
         if (burst_counter == 1'b1) begin
            burst_counter <= burstlength;
            //if that was the last repeat, decrement operation/burst counter, reset repeats
            operation_cntr <= operation_cntr - 1'b1;
            //if that was the last operation, reset the count for the next loop
            if (operation_cntr == 1) begin //last operation of last block
               operation_cntr <= load_operation_cntr;
            end
         end

      end
   end

   //assert on last accepted cycle of last operation to signal for a new address
   //only issue on last cycle of burst
   assign next_addr_enable  = enable & ready & (burst_counter == 1'b1);
   assign next_data_enable  = enable & ready;

endmodule


