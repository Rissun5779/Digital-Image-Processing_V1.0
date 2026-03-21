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


`timescale 1ns / 1ns


 
module altera_mbox_data_adapter (
 // Interface: in
 output reg         in_ready,
 input              in_valid,
 input [32-1 : 0]    in_data,
 // Interface: out
 input                out_ready,
 output reg           out_valid,
 output reg [64-1: 0]  out_data,

  // Interface: clk
 input              clk,
 // Interface: reset
 input              reset

);



   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------
   wire [1-1:0]   state_from_memory;
   reg  [1-1:0]   state;
   reg  [1-1:0]   new_state;
   reg  [1-1:0]   state_d1;
    
   reg            in_ready_d1;
   reg            a_ready;
   reg            a_valid;
   reg [32-1:0]    a_data0; 
   reg            a_startofpacket;
   reg            a_endofpacket;
   reg            a_empty;
   reg            a_error;
   reg            b_ready;
   reg            b_valid;
   reg  [64-1:0]   b_data;
   reg            b_startofpacket; 
   wire           b_startofpacket_wire; 
   reg            b_endofpacket; 
   reg            b_empty;   
   reg            b_error; 
   reg            mem_write0;
   reg  [32-1:0]   mem_writedata0;
   wire [32-1:0]   mem_readdata0;
   wire           mem_waitrequest0;
   reg  [32-1:0]   mem0[0:0];
   reg            sop_mem_writeenable;
   reg            sop_mem_writedata;
   wire           mem_waitrequest_sop; 

   wire           state_waitrequest;
   reg            state_waitrequest_d1; 


   wire           error_from_mem;
   reg            error_mem_writedata;
   reg          error_mem_writeenable;

   reg  [1-1:0]   state_register;
   reg            sop_register; 
   reg            error_register;
   reg  [32-1:0]   data0_register;

   // ---------------------------------------------------------------------
   //| Input Register Stage
   // ---------------------------------------------------------------------
   always_ff @(posedge clk) begin
      if (reset) begin
         a_valid   <= 0;
         a_data0   <= 0;
      end else begin
         if (in_ready) begin
            a_valid   <= in_valid;
            a_data0 <= in_data[31:0];
         end
      end 
   end


   // ---------------------------------------------------------------------
   //| State & Memory Keepers
   // ---------------------------------------------------------------------
   always_ff @(posedge clk) begin
      if (reset) begin
         in_ready_d1          <= 0;
         state_d1             <= 0;
         state_waitrequest_d1 <= 0;
      end else begin
         in_ready_d1          <= in_ready;
         state_d1             <= state;
         state_waitrequest_d1 <= state_waitrequest;
      end
   end
   
   always_ff @(posedge clk) begin
      if (reset) begin
         state_register <= 0;
         data0_register <= 0;
      end else begin
         state_register <= new_state;
         if (mem_write0)
            data0_register <= mem_writedata0;
         end
      end
   
      assign state_from_memory = state_register;
      assign mem_readdata0 = data0_register;
   
   // ---------------------------------------------------------------------
   //| State Machine
   // ---------------------------------------------------------------------
   always_comb begin

      
   b_ready = (out_ready || ~out_valid);

   a_ready   = 0;
   b_data    = 0;
   b_valid   = 0;
      
   state = state_from_memory;
   if (~in_ready_d1)
      state = state_d1;
         
      
   new_state           = state;
   mem_write0          = 0;
   mem_writedata0      = a_data0;
   sop_mem_writeenable = 0;

      
   case (state) 
            0 : begin
            mem_writedata0 = a_data0;
            a_ready = 1;
            if (a_valid) begin
               new_state = state+1'b1;
               mem_write0 = 1;
            end
         end
         1 : begin
            //b_data[63:32] = mem_readdata0;
            //b_data[31:0] = a_data0;
            b_data[63:32] = a_data0;
            b_data[31:0] = mem_readdata0;
            if (out_ready || ~out_valid) begin
               a_ready = 1;
               if (a_valid) 
               begin
                  new_state = 0;
                  b_valid = 1;
               end
            end
         end

   endcase

      in_ready = (a_ready || ~a_valid);

      
      sop_mem_writedata = 0;
      if (a_valid)
         sop_mem_writedata = a_startofpacket;
      if (b_ready && b_valid && b_startofpacket)
         sop_mem_writeenable = 1;

   end


   // ---------------------------------------------------------------------
   //| Output Register Stage
   // ---------------------------------------------------------------------
   always_ff @(posedge clk) begin
      if (reset) begin
         out_valid         <= 0;
         out_data          <= 0;
      end else begin
         if (out_ready || ~out_valid) begin
            out_valid         <= b_valid;
            out_data          <= b_data;
         end
      end 
   end
   



endmodule

   

