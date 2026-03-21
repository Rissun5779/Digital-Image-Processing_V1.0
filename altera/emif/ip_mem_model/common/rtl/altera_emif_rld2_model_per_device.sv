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
// memory model per device in a given depth expansion
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_rld2_model_per_device
    # (
   parameter MEM_NUMBER_OF_RANKS                                          = 1,
   // Definition of port widths for "mem" interface
   parameter PORT_MEM_CKE_WIDTH                                           = 1,
   parameter PORT_MEM_BA_WIDTH                                            = 1,
   parameter PORT_MEM_BG_WIDTH                                            = 1,
   parameter PORT_MEM_C_WIDTH                                             = 1,
   parameter PORT_MEM_A_WIDTH                                             = 1,
   parameter PORT_MEM_CS_N_WIDTH                                          = 1,
   parameter PORT_MEM_RAS_N_WIDTH                                         = 1,
   parameter PORT_MEM_CAS_N_WIDTH                                         = 1,
   parameter PORT_MEM_WE_N_WIDTH                                          = 1,
   parameter PORT_MEM_ACT_N_WIDTH                                         = 1,
   parameter PORT_MEM_DQS_WIDTH                                           = 1,
   parameter PORT_MEM_DQS_N_WIDTH                                         = 1,
   parameter PORT_MEM_DQ_WIDTH                                            = 1,               
   parameter PORT_MEM_DM_WIDTH                                            = 1,
   parameter PORT_MEM_DBI_N_WIDTH                                         = 1,
   parameter PORT_MEM_RESET_N_WIDTH                                       = 1,
   parameter PORT_MEM_PAR_WIDTH                                           = 1,
   parameter PORT_MEM_ALERT_N_WIDTH                                       = 1,
   parameter PORT_MEM_QK_WIDTH                                            = 1,
   parameter PORT_MEM_DK_WIDTH                                            = 1,
   parameter PORT_MEM_DK_N_WIDTH                                          = 1,
   parameter PORT_MEM_QK_N_WIDTH                                          = 1,
   parameter PORT_MEM_REF_N_WIDTH                                         = 1

  ) (

   input  logic                        [PORT_MEM_A_WIDTH-1:0]            mem_a,
   input  logic                        [PORT_MEM_BA_WIDTH-1:0]           mem_ba,
   input  logic                        [PORT_MEM_BG_WIDTH-1:0]           mem_bg,
   input  logic                        [PORT_MEM_C_WIDTH-1:0]            mem_c,
   input  logic                                                          mem_ck,
   input  logic                                                          mem_ck_n,
   input  logic                        [PORT_MEM_CKE_WIDTH - 1:0]        mem_cke,
   input  logic                        [PORT_MEM_CS_N_WIDTH - 1:0]       mem_cs_n,
   input  logic                        [PORT_MEM_RAS_N_WIDTH - 1:0]      mem_ras_n,
   input  logic                        [PORT_MEM_CAS_N_WIDTH - 1:0]      mem_cas_n,
   input  logic                        [PORT_MEM_WE_N_WIDTH - 1:0]       mem_we_n,
   input  logic                        [PORT_MEM_ACT_N_WIDTH - 1:0]      mem_act_n,
   input  logic                        [PORT_MEM_RESET_N_WIDTH - 1:0]    mem_reset_n,
   input  logic                        [PORT_MEM_DM_WIDTH - 1:0]         mem_dm,
   inout  tri                          [PORT_MEM_DBI_N_WIDTH - 1:0]      mem_dbi_n,
   inout  tri                          [PORT_MEM_DQ_WIDTH - 1:0]         mem_dq,
   inout  tri                          [PORT_MEM_DQS_WIDTH - 1:0]        mem_dqs,
   inout  tri                          [PORT_MEM_DQS_N_WIDTH - 1:0]      mem_dqs_n,
   output logic                        [PORT_MEM_ALERT_N_WIDTH-1:0]      mem_alert_n,
   input  logic                        [PORT_MEM_PAR_WIDTH-1:0]          mem_par,
   input  logic                                                          mem_odt,

   output logic                        [PORT_MEM_QK_WIDTH-1:0]           mem_qk,
   output logic                        [PORT_MEM_QK_N_WIDTH-1:0]         mem_qk_n,
   input logic                         [PORT_MEM_DK_WIDTH-1:0]           mem_dk,
   input logic                         [PORT_MEM_DK_N_WIDTH-1:0]         mem_dk_n,
   input logic                         [PORT_MEM_REF_N_WIDTH-1:0]        mem_ref_n   
   
  );
   timeunit 1ps;
   timeprecision 1ps;



   reg                                 [PORT_MEM_A_WIDTH-1:0]            a;
   reg                                 [PORT_MEM_BA_WIDTH-1:0]           ba;
   reg                                 [PORT_MEM_BG_WIDTH-1:0]           bg;
   reg                                 [PORT_MEM_C_WIDTH-1:0]            c;
   reg                                 [PORT_MEM_DM_WIDTH-1:0]           dm;
   reg                                                                   cke;
   reg                                 [MEM_NUMBER_OF_RANKS-1:0]         cs_n;
   reg                                 [PORT_MEM_CS_N_WIDTH-1: 0]        cs_rdimm_n;
   reg                                                                   ras_n;
   reg                                                                   cas_n;
   reg                                                                   we_n;
   reg                                                                   act_n;
   reg                                                                   odt;
   reg                                                                   alert_n;

   generate
         genvar rank;
         for (rank = 0; rank < MEM_NUMBER_OF_RANKS; rank = rank + 1)  begin : rank_gen
            altera_emif_rld2_model_rank #(
               .MEM_BANKADDR_WIDTH                            (PORT_MEM_BA_WIDTH),
               .MEM_ADDR_WIDTH                                (PORT_MEM_A_WIDTH),
               .MEM_DM_WIDTH                                  (PORT_MEM_DM_WIDTH),
               .MEM_READ_DQS_WIDTH                            (PORT_MEM_QK_WIDTH),
               .MEM_WRITE_DQS_WIDTH                           (PORT_MEM_DK_WIDTH),
               .MEM_DQ_WIDTH                                  (PORT_MEM_DQ_WIDTH),
               .MEM_IF_CS_WIDTH                               (PORT_MEM_CS_N_WIDTH)
            ) rank_inst (
               .mem_a         (mem_a),
               .mem_ba        (mem_ba),
               .mem_ck        (mem_ck),
               .mem_ck_n      (mem_ck_n),
               .mem_cs_n      (mem_cs_n),
               .mem_we_n      (mem_we_n),
               .mem_dm        (mem_dm),
               .mem_dq        (mem_dq),
               .mem_qk        (mem_qk),
               .mem_qk_n      (mem_qk_n),
               .mem_dk        (mem_dk),
               .mem_dk_n      (mem_dk_n),
               .mem_ref_n     (mem_ref_n)
            );
      end
  endgenerate
endmodule

