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


//Module: X1X2 INTERFACE ADAPTER
//Description: This module is used as an adapter between the data generator/checker and the native phy during double transfer rate mode
//Maps the simplified output/input of the generator/checker to the unsimplified interface for native phy
//Currently only designed for PCS Direct mode, will need to modify later for Standard and Enhanced

module alt_xcvr_x1x2_if_adapter #(
    parameter WIDTH = 32
  ) (
    input                tx_clkout,
    input                tx_digitalreset,
    input                tx_fifo_wr_en,
    input  [WIDTH-1:0]   gen_data_out,
    output [WIDTH-1:0]   check_data_in,
    output [79:0]        tx_data,
    input  [79:0]        rx_data
   );

  reg           tx_word_marking_bit;

  /*************************************************************************************************
   * Map simplified interface to the unsimplified interface for pcs direct, double transfer rate mode
   *************************************************************************************************/
  //map tx side simplified to unsimplified
  generate
    if (WIDTH < 20) begin
      assign tx_data = {tx_fifo_wr_en, 59'b0, tx_word_marking_bit, {19-WIDTH{1'b0}}, gen_data_out};
    end else begin
      assign tx_data = {tx_fifo_wr_en, 39'b0, tx_word_marking_bit, {39-WIDTH{1'b0}}, gen_data_out};
    end
  endgenerate

  //map rx side unsimplified to simplified
  assign check_data_in = rx_data[WIDTH-1:0];

  //toggle word marking bit
  always @(posedge tx_clkout) begin
    if(tx_digitalreset) begin
      tx_word_marking_bit <= 1'b0;
    end else begin
      tx_word_marking_bit <= ~tx_word_marking_bit;
    end
  end

endmodule // x1x2_if_adapter
