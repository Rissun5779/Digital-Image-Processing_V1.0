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
// Top-level wrapper of RLD3 soft memory controller
//
// To conform to the rest of EMIF, the interfaces of a memory controller must:
//    Expose one AFI interface 
//    Accept one afi_reset_n interface
//    Accept one afi_clk interface
//    Accept one afi_half_clk interface
//    Output one emif_usr_reset_n interface
//    Output one emif_usr_clk interface
//    Expose one or more AMM/AST interfaces, as master
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_ctrl_rld3_top # (
   parameter PROTOCOL_ENUM                           = "",
   parameter USER_CLK_RATIO                          = 1,
   
   // Definition of port widths for "afi" interface 
   //AUTOGEN_BEGIN: Definition of afi port widths
   parameter PORT_AFI_RLAT_WIDTH                     = 1,
   parameter PORT_AFI_WLAT_WIDTH                     = 1,
   parameter PORT_AFI_SEQ_BUSY_WIDTH                 = 1,
   parameter PORT_AFI_ADDR_WIDTH                     = 1,
   parameter PORT_AFI_BA_WIDTH                       = 1,
   parameter PORT_AFI_BG_WIDTH                       = 1,
   parameter PORT_AFI_C_WIDTH                        = 1,
   parameter PORT_AFI_CKE_WIDTH                      = 1,
   parameter PORT_AFI_CS_N_WIDTH                     = 1,
   parameter PORT_AFI_RM_WIDTH                       = 1,
   parameter PORT_AFI_ODT_WIDTH                      = 1,
   parameter PORT_AFI_RAS_N_WIDTH                    = 1,
   parameter PORT_AFI_CAS_N_WIDTH                    = 1,
   parameter PORT_AFI_WE_N_WIDTH                     = 1,
   parameter PORT_AFI_RST_N_WIDTH                    = 1,
   parameter PORT_AFI_ACT_N_WIDTH                    = 1,
   parameter PORT_AFI_PAR_WIDTH                      = 1,
   parameter PORT_AFI_CA_WIDTH                       = 1,
   parameter PORT_AFI_REF_N_WIDTH                    = 1,
   parameter PORT_AFI_WPS_N_WIDTH                    = 1,
   parameter PORT_AFI_RPS_N_WIDTH                    = 1,
   parameter PORT_AFI_DOFF_N_WIDTH                   = 1,
   parameter PORT_AFI_LD_N_WIDTH                     = 1,
   parameter PORT_AFI_RW_N_WIDTH                     = 1,
   parameter PORT_AFI_LBK0_N_WIDTH                   = 1,
   parameter PORT_AFI_LBK1_N_WIDTH                   = 1,
   parameter PORT_AFI_CFG_N_WIDTH                    = 1,
   parameter PORT_AFI_AP_WIDTH                       = 1,
   parameter PORT_AFI_AINV_WIDTH                     = 1,
   parameter PORT_AFI_DM_WIDTH                       = 1,
   parameter PORT_AFI_DM_N_WIDTH                     = 1,
   parameter PORT_AFI_BWS_N_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_DBI_N_WIDTH              = 1,
   parameter PORT_AFI_WDATA_DBI_N_WIDTH              = 1,
   parameter PORT_AFI_RDATA_DINV_WIDTH               = 1,
   parameter PORT_AFI_WDATA_DINV_WIDTH               = 1,
   parameter PORT_AFI_DQS_BURST_WIDTH                = 1,
   parameter PORT_AFI_WDATA_VALID_WIDTH              = 1,
   parameter PORT_AFI_WDATA_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_EN_FULL_WIDTH            = 1,
   parameter PORT_AFI_RDATA_WIDTH                    = 1,
   parameter PORT_AFI_RDATA_VALID_WIDTH              = 1,
   parameter PORT_AFI_RRANK_WIDTH                    = 1,
   parameter PORT_AFI_WRANK_WIDTH                    = 1,
   parameter PORT_AFI_ALERT_N_WIDTH                  = 1,
   parameter PORT_AFI_PE_N_WIDTH                     = 1,
   
   // Definition of port widths for "ctrl_amm" interface
   parameter PORT_CTRL_AMM_RDATA_WIDTH               = 1,
   parameter PORT_CTRL_AMM_ADDRESS_WIDTH             = 1,
   parameter PORT_CTRL_AMM_WDATA_WIDTH               = 1,
   parameter PORT_CTRL_AMM_BCOUNT_WIDTH              = 1,
   parameter PORT_CTRL_AMM_BYTEEN_WIDTH              = 1,
   
   // Definition of port widths for "ctrl_ast_cmd" interface
   parameter PORT_CTRL_AST_CMD_DATA_WIDTH            = 1,

   // Definition of port widths for "ctrl_ast_wr" interface
   parameter PORT_CTRL_AST_WR_DATA_WIDTH             = 1,   

   // Definition of port widths for "ctrl_ast_rd" interface
   parameter PORT_CTRL_AST_RD_DATA_WIDTH             = 1   
   
   // Definition of controller setting parameters
   
) (
   // AFI reset
   input  logic                                               afi_reset_n,
   
   // AFI clock
   input  logic                                               afi_clk,
   
   // A clock that runs at half the frequency of afi_clk
   input  logic                                               afi_half_clk,
   
   // User reset signal
   output logic                                               emif_usr_reset_n,
   
   // User clock
   output logic                                               emif_usr_clk,

   // Ports for "afi" interface
   //AUTOGEN_BEGIN: Definition of afi ports
   input  logic                                               afi_cal_success,
   input  logic                                               afi_cal_fail,
   output logic                                               afi_cal_req,
   input  logic [PORT_AFI_RLAT_WIDTH-1:0]                     afi_rlat,
   input  logic [PORT_AFI_WLAT_WIDTH-1:0]                     afi_wlat,
   input  logic [PORT_AFI_SEQ_BUSY_WIDTH-1:0]                 afi_seq_busy,
   output logic                                               afi_ctl_refresh_done,
   output logic                                               afi_ctl_long_idle,
   output logic                                               afi_mps_req,
   input  logic                                               afi_mps_ack,
   output logic [PORT_AFI_ADDR_WIDTH-1:0]                     afi_addr,
   output logic [PORT_AFI_BA_WIDTH-1:0]                       afi_ba,
   output logic [PORT_AFI_BG_WIDTH-1:0]                       afi_bg,
   output logic [PORT_AFI_C_WIDTH-1:0]                        afi_c,
   output logic [PORT_AFI_CKE_WIDTH-1:0]                      afi_cke,
   output logic [PORT_AFI_CS_N_WIDTH-1:0]                     afi_cs_n,
   output logic [PORT_AFI_RM_WIDTH-1:0]                       afi_rm,
   output logic [PORT_AFI_ODT_WIDTH-1:0]                      afi_odt,
   output logic [PORT_AFI_RAS_N_WIDTH-1:0]                    afi_ras_n,
   output logic [PORT_AFI_CAS_N_WIDTH-1:0]                    afi_cas_n,
   output logic [PORT_AFI_WE_N_WIDTH-1:0]                     afi_we_n,
   output logic [PORT_AFI_RST_N_WIDTH-1:0]                    afi_rst_n,
   output logic [PORT_AFI_ACT_N_WIDTH-1:0]                    afi_act_n,
   output logic [PORT_AFI_PAR_WIDTH-1:0]                      afi_par,
   output logic [PORT_AFI_CA_WIDTH-1:0]                       afi_ca,
   output logic [PORT_AFI_REF_N_WIDTH-1:0]                    afi_ref_n,
   output logic [PORT_AFI_WPS_N_WIDTH-1:0]                    afi_wps_n,
   output logic [PORT_AFI_RPS_N_WIDTH-1:0]                    afi_rps_n,
   output logic [PORT_AFI_DOFF_N_WIDTH-1:0]                   afi_doff_n,
   output logic [PORT_AFI_LD_N_WIDTH-1:0]                     afi_ld_n,
   output logic [PORT_AFI_RW_N_WIDTH-1:0]                     afi_rw_n,
   output logic [PORT_AFI_LBK0_N_WIDTH-1:0]                   afi_lbk0_n,
   output logic [PORT_AFI_LBK1_N_WIDTH-1:0]                   afi_lbk1_n,
   output logic [PORT_AFI_CFG_N_WIDTH-1:0]                    afi_cfg_n,
   output logic [PORT_AFI_AP_WIDTH-1:0]                       afi_ap,
   output logic [PORT_AFI_AINV_WIDTH-1:0]                     afi_ainv,
   output logic [PORT_AFI_DM_WIDTH-1:0]                       afi_dm,
   output logic [PORT_AFI_DM_N_WIDTH-1:0]                     afi_dm_n,
   output logic [PORT_AFI_BWS_N_WIDTH-1:0]                    afi_bws_n,
   input  logic [PORT_AFI_RDATA_DBI_N_WIDTH-1:0]              afi_rdata_dbi_n,
   output logic [PORT_AFI_WDATA_DBI_N_WIDTH-1:0]              afi_wdata_dbi_n,
   input  logic [PORT_AFI_RDATA_DINV_WIDTH-1:0]               afi_rdata_dinv,
   output logic [PORT_AFI_WDATA_DINV_WIDTH-1:0]               afi_wdata_dinv,
   output logic [PORT_AFI_DQS_BURST_WIDTH-1:0]                afi_dqs_burst,
   output logic [PORT_AFI_WDATA_VALID_WIDTH-1:0]              afi_wdata_valid,
   output logic [PORT_AFI_WDATA_WIDTH-1:0]                    afi_wdata,
   output logic [PORT_AFI_RDATA_EN_FULL_WIDTH-1:0]            afi_rdata_en_full,
   input  logic [PORT_AFI_RDATA_WIDTH-1:0]                    afi_rdata,
   input  logic [PORT_AFI_RDATA_VALID_WIDTH-1:0]              afi_rdata_valid,
   output logic [PORT_AFI_RRANK_WIDTH-1:0]                    afi_rrank,
   output logic [PORT_AFI_WRANK_WIDTH-1:0]                    afi_wrank,
   input  logic [PORT_AFI_ALERT_N_WIDTH-1:0]                  afi_alert_n,
   input  logic [PORT_AFI_PE_N_WIDTH-1:0]                     afi_pe_n,
   
   // Ports for "ctrl_amm" interfaces (up to 4 ports)
   input  logic                                               amm_write_0,
   input  logic                                               amm_read_0,
   output logic                                               amm_ready_0,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_0,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_0,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_0,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_0,
   input  logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_0,
   input  logic                                               amm_beginbursttransfer_0,
   output logic                                               amm_readdatavalid_0,
   
   input  logic                                               amm_write_1,
   input  logic                                               amm_read_1,
   output logic                                               amm_ready_1,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_1,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_1,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_1,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_1,
   input  logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_1,
   input  logic                                               amm_beginbursttransfer_1,
   output logic                                               amm_readdatavalid_1,

   input  logic                                               amm_write_2,
   input  logic                                               amm_read_2,
   output logic                                               amm_ready_2,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_2,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_2,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_2,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_2,
   input  logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_2,
   input  logic                                               amm_beginbursttransfer_2,
   output logic                                               amm_readdatavalid_2,

   input  logic                                               amm_write_3,
   input  logic                                               amm_read_3,
   output logic                                               amm_ready_3,
   output logic [PORT_CTRL_AMM_RDATA_WIDTH-1:0]               amm_readdata_3,
   input  logic [PORT_CTRL_AMM_ADDRESS_WIDTH-1:0]             amm_address_3,
   input  logic [PORT_CTRL_AMM_WDATA_WIDTH-1:0]               amm_writedata_3,
   input  logic [PORT_CTRL_AMM_BCOUNT_WIDTH-1:0]              amm_burstcount_3,
   input  logic [PORT_CTRL_AMM_BYTEEN_WIDTH-1:0]              amm_byteenable_3,
   input  logic                                               amm_beginbursttransfer_3,
   output logic                                               amm_readdatavalid_3
);
   timeunit 1ps;
   timeprecision 1ps;
   
   // Expose user clocks
   assign emif_usr_reset_n = afi_reset_n;
   assign emif_usr_clk     = (USER_CLK_RATIO == 8) ? afi_half_clk : afi_clk;
   
   assign afi_cal_req = '0;
   assign afi_ctl_refresh_done = '0;
   assign afi_ctl_long_idle = '0;
   assign afi_mps_req = '0;
   assign afi_addr = '0;
   assign afi_ba = '0;
   assign afi_bg = '0;
   assign afi_c = '0;
   assign afi_cke = '0;
   assign afi_cs_n = '1;
   assign afi_rm = '0;
   assign afi_odt = '0;
   assign afi_ras_n = '1;
   assign afi_cas_n = '1;
   assign afi_we_n = '1;
   assign afi_rst_n = '1;
   assign afi_act_n = '1;
   assign afi_par = '0;
   assign afi_ca = '0;
   assign afi_ref_n = '1;
   assign afi_wps_n = '1;
   assign afi_rps_n = '1;
   assign afi_doff_n = '1;
   assign afi_ld_n = '1;
   assign afi_rw_n = '1;
   assign afi_lbk0_n = '1;
   assign afi_lbk1_n = '1;
   assign afi_cfg_n = '1;
   assign afi_ap = '0;
   assign afi_ainv = '0;
   assign afi_dm = '0;
   assign afi_dm_n = '1;
   assign afi_bws_n = '0;
   assign afi_wdata_dbi_n = '1;
   assign afi_wdata_dinv = '0;
   assign afi_dqs_burst = '0;
   assign afi_wdata_valid = '0;
   assign afi_wdata = '0;
   assign afi_rdata_en_full = '0;
   
   // AFI expects the rank switching signal to be one-hot encoded, but is also able
   // to treat all-zeros as selecting shadow register set 0. Since this controller
   // doesn't support multi-rank, we simply tie the rank switcing signals to '0.  
   // For proper shadow register switching, the multi-rank-capable controller
   // should one-hot encode which rank is being read or write, for all the AFI
   // time slots, into the afi_rrank and afi_wrank signals. The afi_rrank signal must 
   // be asserted and deasserted following the timing of afi_rdata_en_full. The
   // afi_wrank signal must be asserted and deasserted following the timing of 
   // afi_dqs_burst (for DDRx) or afi_wdata_valid (for non-DDRx).
   assign afi_rrank = '0;
   assign afi_wrank = '0;
      
   assign amm_ready_0 = '0;
   assign amm_readdata_0 = '0;
   assign amm_readdatavalid_0 = '0;

   assign amm_ready_1 = '0;
   assign amm_readdata_1 = '0;
   assign amm_readdatavalid_1 = '0;

   assign amm_ready_2 = '0;
   assign amm_readdata_2 = '0;
   assign amm_readdatavalid_2 = '0;

   assign amm_ready_3 = '0;
   assign amm_readdata_3 = '0;
   assign amm_readdatavalid_3 = '0;
   
endmodule
