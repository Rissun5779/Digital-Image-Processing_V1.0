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


module altera_emif_ctrl_qdr4_afi_channel_fifo #(
   parameter PORT_AFI_ADDR_WIDTH = 1,
   parameter PORT_AFI_LD_N_WIDTH = 1, 
   parameter PORT_AFI_RW_N_WIDTH = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH = 1,
   parameter PORT_AFI_WDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH = 1,
   parameter PORT_AFI_RDATA_WIDTH = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH = 1,
   parameter NUM_OF_AVL_CHANNELS = 8,
   parameter DEPTH = 8
) (
   input logic                                               clk,
   input logic                                               reset_n,
   
   output logic                                              empty,
   output logic                                              full,
   input logic                                               dequeue,
   input logic                                               write,
   
   input logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_addr_in,
   input logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_ld_n_in,
   input logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]            afi_rw_n_in,
   input logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]   afi_rdata_en_full_in,
   
   output logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]           afi_addr_out,
   output logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]           afi_ld_n_out,
   output logic [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]           afi_rw_n_out,
   output logic [PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS-1:0]  afi_rdata_en_full_out,
   
   output logic [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0]           afi_addr_next_out,
   output logic [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0]           afi_ld_n_next_out,
   
   input logic next_dequeue_mask,
   
   output logic is_write_command,
   output logic is_read_command
);
   timeunit 1ps;
   timeprecision 1ps;
   
   wire [PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS-1:0] afi_addr_next;
   wire [PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0] afi_ld_n_next;
   wire [PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS-1:0] afi_rw_n_next;
   
   // Pre-calculate whether a read or write command can potentially be issued in the following
   // cycle. This helps to achieve timing closure.
   always_ff @(posedge clk or negedge reset_n)
   begin
      if (!reset_n) begin
         is_write_command <= 1'b0;
         is_read_command <= 1'b0;
      end else begin
         if (dequeue) begin
            is_write_command <= (afi_ld_n_next != '1 && afi_rw_n_next != '1);
            is_read_command <= (afi_ld_n_next != '1 && afi_rw_n_next == '1);
         end else begin
            is_write_command <= (afi_ld_n_out != '1 && afi_rw_n_out != '1) & next_dequeue_mask;
            is_read_command <= (afi_ld_n_out != '1 && afi_rw_n_out == '1) & next_dequeue_mask;
         end
      end
   end
   
   // These signals are needed outside of this module to pre-calculate bank violations.
   assign afi_addr_next_out = afi_addr_next;
   assign afi_ld_n_next_out = afi_ld_n_next;
   
   altera_emif_ctrl_qdr4_fifo #(
      .WIDTH (PORT_AFI_ADDR_WIDTH/NUM_OF_AVL_CHANNELS),
      .DEPTH (DEPTH)
   ) afi_addr_fifo (
      .clk (clk),
      .reset_n (reset_n),
      .d (afi_addr_in),
      .q (afi_addr_out),
      .q_next (afi_addr_next),
      .rdreq (dequeue),
      .wrreq (write),
      .empty(empty),
      .full(full)
   );
   
   altera_emif_ctrl_qdr4_fifo #(
      .WIDTH (PORT_AFI_LD_N_WIDTH/NUM_OF_AVL_CHANNELS),
      .DEPTH (DEPTH)
   ) afi_ld_n_fifo (
      .clk (clk),
      .reset_n (reset_n),
      .d (afi_ld_n_in),
      .q (afi_ld_n_out),
      .q_next (afi_ld_n_next),
      .rdreq (dequeue),
      .wrreq (write)
   );
   
   altera_emif_ctrl_qdr4_fifo #(
      .WIDTH (PORT_AFI_RW_N_WIDTH/NUM_OF_AVL_CHANNELS),
      .DEPTH (DEPTH)
   ) afi_rw_n_fifo (
      .clk (clk),
      .reset_n (reset_n),
      .d (afi_rw_n_in),
      .q (afi_rw_n_out),
      .q_next (afi_rw_n_next),
      .rdreq (dequeue),
      .wrreq (write)
   );
   
   altera_emif_ctrl_qdr4_fifo #(
      .WIDTH (PORT_AFI_RDATA_EN_FULL_WIDTH/NUM_OF_AVL_CHANNELS),
      .DEPTH (DEPTH)
   ) afi_rdata_en_full_fifo (
      .clk (clk),
      .reset_n (reset_n),
      .d (afi_rdata_en_full_in),
      .q (afi_rdata_en_full_out),
      .rdreq (dequeue),
      .wrreq (write)
   );
endmodule
