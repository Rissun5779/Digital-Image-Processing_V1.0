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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
// turn off superfluous verilog processor warnings
// altera message_level Level1
// altera message_off 10034 10035 10036 10037 10230 10240 10030
//-----------------------------------------------------------------------------
// Title         : PCI Express Reference Design Example Application
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altpcie_lmi_burst_intf.v
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
// Description :
// This module converts the S5 style 32-bit LMI interface to an 8-bit burst
// interface for NightFury.  This module is implemented in soft logic.
//-----------------------------------------------------------------------------
module altpcie_a10_lmi_burst_intf  (
   input             clk,
   input             srst,
   input             rstn,

   // from PLD
   input             pld_lmi_rden_i,            // lmi write request from PLD
   input             pld_lmi_wren_i,            // lmi write request from PLD
   input[11:0]       pld_lmi_addr_i,            // lmi address from PLD
   input[31:0]       pld_lmi_wrdata_i,          // lmi write data from PLD

   // from core
   input[7:0]        hip_lmi_rddata_i,          // lmi read data from core
   input             hip_lmi_ack_i,             // lmi read/write request acknowledge from core
                                                //   - during writes, ack pulses when the HIP has completed the 32bit reg write
                                                //   - during reads, ack pulses on the 1st 8-bit transfer of read data

   // to core
   output reg        hip_lmi_rden_o,            // lmi write request to core
   output reg        hip_lmi_wren_o,            // lmi write request to core
   output reg[11:0]  hip_lmi_addr_o,            // lmi address to core
   output reg[7:0]   hip_lmi_wrdata_o,          // lmi write data to core

   // to PLD
   output reg[31:0]  pld_lmi_rddata_o,          // lmi read data to PLD
   output reg        pld_lmi_ack_o              // lmi read/write request acknowledge to PLD
    );

   // LMI Burst State Machine (lmi_burst_sm)
   localparam IDLE           = 4'h0;   // wait for req.  if write req, xfer byte 0 immediately
   localparam WR_DATA_1      = 4'h1;   // xfer wrdata byte 1
   localparam WR_DATA_2      = 4'h2;   // xfer wrdata byte 2
   localparam WR_DATA_3      = 4'h3;   // xfer wrdata byte 3
   localparam WR_WAIT_ACK    = 4'h4;   // wait for hip to finish processing write
   localparam RD_WAIT_DATA_0 = 4'h5;   // wait for hip to return read data byte 0
   localparam RD_DATA_1      = 4'h6;   // capture read data byte 1
   localparam RD_DATA_2      = 4'h7;   // capture read data byte 2
   localparam RD_DATA_3      = 4'h8;   // capture read data byte 3

   reg[3:0]   lmi_burst_sm, lmi_burst_sm_n;
   reg        hip_lmi_rden_n;
   reg        hip_lmi_wren_n;
   reg[11:0]  hip_lmi_addr_n;
   reg[7:0]   hip_lmi_wrdata_n;
   reg[31:0]  pld_lmi_rddata_n;
   reg        pld_lmi_ack_n;
   reg[31:0]  pld_lmi_wrdata_hold, pld_lmi_wrdata_hold_n;

   // boundary regs (hip side)
   reg [7:0]  hip_lmi_rddata_r;
   reg        hip_lmi_ack_r;

   always @ (posedge clk or negedge rstn) begin
       if (rstn==1'b0) begin
           lmi_burst_sm        <= IDLE;
           hip_lmi_rden_o      <= 1'b0;
           hip_lmi_wren_o      <= 1'b0;
           hip_lmi_addr_o      <= 12'h0;
           hip_lmi_wrdata_o    <= 8'h0;
           pld_lmi_rddata_o    <= 32'h0;
           pld_lmi_ack_o       <= 1'b0;
           pld_lmi_wrdata_hold <= 32'h0;
           // input boundary regs
           hip_lmi_rddata_r    <= 32'h0;
           hip_lmi_ack_r       <= 1'b0;
       end
       else if (srst) begin
           lmi_burst_sm        <= IDLE;
           hip_lmi_rden_o      <= 1'b0;
           hip_lmi_wren_o      <= 1'b0;
           hip_lmi_addr_o      <= 12'h0;
           hip_lmi_wrdata_o    <= 8'h0;
           pld_lmi_rddata_o    <= 32'h0;
           pld_lmi_ack_o       <= 1'b0;
           pld_lmi_wrdata_hold <= 32'h0;
           // input boundary regs
           hip_lmi_rddata_r    <= 32'h0;
           hip_lmi_ack_r       <= 1'b0;
       end
       else begin
           lmi_burst_sm        <= lmi_burst_sm_n;
           hip_lmi_rden_o      <= hip_lmi_rden_n;
           hip_lmi_wren_o      <= hip_lmi_wren_n;
           hip_lmi_addr_o      <= hip_lmi_addr_n;
           hip_lmi_wrdata_o    <= hip_lmi_wrdata_n;
           pld_lmi_rddata_o    <= pld_lmi_rddata_n;
           pld_lmi_ack_o       <= pld_lmi_ack_n;
           pld_lmi_wrdata_hold <= pld_lmi_wrdata_hold_n;
           // input boundary regs
           hip_lmi_rddata_r    <= hip_lmi_rddata_i;
           hip_lmi_ack_r       <= hip_lmi_ack_i;
       end
   end

   always @ (*) begin
       // defaults
       hip_lmi_rden_n        = 1'b0;   // pulse
       hip_lmi_wren_n        = 1'b0;   // pulse
       pld_lmi_ack_n         = 1'b0;   // pulse
       hip_lmi_addr_n        = hip_lmi_addr_o;
       hip_lmi_wrdata_n      = hip_lmi_wrdata_o;
       pld_lmi_rddata_n      = pld_lmi_rddata_o;
       pld_lmi_wrdata_hold_n = pld_lmi_wrdata_hold;
       lmi_burst_sm_n        = lmi_burst_sm;

       // State machine to convert
       // 32-bit LMI user interface to
       // 8-bit HIP interface (burst)
       //----------------------------------
       case (lmi_burst_sm)
          IDLE: begin
              pld_lmi_ack_n         = 1'b0;
              hip_lmi_addr_n        = pld_lmi_addr_i;     // sample/hold the wraddr
              pld_lmi_wrdata_hold_n = pld_lmi_wrdata_i;   // sample/hold the wrdata for remaining data phases

              // wait for LMI req from user
              //---------------------------
              if (pld_lmi_wren_i) begin                   // level sensitive
                  hip_lmi_wren_n    = 1'b1;               // pulse wren cmd and transfer byte 0
                  hip_lmi_wrdata_n  = pld_lmi_wrdata_i[7:0];
                  lmi_burst_sm_n    = WR_DATA_1;
              end
              else if (pld_lmi_rden_i) begin
                  hip_lmi_rden_n = 1'b1;                   // pulse rden cmd
                  lmi_burst_sm_n = RD_WAIT_DATA_0;         // wait for hip to return read data
              end
          end
          WR_DATA_1: begin
              // burst byte 1
              hip_lmi_wren_n    = 1'b0;
              hip_lmi_wrdata_n  = pld_lmi_wrdata_hold[15:8];
              lmi_burst_sm_n    = WR_DATA_2;
          end
          WR_DATA_2: begin
              // burst byte 2
              hip_lmi_wrdata_n  = pld_lmi_wrdata_hold[23:16];
              lmi_burst_sm_n = WR_DATA_3;
          end
          WR_DATA_3: begin
              // burst byte 3
              hip_lmi_wrdata_n  = pld_lmi_wrdata_hold[31:24];
              lmi_burst_sm_n    = WR_WAIT_ACK;
          end
          WR_WAIT_ACK: begin
              // wait for HIP to finish reg write
              if (hip_lmi_ack_r) begin
                  lmi_burst_sm_n = IDLE;
                  pld_lmi_ack_n  = 1'b1;
              end
          end
          RD_WAIT_DATA_0: begin
              // wait for HIP to return byte 0
              if (hip_lmi_ack_r) begin
                  lmi_burst_sm_n = RD_DATA_1;
                  pld_lmi_rddata_n[7:0] = hip_lmi_rddata_r;
              end
          end
          RD_DATA_1: begin
              // wait for HIP to return byte 1
              lmi_burst_sm_n = RD_DATA_2;
              pld_lmi_rddata_n[15:8] = hip_lmi_rddata_r;
          end
          RD_DATA_2: begin
              // wait for HIP to return byte 2
              lmi_burst_sm_n = RD_DATA_3;
              pld_lmi_rddata_n[23:16] = hip_lmi_rddata_r;
          end
          RD_DATA_3: begin
              // wait for HIP to return byte 3
              lmi_burst_sm_n = IDLE;
              pld_lmi_rddata_n[31:24] = hip_lmi_rddata_r;
              pld_lmi_ack_n  = 1'b1;
          end
          default: begin
          end
       endcase


   end


endmodule
