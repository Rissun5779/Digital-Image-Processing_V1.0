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
module  altera_avalon_ecc_encoder
#(
  parameter DATA_WIDTH = 32,
  //Internal Parameters
  parameter REM = DATA_WIDTH%32,
  parameter NUM_ECC = (REM > 0 )? DATA_WIDTH/32+1: DATA_WIDTH/32 
)(
  input [DATA_WIDTH-1 :0] in_data, 
  output [NUM_ECC*39-1 :0] out_data 
);


  genvar i;
  generate begin 
    for (i = 0; i < NUM_ECC; i = i+1) begin : enc_mod
      if ( REM ==0 || i < NUM_ECC-1)  begin 
        altera_avalon_ecc_enc ecc_enc 
        ( 
          .data(in_data[(i+1)*32-1 :(i*32)]   ),
          .q(out_data[(i+1)*39-1 : i*39] )
        );
      end 
      else begin 
        altera_avalon_ecc_enc ecc_enc 
          ( 
            .data( {{{32*(i+1) - REM}{1'b0}} , in_data [ (i*32)+REM-1 : (i*32) ]}),
	    .q(out_data[(i+1)*39-1 : i*39] )
          );
      end 
    end 
  end 
  endgenerate
            
endmodule 
