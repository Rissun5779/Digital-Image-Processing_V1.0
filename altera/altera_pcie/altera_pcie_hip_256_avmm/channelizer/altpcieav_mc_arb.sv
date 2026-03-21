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


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altpcieav_mc_arb
  # (
      NUMBER_OF_CHANNELS = 4
    )

 (
   input   logic           Clk_i,
   input   logic           Rstn_i,

   input   logic           PriorQueueReq0_i,
   input   logic           PriorQueueReq1_i,
   input   logic           PriorQueueReq2_i,
   input   logic           PriorQueueReq3_i,
   input   logic           PriorQueueReq4_i,
   input   logic           PriorQueueReq5_i,
   input   logic           PriorQueueReq6_i,
   input   logic           PriorQueueReq7_i,

   output  logic           PriorQueueGrant0_o,
   output  logic           PriorQueueGrant1_o,
   output  logic           PriorQueueGrant2_o,
   output  logic           PriorQueueGrant3_o,
   output  logic           PriorQueueGrant4_o,
   output  logic           PriorQueueGrant5_o,
   output  logic           PriorQueueGrant6_o,
   output  logic           PriorQueueGrant7_o

 );
     //state machine encoding
     localparam  ARB_IDLE                  = 16'h0000;
     localparam  ARB_GRANT_0               = 16'h0002;
     localparam  ARB_GRANT_1               = 16'h0004;
     localparam  ARB_GRANT_2               = 16'h0008;
     localparam  ARB_GRANT_3               = 16'h0010;
     localparam  ARB_GRANT_4               = 16'h0020;
     localparam  ARB_GRANT_5               = 16'h0040;
     localparam  ARB_GRANT_6               = 16'h0080;
     localparam  ARB_GRANT_7               = 16'h0100;
     localparam  ARB_LAST_GRANT_0          = 16'h0200;
     localparam  ARB_LAST_GRANT_1          = 16'h0400;
     localparam  ARB_LAST_GRANT_2          = 16'h0800;
     localparam  ARB_LAST_GRANT_3          = 16'h1000;
     localparam  ARB_LAST_GRANT_4          = 16'h2000;
     localparam  ARB_LAST_GRANT_5          = 16'h4000;
     localparam  ARB_LAST_GRANT_6          = 16'h8000;

  logic [15:0]                           arb_state;
  logic [15:0]                           arb_nxt_state;

  logic                                  chan_req_0;
  logic                                  chan_req_1;
  logic                                  chan_req_2;
  logic                                  chan_req_3;
  logic                                  chan_req_4;
  logic                                  chan_req_5;
  logic                                  chan_req_6;
  logic                                  chan_req_7;


   generate if(NUMBER_OF_CHANNELS == 2)
     begin
       assign chan_req_0 = PriorQueueReq0_i;
       assign chan_req_1 = PriorQueueReq1_i;
       assign chan_req_2 = 1'b0;
       assign chan_req_3 = 1'b0;
       assign chan_req_4 = 1'b0;
       assign chan_req_5 = 1'b0;
       assign chan_req_6 = 1'b0;
       assign chan_req_7 = 1'b0;
     end
  endgenerate


generate if(NUMBER_OF_CHANNELS == 4)
     begin
       assign chan_req_0 = PriorQueueReq0_i;
       assign chan_req_1 = PriorQueueReq1_i;
       assign chan_req_2 = PriorQueueReq2_i;
       assign chan_req_3 = PriorQueueReq3_i;
       assign chan_req_4 = 1'b0;
       assign chan_req_5 = 1'b0;
       assign chan_req_6 = 1'b0;
       assign chan_req_7 = 1'b0;
     end
  endgenerate

generate if(NUMBER_OF_CHANNELS == 8)
     begin
       assign chan_req_0 = PriorQueueReq0_i;
       assign chan_req_1 = PriorQueueReq1_i;
       assign chan_req_2 = PriorQueueReq2_i;
       assign chan_req_3 = PriorQueueReq3_i;
       assign chan_req_4 = PriorQueueReq4_i;
       assign chan_req_5 = PriorQueueReq5_i;
       assign chan_req_6 = PriorQueueReq6_i;
       assign chan_req_7 = PriorQueueReq7_i;
     end
  endgenerate


 /// Arbiter state machine

  always_ff @ (posedge Clk_i or negedge Rstn_i)
     begin
       if(~Rstn_i)
           arb_state <= ARB_IDLE;
         else
           arb_state <= arb_nxt_state;
     end

 always_comb
  begin
    case(arb_state)
      ARB_IDLE :    /// same as last grant 7
        if(chan_req_0)
          arb_nxt_state <= ARB_GRANT_0;
        else if(chan_req_1)
          arb_nxt_state <= ARB_GRANT_1;
        else if(chan_req_2)
          arb_nxt_state <= ARB_GRANT_2;
        else if(chan_req_3)
          arb_nxt_state <= ARB_GRANT_3;
        else if(chan_req_4)
          arb_nxt_state <= ARB_GRANT_4;
        else if(chan_req_5)
          arb_nxt_state <= ARB_GRANT_5;
        else if(chan_req_6)
          arb_nxt_state <= ARB_GRANT_6;
         else if(chan_req_7)
          arb_nxt_state <= ARB_GRANT_7;
        else
           arb_nxt_state <= ARB_IDLE;


       ARB_GRANT_0 :
           arb_nxt_state <= ARB_LAST_GRANT_0;

       ARB_GRANT_1 :
           arb_nxt_state <= ARB_LAST_GRANT_1;

        ARB_GRANT_2 :
           arb_nxt_state <= ARB_LAST_GRANT_2;


        ARB_GRANT_3 :
           arb_nxt_state <= ARB_LAST_GRANT_3;

        ARB_GRANT_4 :
           arb_nxt_state <= ARB_LAST_GRANT_4;

        ARB_GRANT_5 :
           arb_nxt_state <= ARB_LAST_GRANT_5;

        ARB_GRANT_6 :
           arb_nxt_state <= ARB_LAST_GRANT_6;

        ARB_GRANT_7 :
           arb_nxt_state <= ARB_IDLE;

        ARB_LAST_GRANT_0 :
          if(chan_req_1)
            arb_nxt_state <= ARB_GRANT_1;
          else if(chan_req_2)
            arb_nxt_state <= ARB_GRANT_2;
          else if(chan_req_3)
            arb_nxt_state <= ARB_GRANT_3;
          else if(chan_req_4)
            arb_nxt_state <= ARB_GRANT_4;
          else if(chan_req_5)
            arb_nxt_state <= ARB_GRANT_5;
          else if(chan_req_6)
            arb_nxt_state <= ARB_GRANT_6;
          else if(chan_req_7)
            arb_nxt_state <= ARB_GRANT_7;
          else
             arb_nxt_state <= ARB_LAST_GRANT_0;

      ARB_LAST_GRANT_1 :
        if(chan_req_2)
          arb_nxt_state <= ARB_GRANT_2;
        else if(chan_req_3)
          arb_nxt_state <= ARB_GRANT_3;
        else if(chan_req_4)
          arb_nxt_state <= ARB_GRANT_4;
        else if(chan_req_5)
          arb_nxt_state <= ARB_GRANT_5;
        else if(chan_req_6)
          arb_nxt_state <= ARB_GRANT_6;
        else if(chan_req_7)
          arb_nxt_state <= ARB_GRANT_7;
        else if(chan_req_0)
          arb_nxt_state <= ARB_GRANT_0;
        else
           arb_nxt_state <= ARB_LAST_GRANT_1;

     ARB_LAST_GRANT_2 :
         if(chan_req_3)
          arb_nxt_state <= ARB_GRANT_3;
        else if(chan_req_4)
          arb_nxt_state <= ARB_GRANT_4;
        else if(chan_req_5)
          arb_nxt_state <= ARB_GRANT_5;
        else if(chan_req_6)
          arb_nxt_state <= ARB_GRANT_6;
        else if(chan_req_7)
          arb_nxt_state <= ARB_GRANT_7;
        else if(chan_req_0)
          arb_nxt_state <= ARB_GRANT_0;
        else if(chan_req_1)
          arb_nxt_state <= ARB_GRANT_1;
        else
           arb_nxt_state <= ARB_LAST_GRANT_2;

    ARB_LAST_GRANT_3:
          if(chan_req_4)
          arb_nxt_state <= ARB_GRANT_4;
        else if(chan_req_5)
          arb_nxt_state <= ARB_GRANT_5;
        else if(chan_req_6)
          arb_nxt_state <= ARB_GRANT_6;
        else if(chan_req_7)
          arb_nxt_state <= ARB_GRANT_7;
        else if(chan_req_0)
          arb_nxt_state <= ARB_GRANT_0;
        else if(chan_req_1)
          arb_nxt_state <= ARB_GRANT_1;
        else if(chan_req_2)
          arb_nxt_state <= ARB_GRANT_2;
        else
           arb_nxt_state <= ARB_LAST_GRANT_3;


   ARB_LAST_GRANT_4 :
        if(chan_req_5)
          arb_nxt_state <= ARB_GRANT_5;
        else if(chan_req_6)
          arb_nxt_state <= ARB_GRANT_6;
        else if(chan_req_7)
          arb_nxt_state <= ARB_GRANT_7;
        else if(chan_req_0)
          arb_nxt_state <= ARB_GRANT_0;
        else if(chan_req_1)
          arb_nxt_state <= ARB_GRANT_1;
        else if(chan_req_2)
          arb_nxt_state <= ARB_GRANT_2;
        else if(chan_req_3)
          arb_nxt_state <= ARB_GRANT_3;
        else
           arb_nxt_state <= ARB_LAST_GRANT_4;

   ARB_LAST_GRANT_5:
         if(chan_req_6)
          arb_nxt_state <= ARB_GRANT_6;
        else if(chan_req_7)
          arb_nxt_state <= ARB_GRANT_7;
        else if(chan_req_0)
          arb_nxt_state <= ARB_GRANT_0;
        else if(chan_req_1)
          arb_nxt_state <= ARB_GRANT_1;
        else if(chan_req_2)
          arb_nxt_state <= ARB_GRANT_2;
        else if(chan_req_3)
          arb_nxt_state <= ARB_GRANT_3;
        else if(chan_req_4)
          arb_nxt_state <= ARB_GRANT_4;
        else
           arb_nxt_state <= ARB_LAST_GRANT_5;

   ARB_LAST_GRANT_6:
        if(chan_req_7)
          arb_nxt_state <= ARB_GRANT_7;
        else if(chan_req_0)
          arb_nxt_state <= ARB_GRANT_0;
        else if(chan_req_1)
          arb_nxt_state <= ARB_GRANT_1;
        else if(chan_req_2)
          arb_nxt_state <= ARB_GRANT_2;
        else if(chan_req_3)
          arb_nxt_state <= ARB_GRANT_3;
        else if(chan_req_4)
          arb_nxt_state <= ARB_GRANT_4;
        else if(chan_req_5)
          arb_nxt_state <= ARB_GRANT_5;
        else
           arb_nxt_state <= ARB_LAST_GRANT_6;

        ARB_GRANT_7 :
           arb_nxt_state <= ARB_IDLE;

    default:
           arb_nxt_state <= ARB_IDLE;

  endcase
end

  assign PriorQueueGrant0_o = (arb_state == ARB_GRANT_0) | (arb_state == ARB_LAST_GRANT_0); // grant or park
  assign PriorQueueGrant1_o = (arb_state == ARB_GRANT_1) | (arb_state == ARB_LAST_GRANT_1); // grant or park
  assign PriorQueueGrant2_o = (arb_state == ARB_GRANT_2) | (arb_state == ARB_LAST_GRANT_2); // grant or park
  assign PriorQueueGrant3_o = (arb_state == ARB_GRANT_3) | (arb_state == ARB_LAST_GRANT_3); // grant or park
  assign PriorQueueGrant4_o = (arb_state == ARB_GRANT_4) | (arb_state == ARB_LAST_GRANT_4); // grant or park
  assign PriorQueueGrant5_o = (arb_state == ARB_GRANT_5) | (arb_state == ARB_LAST_GRANT_5); // grant or park
  assign PriorQueueGrant6_o = (arb_state == ARB_GRANT_6) | (arb_state == ARB_LAST_GRANT_6); // grant or park
  assign PriorQueueGrant7_o = (arb_state == ARB_GRANT_7); // grant or park

endmodule
