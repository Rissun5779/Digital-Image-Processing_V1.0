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


///////////////////////////////////////////////////////////////////////////////
// Basic simulation model of DDR3 RDIMM Buffer used by DDR3 RDIMM
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_ddr3_model_rdimm_chip # (
   parameter MEM_DEPTH_IDX                                                = -1,
   parameter MEM_WIDTH_IDX                                                = 0,
   parameter PORT_MEM_CS_N_WIDTH                                          = 1

) (
   input             [1:0]   DCKE,
   input             [1:0]   DODT,
   input             [3:0]   DCS_n,

   input            [15:0]   DA,
   input             [2:0]   DBA,
   input                     DRAS_n,
   input                     DCAS_n,
   input                     DWE_n,

   input                     CK,
   input                     CK_n,

   input                     DRESET_n,

   input                     PAR_IN,

   output   logic    [1:0]   QCKE,
   output   logic    [1:0]   QODT,
   output   logic    [3:0]   QCS_n,

   output   logic   [15:0]   QA,
   output   logic    [2:0]   QBA,
   output   logic            QRAS_n,
   output   logic            QCAS_n,
   output   logic            QWE_n,

   output            [3:0]   Y,
   output            [3:0]   Y_n,

   output   logic            ERROUT_n
);

   timeunit 1ps;
   timeprecision 1ps;

   assign Y   = {4{CK}};
   assign Y_n = {4{CK_n}};

   generate
      reg my_parity;
      reg [4:0] err_out_shiftreg = 5'b11111;
      always @(posedge CK) begin
            err_out_shiftreg[4:1] <= err_out_shiftreg[3:0];
            if (DCS_n != {PORT_MEM_CS_N_WIDTH{1'b1}}) begin
               err_out_shiftreg[1:0] <= {2{^{DA, DBA, DRAS_n, DCAS_n, DWE_n} == PAR_IN}};
            end else begin
               err_out_shiftreg[0] <= 1'b1;
            end
      end
      assign ERROUT_n = err_out_shiftreg[4];
   endgenerate

   always @ (*)
   begin
      QA     <= repeat(1) @(negedge CK) DA;
      QBA    <= repeat(1) @(negedge CK) DBA;
      QRAS_n <= repeat(1) @(negedge CK) DRAS_n;
      QCAS_n <= repeat(1) @(negedge CK) DCAS_n;
      QWE_n  <= repeat(1) @(negedge CK) DWE_n;
      QCS_n  <= repeat(1) @(negedge CK) DCS_n;
      QODT   <= repeat(1) @(negedge CK) DODT;
      QCKE   <= repeat(1) @(negedge CK) DCKE;
   end

   task automatic cmd_program_rdimm;
      bit [3:0] rdimm_addr = {DBA[2], DA[2:0]};
      bit [3:0] rdimm_d = {DBA[1:0], DA[4:3]};
      $display("[%0t] [DW=%0d%0d]:  RDIMM RC%0d => %0H", $time, MEM_DEPTH_IDX, MEM_WIDTH_IDX, rdimm_addr, rdimm_d);	
   endtask

   always @ (posedge CK) begin
      if((DCS_n[1:0] == 2'b00) && DRAS_n && DCAS_n && DWE_n) cmd_program_rdimm;
   end

endmodule

