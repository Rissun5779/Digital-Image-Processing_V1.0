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


// (C) 2001-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//-------------------------------------------------------------------
// Filename    : alt_xcvr_bit_slip.v
//
// Description : parameterizable bit_slip module 
//
// Limitation  : -
//
// Authors     : aweerasi 
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_bit_slip #(
	parameter DATA_WIDTH=32
) (
  input                   clk,
	input                   reset,
  input [DATA_WIDTH-1:0]	rx_parallel_data,
  input [DATA_WIDTH-1:0]	ext_data_pattern,
  output wire             rx_bit_slip
);

// Define bit slip period
localparam WAIT_CNTR_WIDTH = 8;
localparam WAIT_CNTR_VAL   = 128;
reg [WAIT_CNTR_WIDTH-1:0] wait_cntr;

// Define bit slip duration 
localparam SLIP_CNTR_WIDTH = 8;
localparam SLIP_CNTR_VAL   = 128;
reg [SLIP_CNTR_WIDTH-1:0] slip_cntr;

//SV constructs are not supported
//typedef enum {IDLE, SLIP_GEN, WAIT_CNT, SLIP_CHECK, SLIP_DONE} state_type;
//state_type state, next_state;

// Define state machine states
localparam IDLE       = 0; 
localparam SLIP_GEN   = 1; 
localparam WAIT_CNT   = 2; 
localparam SLIP_CHECK = 3; 
localparam SLIP_DONE  = 4; 

reg  [2:0] state, next_state;

// Bitslip period counter
//=======================
always @(posedge clk or posedge reset) begin
  if      (reset || (state != WAIT_CNT))  wait_cntr <= {WAIT_CNTR_WIDTH{1'b0}};
  else if (state == WAIT_CNT)             wait_cntr <= wait_cntr + 1;
end

// Bitslip duration counter
// Since rx_bitslip is an asynchronous signal, it needs to be held for a minimum 
//  of 120 cycles to be captured by the Slow Shift Register chain of the adapter
//=========================
always @(posedge clk or posedge reset) begin
  if      (reset || (state != SLIP_GEN))  slip_cntr <= {SLIP_CNTR_WIDTH{1'b0}};
  else if (state == SLIP_GEN)             slip_cntr <= slip_cntr + 1;
end

// Generate the data locked (bit slip done) signal
assign is_data_locked = (state == SLIP_DONE);

// Generate the bit_slip signal to the rx channel
assign rx_bit_slip = (state == SLIP_GEN);

// Bit-slip state machine
//=======================
always @(posedge clk or posedge reset) begin
  if(reset) state <= IDLE;
  else      state <= next_state;
end
// State transitions
always @ (*) begin
  case(state)
    IDLE: begin
      next_state = (rx_parallel_data != ext_data_pattern) ? SLIP_GEN : IDLE;
    end
    SLIP_GEN: begin
      next_state = (slip_cntr < SLIP_CNTR_VAL) ? SLIP_GEN : WAIT_CNT;
    end
    WAIT_CNT: begin
      next_state = (wait_cntr < WAIT_CNTR_VAL) ? WAIT_CNT : SLIP_CHECK;
    end
    SLIP_CHECK: begin
      next_state = (rx_parallel_data != ext_data_pattern) ? SLIP_GEN : SLIP_DONE;
    end
    SLIP_DONE: begin
      next_state = SLIP_DONE;
    end
    default: begin
      next_state = IDLE;
    end
  endcase
end

endmodule
