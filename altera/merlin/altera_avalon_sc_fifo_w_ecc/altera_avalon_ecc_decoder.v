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


// cclare, 1-6-2015
// Top level ECC Decode Wrapper file for 32-bit chunks of data
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  altera_avalon_ecc_decoder
#(
  parameter DATA_WIDTH = 32,

  //Internal Parameters
  parameter REM = DATA_WIDTH%32,
  parameter NUM_ECC = (REM > 0 )? DATA_WIDTH/32 +1 : DATA_WIDTH/32 
)(
  input [NUM_ECC*39-1 :0] in_data,
  output [DATA_WIDTH-1 :0] out_data, 
  output ecc_error
);

  `ifdef USE_ECC_INJECTOR 
    reg [NUM_ECC*39-1 :0] error_vector = {NUM_ECC*39{1'b0}};
  `endif

  // Future enhancement to only store data bus and encoded ECC bits,
  // for now the entire 39 bit chunk is stored in FIFO
  wire [NUM_ECC-1 :0] ecc_uncor_err;
  wire [NUM_ECC-1 :0] ecc_detect_err; 

  genvar i;
  generate begin 
    for (i = 0; i < NUM_ECC; i = i+1) begin : dec_mod
      if (REM == 0 || i < (NUM_ECC-1) ) begin 
        altera_avalon_ecc_dec ecc_dec
        ( 
        `ifdef USE_ECC_INJECTOR 
	  .data(in_data[(i+1)*39-1 : i*39] ^ error_vector[(i+1)*39-1 : i*39]),
        `else 
	  .data(in_data[(i+1)*39-1 : i*39]),
        `endif
          .q(out_data[(i+1)*32-1 :(i*32)]),
          .err_detected(ecc_detect_err[i]),
          .err_fatal(ecc_uncor_err[i])
        );
      end else begin 
        altera_avalon_ecc_dec ecc_dec
        ( 
         `ifdef USE_ECC_INJECTOR 
          .data(in_data[(i+1)*39-1 : i*39] ^ error_vector[(i+1)*39-1 : i*39]),
         `else 
	  .data(in_data[(i+1)*39-1 : i*39]),
         `endif
          .q(out_data[(i*32)+REM-1 :(i*32)]),
          .err_detected(ecc_detect_err[i]),
          .err_fatal(ecc_uncor_err[i])
         );
      end 
    end 
  end 
  endgenerate
  assign ecc_error = |ecc_uncor_err & |ecc_detect_err;
endmodule 
