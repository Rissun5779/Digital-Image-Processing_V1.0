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


module altera_emif_ctrl_qdr4_dinv_write_block #(
   parameter DATA_WIDTH = 1,
   parameter DINV_WIDTH = 1
) (
   input logic [DATA_WIDTH-1:0] data_in,
   input logic [DINV_WIDTH-1:0] invert_data,
   output logic [DATA_WIDTH-1:0] data_out,
   output logic [DINV_WIDTH-1:0] dinv_out
);
   timeunit 1ps;
   timeprecision 1ps;
   localparam DINV_GROUP_SIZE = DATA_WIDTH/DINV_WIDTH;
   generate
      genvar i;
      for (i = 0; i < DINV_WIDTH; i++)
      begin : gen_dinv_group
         always @(*) begin
            if (invert_data[i]) begin
               data_out[DINV_GROUP_SIZE*(i+1)-1:DINV_GROUP_SIZE*i] =
                  ~data_in[DINV_GROUP_SIZE*(i+1)-1:DINV_GROUP_SIZE*i];
            end else begin
               data_out[DINV_GROUP_SIZE*(i+1)-1:DINV_GROUP_SIZE*i] =
                  data_in[DINV_GROUP_SIZE*(i+1)-1:DINV_GROUP_SIZE*i];
            end
            dinv_out[i] = invert_data[i];
         end
      end
   endgenerate
endmodule

