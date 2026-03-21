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



module altera_emif_ctrl_qdr2_fsm # (
   parameter USER_CLK_RATIO                          = 1,
   parameter CTRL_BL                                 = 2
) (
   // Clock and reset interface
   input    logic clk,
   input    logic reset_n,
   
   // PHY initialization and calibration status
   input    logic init_complete,
   input    logic init_fail,
   
   // User memory requests
   input    logic write_req,
   input    logic read_req,
  
   // State machine command outputs
   output   logic do_write,
   output   logic do_read
);
   timeunit 1ps;
   timeprecision 1ps;

   // FSM states
   enum int unsigned {
      INIT,
      INIT_FAIL,
      IDLE,
      WRITE,
      READ,
      INIT_COMPLETE
   } state;

   generate
   if (USER_CLK_RATIO == 1 && CTRL_BL == 4)
   begin
      always_ff @(posedge clk, negedge reset_n)
      begin
         if (!reset_n)
         begin
            state <= INIT;
         end
         else
            case(state)
               INIT :
                  if (init_complete == 1'b1)
                     state <= IDLE;
                  else if (init_fail == 1'b1)
                     state <= INIT_FAIL;
                  else
                     state <= INIT;
               INIT_FAIL :
                  state <= INIT_FAIL;
               default :
                  if (do_write)
                     state <= WRITE;
                  else if (do_read)
                     state <= READ;
                  else
                     state <= IDLE;
            endcase
      end

      always_ff @(state or write_req or read_req)
      begin
         do_read <= 1'b0;
         do_write <= 1'b0;
         case(state)
            IDLE:
               if (write_req)
                  do_write <= 1'b1;
               else if (read_req)
                  do_read <= 1'b1;
            WRITE:
               if (read_req)
                  do_read <= 1'b1;
            READ:
               if (write_req)
                  do_write <= 1'b1;
            default:
               ; 
         endcase
      end
   end
   else
   begin
      always_ff @(posedge clk, negedge reset_n)
      begin
         if (!reset_n)
         begin
            state <= INIT;
         end
         else
            case(state)
               INIT :
                  if (init_complete == 1'b1)
                     state <= INIT_COMPLETE;
                  else if (init_fail == 1'b1)
                     state <= INIT_FAIL;
                  else
                     state <= INIT;
               INIT_FAIL :
                  state <= INIT_FAIL;
               INIT_COMPLETE :
                  state <= INIT_COMPLETE;
            endcase
      end

      always_comb
      begin
         do_write <= 1'b0;
         do_read <= 1'b0;
         if (state == INIT_COMPLETE)
         begin
            if (write_req)
               do_write <= 1'b1;
            if (read_req)
               do_read <= 1'b1;
         end
      end
   end
   endgenerate

endmodule
