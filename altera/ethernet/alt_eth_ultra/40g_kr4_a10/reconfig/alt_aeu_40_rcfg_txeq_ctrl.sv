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




//===========================================================================
// This confidential and proprietary software may be used only as authorized
// by a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//============================================================================

//============================================================================
// Reconfig PMA TX Equalization State Machine
// Generates data address and control signals to AVMM master SM
//============================================================================

`timescale 1 ps / 1 ps

module alt_aeu_40_rcfg_txeq_ctrl
 (
  input  wire        clk,
  input  wire        reset,
     // PMA RX EQ reconfig requests
  input  wire            lt_start_rc,   // start the TX EQ reconfig
  input  wire [4:0]      main_rc,       // main tap value for reconfig
  input  wire [5:0]      post_rc,       // post tap value for reconfig
  input  wire [4:0]      pre_rc,        // pre tap value for reconfig
  input  wire [2:0]      tap_to_upd,    // specific TX EQ tap to update
                                        // bit-2 = main, bit-1 = post, ...
  output reg             rc_busy = 1'b0,// reconfig is busy
    //  AVMM master State Machine
  output reg [9:0]    ctrl_addr,
  output reg [7:0]    ctrl_writedata,
  output reg [7:0]    ctrl_datamask,
  output reg          ctrl_rmw   = 1'b0,
  output reg          ctrl_write = 1'b0,
  input  wire         ctrl_busy
  );

//============================================================================
//  input Handshaking
//============================================================================
  wire      start_sync;
  reg       start_dly  = 1'b0;
  reg       start_edge = 1'b0;  // start rising edge or start & wait edge
  reg       busy_dly   = 1'b0;
  reg       busy_edge  = 1'b0;   // falling edge of busy

  // synchronize the start input
  alt_xcvr_resync #(
    .WIDTH  (1)  // Number of bits to resync
  ) strt_sync_inst (
    .clk    (clk),
    .reset  (reset),
    .d      (lt_start_rc),
    .q      (start_sync)
  );

  always @(posedge clk) begin
    start_dly  <=  start_sync;
    start_edge <=  start_sync & ~start_dly;
    busy_dly   <=  ctrl_busy;
    busy_edge  <= ~ctrl_busy & busy_dly;
  end

//============================================================================
//  Control State Machine
//============================================================================
  localparam [2:0] IDLE      = 3'd0;    // wait for rc_start
  localparam [2:0] WR_VOD    = 3'd1;    // write the Main-tap value
  localparam [2:0] WAIT_1    = 3'd2;    // De-active wait
  localparam [2:0] WR_POST   = 3'd3;    // write the Post-tap value
  localparam [2:0] WAIT_2    = 3'd4;    // De-active wait
  localparam [2:0] WR_PRE    = 3'd5;    // write the Pre-tap value
  localparam [2:0] WAIT_3    = 3'd6;    // De-active wait
  localparam [2:0] DONE      = 3'd7;    // check for rc_start inactive

  reg [2:0]  txeq_state     = 3'd0;
  reg [2:0]  txeq_nxt_state;

    // state register
  always @(posedge clk) begin
   if (reset)
     txeq_state <= IDLE;
   else
     txeq_state <= txeq_nxt_state;
  end

    // next state logic
  always_comb begin
    ctrl_addr      = 10'b0;
    ctrl_writedata = 8'b0;
    ctrl_datamask  = 8'h00;
    case(txeq_state)
      IDLE: begin
          if     (start_edge & tap_to_upd[2]) begin
            txeq_nxt_state   = WR_VOD;
            end
          else if (start_edge & tap_to_upd[1]) begin
            txeq_nxt_state = WR_POST;
            end
          else if (start_edge & tap_to_upd[0]) begin
            txeq_nxt_state = WR_PRE;
            end
          else if (start_edge) begin
            txeq_nxt_state = DONE;
            end
          else
            txeq_nxt_state = IDLE;
          end
      WR_VOD: begin
          ctrl_addr      = 10'h109;
          ctrl_writedata = {3'b000,main_rc}; // b7 = rst DCC, b6=pwrdn, b5=comp
          ctrl_datamask  = {8'b0001_1111};
          txeq_nxt_state = WAIT_1;
          end
      WAIT_1: begin
          ctrl_addr      = 10'h109;
          ctrl_writedata = {3'b000,main_rc}; // b7 = rst DCC, b6=pwrdn, b5=comp
          ctrl_datamask  = {8'b0001_1111};
          if      (busy_edge & tap_to_upd[1])
            txeq_nxt_state = WR_POST;
          else if (busy_edge & tap_to_upd[0])
            txeq_nxt_state = WR_PRE;
          else if (busy_edge)
            txeq_nxt_state = DONE;
          else
            txeq_nxt_state = WAIT_1;
          end
      WR_POST: begin
          ctrl_addr      = 10'h105;
          ctrl_writedata = {2'b01,post_rc}; // b7 = dynamic, b6 = sign
          ctrl_datamask  = {8'b0111_1111};
          txeq_nxt_state = WAIT_2;
          end
      WAIT_2: begin
          ctrl_addr      = 10'h105;
          ctrl_writedata = {2'b01,post_rc}; // b7 = dynamic, b6 = sign
          ctrl_datamask  = {8'b0111_1111};
          if (busy_edge & tap_to_upd[0])
            txeq_nxt_state = WR_PRE;
          else if (busy_edge)
            txeq_nxt_state = DONE;
          else
            txeq_nxt_state = WAIT_2;
          end
      WR_PRE: begin
          ctrl_addr      = 10'h107;
          ctrl_writedata = {3'b001,pre_rc}; // b7:6 = term, b5 = sign
          ctrl_datamask  = {8'b0011_1111};
          txeq_nxt_state = WAIT_3;
          end
      WAIT_3: begin
          ctrl_addr      = 10'h107;
          ctrl_writedata = {3'b001,pre_rc}; // b7:6 = term, b5 = sign
          ctrl_datamask  = {8'b0011_1111};
          if (busy_edge)
            txeq_nxt_state = DONE;
          else
            txeq_nxt_state = WAIT_3;
          end
      DONE: begin
          if (start_sync)
            txeq_nxt_state = DONE;
          else
            txeq_nxt_state = IDLE;
          end
      default : begin
        txeq_nxt_state = IDLE;
        ctrl_addr      = 10'b0;
        ctrl_writedata = 8'b0;
        end
    endcase
  end

//============================================================================
//  outputs
//============================================================================
  always @(posedge clk) begin
     rc_busy    <= (txeq_nxt_state != IDLE);
     ctrl_write <= 1'b0;
     ctrl_rmw   <= (txeq_state == WR_VOD)  ||
                   (txeq_state == WR_POST) ||
                   (txeq_state == WR_PRE);
  end

  endmodule // alt_aeu_40_rcfg_txeq_ctrl
