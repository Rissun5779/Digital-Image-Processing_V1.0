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
module altera_emif_qdr4_model_per_device # (

   parameter MEM_TRL_CYC                             = 0,
   parameter MEM_TWL_CYC                             = 0,
   parameter MEM_BL                                  = 0,
   parameter MEM_DATA_INV_ENA                        = 0,
   parameter MEM_GUARANTEED_WRITE_INIT               = 0,
   parameter MEM_VERBOSE                             = 1,
   parameter MEM_DEVICE_WIDTH                        = 0,
   parameter MEM_WIDTH_IDX                           = -1,
   
   // Definition of port widths for "mem" interface
   parameter PORT_MEM_CK_WIDTH                       = 1,
   parameter PORT_MEM_CK_N_WIDTH                     = 1,
   parameter PORT_MEM_DKA_WIDTH                      = 1,
   parameter PORT_MEM_DKA_N_WIDTH                    = 1,
   parameter PORT_MEM_DKB_WIDTH                      = 1,
   parameter PORT_MEM_DKB_N_WIDTH                    = 1,
   parameter PORT_MEM_A_WIDTH                        = 1,
   parameter PORT_MEM_RESET_N_WIDTH                  = 1,
   parameter PORT_MEM_LDA_N_WIDTH                    = 1,
   parameter PORT_MEM_LDB_N_WIDTH                    = 1,
   parameter PORT_MEM_RWA_N_WIDTH                    = 1,
   parameter PORT_MEM_RWB_N_WIDTH                    = 1,
   parameter PORT_MEM_LBK0_N_WIDTH                   = 1,
   parameter PORT_MEM_LBK1_N_WIDTH                   = 1,
   parameter PORT_MEM_CFG_N_WIDTH                    = 1,
   parameter PORT_MEM_AP_WIDTH                       = 1,
   parameter PORT_MEM_PE_N_WIDTH                     = 1,
   parameter PORT_MEM_AINV_WIDTH                     = 1,
   parameter PORT_MEM_DQA_WIDTH                      = 1,
   parameter PORT_MEM_DQB_WIDTH                      = 1,
   parameter PORT_MEM_DINVA_WIDTH                    = 1,
   parameter PORT_MEM_DINVB_WIDTH                    = 1,
   parameter PORT_MEM_QKA_WIDTH                      = 1,
   parameter PORT_MEM_QKA_N_WIDTH                    = 1,
   parameter PORT_MEM_QKB_WIDTH                      = 1,
   parameter PORT_MEM_QKB_N_WIDTH                    = 1
) (
   // Ports for "mem" interface
   input  logic [PORT_MEM_CK_WIDTH-1:0]                       mem_ck,
   input  logic [PORT_MEM_CK_N_WIDTH-1:0]                     mem_ck_n,
   input  logic [PORT_MEM_DKA_WIDTH-1:0]                      mem_dka,
   input  logic [PORT_MEM_DKA_N_WIDTH-1:0]                    mem_dka_n,
   input  logic [PORT_MEM_DKB_WIDTH-1:0]                      mem_dkb,
   input  logic [PORT_MEM_DKB_N_WIDTH-1:0]                    mem_dkb_n,
   input  logic [PORT_MEM_A_WIDTH-1:0]                        mem_a,
   input  logic [PORT_MEM_RESET_N_WIDTH-1:0]                  mem_reset_n,
   input  logic [PORT_MEM_LDA_N_WIDTH-1:0]                    mem_lda_n,
   input  logic [PORT_MEM_LDB_N_WIDTH-1:0]                    mem_ldb_n,
   input  logic [PORT_MEM_RWA_N_WIDTH-1:0]                    mem_rwa_n,
   input  logic [PORT_MEM_RWB_N_WIDTH-1:0]                    mem_rwb_n,
   input  logic [PORT_MEM_LBK0_N_WIDTH-1:0]                   mem_lbk0_n,
   input  logic [PORT_MEM_LBK1_N_WIDTH-1:0]                   mem_lbk1_n,
   input  logic [PORT_MEM_CFG_N_WIDTH-1:0]                    mem_cfg_n,
   input  logic [PORT_MEM_AP_WIDTH-1:0]                       mem_ap,
   output logic [PORT_MEM_PE_N_WIDTH-1:0]                     mem_pe_n,
   input  logic [PORT_MEM_AINV_WIDTH-1:0]                     mem_ainv, 
   inout  tri   [PORT_MEM_DQA_WIDTH-1:0]                      mem_dqa,
   inout  tri   [PORT_MEM_DQB_WIDTH-1:0]                      mem_dqb,
   inout  tri   [PORT_MEM_DINVA_WIDTH-1:0]                    mem_dinva,
   inout  tri   [PORT_MEM_DINVB_WIDTH-1:0]                    mem_dinvb,
   output logic [PORT_MEM_QKA_WIDTH-1:0]                      mem_qka,
   output logic [PORT_MEM_QKA_N_WIDTH-1:0]                    mem_qka_n,
   output logic [PORT_MEM_QKB_WIDTH-1:0]                      mem_qkb,
   output logic [PORT_MEM_QKB_N_WIDTH-1:0]                    mem_qkb_n
);
   timeunit 1ps;
   timeprecision 1ps;

// ******************************************************************************************************************************** 
// BEGIN PARAMETER SECTION
// All parameters default to "" will have their values passed in from the toplevel testbench 

   localparam RANKS = 1; 

// Memory device specific parameters, they are set according to the memory spec.

   generate
   genvar rank;
   for (rank = 0; rank < RANKS; rank = rank + 1)
   begin : rank_gen
   
      altera_emif_qdr4_model_rank #(
      
         .PORT_MEM_A_WIDTH                            (PORT_MEM_A_WIDTH),
         
         // Assume that ports A and B have the same clock/dinv port widths
         .PORT_MEM_DK_WIDTH                           (PORT_MEM_DKA_WIDTH),
         .PORT_MEM_QK_WIDTH                           (PORT_MEM_QKA_WIDTH),
         .PORT_MEM_DQ_WIDTH                           (PORT_MEM_DQA_WIDTH),
         .PORT_MEM_DINV_WIDTH                         (PORT_MEM_DINVA_WIDTH),

         .MEM_TRL_CYC                                 (MEM_TRL_CYC),
         .MEM_TWL_CYC                                 (MEM_TWL_CYC),
         .MEM_BL                                      (MEM_BL),
         .MEM_DATA_INV_ENA                            (MEM_DATA_INV_ENA),
         .MEM_GUARANTEED_WRITE_INIT                   (MEM_GUARANTEED_WRITE_INIT),
         .MEM_VERBOSE                                 (MEM_VERBOSE),
         .MEM_WIDTH_IDX                               (MEM_WIDTH_IDX),
         .MEM_DEPTH_IDX                               (rank)

      ) mem_inst (

         .mem_ck                                   (mem_ck),
         .mem_ck_n                                 (mem_ck_n),
         .mem_a                                    (mem_a),
         .mem_ap                                   (mem_ap),
         .mem_pe_n                                 (mem_pe_n),
         .mem_ainv                                 (mem_ainv),
         
         .mem_dka                                  (mem_dka),
         .mem_dka_n                                (mem_dka_n),
         .mem_dkb                                  (mem_dkb),
         .mem_dkb_n                                (mem_dkb_n),
         
         .mem_qka                                  (mem_qka),
         .mem_qka_n                                (mem_qka_n),
         .mem_qkb                                  (mem_qkb),
         .mem_qkb_n                                (mem_qkb_n),
         
         .mem_dqa                                  (mem_dqa),
         .mem_dqb                                  (mem_dqb),
         
         .mem_dinva                                (mem_dinva),
         .mem_dinvb                                (mem_dinvb),
         
         .mem_lda_n                                (mem_lda_n),
         .mem_ldb_n                                (mem_ldb_n),
         .mem_rwa_n                                (mem_rwa_n),
         .mem_rwb_n                                (mem_rwb_n),
         .mem_cfg_n                                (mem_cfg_n),
         .mem_reset_n                              (mem_reset_n),
         .mem_lbk0_n                               (mem_lbk0_n),
         .mem_lbk1_n                               (mem_lbk1_n)
      );
         
   end
   
   endgenerate

endmodule
