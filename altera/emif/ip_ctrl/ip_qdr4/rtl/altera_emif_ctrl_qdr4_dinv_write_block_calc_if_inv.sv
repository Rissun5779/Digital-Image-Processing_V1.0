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


module altera_emif_ctrl_qdr4_dinv_write_block_calc_if_inv #(
   parameter DATA_WIDTH = 1,
   parameter DINV_WIDTH = 1
) (
   input logic [DATA_WIDTH-1:0] data_in,
   output logic [DINV_WIDTH-1:0] invert_data
);
   timeunit 1ps;
   timeprecision 1ps;
   
   localparam DINV_GROUP_SIZE = DATA_WIDTH/DINV_WIDTH;
   localparam ONES_COUNTER_WIDTH = ceil_log2(DINV_GROUP_SIZE);
   localparam ONES_THRESHOLD = (DINV_GROUP_SIZE == 18) ? 8 : 4;
   
   generate
      genvar i;
      
      for (i = 0; i < DINV_WIDTH; i++)
         begin : gen_dinv_group_invert_data
         reg [ONES_COUNTER_WIDTH-1:0] ones_counter;
         
         int j;
         always @(*) begin
            ones_counter = '0;
            for (j = 0; j < DINV_GROUP_SIZE; j++)
               ones_counter += data_in[DINV_GROUP_SIZE*i+j];
         end

         always @(*) begin
            if (ones_counter <= ONES_THRESHOLD) begin
               invert_data[i] = 1'b1;
            end else begin
               invert_data[i] = 1'b0;
            end
         end
      end
   endgenerate
   
   // Calculate the ceiling of log_2 of the input value
   function integer ceil_log2;
      input integer value;
      begin
         value = value - 1;
         for (ceil_log2 = 0; value > 0; ceil_log2 = ceil_log2 + 1)
            value = value >> 1;
      end
   endfunction

endmodule
