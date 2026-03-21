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


//-----------------------------------------------------------------------------
// Filename    : per_pin_pattern_gen.v
// Description : Wrapper for the per pin pattern generators. This will
//                instantiate the data generator with the correct output data
//                width to correspond with the interface rate (supported rates:
//                half-rate, quarter-rate), and the correct pattern length for
//                either a deterministic sequential data pattern, or PRBS data.
//-----------------------------------------------------------------------------

module altera_emif_avl_tg_2_per_pin_pattern_gen #(

   //Corresponds to memory data rate, 8 for quarter-rate, 4 for half-rate, 2 for full-rate
   parameter OUTPUT_WIDTH      = 8,

   //The length of the pattern to be written to the DQ pin
   //Legal values: 8, 16, 32
   //Correspond to the sequence length for deterministic mode
   //Correspond to PRBS-7, PRBS-15, PRBS-31 for PRBS mode
   parameter PATTERN_LENGTH    = 8,

   //pattern mode
   //defaults: 0 (PRBS) for data generators, 1 (Deterministic) for byte enable generators
   parameter DEFAULT_MODE      = 1'b0,
   parameter DEFAULT_STATE     = 1
)(
   input                       clk,
   input                       rst,

   //load enable signal to update load_data and load_mode
   input                       load,
   //Data mode: 0 for prbs output, 1 for deterministic sequence based on load_data
   input                       load_mode,
  //PRBS seed or desired data sequence for deterministic mode
   input [PATTERN_LENGTH-1: 0] load_data,
   input                       load_inversion,
   input                       enable,
   output [OUTPUT_WIDTH-1:0]   dout,
   output [PATTERN_LENGTH+1:0] state_out
);
   timeunit 1ns;
   timeprecision 1ps;

   initial begin
      if (!((PATTERN_LENGTH == 8 || PATTERN_LENGTH == 16 || PATTERN_LENGTH == 32) &&
         (OUTPUT_WIDTH == 2 || OUTPUT_WIDTH == 4 || OUTPUT_WIDTH == 8 ))) begin
         $display("Error: You have specified incorrect parameters to module:per_pin_pattern_gen.");
         $finish;
      end
   end

   //instantiate appropriate pin pattern generator
   //invalid parameters will default to PATTERN_LENGTH=8, OUTPUT_WIDTH=8
   generate

      case(OUTPUT_WIDTH)
      (8):
         case(PATTERN_LENGTH)
          8:      altera_emif_avl_tg_2_pppg8_8bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout), .state_out(state_out));
         16:      altera_emif_avl_tg_2_pppg16_8bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         32:      altera_emif_avl_tg_2_pppg32_8bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         default: altera_emif_avl_tg_2_pppg8_8bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout), .state_out(state_out));
         endcase
      (4):
         case(PATTERN_LENGTH)
          8:      altera_emif_avl_tg_2_pppg8_4bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         16:      altera_emif_avl_tg_2_pppg16_4bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         32:      altera_emif_avl_tg_2_pppg32_4bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         default: altera_emif_avl_tg_2_pppg8_8bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout), .state_out(state_out));
         endcase
      (2):
         case(PATTERN_LENGTH)
          8:      altera_emif_avl_tg_2_pppg8_2bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         16:      altera_emif_avl_tg_2_pppg16_2bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         32:      altera_emif_avl_tg_2_pppg32_2bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout),.state_out(state_out));
         default: altera_emif_avl_tg_2_pppg8_8bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout), .state_out(state_out));
         endcase
      default:
         altera_emif_avl_tg_2_pppg8_8bit_parallel #(.DEFAULT_MODE (DEFAULT_MODE), .DEFAULT_STATE(DEFAULT_STATE)) pppg_inst(.clk(clk), .rst(rst), .load(load), .load_data(load_data), .load_mode(load_mode), .load_inversion (load_inversion), .enable(enable), .dout(dout), .state_out(state_out));
      endcase

  endgenerate

endmodule
