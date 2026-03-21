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


module altera_emif_ctrl_qdr4_ainv_block_calc_if_inv #(
   parameter ADDR_WIDTH = 1,
   parameter AINV_WIDTH = 1
) (
   input logic [ADDR_WIDTH-1:0] addr_in,
   input logic [AINV_WIDTH-1:0] ap_in,
   output logic [AINV_WIDTH-1:0] invert_addr
);
   timeunit 1ps;
   timeprecision 1ps;
   localparam AINV_GROUP_SIZE = ADDR_WIDTH/AINV_WIDTH;
   localparam ONES_COUNTER_WIDTH = ceil_log2(AINV_GROUP_SIZE + 1);
   localparam ONES_THRESHOLD = (AINV_GROUP_SIZE + 1) / 2; 
   
   generate
      genvar i;
      
      for (i = 0; i < AINV_WIDTH; i++)
         begin : gen_ainv_group_invert_addr
         reg [ONES_COUNTER_WIDTH-1:0] ones_counter;
         reg [AINV_GROUP_SIZE:0] ap_ainv_bus;
         
         int j;
         always @(*) begin
            ones_counter = '0;
            ap_ainv_bus = {ap_in[i], addr_in[AINV_GROUP_SIZE*(i+1)-1:AINV_GROUP_SIZE*i]};
            for (j = 0; j < AINV_GROUP_SIZE; j++)
               ones_counter += ap_ainv_bus[j];
         end

         always @(*) begin
            if (ones_counter <= ONES_THRESHOLD) begin
               invert_addr[i] = 1'b1;
            end else begin
               invert_addr[i] = 1'b0;
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
