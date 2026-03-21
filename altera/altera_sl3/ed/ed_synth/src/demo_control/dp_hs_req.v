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


`timescale 1ns/1ns

// Request state enumeration
`define  REQ_WAIT_FOR_REQ_ASSERT    2'b00
`define  REQ_WAIT_FOR_ACK_ASSERT    2'b01
`define  REQ_WAIT_FOR_ACK_DEASSERT  2'b10


module dp_hs_req
(
   input                async_reset_n,
   input                sync_reset_n,
   
   input       [0:1]    sync_ctrl,

   // The synchronous handshake interface 
   input                si_clk,
   input                si_req_n,
   output reg           si_ack_n,
   
   // The asynchronous handshake interface   
   output reg           ai_req_n,
   input                ai_ack_n
);

   // Local variables
   reg               next_ai_req_n;
   reg               next_si_ack_n;
   wire              sync_ack_n;
   reg      [1:0]    ack_state, next_ack_state;

   
   // Instantiate the ack synchronizer
   altera_std_synchronizer_nocut #
   (
     .depth(2),
     .rst_value(1)
   ) 
   ack_sync 
     (
     .clk(si_clk), 
     .reset_n(sync_reset_n), 
     .din(ai_ack_n), 
     .dout(sync_ack_n)
   );


   //
   // Ack state machine - This logic converts
   // an incoming ack from the other clock domain
   // into a single cycle event.
   //
   
   // Ack state machine storage
   always @(posedge si_clk or negedge async_reset_n)
   begin

      if (async_reset_n == 1'b0) begin

         ack_state   <= `REQ_WAIT_FOR_REQ_ASSERT;
         ai_req_n    <= 1'b1;
         si_ack_n    <= 1'b1;

      end else begin

         if (sync_reset_n == 1'b0) begin

            ack_state   <= `REQ_WAIT_FOR_REQ_ASSERT;
            ai_req_n    <= 1'b1;
            si_ack_n    <= 1'b1;

         end else begin

            ack_state   <= next_ack_state;
            ai_req_n    <= next_ai_req_n;
            si_ack_n    <= next_si_ack_n;

         end

      end

   end


   // Ack state machine decoder
   always @(ack_state or si_req_n or sync_ack_n) begin

      case (ack_state)

         `REQ_WAIT_FOR_REQ_ASSERT: begin

            if (si_req_n == 1'b0) begin
                    
               next_ack_state    = `REQ_WAIT_FOR_ACK_ASSERT;
               next_ai_req_n     = 1'b0;
               next_si_ack_n     = 1'b1;

            end else begin
                    
               next_ack_state    = `REQ_WAIT_FOR_REQ_ASSERT;
               next_ai_req_n     = 1'b1;
               next_si_ack_n     = 1'b1;

            end

         end
         
            
         `REQ_WAIT_FOR_ACK_ASSERT: begin
                 
            if (sync_ack_n == 1'b0) begin
                    
               next_ack_state    = `REQ_WAIT_FOR_ACK_DEASSERT;
               next_ai_req_n     = 1'b1;
               next_si_ack_n     = 1'b0;

            end else begin
                    
               next_ack_state    = `REQ_WAIT_FOR_ACK_ASSERT;
               next_ai_req_n     = 1'b0;
               next_si_ack_n     = 1'b1;

            end
            
         end

         
         `REQ_WAIT_FOR_ACK_DEASSERT: begin
                 
            if (sync_ack_n == 1'b1) begin
                    
               next_ack_state    = `REQ_WAIT_FOR_REQ_ASSERT;
               next_ai_req_n     = 1'b1;
               next_si_ack_n     = 1'b1;

            end else begin
                    
               next_ack_state    = `REQ_WAIT_FOR_ACK_DEASSERT;
               next_ai_req_n     = 1'b1;
               next_si_ack_n     = 1'b1;

            end
            
         end

         
         default: begin

            next_ack_state    = `REQ_WAIT_FOR_REQ_ASSERT;
            next_ai_req_n     = 1'b1;
            next_si_ack_n     = 1'b1;
               
         end
              
      endcase

   end

   
endmodule
