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


//------------------------------------------------------------------
//
// File Name: altera_xcvr_reset_sequencer_s10.sv
//
// Description : Master Transceiver Reset Sequencer (TRS) to stagger 
//               analog and digital (including AIB) resets. All
//               assertions and deassertions are 200ns apart.
//
// Limitation  : Intended for Nadder (Crete NF and Crete ND)
//
// Copyright (c) Altera Corporation 1997-2016
// All rights reserved
//
//-------------------------------------------------------------------

`timescale 1ps/1ps

module altera_xcvr_reset_sequencer_s10 #(
    parameter CLK_FREQ_IN_HZ      = 100000000,
    parameter RESET_SEPARATION_NS = 200,
    parameter NUM_RESETS          = 1       // Total number of resets to sequence
                                            // rx/tx_analogreset, rx/tx_digitalreset, pll_powerdown
) (
    input                   osc_clk_in,    // Input clock fed by osc_clk_1 external pin
    input  [NUM_RESETS-1:0] reset_req,
    output [NUM_RESETS-1:0] reset_ack
);

// Determine needed size for scheduling counter
localparam  SCHED_COUNT_MAX   = NUM_RESETS-1;
localparam  SCHED_COUNT_SIZE  = clogb2(NUM_RESETS-1);
localparam  [SCHED_COUNT_SIZE-1:0] SCHED_COUNT_ADD = {{SCHED_COUNT_SIZE-1{1'b0}},1'b1};

// These parameters calculate the counter width and count for reset separation
localparam  [63:0] INITIAL_COUNT  = (CLK_FREQ_IN_HZ * RESET_SEPARATION_NS) / 1000000000;

// Round counter limit up if needed
localparam  [63:0] ROUND_COUNT    = (((INITIAL_COUNT * 1000000000) / CLK_FREQ_IN_HZ) < RESET_SEPARATION_NS)
                            ? (INITIAL_COUNT + 1) : INITIAL_COUNT;

// Use given counter limit if provided (RESET_COUNT), otherwise use calculated counter limit
localparam  RESET_COUNT_MAX   = ROUND_COUNT - 1;
localparam  RESET_COUNT_SIZE  = clogb2(RESET_COUNT_MAX);
localparam  [RESET_COUNT_SIZE-1:0] RESET_COUNT_ADD   = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};

// Determine needed size for request timeout counter
localparam  TIMEOUT_COUNT_MAX  = 100000; // 100000 cycles @ 100MHz for 1ms 
localparam  TIMEOUT_COUNT_SIZE = clogb2(TIMEOUT_COUNT_MAX);
localparam  [TIMEOUT_COUNT_SIZE-1:0] TIMEOUT_COUNT_ADD = {{TIMEOUT_COUNT_SIZE-1{1'b0}},1'b1};

// Need to self-generate internal reset signal
wire  reset_n;

// Synchronized reset_req inputs
wire  [NUM_RESETS-1:0]  reset_req_sync;

// Reset output registers (must be synchronized at destination logic)
reg   [NUM_RESETS-1:0]  reset_ack_reg;
reg   [NUM_RESETS-1:0]  reset_ack_stage;
wire  reset_match;    // determines if scheduled input matches output

// Round robin scheduling counter
reg   [SCHED_COUNT_SIZE-1:0]  sched_counter;
wire  sched_timeout;  // time to advance schedule counter

// Delay counter (for staggering reset outputs)
reg   [RESET_COUNT_SIZE-1:0]  reset_counter;
wire  reset_timeout;  // time to restart reset separation counter

// Timeout for reset requests
reg   [TIMEOUT_COUNT_SIZE-1:0] timeout_counter;
wire  watchdog_timeout;


//***************************************************************************//
//*********************** Internal reset generation *************************//
alt_xcvr_resync #(
  .SYNC_CHAIN_LENGTH(3),
  .INIT_VALUE(0)
  ) reset_n_generator (
    .clk    (osc_clk_in     ),
    .reset  (1'b0           ),
    .d      (1'b1           ),
    .q      (reset_n        )
);
//********************* End Internal reset generation ***********************//
//***************************************************************************//


//***************************************************************************//
//********************* Reset input synchronization *************************//
alt_xcvr_resync #(
  .SYNC_CHAIN_LENGTH(3),
  .WIDTH(NUM_RESETS),
  .INIT_VALUE(0)
  ) reset_req_synchronizers (
    .clk    (osc_clk_in),
    .reset  (~reset_n       ),
    .d      (reset_req      ),
    .q      (reset_req_sync )
  );

//******************* End reset input synchronization ***********************//
//***************************************************************************//


//***************************************************************************//
//************************* Reset sequencer logic ***************************//
assign  reset_match   = reset_ack_reg[sched_counter] == reset_req_sync[sched_counter];
assign  reset_timeout = reset_counter == RESET_COUNT_MAX;
assign  sched_timeout = sched_counter == SCHED_COUNT_MAX;
assign  watchdog_timeout   = timeout_counter == TIMEOUT_COUNT_MAX;

assign	reset_ack = reset_ack_stage;

// Scheduler, reset counter, and output register logic
always @(posedge osc_clk_in or negedge reset_n)

  if(~reset_n) begin
    reset_ack_reg   <= {NUM_RESETS{1'b0}};
    sched_counter   <= {SCHED_COUNT_SIZE{1'b0}};
    reset_counter   <= {RESET_COUNT_SIZE{1'b0}};
    timeout_counter <= {TIMEOUT_COUNT_SIZE{1'b0}};
  end else begin

    // Required reset delay is met
    if(reset_timeout) begin 

      // If watchdog timer has expired, deassert the reset_ack
      if(watchdog_timeout) begin
        reset_ack_reg[sched_counter]  <= 1'b0;
    
        // Keep watchdog timeout status asserted while reset request is still high
        if(reset_req_sync[sched_counter])
          timeout_counter <= timeout_counter;
        // Reset the watchdog timer and separation counter once reset request has been deasserted
        else begin
          timeout_counter <= {TIMEOUT_COUNT_SIZE{1'b0}};
          reset_counter <= {RESET_COUNT_SIZE{1'b0}};
        end

      // Reset request has been made
      end else if(!reset_match) begin
        // Reset the separation counter and watchdog timer if reset req has been deasserted
        if(!reset_req_sync[sched_counter]) begin
          reset_counter <= {RESET_COUNT_SIZE{1'b0}};
          timeout_counter <= {TIMEOUT_COUNT_SIZE{1'b0}};
        end else reset_counter <= reset_counter;

        // Update the scheduled output to match the input
        reset_ack_reg[sched_counter]  <= reset_req_sync[sched_counter];

      end else begin
        // Do nothing if no reset request has been made (i.e. do not clear reset counter)
        // Once a reset request has been deasserted, the reset counter will be cleared
        reset_counter <= reset_counter;

        // Increment the timeout counter if reset_req is asserted (watchdog timer has not expired yet)
        if(reset_req_sync[sched_counter])
          timeout_counter <= timeout_counter + TIMEOUT_COUNT_ADD;
        else // If reset_req has deasserted, reset the watchdog timer 
          timeout_counter <= {TIMEOUT_COUNT_SIZE{1'b0}};

      end
    // Required reset delay has NOT been met
    end else begin
      reset_counter <= reset_counter + RESET_COUNT_ADD;
      timeout_counter <= timeout_counter;
    end

     // Logic to advance scheduler
    if(sched_timeout && !reset_req_sync[SCHED_COUNT_MAX]) // Scheduler has finished cycling through endpoints
      sched_counter <=  {SCHED_COUNT_SIZE{1'b0}};
    else if (!reset_ack_reg[sched_counter] && !reset_req_sync[sched_counter]) // No reset request made, advance the scheduler
      sched_counter <=  sched_counter + SCHED_COUNT_ADD;
    else // Reset request is still high, stay on the request OR
         // Reset request was made, however reset delay not met so stay on this request
      sched_counter <=  sched_counter;
  end

// Add register stage
always @(posedge osc_clk_in) begin
  reset_ack_stage <= reset_ack_reg;
end

//*********************** End Reset sequencer logic *************************//
//***************************************************************************//

////////////////////////////////////////////////////////////////////
// Return the number of bits required to represent an integer
// E.g. 0->1; 1->1; 2->2; 3->2 ... 31->5; 32->6
//
function integer clogb2;
  input integer input_num;
  begin
    for (clogb2=0; input_num>0 && clogb2<256; clogb2=clogb2+1)
      input_num = input_num >> 1;
    if(clogb2 == 0)
      clogb2 = 1;
  end
endfunction

endmodule
