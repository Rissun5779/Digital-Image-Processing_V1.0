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
module altpcie_sc_hip_vecsync2
   #(
      parameter DWIDTH           = 2 // Sync Data input
    )
   (
   // Inputs
   input  wire               wr_clk,        // write clock
   input  wire               rd_clk,        // read clock
   input  wire               wr_rst_n,      // async write reset
   input  wire               rd_rst_n,      // async read reset
   input  wire [DWIDTH-1:0]  data_in,       // data in
   // Outputs
   output wire  [DWIDTH-1:0] data_out       // data out
   );

// 2-stage synchronizer
localparam SYNCSTAGE = 2;

// Vecsync module
altpcie_hip_vecsync
   #(
      .DWIDTH(DWIDTH),       // Sync Data input
      .SYNCSTAGE(SYNCSTAGE)  // Sync stages
    ) altpcie_sc_hip_vecsync2
   (
   // Inputs
   .wr_clk(wr_clk),         // write clock
   .rd_clk(rd_clk),         // read clock
   .wr_rst_n(wr_rst_n),     // async write reset
   .rd_rst_n(rd_rst_n),     // async read reset
   .data_in(data_in),       // data in
   // Outputs
   .data_out(data_out)      // data out
   );

endmodule // altpcie_sc_hip_vecsync2
