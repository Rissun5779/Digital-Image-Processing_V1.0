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


module altera_emif_ctrl_qdr4_ainv_block #(
   parameter ADDR_WIDTH = 1,
   parameter AINV_WIDTH = 1
) (
   input logic [ADDR_WIDTH-1:0] addr_in,
   input logic [AINV_WIDTH-1:0] ap_in,
   input logic [AINV_WIDTH-1:0] invert_addr,
   output logic [ADDR_WIDTH-1:0] addr_out,
   output logic [AINV_WIDTH-1:0] ap_out,
   output logic [AINV_WIDTH-1:0] ainv_out
);
   timeunit 1ps;
   timeprecision 1ps;
   
   localparam AINV_GROUP_SIZE = ADDR_WIDTH/AINV_WIDTH;
   generate
      genvar i;
      for (i = 0; i < AINV_WIDTH; i++)
      begin : gen_ainv_group
         always @(*) begin          
             if (invert_addr[i]) begin
               addr_out[AINV_GROUP_SIZE*(i+1)-1:AINV_GROUP_SIZE*i] =
                  ~addr_in[AINV_GROUP_SIZE*(i+1)-1:AINV_GROUP_SIZE*i];
               ap_out[i] = ~ap_in[i];
            end else begin
               addr_out[AINV_GROUP_SIZE*(i+1)-1:AINV_GROUP_SIZE*i] =
                  addr_in[AINV_GROUP_SIZE*(i+1)-1:AINV_GROUP_SIZE*i];
               ap_out[i] = ap_in[i];
            end
            ainv_out[i] = invert_addr[i];
         end
      end
   endgenerate
endmodule

