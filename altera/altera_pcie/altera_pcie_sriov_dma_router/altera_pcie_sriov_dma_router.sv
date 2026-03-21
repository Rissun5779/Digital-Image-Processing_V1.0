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



// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_pcie_sriov_dma_router # (

      parameter NUM_PORTS              = 4  // allow 2,4, 8

   )
  (
      input logic                                  Clk_i,
      input logic                                  Rstn_i,


 ///=========================================================================
      /// AST Descriptor Entry Inteface input - 8 ports max

      input   logic  [167:0]                       AstControlData_0_i,
      input   logic                                AstControlValid_0_i,
      output  logic                                AstControlReady_0_o,

      input   logic  [167:0]                       AstControlData_1_i,
      input   logic                                AstControlValid_1_i,
      output  logic                                AstControlReady_1_o,

      input   logic  [167:0]                       AstControlData_2_i,
      input   logic                                AstControlValid_2_i,
      output  logic                                AstControlReady_2_o,

      input   logic  [167:0]                       AstControlData_3_i,
      input   logic                                AstControlValid_3_i,
      output  logic                                AstControlReady_3_o,

      input   logic  [167:0]                       AstControlData_4_i,
      input   logic                                AstControlValid_4_i,
      output  logic                                AstControlReady_4_o,

      input   logic  [167:0]                       AstControlData_5_i,
      input   logic                                AstControlValid_5_i,
      output  logic                                AstControlReady_5_o,

      input   logic  [167:0]                       AstControlData_6_i,
      input   logic                                AstControlValid_6_i,
      output  logic                                AstControlReady_6_o,

      input   logic  [167:0]                       AstControlData_7_i,
      input   logic                                AstControlValid_7_i,
      output  logic                                AstControlReady_7_o,

 /// AST Control Inteface output to either DMA-Read or DMA-Write engines

      output   logic  [167:0]                       AstControlData_o,
      output   logic                                AstControlValid_o,
      input    logic                                AstControlReady_i,

 ///=========================================================================
 /// Status Ports
 //  output   logic  [31:0]                        pf0_AstStatusData_0_o,
     output   logic  [31:0]                        AstStatusData_0_o,
     output   logic  [31:0]                        AstStatusData_1_o,
     output   logic  [31:0]                        AstStatusData_2_o,
     output   logic  [31:0]                        AstStatusData_3_o,
     output   logic  [31:0]                        AstStatusData_4_o,
     output   logic  [31:0]                        AstStatusData_5_o,
     output   logic  [31:0]                        AstStatusData_6_o,
     output   logic  [31:0]                        AstStatusData_7_o,

//  output   logic                                 pf0_AstStatusValid_0_o,
    output   logic                                 AstStatusValid_0_o,
    output   logic                                 AstStatusValid_1_o,
    output   logic                                 AstStatusValid_2_o,
    output   logic                                 AstStatusValid_3_o,
    output   logic                                 AstStatusValid_4_o,
    output   logic                                 AstStatusValid_5_o,
    output   logic                                 AstStatusValid_6_o,
    output   logic                                 AstStatusValid_7_o,

    input   logic  [31:0]                          AstStatusData_i,
    input   logic                                  AstStatusValid_i

 ///=========================================================================
 /// Descriptor Entries Fetching via DMA-RD
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

  logic                                 control_valid_0;
  logic                                 control_valid_1;
  logic                                 control_valid_2;
  logic                                 control_valid_3;
  logic                                 control_valid_4;
  logic                                 control_valid_5;
  logic                                 control_valid_6;
  logic                                 control_valid_7;

  logic  [167:0]                       control_data_0;
  logic  [167:0]                       control_data_1;
  logic  [167:0]                       control_data_2;
  logic  [167:0]                       control_data_3;
  logic  [167:0]                       control_data_4;
  logic  [167:0]                       control_data_5;
  logic  [167:0]                       control_data_6;
  logic  [167:0]                       control_data_7;

  logic  [7:0]                         func_no; // Function number
  logic  [7:0]                         vf_active;


  generate begin
    if (NUM_PORTS == 4'h2) begin
          assign control_valid_0 = AstControlValid_0_i;
          assign control_valid_1 = AstControlValid_1_i;
          assign control_valid_2 = 1'b0;
          assign control_valid_3 = 1'b0;
          assign control_valid_4 = 1'b0;
          assign control_valid_5 = 1'b0;
          assign control_valid_6 = 1'b0;
          assign control_valid_7 = 1'b0;

          assign control_data_0  = AstControlData_0_i;
          assign control_data_1  = AstControlData_1_i;
          assign control_data_2  = 168'h0;
          assign control_data_3  = 168'h0;
          assign control_data_4  = 168'h0;
          assign control_data_5  = 168'h0;
          assign control_data_6  = 168'h0;
          assign control_data_7  = 168'h0;
    end else if (NUM_PORTS == 4'h4) begin
          assign control_valid_0 = AstControlValid_0_i;
          assign control_valid_1 = AstControlValid_1_i;
          assign control_valid_2 = AstControlValid_2_i;
          assign control_valid_3 = AstControlValid_3_i;
          assign control_valid_4 = 1'b0;
          assign control_valid_5 = 1'b0;
          assign control_valid_6 = 1'b0;
          assign control_valid_7 = 1'b0;

          assign control_data_0  = AstControlData_0_i;
          assign control_data_1  = AstControlData_1_i;
          assign control_data_2  = AstControlData_2_i;
          assign control_data_3  = AstControlData_3_i;
          assign control_data_4  = 168'h0;
          assign control_data_5  = 168'h0;
          assign control_data_6  = 168'h0;
          assign control_data_7  = 168'h0;
    end else if (NUM_PORTS == 4'h8) begin
          assign control_valid_0 = AstControlValid_0_i;
          assign control_valid_1 = AstControlValid_1_i;
          assign control_valid_2 = AstControlValid_2_i;
          assign control_valid_3 = AstControlValid_3_i;
          assign control_valid_4 = AstControlValid_4_i;
          assign control_valid_5 = AstControlValid_5_i;
          assign control_valid_6 = AstControlValid_6_i;
          assign control_valid_7 = AstControlValid_7_i;

          assign control_data_0  = AstControlData_0_i;
          assign control_data_1  = AstControlData_1_i;
          assign control_data_2  = AstControlData_2_i;
          assign control_data_3  = AstControlData_3_i;
          assign control_data_4  = AstControlData_4_i;
          assign control_data_5  = AstControlData_5_i;
          assign control_data_6  = AstControlData_6_i;
          assign control_data_7  = AstControlData_7_i;
    end else begin
          assign control_valid_0 = AstControlValid_0_i;
          assign control_valid_1 = 1'b0;
          assign control_valid_2 = 1'b0;
          assign control_valid_3 = 1'b0;
          assign control_valid_4 = 1'b0;
          assign control_valid_5 = 1'b0;
          assign control_valid_6 = 1'b0;
          assign control_valid_7 = 1'b0;

          assign control_data_0  = 168'h0;
          assign control_data_1  = 168'h0;
          assign control_data_2  = 168'h0;
          assign control_data_3  = 168'h0;
          assign control_data_4  = 168'h0;
          assign control_data_5  = 168'h0;
          assign control_data_6  = 168'h0;
          assign control_data_7  = 168'h0;
    end
  end
endgenerate


//======================================================================
// Arbiter state machine to route Descriptor entry to the DMA engine
//======================================================================

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
        if(control_valid_0 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_0;
        else if(control_valid_1 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_1;
        else if(control_valid_2 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_2;
        else if(control_valid_3 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_3;
        else if(control_valid_4 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_4;
        else if(control_valid_5 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_5;
        else if(control_valid_6 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_6;
         else if(control_valid_7 & AstControlReady_i)
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
          if(control_valid_1 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_1;
          else if(control_valid_2 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_2;
          else if(control_valid_3 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_3;
          else if(control_valid_4 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_4;
          else if(control_valid_5 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_5;
          else if(control_valid_6 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_6;
          else if(control_valid_7 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_7;
          else if(control_valid_0 & AstControlReady_i)
            arb_nxt_state <= ARB_GRANT_0;
          else
             arb_nxt_state <= ARB_LAST_GRANT_0;

      ARB_LAST_GRANT_1 :
        if(control_valid_2 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_2;
        else if(control_valid_3 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_3;
        else if(control_valid_4 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_4;
        else if(control_valid_5 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_5;
        else if(control_valid_6 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_6;
        else if(control_valid_7 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_7;
        else if(control_valid_0 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_0;
        else if(control_valid_1 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_1;
        else
           arb_nxt_state <= ARB_LAST_GRANT_1;

     ARB_LAST_GRANT_2 :
         if(control_valid_3 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_3;
        else if(control_valid_4 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_4;
        else if(control_valid_5 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_5;
        else if(control_valid_6 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_6;
        else if(control_valid_7 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_7;
        else if(control_valid_0 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_0;
        else if(control_valid_1 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_1;
        else if(control_valid_2 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_2;
        else
           arb_nxt_state <= ARB_LAST_GRANT_2;

    ARB_LAST_GRANT_3:
          if(control_valid_4 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_4;
        else if(control_valid_5 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_5;
        else if(control_valid_6 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_6;
        else if(control_valid_7 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_7;
        else if(control_valid_0 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_0;
        else if(control_valid_1 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_1;
        else if(control_valid_2 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_2;
        else if(control_valid_3 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_3;
        else
           arb_nxt_state <= ARB_LAST_GRANT_3;


   ARB_LAST_GRANT_4 :
        if(control_valid_5 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_5;
        else if(control_valid_6 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_6;
        else if(control_valid_7 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_7;
        else if(control_valid_0 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_0;
        else if(control_valid_1 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_1;
        else if(control_valid_2 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_2;
        else if(control_valid_3 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_3;
        else if(control_valid_4 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_4;
        else
           arb_nxt_state <= ARB_LAST_GRANT_4;

   ARB_LAST_GRANT_5:
         if(control_valid_6 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_6;
        else if(control_valid_7 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_7;
        else if(control_valid_0 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_0;
        else if(control_valid_1 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_1;
        else if(control_valid_2 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_2;
        else if(control_valid_3 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_3;
        else if(control_valid_4 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_4;
        else if(control_valid_5 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_5;
        else
           arb_nxt_state <= ARB_LAST_GRANT_5;

   ARB_LAST_GRANT_6:
        if(control_valid_7 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_7;
        else if(control_valid_0 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_0;
        else if(control_valid_1 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_1;
        else if(control_valid_2 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_2;
        else if(control_valid_3 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_3;
        else if(control_valid_4 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_4;
        else if(control_valid_5 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_5;
        else if(control_valid_6 & AstControlReady_i)
          arb_nxt_state <= ARB_GRANT_6;
        else
           arb_nxt_state <= ARB_LAST_GRANT_6;

        ARB_GRANT_7 :
           arb_nxt_state <= ARB_IDLE;

    default:
           arb_nxt_state <= ARB_IDLE;

  endcase
end

  assign AstControlReady_0_o = arb_state[1];
  assign AstControlReady_1_o = arb_state[2];
  assign AstControlReady_2_o = arb_state[3];
  assign AstControlReady_3_o = arb_state[4];
  assign AstControlReady_4_o = arb_state[5];
  assign AstControlReady_5_o = arb_state[6];
  assign AstControlReady_6_o = arb_state[7];
  assign AstControlReady_7_o = arb_state[8];


//======================================================================
// Output to DMA engine
//======================================================================
  /// Muxing the Control Ports

   always_comb
     begin
       case(arb_state[8:1])
            8'b00000001 :  AstControlData_o = control_data_0;
            8'b00000010 :  AstControlData_o = control_data_1;
            8'b00000100 :  AstControlData_o = control_data_2;
            8'b00001000 :  AstControlData_o = control_data_3;
            8'b00010000 :  AstControlData_o = control_data_4;
            8'b00100000 :  AstControlData_o = control_data_5;
            8'b01000000 :  AstControlData_o = control_data_6;
            8'b10000000 :  AstControlData_o = control_data_7;
            default     :  AstControlData_o = control_data_0;
       endcase
    end

assign AstControlValid_o = |arb_state[8:1];

//======================================================================
// Status port from DMA engine to Descriptor Controller
// Drive Valid and Status to all active descriptor controller.
// It is up to the descriptor controller to make sure it match with function
// number before processing it.
//======================================================================
assign func_no    = AstStatusData_i[31:24];
assign vf_active =  func_no[7]; // 128VFs

  //assign pf0_AstStatusValid_0_o = !vf_active & !func_no[0] & AstStatusValid_i;

 //======================================
 // Decode the following ports for VFs
 generate begin
    if ( NUM_PORTS ==  4'h2) begin
          assign AstStatusValid_0_o = vf_active & !func_no[0] & AstStatusValid_i;
          assign AstStatusValid_1_o = vf_active &  func_no[0] & AstStatusValid_i;
          assign AstStatusValid_2_o = 1'b0;
          assign AstStatusValid_3_o = 1'b0;
          assign AstStatusValid_5_o = 1'b0;
          assign AstStatusValid_6_o = 1'b0;
          assign AstStatusValid_7_o = 1'b0;
    end else if ( NUM_PORTS ==  4'h4 ) begin
          assign AstStatusValid_0_o = vf_active &  (func_no[1:0] == 2'h0) & AstStatusValid_i;
          assign AstStatusValid_1_o = vf_active &  (func_no[1:0] == 2'h1) & AstStatusValid_i;
          assign AstStatusValid_2_o = vf_active &  (func_no[1:0] == 2'h2) & AstStatusValid_i;
          assign AstStatusValid_3_o = vf_active &  (func_no[1:0] == 2'h3) & AstStatusValid_i;
          assign AstStatusValid_5_o = 1'b0;
          assign AstStatusValid_6_o = 1'b0;
          assign AstStatusValid_7_o = 1'b0;
   end else if ( NUM_PORTS ==  4'h8) begin
          assign AstStatusValid_0_o = vf_active &  (func_no[2:0] == 3'h0) & AstStatusValid_i;
          assign AstStatusValid_1_o = vf_active &  (func_no[2:0] == 3'h1) & AstStatusValid_i;
          assign AstStatusValid_2_o = vf_active &  (func_no[2:0] == 3'h2) & AstStatusValid_i;
          assign AstStatusValid_3_o = vf_active &  (func_no[2:0] == 3'h3) & AstStatusValid_i;
          assign AstStatusValid_4_o = vf_active &  (func_no[2:0] == 3'h4) & AstStatusValid_i;
          assign AstStatusValid_5_o = vf_active &  (func_no[2:0] == 3'h5) & AstStatusValid_i;
          assign AstStatusValid_6_o = vf_active &  (func_no[2:0] == 3'h6) & AstStatusValid_i;
          assign AstStatusValid_7_o = vf_active &  (func_no[2:0] == 3'h7) & AstStatusValid_i;
   end else begin
          assign AstStatusValid_0_o = 1'b0;
          assign AstStatusValid_1_o = 1'b0;
          assign AstStatusValid_2_o = 1'b0;
          assign AstStatusValid_3_o = 1'b0;
          assign AstStatusValid_5_o = 1'b0;
          assign AstStatusValid_6_o = 1'b0;
          assign AstStatusValid_7_o = 1'b0;
   end

  end
  endgenerate

//assign  pf0_AstStatusData_0_o = AstStatusData_i;
assign  AstStatusData_0_o = AstStatusData_i;
assign  AstStatusData_1_o = AstStatusData_i;
assign  AstStatusData_2_o = AstStatusData_i;
assign  AstStatusData_3_o = AstStatusData_i;
assign  AstStatusData_4_o = AstStatusData_i;
assign  AstStatusData_5_o = AstStatusData_i;
assign  AstStatusData_6_o = AstStatusData_i;
assign  AstStatusData_7_o = AstStatusData_i;

endmodule






