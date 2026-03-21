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
// Top-level wrapper of board delay model
///////////////////////////////////////////////////////////////////////////////
module altera_emif_board_delay_model # (
   parameter PROTOCOL_ENUM                           = "PROTOCOL_DDR3",
   parameter MEM_FORMAT_ENUM                         = "MEM_FORMAT_DISCRETE",
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
   // Ports for "mem" interface from FPGA
   input  logic [PORT_MEM_CK_WIDTH-1:0]                       mem_ck_0,
   input  logic [PORT_MEM_CK_N_WIDTH-1:0]                     mem_ck_n_0,   
   input  logic [PORT_MEM_DK_WIDTH-1:0]                       mem_dk_0,   
   input  logic [PORT_MEM_DK_N_WIDTH-1:0]                     mem_dk_n_0,   
   input  logic [PORT_MEM_DKA_WIDTH-1:0]                      mem_dka_0,   
   input  logic [PORT_MEM_DKA_N_WIDTH-1:0]                    mem_dka_n_0,   
   input  logic [PORT_MEM_DKB_WIDTH-1:0]                      mem_dkb_0,   
   input  logic [PORT_MEM_DKB_N_WIDTH-1:0]                    mem_dkb_n_0,   
   input  logic [PORT_MEM_K_WIDTH-1:0]                        mem_k_0,   
   input  logic [PORT_MEM_K_N_WIDTH-1:0]                      mem_k_n_0,   
   input  logic [PORT_MEM_A_WIDTH-1:0]                        mem_a_0,   
   input  logic [PORT_MEM_BA_WIDTH-1:0]                       mem_ba_0,   
   input  logic [PORT_MEM_BG_WIDTH-1:0]                       mem_bg_0,   
   input  logic [PORT_MEM_C_WIDTH-1:0]                        mem_c_0,   
   input  logic [PORT_MEM_CKE_WIDTH-1:0]                      mem_cke_0,   
   input  logic [PORT_MEM_CS_N_WIDTH-1:0]                     mem_cs_n_0,   
   input  logic [PORT_MEM_RM_WIDTH-1:0]                       mem_rm_0,
   input  logic [PORT_MEM_ODT_WIDTH-1:0]                      mem_odt_0,   
   input  logic [PORT_MEM_RAS_N_WIDTH-1:0]                    mem_ras_n_0,   
   input  logic [PORT_MEM_CAS_N_WIDTH-1:0]                    mem_cas_n_0,   
   input  logic [PORT_MEM_WE_N_WIDTH-1:0]                     mem_we_n_0,   
   input  logic [PORT_MEM_RESET_N_WIDTH-1:0]                  mem_reset_n_0,
   input  logic [PORT_MEM_ACT_N_WIDTH-1:0]                    mem_act_n_0,   
   input  logic [PORT_MEM_PAR_WIDTH-1:0]                      mem_par_0,   
   input  logic [PORT_MEM_CA_WIDTH-1:0]                       mem_ca_0,   
   input  logic [PORT_MEM_REF_N_WIDTH-1:0]                    mem_ref_n_0,   
   input  logic [PORT_MEM_WPS_N_WIDTH-1:0]                    mem_wps_n_0,   
   input  logic [PORT_MEM_RPS_N_WIDTH-1:0]                    mem_rps_n_0,   
   input  logic [PORT_MEM_DOFF_N_WIDTH-1:0]                   mem_doff_n_0,   
   input  logic [PORT_MEM_LDA_N_WIDTH-1:0]                    mem_lda_n_0,   
   input  logic [PORT_MEM_LDB_N_WIDTH-1:0]                    mem_ldb_n_0,   
   input  logic [PORT_MEM_RWA_N_WIDTH-1:0]                    mem_rwa_n_0,   
   input  logic [PORT_MEM_RWB_N_WIDTH-1:0]                    mem_rwb_n_0,   
   input  logic [PORT_MEM_LBK0_N_WIDTH-1:0]                   mem_lbk0_n_0,   
   input  logic [PORT_MEM_LBK1_N_WIDTH-1:0]                   mem_lbk1_n_0,   
   input  logic [PORT_MEM_CFG_N_WIDTH-1:0]                    mem_cfg_n_0,   
   input  logic [PORT_MEM_AP_WIDTH-1:0]                       mem_ap_0,   
   output logic [PORT_MEM_PE_N_WIDTH-1:0]                     mem_pe_n_0,   
   input  logic [PORT_MEM_AINV_WIDTH-1:0]                     mem_ainv_0,   
   input  logic [PORT_MEM_DM_WIDTH-1:0]                       mem_dm_0,   
   input  logic [PORT_MEM_BWS_N_WIDTH-1:0]                    mem_bws_n_0,   
   input  logic [PORT_MEM_D_WIDTH-1:0]                        mem_d_0,   
   inout  tri   [PORT_MEM_DQ_WIDTH-1:0]                       mem_dq_0,   
   inout  tri   [PORT_MEM_DBI_N_WIDTH-1:0]                    mem_dbi_n_0,   
   inout  tri   [PORT_MEM_DQA_WIDTH-1:0]                      mem_dqa_0,   
   inout  tri   [PORT_MEM_DQB_WIDTH-1:0]                      mem_dqb_0,   
   inout  tri   [PORT_MEM_DINVA_WIDTH-1:0]                    mem_dinva_0,   
   inout  tri   [PORT_MEM_DINVB_WIDTH-1:0]                    mem_dinvb_0,   
   output logic [PORT_MEM_Q_WIDTH-1:0]                        mem_q_0,   
   output logic [PORT_MEM_ALERT_N_WIDTH-1:0]                  mem_alert_n_0,
   inout  tri   [PORT_MEM_DQS_WIDTH-1:0]                      mem_dqs_0,   
   inout  tri   [PORT_MEM_DQS_N_WIDTH-1:0]                    mem_dqs_n_0,   
   output logic [PORT_MEM_QK_WIDTH-1:0]                       mem_qk_0,   
   output logic [PORT_MEM_QK_N_WIDTH-1:0]                     mem_qk_n_0,   
   output logic [PORT_MEM_QKA_WIDTH-1:0]                      mem_qka_0,   
   output logic [PORT_MEM_QKA_N_WIDTH-1:0]                    mem_qka_n_0,   
   output logic [PORT_MEM_QKB_WIDTH-1:0]                      mem_qkb_0,   
   output logic [PORT_MEM_QKB_N_WIDTH-1:0]                    mem_qkb_n_0,   
   output logic [PORT_MEM_CQ_WIDTH-1:0]                       mem_cq_0,   
   output logic [PORT_MEM_CQ_N_WIDTH-1:0]                     mem_cq_n_0,

   // Ports for "mem" interface on memory device
   output  logic [PORT_MEM_CK_WIDTH-1:0]                       mem_ck_1,
   output  logic [PORT_MEM_CK_N_WIDTH-1:0]                     mem_ck_n_1,   
   output  logic [PORT_MEM_DK_WIDTH-1:0]                       mem_dk_1,   
   output  logic [PORT_MEM_DK_N_WIDTH-1:0]                     mem_dk_n_1,   
   output  logic [PORT_MEM_DKA_WIDTH-1:0]                      mem_dka_1,   
   output  logic [PORT_MEM_DKA_N_WIDTH-1:0]                    mem_dka_n_1,   
   output  logic [PORT_MEM_DKB_WIDTH-1:0]                      mem_dkb_1,   
   output  logic [PORT_MEM_DKB_N_WIDTH-1:0]                    mem_dkb_n_1,   
   output  logic [PORT_MEM_K_WIDTH-1:0]                        mem_k_1,   
   output  logic [PORT_MEM_K_N_WIDTH-1:0]                      mem_k_n_1,   
   output  logic [PORT_MEM_A_WIDTH-1:0]                        mem_a_1,   
   output  logic [PORT_MEM_BA_WIDTH-1:0]                       mem_ba_1,   
   output  logic [PORT_MEM_BG_WIDTH-1:0]                       mem_bg_1,   
   output  logic [PORT_MEM_C_WIDTH-1:0]                        mem_c_1,   
   output  logic [PORT_MEM_CKE_WIDTH-1:0]                      mem_cke_1,   
   output  logic [PORT_MEM_CS_N_WIDTH-1:0]                     mem_cs_n_1,   
   output  logic [PORT_MEM_RM_WIDTH-1:0]                       mem_rm_1,
   output  logic [PORT_MEM_ODT_WIDTH-1:0]                      mem_odt_1,   
   output  logic [PORT_MEM_RAS_N_WIDTH-1:0]                    mem_ras_n_1,   
   output  logic [PORT_MEM_CAS_N_WIDTH-1:0]                    mem_cas_n_1,   
   output  logic [PORT_MEM_WE_N_WIDTH-1:0]                     mem_we_n_1,   
   output  logic [PORT_MEM_RESET_N_WIDTH-1:0]                  mem_reset_n_1,
   output  logic [PORT_MEM_ACT_N_WIDTH-1:0]                    mem_act_n_1,   
   output  logic [PORT_MEM_PAR_WIDTH-1:0]                      mem_par_1,   
   output  logic [PORT_MEM_CA_WIDTH-1:0]                       mem_ca_1,   
   output  logic [PORT_MEM_REF_N_WIDTH-1:0]                    mem_ref_n_1,   
   output  logic [PORT_MEM_WPS_N_WIDTH-1:0]                    mem_wps_n_1,   
   output  logic [PORT_MEM_RPS_N_WIDTH-1:0]                    mem_rps_n_1,   
   output  logic [PORT_MEM_DOFF_N_WIDTH-1:0]                   mem_doff_n_1,   
   output  logic [PORT_MEM_LDA_N_WIDTH-1:0]                    mem_lda_n_1,   
   output  logic [PORT_MEM_LDB_N_WIDTH-1:0]                    mem_ldb_n_1,   
   output  logic [PORT_MEM_RWA_N_WIDTH-1:0]                    mem_rwa_n_1,   
   output  logic [PORT_MEM_RWB_N_WIDTH-1:0]                    mem_rwb_n_1,   
   output  logic [PORT_MEM_LBK0_N_WIDTH-1:0]                   mem_lbk0_n_1,   
   output  logic [PORT_MEM_LBK1_N_WIDTH-1:0]                   mem_lbk1_n_1,   
   output  logic [PORT_MEM_CFG_N_WIDTH-1:0]                    mem_cfg_n_1,   
   output  logic [PORT_MEM_AP_WIDTH-1:0]                       mem_ap_1,   
   input logic [PORT_MEM_PE_N_WIDTH-1:0]                     mem_pe_n_1,   
   output  logic [PORT_MEM_AINV_WIDTH-1:0]                     mem_ainv_1,   
   output  logic [PORT_MEM_DM_WIDTH-1:0]                       mem_dm_1,   
   output  logic [PORT_MEM_BWS_N_WIDTH-1:0]                    mem_bws_n_1,   
   output  logic [PORT_MEM_D_WIDTH-1:0]                        mem_d_1,   
   inout  tri   [PORT_MEM_DQ_WIDTH-1:0]                       mem_dq_1,   
   inout  tri   [PORT_MEM_DBI_N_WIDTH-1:0]                    mem_dbi_n_1,   
   inout  tri   [PORT_MEM_DQA_WIDTH-1:0]                      mem_dqa_1,   
   inout  tri   [PORT_MEM_DQB_WIDTH-1:0]                      mem_dqb_1,   
   inout  tri   [PORT_MEM_DINVA_WIDTH-1:0]                    mem_dinva_1,   
   inout  tri   [PORT_MEM_DINVB_WIDTH-1:0]                    mem_dinvb_1,   
   input logic [PORT_MEM_Q_WIDTH-1:0]                        mem_q_1,   
   input logic [PORT_MEM_ALERT_N_WIDTH-1:0]                  mem_alert_n_1,
   inout  tri   [PORT_MEM_DQS_WIDTH-1:0]                      mem_dqs_1,   
   inout  tri   [PORT_MEM_DQS_N_WIDTH-1:0]                    mem_dqs_n_1,   
   input logic [PORT_MEM_QK_WIDTH-1:0]                       mem_qk_1,   
   input logic [PORT_MEM_QK_N_WIDTH-1:0]                     mem_qk_n_1,   
   input logic [PORT_MEM_QKA_WIDTH-1:0]                      mem_qka_1,   
   input logic [PORT_MEM_QKA_N_WIDTH-1:0]                    mem_qka_n_1,   
   input logic [PORT_MEM_QKB_WIDTH-1:0]                      mem_qkb_1,   
   input logic [PORT_MEM_QKB_N_WIDTH-1:0]                    mem_qkb_n_1,   
   input logic [PORT_MEM_CQ_WIDTH-1:0]                       mem_cq_1,   
   input logic [PORT_MEM_CQ_N_WIDTH-1:0]                     mem_cq_n_1
);
   timeunit 1ps;
   timeprecision 1ps;
  
   parameter CFG_FILE = "board_delay_config.hex";
   parameter CFG_FILE_POSTCAL = "board_delay_config_postcal.hex";
   parameter MEM_IF_BOARD_BASE_DELAY = 0;

   integer base_delay[1] = {MEM_IF_BOARD_BASE_DELAY};
   integer rank_delay[1] = {0};

   integer mem_ck_dly        [PORT_MEM_CK_WIDTH];      
   integer mem_ck_n_dly      [PORT_MEM_CK_N_WIDTH];    
   integer mem_dk_dly        [PORT_MEM_DK_WIDTH];      
   integer mem_dk_n_dly      [PORT_MEM_DK_N_WIDTH];    
   integer mem_dka_dly       [PORT_MEM_DKA_WIDTH];     
   integer mem_dka_n_dly     [PORT_MEM_DKA_N_WIDTH];   
   integer mem_dkb_dly       [PORT_MEM_DKB_WIDTH];     
   integer mem_dkb_n_dly     [PORT_MEM_DKB_N_WIDTH];   
   integer mem_k_dly         [PORT_MEM_K_WIDTH];       
   integer mem_k_n_dly       [PORT_MEM_K_N_WIDTH];     
   integer mem_a_dly         [PORT_MEM_A_WIDTH];       
   integer mem_ba_dly        [PORT_MEM_BA_WIDTH];      
   integer mem_bg_dly        [PORT_MEM_BG_WIDTH];      
   integer mem_c_dly         [PORT_MEM_C_WIDTH];       
   integer mem_cke_dly       [PORT_MEM_CKE_WIDTH];     
   integer mem_cs_n_dly      [PORT_MEM_CS_N_WIDTH];    
   integer mem_rm_dly        [PORT_MEM_RM_WIDTH];      
   integer mem_odt_dly       [PORT_MEM_ODT_WIDTH];     
   integer mem_ras_n_dly     [PORT_MEM_RAS_N_WIDTH];   
   integer mem_cas_n_dly     [PORT_MEM_CAS_N_WIDTH];   
   integer mem_we_n_dly      [PORT_MEM_WE_N_WIDTH];    
   integer mem_reset_n_dly   [PORT_MEM_RESET_N_WIDTH]; 
   integer mem_act_n_dly     [PORT_MEM_ACT_N_WIDTH];   
   integer mem_par_dly       [PORT_MEM_PAR_WIDTH];     
   integer mem_ca_dly        [PORT_MEM_CA_WIDTH];      
   integer mem_ref_n_dly     [PORT_MEM_REF_N_WIDTH];   
   integer mem_wps_n_dly     [PORT_MEM_WPS_N_WIDTH];   
   integer mem_rps_n_dly     [PORT_MEM_RPS_N_WIDTH];   
   integer mem_doff_n_dly    [PORT_MEM_DOFF_N_WIDTH];  
   integer mem_lda_n_dly     [PORT_MEM_LDA_N_WIDTH];   
   integer mem_ldb_n_dly     [PORT_MEM_LDB_N_WIDTH];   
   integer mem_rwa_n_dly     [PORT_MEM_RWA_N_WIDTH];   
   integer mem_rwb_n_dly     [PORT_MEM_RWB_N_WIDTH];   
   integer mem_lbk0_n_dly    [PORT_MEM_LBK0_N_WIDTH];  
   integer mem_lbk1_n_dly    [PORT_MEM_LBK1_N_WIDTH];  
   integer mem_cfg_n_dly     [PORT_MEM_CFG_N_WIDTH];   
   integer mem_ap_dly        [PORT_MEM_AP_WIDTH];      
   integer mem_pe_n_dly      [PORT_MEM_PE_N_WIDTH];    
   integer mem_ainv_dly      [PORT_MEM_AINV_WIDTH];    
   integer mem_dm_dly        [PORT_MEM_DM_WIDTH];      
   integer mem_bws_n_dly     [PORT_MEM_BWS_N_WIDTH];   
   integer mem_d_dly         [PORT_MEM_D_WIDTH];       
   integer mem_dq_dly        [PORT_MEM_DQ_WIDTH];      
   integer mem_dbi_n_dly     [PORT_MEM_DBI_N_WIDTH];   
   integer mem_dqa_dly       [PORT_MEM_DQA_WIDTH];     
   integer mem_dqb_dly       [PORT_MEM_DQB_WIDTH];     
   integer mem_dinva_dly     [PORT_MEM_DINVA_WIDTH];   
   integer mem_dinvb_dly     [PORT_MEM_DINVB_WIDTH];   
   integer mem_q_dly         [PORT_MEM_Q_WIDTH];       
   integer mem_alert_n_dly   [PORT_MEM_ALERT_N_WIDTH]; 
   integer mem_dqs_dly       [PORT_MEM_DQS_WIDTH];     
   integer mem_dqs_n_dly     [PORT_MEM_DQS_N_WIDTH];   
   integer mem_qk_dly        [PORT_MEM_QK_WIDTH];      
   integer mem_qk_n_dly      [PORT_MEM_QK_N_WIDTH];    
   integer mem_qka_dly       [PORT_MEM_QKA_WIDTH];     
   integer mem_qka_n_dly     [PORT_MEM_QKA_N_WIDTH];   
   integer mem_qkb_dly       [PORT_MEM_QKB_WIDTH];     
   integer mem_qkb_n_dly     [PORT_MEM_QKB_N_WIDTH];   
   integer mem_cq_dly        [PORT_MEM_CQ_WIDTH];      
   integer mem_cq_n_dly      [PORT_MEM_CQ_N_WIDTH];    

   integer mem_ck_bad        [PORT_MEM_CK_WIDTH];      
   integer mem_ck_n_bad      [PORT_MEM_CK_N_WIDTH];    
   integer mem_dk_bad        [PORT_MEM_DK_WIDTH];      
   integer mem_dk_n_bad      [PORT_MEM_DK_N_WIDTH];    
   integer mem_dka_bad       [PORT_MEM_DKA_WIDTH];     
   integer mem_dka_n_bad     [PORT_MEM_DKA_N_WIDTH];   
   integer mem_dkb_bad       [PORT_MEM_DKB_WIDTH];     
   integer mem_dkb_n_bad     [PORT_MEM_DKB_N_WIDTH];   
   integer mem_k_bad         [PORT_MEM_K_WIDTH];       
   integer mem_k_n_bad       [PORT_MEM_K_N_WIDTH];     
   integer mem_a_bad         [PORT_MEM_A_WIDTH];       
   integer mem_ba_bad        [PORT_MEM_BA_WIDTH];      
   integer mem_bg_bad        [PORT_MEM_BG_WIDTH];      
   integer mem_c_bad         [PORT_MEM_C_WIDTH];       
   integer mem_cke_bad       [PORT_MEM_CKE_WIDTH];     
   integer mem_cs_n_bad      [PORT_MEM_CS_N_WIDTH];    
   integer mem_rm_bad        [PORT_MEM_RM_WIDTH];      
   integer mem_odt_bad       [PORT_MEM_ODT_WIDTH];     
   integer mem_ras_n_bad     [PORT_MEM_RAS_N_WIDTH];   
   integer mem_cas_n_bad     [PORT_MEM_CAS_N_WIDTH];   
   integer mem_we_n_bad      [PORT_MEM_WE_N_WIDTH];    
   integer mem_reset_n_bad   [PORT_MEM_RESET_N_WIDTH]; 
   integer mem_act_n_bad     [PORT_MEM_ACT_N_WIDTH];   
   integer mem_par_bad       [PORT_MEM_PAR_WIDTH];     
   integer mem_ca_bad        [PORT_MEM_CA_WIDTH];      
   integer mem_ref_n_bad     [PORT_MEM_REF_N_WIDTH];   
   integer mem_wps_n_bad     [PORT_MEM_WPS_N_WIDTH];   
   integer mem_rps_n_bad     [PORT_MEM_RPS_N_WIDTH];   
   integer mem_doff_n_bad    [PORT_MEM_DOFF_N_WIDTH];  
   integer mem_lda_n_bad     [PORT_MEM_LDA_N_WIDTH];   
   integer mem_ldb_n_bad     [PORT_MEM_LDB_N_WIDTH];   
   integer mem_rwa_n_bad     [PORT_MEM_RWA_N_WIDTH];   
   integer mem_rwb_n_bad     [PORT_MEM_RWB_N_WIDTH];   
   integer mem_lbk0_n_bad    [PORT_MEM_LBK0_N_WIDTH];  
   integer mem_lbk1_n_bad    [PORT_MEM_LBK1_N_WIDTH];  
   integer mem_cfg_n_bad     [PORT_MEM_CFG_N_WIDTH];   
   integer mem_ap_bad        [PORT_MEM_AP_WIDTH];      
   integer mem_pe_n_bad      [PORT_MEM_PE_N_WIDTH];    
   integer mem_ainv_bad      [PORT_MEM_AINV_WIDTH];    
   integer mem_dm_bad        [PORT_MEM_DM_WIDTH];      
   integer mem_bws_n_bad     [PORT_MEM_BWS_N_WIDTH];   
   integer mem_d_bad         [PORT_MEM_D_WIDTH];       
   integer mem_dq_bad        [PORT_MEM_DQ_WIDTH];      
   integer mem_dbi_n_bad     [PORT_MEM_DBI_N_WIDTH];   
   integer mem_dqa_bad       [PORT_MEM_DQA_WIDTH];     
   integer mem_dqb_bad       [PORT_MEM_DQB_WIDTH];     
   integer mem_dinva_bad     [PORT_MEM_DINVA_WIDTH];   
   integer mem_dinvb_bad     [PORT_MEM_DINVB_WIDTH];   
   integer mem_q_bad         [PORT_MEM_Q_WIDTH];       
   integer mem_alert_n_bad   [PORT_MEM_ALERT_N_WIDTH]; 
   integer mem_dqs_bad       [PORT_MEM_DQS_WIDTH];     
   integer mem_dqs_n_bad     [PORT_MEM_DQS_N_WIDTH];   
   integer mem_qk_bad        [PORT_MEM_QK_WIDTH];      
   integer mem_qk_n_bad      [PORT_MEM_QK_N_WIDTH];    
   integer mem_qka_bad       [PORT_MEM_QKA_WIDTH];     
   integer mem_qka_n_bad     [PORT_MEM_QKA_N_WIDTH];   
   integer mem_qkb_bad       [PORT_MEM_QKB_WIDTH];     
   integer mem_qkb_n_bad     [PORT_MEM_QKB_N_WIDTH];   
   integer mem_cq_bad        [PORT_MEM_CQ_WIDTH];      
   integer mem_cq_n_bad      [PORT_MEM_CQ_N_WIDTH]; 

   integer mem_dq_bad_z        [PORT_MEM_DQ_WIDTH];      
   integer mem_dbi_n_bad_z     [PORT_MEM_DBI_N_WIDTH];   
   integer mem_dqa_bad_z       [PORT_MEM_DQA_WIDTH];     
   integer mem_dqb_bad_z       [PORT_MEM_DQB_WIDTH];     
   integer mem_dinva_bad_z     [PORT_MEM_DINVA_WIDTH];   
   integer mem_dinvb_bad_z     [PORT_MEM_DINVB_WIDTH];   
   integer mem_dqs_bad_z       [PORT_MEM_DQS_WIDTH];     
   integer mem_dqs_n_bad_z     [PORT_MEM_DQS_N_WIDTH];  

   altera_board_delay_util delay_util();

   task load_config;
      input string filename;
      input bit suppress_warning;
   begin
      integer idx;
      integer fp;

      fp = $fopen(filename, "r");
      if (fp == 0)
      begin
         if (!suppress_warning)
            $display("Warning: cannot open %0s for configuring memory delays/windows", filename);
            return;
         end
         $fclose(fp);

         $display("Loading %0s for configuring memory delays/windows", filename);

         delay_util.read_config(.file(filename), .name("base_delay"),    .delays(base_delay));
         delay_util.read_config(.file(filename), .name("rank_delay"),    .delays(rank_delay));

         delay_util.read_config(.file(filename), .name("mem_ck_dly"),        .delays(mem_ck_dly     ));
         delay_util.read_config(.file(filename), .name("mem_ck_n_dly"),      .delays(mem_ck_n_dly   ));
         delay_util.read_config(.file(filename), .name("mem_dk_dly"),        .delays(mem_dk_dly     ));
         delay_util.read_config(.file(filename), .name("mem_dk_n_dly"),      .delays(mem_dk_n_dly   ));
         delay_util.read_config(.file(filename), .name("mem_dka_dly"),       .delays(mem_dka_dly    ));
         delay_util.read_config(.file(filename), .name("mem_dka_n_dly"),     .delays(mem_dka_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_dkb_dly"),       .delays(mem_dkb_dly    ));
         delay_util.read_config(.file(filename), .name("mem_dkb_n_dly"),     .delays(mem_dkb_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_k_dly"),         .delays(mem_k_dly      ));
         delay_util.read_config(.file(filename), .name("mem_k_n_dly"),       .delays(mem_k_n_dly    ));
         delay_util.read_config(.file(filename), .name("mem_a_dly"),         .delays(mem_a_dly      ));
         delay_util.read_config(.file(filename), .name("mem_ba_dly"),        .delays(mem_ba_dly     ));
         delay_util.read_config(.file(filename), .name("mem_bg_dly"),        .delays(mem_bg_dly     ));
         delay_util.read_config(.file(filename), .name("mem_c_dly"),         .delays(mem_c_dly      ));
         delay_util.read_config(.file(filename), .name("mem_cke_dly"),       .delays(mem_cke_dly    ));
         delay_util.read_config(.file(filename), .name("mem_cs_n_dly"),      .delays(mem_cs_n_dly   ));
         delay_util.read_config(.file(filename), .name("mem_rm_dly"),        .delays(mem_rm_dly     ));
         delay_util.read_config(.file(filename), .name("mem_odt_dly"),       .delays(mem_odt_dly    ));
         delay_util.read_config(.file(filename), .name("mem_ras_n_dly"),     .delays(mem_ras_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_cas_n_dly"),     .delays(mem_cas_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_we_n_dly"),      .delays(mem_we_n_dly   ));
         delay_util.read_config(.file(filename), .name("mem_reset_n_dly"),   .delays(mem_reset_n_dly));
         delay_util.read_config(.file(filename), .name("mem_act_n_dly"),     .delays(mem_act_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_par_dly"),       .delays(mem_par_dly    ));
         delay_util.read_config(.file(filename), .name("mem_ca_dly"),        .delays(mem_ca_dly     ));
         delay_util.read_config(.file(filename), .name("mem_ref_n_dly"),     .delays(mem_ref_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_wps_n_dly"),     .delays(mem_wps_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_rps_n_dly"),     .delays(mem_rps_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_doff_n_dly"),    .delays(mem_doff_n_dly ));
         delay_util.read_config(.file(filename), .name("mem_lda_n_dly"),     .delays(mem_lda_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_ldb_n_dly"),     .delays(mem_ldb_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_rwa_n_dly"),     .delays(mem_rwa_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_rwb_n_dly"),     .delays(mem_rwb_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_lbk0_n_dly"),    .delays(mem_lbk0_n_dly ));
         delay_util.read_config(.file(filename), .name("mem_lbk1_n_dly"),    .delays(mem_lbk1_n_dly ));
         delay_util.read_config(.file(filename), .name("mem_cfg_n_dly"),     .delays(mem_cfg_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_ap_dly"),        .delays(mem_ap_dly     ));
         delay_util.read_config(.file(filename), .name("mem_pe_n_dly"),      .delays(mem_pe_n_dly   ));
         delay_util.read_config(.file(filename), .name("mem_ainv_dly"),      .delays(mem_ainv_dly   ));
         delay_util.read_config(.file(filename), .name("mem_dm_dly"),        .delays(mem_dm_dly     ));
         delay_util.read_config(.file(filename), .name("mem_bws_n_dly"),     .delays(mem_bws_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_d_dly"),         .delays(mem_d_dly      ));
         delay_util.read_config(.file(filename), .name("mem_dq_dly"),        .delays(mem_dq_dly     ));
         delay_util.read_config(.file(filename), .name("mem_dbi_n_dly"),     .delays(mem_dbi_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_dqa_dly"),       .delays(mem_dqa_dly    ));
         delay_util.read_config(.file(filename), .name("mem_dqb_dly"),       .delays(mem_dqb_dly    ));
         delay_util.read_config(.file(filename), .name("mem_dinva_dly"),     .delays(mem_dinva_dly  ));
         delay_util.read_config(.file(filename), .name("mem_dinvb_dly"),     .delays(mem_dinvb_dly  ));
         delay_util.read_config(.file(filename), .name("mem_q_dly"),         .delays(mem_q_dly      ));
         delay_util.read_config(.file(filename), .name("mem_alert_n_dly"),   .delays(mem_alert_n_dly));
         delay_util.read_config(.file(filename), .name("mem_dqs_dly"),       .delays(mem_dqs_dly    ));
         delay_util.read_config(.file(filename), .name("mem_dqs_n_dly"),     .delays(mem_dqs_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_qk_dly"),        .delays(mem_qk_dly     ));
         delay_util.read_config(.file(filename), .name("mem_qk_n_dly"),      .delays(mem_qk_n_dly   ));
         delay_util.read_config(.file(filename), .name("mem_qka_dly"),       .delays(mem_qka_dly    ));
         delay_util.read_config(.file(filename), .name("mem_qka_n_dly"),     .delays(mem_qka_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_qkb_dly"),       .delays(mem_qkb_dly    ));
         delay_util.read_config(.file(filename), .name("mem_qkb_n_dly"),     .delays(mem_qkb_n_dly  ));
         delay_util.read_config(.file(filename), .name("mem_cq_dly"),        .delays(mem_cq_dly     ));
         delay_util.read_config(.file(filename), .name("mem_cq_n_dly"),      .delays(mem_cq_n_dly   ));


         delay_util.read_config(.file(filename), .name("mem_ck_bad"),        .delays(mem_ck_bad     ));
         delay_util.read_config(.file(filename), .name("mem_ck_n_bad"),      .delays(mem_ck_n_bad   ));
         delay_util.read_config(.file(filename), .name("mem_dk_bad"),        .delays(mem_dk_bad     ));
         delay_util.read_config(.file(filename), .name("mem_dk_n_bad"),      .delays(mem_dk_n_bad   ));
         delay_util.read_config(.file(filename), .name("mem_dka_bad"),       .delays(mem_dka_bad    ));
         delay_util.read_config(.file(filename), .name("mem_dka_n_bad"),     .delays(mem_dka_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_dkb_bad"),       .delays(mem_dkb_bad    ));
         delay_util.read_config(.file(filename), .name("mem_dkb_n_bad"),     .delays(mem_dkb_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_k_bad"),         .delays(mem_k_bad      ));
         delay_util.read_config(.file(filename), .name("mem_k_n_bad"),       .delays(mem_k_n_bad    ));
         delay_util.read_config(.file(filename), .name("mem_a_bad"),         .delays(mem_a_bad      ));
         delay_util.read_config(.file(filename), .name("mem_ba_bad"),        .delays(mem_ba_bad     ));
         delay_util.read_config(.file(filename), .name("mem_bg_bad"),        .delays(mem_bg_bad     ));
         delay_util.read_config(.file(filename), .name("mem_c_bad"),         .delays(mem_c_bad      ));
         delay_util.read_config(.file(filename), .name("mem_cke_bad"),       .delays(mem_cke_bad    ));
         delay_util.read_config(.file(filename), .name("mem_cs_n_bad"),      .delays(mem_cs_n_bad   ));
         delay_util.read_config(.file(filename), .name("mem_rm_bad"),        .delays(mem_rm_bad     ));
         delay_util.read_config(.file(filename), .name("mem_odt_bad"),       .delays(mem_odt_bad    ));
         delay_util.read_config(.file(filename), .name("mem_ras_n_bad"),     .delays(mem_ras_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_cas_n_bad"),     .delays(mem_cas_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_we_n_bad"),      .delays(mem_we_n_bad   ));
         delay_util.read_config(.file(filename), .name("mem_reset_n_bad"),   .delays(mem_reset_n_bad));
         delay_util.read_config(.file(filename), .name("mem_act_n_bad"),     .delays(mem_act_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_par_bad"),       .delays(mem_par_bad    ));
         delay_util.read_config(.file(filename), .name("mem_ca_bad"),        .delays(mem_ca_bad     ));
         delay_util.read_config(.file(filename), .name("mem_ref_n_bad"),     .delays(mem_ref_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_wps_n_bad"),     .delays(mem_wps_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_rps_n_bad"),     .delays(mem_rps_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_doff_n_bad"),    .delays(mem_doff_n_bad ));
         delay_util.read_config(.file(filename), .name("mem_lda_n_bad"),     .delays(mem_lda_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_ldb_n_bad"),     .delays(mem_ldb_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_rwa_n_bad"),     .delays(mem_rwa_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_rwb_n_bad"),     .delays(mem_rwb_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_lbk0_n_bad"),    .delays(mem_lbk0_n_bad ));
         delay_util.read_config(.file(filename), .name("mem_lbk1_n_bad"),    .delays(mem_lbk1_n_bad ));
         delay_util.read_config(.file(filename), .name("mem_cfg_n_bad"),     .delays(mem_cfg_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_ap_bad"),        .delays(mem_ap_bad     ));
         delay_util.read_config(.file(filename), .name("mem_pe_n_bad"),      .delays(mem_pe_n_bad   ));
         delay_util.read_config(.file(filename), .name("mem_ainv_bad"),      .delays(mem_ainv_bad   ));
         delay_util.read_config(.file(filename), .name("mem_dm_bad"),        .delays(mem_dm_bad     ));
         delay_util.read_config(.file(filename), .name("mem_bws_n_bad"),     .delays(mem_bws_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_d_bad"),         .delays(mem_d_bad      ));
         delay_util.read_config(.file(filename), .name("mem_dq_bad"),        .delays(mem_dq_bad     ));
         delay_util.read_config(.file(filename), .name("mem_dbi_n_bad"),     .delays(mem_dbi_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_dqa_bad"),       .delays(mem_dqa_bad    ));
         delay_util.read_config(.file(filename), .name("mem_dqb_bad"),       .delays(mem_dqb_bad    ));
         delay_util.read_config(.file(filename), .name("mem_dinva_bad"),     .delays(mem_dinva_bad  ));
         delay_util.read_config(.file(filename), .name("mem_dinvb_bad"),     .delays(mem_dinvb_bad  ));
         delay_util.read_config(.file(filename), .name("mem_q_bad"),         .delays(mem_q_bad      ));
         delay_util.read_config(.file(filename), .name("mem_alert_n_bad"),   .delays(mem_alert_n_bad));
         delay_util.read_config(.file(filename), .name("mem_dqs_bad"),       .delays(mem_dqs_bad    ));
         delay_util.read_config(.file(filename), .name("mem_dqs_n_bad"),     .delays(mem_dqs_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_qk_bad"),        .delays(mem_qk_bad     ));
         delay_util.read_config(.file(filename), .name("mem_qk_n_bad"),      .delays(mem_qk_n_bad   ));
         delay_util.read_config(.file(filename), .name("mem_qka_bad"),       .delays(mem_qka_bad    ));
         delay_util.read_config(.file(filename), .name("mem_qka_n_bad"),     .delays(mem_qka_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_qkb_bad"),       .delays(mem_qkb_bad    ));
         delay_util.read_config(.file(filename), .name("mem_qkb_n_bad"),     .delays(mem_qkb_n_bad  ));
         delay_util.read_config(.file(filename), .name("mem_cq_bad"),        .delays(mem_cq_bad     ));
         delay_util.read_config(.file(filename), .name("mem_cq_n_bad"),      .delays(mem_cq_n_bad   ));

      end
   endtask

   initial load_config(CFG_FILE, 0);

   generate
   genvar i;
      for (i = 0; i < PORT_MEM_CK_WIDTH; i = i + 1)
         unidir_delay mem_ck_inst (.in(mem_ck_0[i]), .out(mem_ck_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ck_dly[i]), .bad(mem_ck_bad[i]));
      for (i = 0; i < PORT_MEM_CK_N_WIDTH; i = i + 1)
         unidir_delay mem_ck_n_inst (.in(mem_ck_n_0[i]), .out(mem_ck_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ck_n_dly[i]), .bad(mem_ck_n_bad[i]));
      for (i = 0; i < PORT_MEM_DK_WIDTH; i = i + 1)
         unidir_delay mem_dk_inst (.in(mem_dk_0[i]), .out(mem_dk_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dk_dly[i]), .bad(mem_dk_bad[i]));
      for (i = 0; i < PORT_MEM_DK_N_WIDTH; i = i + 1)
         unidir_delay mem_dk_n_inst (.in(mem_dk_n_0[i]), .out(mem_dk_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dk_n_dly[i]), .bad(mem_dk_n_bad[i]));
      for (i = 0; i < PORT_MEM_DKA_WIDTH; i = i + 1)
         unidir_delay mem_dka_inst (.in(mem_dka_0[i]), .out(mem_dka_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dka_dly[i]), .bad(mem_dka_bad[i]));
      for (i = 0; i < PORT_MEM_DKA_N_WIDTH; i = i + 1)
         unidir_delay mem_dka_n_inst (.in(mem_dka_n_0[i]), .out(mem_dka_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dka_n_dly[i]), .bad(mem_dka_n_bad[i]));
      for (i = 0; i < PORT_MEM_DKB_WIDTH; i = i + 1)
         unidir_delay mem_dkb_inst (.in(mem_dkb_0[i]), .out(mem_dkb_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dkb_dly[i]), .bad(mem_dkb_bad[i]));
      for (i = 0; i < PORT_MEM_DKB_N_WIDTH; i = i + 1)
         unidir_delay mem_dkb_n_inst (.in(mem_dkb_n_0[i]), .out(mem_dkb_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dkb_n_dly[i]), .bad(mem_dkb_n_bad[i]));
      for (i = 0; i < PORT_MEM_K_WIDTH; i = i + 1)
         unidir_delay mem_k_inst (.in(mem_k_0[i]), .out(mem_k_1[i]),
            .base_delay(base_delay[0]), .delay(mem_k_dly[i]), .bad(mem_k_bad[i]));
      for (i = 0; i < PORT_MEM_K_N_WIDTH; i = i + 1)
         unidir_delay mem_k_n_inst (.in(mem_k_n_0[i]), .out(mem_k_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_k_n_dly[i]), .bad(mem_k_n_bad[i]));
      for (i = 0; i < PORT_MEM_A_WIDTH; i = i + 1)
         unidir_delay mem_a_inst (.in(mem_a_0[i]), .out(mem_a_1[i]),
            .base_delay(base_delay[0]), .delay(mem_a_dly[i]), .bad(mem_a_bad[i]));
      for (i = 0; i < PORT_MEM_BA_WIDTH; i = i + 1)
         unidir_delay mem_ba_inst (.in(mem_ba_0[i]), .out(mem_ba_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ba_dly[i]), .bad(mem_ba_bad[i]));
      for (i = 0; i < PORT_MEM_BG_WIDTH; i = i + 1)
         unidir_delay mem_bg_inst (.in(mem_bg_0[i]), .out(mem_bg_1[i]),
            .base_delay(base_delay[0]), .delay(mem_bg_dly[i]), .bad(mem_bg_bad[i]));
      for (i = 0; i < PORT_MEM_C_WIDTH; i = i + 1)
         unidir_delay mem_c_inst (.in(mem_c_0[i]), .out(mem_c_1[i]),
            .base_delay(base_delay[0]), .delay(mem_c_dly[i]), .bad(mem_c_bad[i]));
      for (i = 0; i < PORT_MEM_CKE_WIDTH; i = i + 1)
         unidir_delay mem_cke_inst (.in(mem_cke_0[i]), .out(mem_cke_1[i]),
            .base_delay(base_delay[0]), .delay(mem_cke_dly[i]), .bad(mem_cke_bad[i]));
      for (i = 0; i < PORT_MEM_CS_N_WIDTH; i = i + 1)
         unidir_delay mem_cs_n_inst (.in(mem_cs_n_0[i]), .out(mem_cs_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_cs_n_dly[i]), .bad(mem_cs_n_bad[i]));
      for (i = 0; i < PORT_MEM_RM_WIDTH; i = i + 1)
         unidir_delay mem_rm_inst (.in(mem_rm_0[i]), .out(mem_rm_1[i]),
            .base_delay(base_delay[0]), .delay(mem_rm_dly[i]), .bad(mem_rm_bad[i]));
      for (i = 0; i < PORT_MEM_ODT_WIDTH; i = i + 1)
         unidir_delay mem_odt_inst (.in(mem_odt_0[i]), .out(mem_odt_1[i]),
            .base_delay(base_delay[0]), .delay(mem_odt_dly[i]), .bad(mem_odt_bad[i]));
      for (i = 0; i < PORT_MEM_RAS_N_WIDTH; i = i + 1)
         unidir_delay mem_ras_n_inst (.in(mem_ras_n_0[i]), .out(mem_ras_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ras_n_dly[i]), .bad(mem_ras_n_bad[i]));
      for (i = 0; i < PORT_MEM_CAS_N_WIDTH; i = i + 1)
         unidir_delay mem_cas_n_inst (.in(mem_cas_n_0[i]), .out(mem_cas_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_cas_n_dly[i]), .bad(mem_cas_n_bad[i]));
      for (i = 0; i < PORT_MEM_WE_N_WIDTH; i = i + 1)
         unidir_delay mem_we_n_inst (.in(mem_we_n_0[i]), .out(mem_we_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_we_n_dly[i]), .bad(mem_we_n_bad[i]));
      for (i = 0; i < PORT_MEM_RESET_N_WIDTH; i = i + 1)
         unidir_delay mem_reset_n_inst (.in(mem_reset_n_0[i]), .out(mem_reset_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_reset_n_dly[i]), .bad(mem_reset_n_bad[i]));
      for (i = 0; i < PORT_MEM_ACT_N_WIDTH; i = i + 1)
         unidir_delay mem_act_n_inst (.in(mem_act_n_0[i]), .out(mem_act_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_act_n_dly[i]), .bad(mem_act_n_bad[i]));
      for (i = 0; i < PORT_MEM_PAR_WIDTH; i = i + 1)
         unidir_delay mem_par_inst (.in(mem_par_0[i]), .out(mem_par_1[i]),
            .base_delay(base_delay[0]), .delay(mem_par_dly[i]), .bad(mem_par_bad[i]));
      for (i = 0; i < PORT_MEM_CA_WIDTH; i = i + 1)
         unidir_delay mem_ca_inst (.in(mem_ca_0[i]), .out(mem_ca_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ca_dly[i]), .bad(mem_ca_bad[i]));
      for (i = 0; i < PORT_MEM_REF_N_WIDTH; i = i + 1)
         unidir_delay mem_ref_n_inst (.in(mem_ref_n_0[i]), .out(mem_ref_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ref_n_dly[i]), .bad(mem_ref_n_bad[i]));
      for (i = 0; i < PORT_MEM_WPS_N_WIDTH; i = i + 1)
         unidir_delay mem_wps_n_inst (.in(mem_wps_n_0[i]), .out(mem_wps_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_wps_n_dly[i]), .bad(mem_wps_n_bad[i]));
      for (i = 0; i < PORT_MEM_RPS_N_WIDTH; i = i + 1)
         unidir_delay mem_rps_n_inst (.in(mem_rps_n_0[i]), .out(mem_rps_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_rps_n_dly[i]), .bad(mem_rps_n_bad[i]));
      for (i = 0; i < PORT_MEM_DOFF_N_WIDTH; i = i + 1)
         unidir_delay mem_doff_n_inst (.in(mem_doff_n_0[i]), .out(mem_doff_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_doff_n_dly[i]), .bad(mem_doff_n_bad[i]));
      for (i = 0; i < PORT_MEM_LDA_N_WIDTH; i = i + 1)
         unidir_delay mem_lda_n_inst (.in(mem_lda_n_0[i]), .out(mem_lda_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_lda_n_dly[i]), .bad(mem_lda_n_bad[i]));
      for (i = 0; i < PORT_MEM_LDB_N_WIDTH; i = i + 1)
         unidir_delay mem_ldb_n_inst (.in(mem_ldb_n_0[i]), .out(mem_ldb_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ldb_n_dly[i]), .bad(mem_ldb_n_bad[i]));
      for (i = 0; i < PORT_MEM_RWA_N_WIDTH; i = i + 1)
         unidir_delay mem_rwa_n_inst (.in(mem_rwa_n_0[i]), .out(mem_rwa_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_rwa_n_dly[i]), .bad(mem_rwa_n_bad[i]));
      for (i = 0; i < PORT_MEM_RWB_N_WIDTH; i = i + 1)
         unidir_delay mem_rwb_n_inst (.in(mem_rwb_n_0[i]), .out(mem_rwb_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_rwb_n_dly[i]), .bad(mem_rwb_n_bad[i]));
      for (i = 0; i < PORT_MEM_LBK0_N_WIDTH; i = i + 1)
         unidir_delay mem_lbk0_n_inst (.in(mem_lbk0_n_0[i]), .out(mem_lbk0_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_lbk0_n_dly[i]), .bad(mem_lbk0_n_bad[i]));
      for (i = 0; i < PORT_MEM_LBK1_N_WIDTH; i = i + 1)
         unidir_delay mem_lbk1_n_inst (.in(mem_lbk1_n_0[i]), .out(mem_lbk1_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_lbk1_n_dly[i]), .bad(mem_lbk1_n_bad[i]));
      for (i = 0; i < PORT_MEM_CFG_N_WIDTH; i = i + 1)
         unidir_delay mem_cfg_n_inst (.in(mem_cfg_n_0[i]), .out(mem_cfg_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_cfg_n_dly[i]), .bad(mem_cfg_n_bad[i]));
      for (i = 0; i < PORT_MEM_AP_WIDTH; i = i + 1)
         unidir_delay mem_ap_inst (.in(mem_ap_0[i]), .out(mem_ap_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ap_dly[i]), .bad(mem_ap_bad[i]));
      for (i = 0; i < PORT_MEM_AINV_WIDTH; i = i + 1)
         unidir_delay mem_ainv_inst (.in(mem_ainv_0[i]), .out(mem_ainv_1[i]),
            .base_delay(base_delay[0]), .delay(mem_ainv_dly[i]), .bad(mem_ainv_bad[i]));
      for (i = 0; i < PORT_MEM_DM_WIDTH; i = i + 1)
         unidir_delay mem_dm_inst (.in(mem_dm_0[i]), .out(mem_dm_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dm_dly[i]), .bad(mem_dm_bad[i]));
      for (i = 0; i < PORT_MEM_BWS_N_WIDTH; i = i + 1)
         unidir_delay mem_bws_n_inst (.in(mem_bws_n_0[i]), .out(mem_bws_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_bws_n_dly[i]), .bad(mem_bws_n_bad[i]));
      for (i = 0; i < PORT_MEM_D_WIDTH; i = i + 1)
         unidir_delay mem_d_inst (.in(mem_d_0[i]), .out(mem_d_1[i]),
            .base_delay(base_delay[0]), .delay(mem_d_dly[i]), .bad(mem_d_bad[i]));
      for (i = 0; i < PORT_MEM_PE_N_WIDTH; i = i + 1)
         unidir_delay mem_pe_n_inst (.in(mem_pe_n_1[i]), .out(mem_pe_n_0[i]),
            .base_delay(base_delay[0]), .delay(mem_pe_n_dly[i]), .bad(mem_pe_n_bad[i]));
      for (i = 0; i < PORT_MEM_Q_WIDTH; i = i + 1)
         unidir_delay mem_q_inst (.in(mem_q_1[i]), .out(mem_q_0[i]),
            .base_delay(base_delay[0]), .delay(mem_q_dly[i]), .bad(mem_q_bad[i]));
      for (i = 0; i < PORT_MEM_ALERT_N_WIDTH; i = i + 1)
         unidir_delay mem_alert_n_inst (.in(mem_alert_n_1[i]), .out(mem_alert_n_0[i]),
            .base_delay(base_delay[0]), .delay(mem_alert_n_dly[i]), .bad(mem_alert_n_bad[i]));
      for (i = 0; i < PORT_MEM_QK_WIDTH; i = i + 1)
         unidir_delay mem_qk_inst (.in(mem_qk_1[i]), .out(mem_qk_0[i]),
            .base_delay(base_delay[0]), .delay(mem_qk_dly[i]), .bad(mem_qk_bad[i]));
      for (i = 0; i < PORT_MEM_QK_N_WIDTH; i = i + 1)
         unidir_delay mem_qk_n_inst (.in(mem_qk_n_1[i]), .out(mem_qk_n_0[i]),
            .base_delay(base_delay[0]), .delay(mem_qk_n_dly[i]), .bad(mem_qk_n_bad[i]));
      for (i = 0; i < PORT_MEM_QKA_WIDTH; i = i + 1)
         unidir_delay mem_qka_inst (.in(mem_qka_1[i]), .out(mem_qka_0[i]),
            .base_delay(base_delay[0]), .delay(mem_qka_dly[i]), .bad(mem_qka_bad[i]));
      for (i = 0; i < PORT_MEM_QKA_N_WIDTH; i = i + 1)
         unidir_delay mem_qka_n_inst (.in(mem_qka_n_1[i]), .out(mem_qka_n_0[i]),
            .base_delay(base_delay[0]), .delay(mem_qka_n_dly[i]), .bad(mem_qka_n_bad[i]));
      for (i = 0; i < PORT_MEM_QKB_WIDTH; i = i + 1)
         unidir_delay mem_qkb_inst (.in(mem_qkb_1[i]), .out(mem_qkb_0[i]),
            .base_delay(base_delay[0]), .delay(mem_qkb_dly[i]), .bad(mem_qkb_bad[i]));
      for (i = 0; i < PORT_MEM_QKB_N_WIDTH; i = i + 1)
         unidir_delay mem_qkb_n_inst (.in(mem_qkb_n_1[i]), .out(mem_qkb_n_0[i]),
            .base_delay(base_delay[0]), .delay(mem_qkb_n_dly[i]), .bad(mem_qkb_n_bad[i]));
      for (i = 0; i < PORT_MEM_CQ_WIDTH; i = i + 1)
         unidir_delay mem_cq_inst (.in(mem_cq_1[i]), .out(mem_cq_0[i]),
            .base_delay(base_delay[0]), .delay(mem_cq_dly[i]), .bad(mem_cq_bad[i]));
      for (i = 0; i < PORT_MEM_CQ_N_WIDTH; i = i + 1)
         unidir_delay mem_cq_n_inst (.in(mem_cq_n_1[i]), .out(mem_cq_n_0[i]),
            .base_delay(base_delay[0]), .delay(mem_cq_n_dly[i]), .bad(mem_cq_n_bad[i]));
      for (i = 0; i < PORT_MEM_DQ_WIDTH; i = i + 1)
         bidir_delay mem_dq_inst (.phy(mem_dq_0[i]), .mem(mem_dq_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dq_dly[i]), .bad(mem_dq_bad[i]), .bad_from_z(mem_dq_bad_z[i]));
      for (i = 0; i < PORT_MEM_DBI_N_WIDTH; i = i + 1)
         bidir_delay mem_dbi_n_inst (.phy(mem_dbi_n_0[i]), .mem(mem_dbi_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dbi_n_dly[i]), .bad(mem_dbi_n_bad[i]), .bad_from_z(mem_dbi_n_bad_z[i]));
      for (i = 0; i < PORT_MEM_DQA_WIDTH; i = i + 1)
         bidir_delay mem_dqa_inst (.phy(mem_dqa_0[i]), .mem(mem_dqa_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dqa_dly[i]), .bad(mem_dqa_bad[i]), .bad_from_z(mem_dqa_bad_z[i]));
      for (i = 0; i < PORT_MEM_DQB_WIDTH; i = i + 1)
         bidir_delay mem_dqb_inst (.phy(mem_dqb_0[i]), .mem(mem_dqb_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dqb_dly[i]), .bad(mem_dqb_bad[i]), .bad_from_z(mem_dqb_bad_z[i]));
      for (i = 0; i < PORT_MEM_DINVA_WIDTH; i = i + 1)
         bidir_delay mem_dinva_inst (.phy(mem_dinva_0[i]), .mem(mem_dinva_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dinva_dly[i]), .bad(mem_dinva_bad[i]), .bad_from_z(mem_dinva_bad_z[i]));
      for (i = 0; i < PORT_MEM_DINVB_WIDTH; i = i + 1)
         bidir_delay mem_dinvb_inst (.phy(mem_dinvb_0[i]), .mem(mem_dinvb_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dinvb_dly[i]), .bad(mem_dinvb_bad[i]), .bad_from_z(mem_dinvb_bad_z[i]));
      for (i = 0; i < PORT_MEM_DQS_WIDTH; i = i + 1)
         bidir_delay mem_dqs_inst (.phy(mem_dqs_0[i]), .mem(mem_dqs_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dqs_dly[i]), .bad(mem_dqs_bad[i]), .bad_from_z(mem_dqs_bad_z[i]));
      for (i = 0; i < PORT_MEM_DQS_N_WIDTH; i = i + 1)
         bidir_delay mem_dqs_n_inst (.phy(mem_dqs_n_0[i]), .mem(mem_dqs_n_1[i]),
            .base_delay(base_delay[0]), .delay(mem_dqs_n_dly[i]), .bad(mem_dqs_n_bad[i]), .bad_from_z(mem_dqs_n_bad_z[i]));
   endgenerate

endmodule

