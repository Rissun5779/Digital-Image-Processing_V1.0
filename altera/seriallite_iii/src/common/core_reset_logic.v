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


/*********************************************************/
//
//    Reset core logic that works on HSSI clock
//    Version 1.0
//    Onkar Patki
//    12/19/2013
//	
// Version: 1.0
// When moving to synchronous reset/no reset-HIPI logic that operates
// on HSSI clockout needs special consideration since HSSI clocks may not
// stable immedietly after reset. This logic will keep reset asserted 
// util ready signal (such as locktodata/rx_ready etc) are asserted.
// Reset will also asserted when reset iput to core is asserted
//
//
/*********************************************************/

`timescale 1ps /1ps

module core_reset_logic # (
   parameter DEPTH = 2 
  ) (	
  input core_reset, // Input to reset core logic- async
  input hssi_ready, // ready signal from HSSI - async
  input core_clock, // clock on which core is working
  output out_core_reset  // sync reset to core
  ) /* synthesis syn_noprune=1 */;

reg  [DEPTH-1:0] core_reset_sync_meta ;
reg  [DEPTH-1:0] hssi_ready_meta ;
reg              reset_all_reg ;

wire core_reset_sync;
wire hssi_ready_sync;
wire reset_all;

// synchronize core-reset
always @ (posedge core_clock or posedge core_reset) begin
  if (core_reset) begin
  core_reset_sync_meta <=  {DEPTH{1'b1}}; 	  
  end
  else begin
  core_reset_sync_meta <= {1'b0,core_reset_sync_meta[DEPTH-1:1]};	  
  end	  
end	

assign core_reset_sync = core_reset_sync_meta[0];

// synchronize hssu-ready
always @ (posedge core_clock or negedge hssi_ready) begin
  if (~hssi_ready) begin
  hssi_ready_meta <=  {DEPTH{1'b1}}; 	  
  end
  else begin
  hssi_ready_meta <= {1'b0,hssi_ready_meta[DEPTH-1:1]};	  
  end	  
end	

assign hssi_ready_sync = hssi_ready_meta[0];

assign reset_all = hssi_ready_sync || core_reset_sync ;

// treat HSSI ready as async reset- async assert/sync-deassert
always @ (posedge core_clock or posedge reset_all) begin
  if (reset_all) begin
  reset_all_reg <=  1'b1; 	  
  end
  else begin
  reset_all_reg <= 1'b0;	  
  end	  
end

assign out_core_reset = reset_all_reg;

endmodule

