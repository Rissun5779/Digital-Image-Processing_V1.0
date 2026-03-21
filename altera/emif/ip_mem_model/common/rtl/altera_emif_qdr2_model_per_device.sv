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
module altera_emif_qdr2_model_per_device # (
   parameter MEM_TRL_CYC                             = "",
   parameter MEM_TWL_CYC                             = 0,
   parameter MEM_BL                                  = 0,
   parameter MEM_GUARANTEED_WRITE_INIT               = 0,
   parameter MEM_SUPPRESS_CMD_TIMING_ERROR           = 0,
   parameter MEM_VERBOSE                             = 1,
   parameter MEM_WIDTH_IDX                           = 0,
   
   // Definition of port widths for "mem" interface
   parameter PORT_MEM_CK_WIDTH                       = 1,
   parameter PORT_MEM_CK_N_WIDTH                     = 1,
   parameter PORT_MEM_DK_WIDTH                       = 1,
   parameter PORT_MEM_DK_N_WIDTH                     = 1,
   parameter PORT_MEM_DKA_WIDTH                      = 1,
   parameter PORT_MEM_DKA_N_WIDTH                    = 1,
   parameter PORT_MEM_DKB_WIDTH                      = 1,
   parameter PORT_MEM_DKB_N_WIDTH                    = 1,
   parameter PORT_MEM_K_WIDTH                        = 1,
   parameter PORT_MEM_K_N_WIDTH                      = 1,
   parameter PORT_MEM_A_WIDTH                        = 1,
   parameter PORT_MEM_BA_WIDTH                       = 1,
   parameter PORT_MEM_BG_WIDTH                       = 1,
   parameter PORT_MEM_C_WIDTH                        = 1,
   parameter PORT_MEM_CKE_WIDTH                      = 1,
   parameter PORT_MEM_CS_N_WIDTH                     = 1,
   parameter PORT_MEM_RM_WIDTH                       = 1,
   parameter PORT_MEM_ODT_WIDTH                      = 1,
   parameter PORT_MEM_RAS_N_WIDTH                    = 1,
   parameter PORT_MEM_CAS_N_WIDTH                    = 1,
   parameter PORT_MEM_WE_N_WIDTH                     = 1,
   parameter PORT_MEM_RESET_N_WIDTH                  = 1,
   parameter PORT_MEM_ACT_N_WIDTH                    = 1,
   parameter PORT_MEM_PAR_WIDTH                      = 1,
   parameter PORT_MEM_CA_WIDTH                       = 1,
   parameter PORT_MEM_REF_N_WIDTH                    = 1,
   parameter PORT_MEM_WPS_N_WIDTH                    = 1,
   parameter PORT_MEM_RPS_N_WIDTH                    = 1,
   parameter PORT_MEM_DOFF_N_WIDTH                   = 1,
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
   parameter PORT_MEM_DM_WIDTH                       = 1,
   parameter PORT_MEM_BWS_N_WIDTH                    = 1,
   parameter PORT_MEM_D_WIDTH                        = 1,
   parameter PORT_MEM_DQ_WIDTH                       = 1,
   parameter PORT_MEM_DBI_N_WIDTH                    = 1,
   parameter PORT_MEM_DQA_WIDTH                      = 1,
   parameter PORT_MEM_DQB_WIDTH                      = 1,
   parameter PORT_MEM_DINVA_WIDTH                    = 1,
   parameter PORT_MEM_DINVB_WIDTH                    = 1,
   parameter PORT_MEM_Q_WIDTH                        = 1,
   parameter PORT_MEM_ALERT_N_WIDTH                  = 1,
   parameter PORT_MEM_DQS_WIDTH                      = 1,
   parameter PORT_MEM_DQS_N_WIDTH                    = 1,
   parameter PORT_MEM_QK_WIDTH                       = 1,
   parameter PORT_MEM_QK_N_WIDTH                     = 1,
   parameter PORT_MEM_QKA_WIDTH                      = 1,
   parameter PORT_MEM_QKA_N_WIDTH                    = 1,
   parameter PORT_MEM_QKB_WIDTH                      = 1,
   parameter PORT_MEM_QKB_N_WIDTH                    = 1,
   parameter PORT_MEM_CQ_WIDTH                       = 1,
   parameter PORT_MEM_CQ_N_WIDTH                     = 1
) (
   // Ports for "mem" interface
   input  logic [PORT_MEM_CK_WIDTH-1:0]                       mem_ck,
   input  logic [PORT_MEM_CK_N_WIDTH-1:0]                     mem_ck_n,   
   input  logic [PORT_MEM_DK_WIDTH-1:0]                       mem_dk,   
   input  logic [PORT_MEM_DK_N_WIDTH-1:0]                     mem_dk_n,   
   input  logic [PORT_MEM_DKA_WIDTH-1:0]                      mem_dka,   
   input  logic [PORT_MEM_DKA_N_WIDTH-1:0]                    mem_dka_n,   
   input  logic [PORT_MEM_DKB_WIDTH-1:0]                      mem_dkb,   
   input  logic [PORT_MEM_DKB_N_WIDTH-1:0]                    mem_dkb_n,   
   input  logic [PORT_MEM_K_WIDTH-1:0]                        mem_k,   
   input  logic [PORT_MEM_K_N_WIDTH-1:0]                      mem_k_n,   
   input  logic [PORT_MEM_A_WIDTH-1:0]                        mem_a,   
   input  logic [PORT_MEM_BA_WIDTH-1:0]                       mem_ba,   
   input  logic [PORT_MEM_BG_WIDTH-1:0]                       mem_bg,   
   input  logic [PORT_MEM_C_WIDTH-1:0]                        mem_c,   
   input  logic [PORT_MEM_CKE_WIDTH-1:0]                      mem_cke,   
   input  logic [PORT_MEM_CS_N_WIDTH-1:0]                     mem_cs_n,   
   input  logic [PORT_MEM_RM_WIDTH-1:0]                       mem_rm,
   input  logic [PORT_MEM_ODT_WIDTH-1:0]                      mem_odt,   
   input  logic [PORT_MEM_RAS_N_WIDTH-1:0]                    mem_ras_n,   
   input  logic [PORT_MEM_CAS_N_WIDTH-1:0]                    mem_cas_n,   
   input  logic [PORT_MEM_WE_N_WIDTH-1:0]                     mem_we_n,   
   input  logic [PORT_MEM_RESET_N_WIDTH-1:0]                  mem_reset_n,
   input  logic [PORT_MEM_ACT_N_WIDTH-1:0]                    mem_act_n,   
   input  logic [PORT_MEM_PAR_WIDTH-1:0]                      mem_par,   
   input  logic [PORT_MEM_CA_WIDTH-1:0]                       mem_ca,   
   input  logic [PORT_MEM_REF_N_WIDTH-1:0]                    mem_ref_n,   
   input  logic [PORT_MEM_WPS_N_WIDTH-1:0]                    mem_wps_n,   
   input  logic [PORT_MEM_RPS_N_WIDTH-1:0]                    mem_rps_n,   
   input  logic [PORT_MEM_DOFF_N_WIDTH-1:0]                   mem_doff_n,   
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
   input  logic [PORT_MEM_DM_WIDTH-1:0]                       mem_dm,   
   input  logic [PORT_MEM_BWS_N_WIDTH-1:0]                    mem_bws_n,   
   input  logic [PORT_MEM_D_WIDTH-1:0]                        mem_d,   
   inout  tri   [PORT_MEM_DQ_WIDTH-1:0]                       mem_dq,   
   inout  tri   [PORT_MEM_DBI_N_WIDTH-1:0]                    mem_dbi_n,   
   inout  tri   [PORT_MEM_DQA_WIDTH-1:0]                      mem_dqa,   
   inout  tri   [PORT_MEM_DQB_WIDTH-1:0]                      mem_dqb,   
   inout  tri   [PORT_MEM_DINVA_WIDTH-1:0]                    mem_dinva,   
   inout  tri   [PORT_MEM_DINVB_WIDTH-1:0]                    mem_dinvb,   
   output logic [PORT_MEM_Q_WIDTH-1:0]                        mem_q,   
   output logic [PORT_MEM_ALERT_N_WIDTH-1:0]                  mem_alert_n,
   inout  tri   [PORT_MEM_DQS_WIDTH-1:0]                      mem_dqs,   
   inout  tri   [PORT_MEM_DQS_N_WIDTH-1:0]                    mem_dqs_n,   
   output logic [PORT_MEM_QK_WIDTH-1:0]                       mem_qk,   
   output logic [PORT_MEM_QK_N_WIDTH-1:0]                     mem_qk_n,   
   output logic [PORT_MEM_QKA_WIDTH-1:0]                      mem_qka,   
   output logic [PORT_MEM_QKA_N_WIDTH-1:0]                    mem_qka_n,   
   output logic [PORT_MEM_QKB_WIDTH-1:0]                      mem_qkb,   
   output logic [PORT_MEM_QKB_N_WIDTH-1:0]                    mem_qkb_n,   
   output logic [PORT_MEM_CQ_WIDTH-1:0]                       mem_cq,   
   output logic [PORT_MEM_CQ_N_WIDTH-1:0]                     mem_cq_n
);
   timeunit 1ps;
   timeprecision 1ps;

// ******************************************************************************************************************************** 
// BEGIN PARAMETER SECTION
// All parameters default to "" will have their values passed in from the toplevel testbench 

   localparam MEM_CS_WIDTH = 1; 

// Memory device specific parameters, they are set according to the memory spec.

   generate
   genvar rank;
   for (rank = 0; rank < MEM_CS_WIDTH; rank = rank + 1)
   begin : rank_gen
      altera_emif_qdr2_model_rank # (

         .PORT_MEM_A_WIDTH                            (PORT_MEM_A_WIDTH),
         .PORT_MEM_BWS_N_WIDTH                        (PORT_MEM_BWS_N_WIDTH),
         .PORT_MEM_K_WIDTH                            (PORT_MEM_K_WIDTH),
         .PORT_MEM_CQ_WIDTH                           (PORT_MEM_CQ_WIDTH),
         .PORT_MEM_D_WIDTH                            (PORT_MEM_D_WIDTH),
         .PORT_MEM_Q_WIDTH                            (PORT_MEM_Q_WIDTH),

         .MEM_TRL_CYC                                 (MEM_TRL_CYC),
         .MEM_TWL_CYC                                 (MEM_TWL_CYC),
         .MEM_BL                                      (MEM_BL),
         .MEM_GUARANTEED_WRITE_INIT                   (MEM_GUARANTEED_WRITE_INIT),
         .MEM_SUPPRESS_CMD_TIMING_ERROR               (MEM_SUPPRESS_CMD_TIMING_ERROR),
         .MEM_VERBOSE                                 (MEM_VERBOSE),
         .MEM_WIDTH_IDX                               (MEM_WIDTH_IDX),
         .MEM_DEPTH_IDX                               (rank)

      ) rank_inst (

         .mem_a                                    (mem_a),
         .mem_bws_n                                (mem_bws_n),
         .mem_rps_n                                (mem_rps_n),
         .mem_wps_n                                (mem_wps_n),
         .mem_doff_n                               (mem_doff_n),
         .mem_k                                    (mem_k),
         .mem_k_n                                  (mem_k_n),
         .mem_cq                                   (mem_cq),
         .mem_cq_n                                 (mem_cq_n),
         .mem_d                                    (mem_d),
         .mem_q                                    (mem_q)
         
      );
   end
   
   endgenerate

endmodule
