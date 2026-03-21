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
// Top-level wrapper of Example QDR-IV AFI Traffic Generator
//
// To conform to the rest of EMIF, the interfaces of a memory controller must:
//    Expose one AFI interface 
//    Accept one afi_reset_n interface
//    Accept one afi_clk interface
//    Accept one afi_half_clk interface
//    Expose one tg_status interface
//
///////////////////////////////////////////////////////////////////////////////
module altera_emif_tg_afi_qdr4_top # (
   parameter PROTOCOL_ENUM                           = "",
   parameter USER_CLK_RATIO                          = 1,
   parameter MEM_BL                                  = 1,
   parameter DENY_RECAL_REQUEST                      = 0,
   
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
   parameter PORT_AFI_PE_N_WIDTH                     = 1   
   
   // Definition of AFI setting parameters
   
) (
   // AFI reset
   input  logic                                               afi_reset_n,
   
   // AFI clock
   input  logic                                               afi_clk,
   
   // A clock that runs at half the frequency of afi_clk
   input  logic                                               afi_half_clk,
   
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
   
   // Ports for "tg_status" interfaces (auto-generated)
   output logic                                               traffic_gen_pass,
   output logic                                               traffic_gen_fail,
   output logic                                               traffic_gen_timeout
);
   timeunit 1ps;
   timeprecision 1ps;


   // AFI expects the rank switching signal to be one-hot encoded, but is also able
   // to treat all-zeros as selecting shadow register set 0. Since this example
   // traffic generator can only access rank 0, we simply tie the rank switcing 
   // signals to '0.  For proper shadow register switching, the traffic generator
   // should one-hot encode which rank is being read or write, for all the AFI
   // time slots, into the afi_rrank and afi_wrank signals. The afi_rrank signal must 
   // be asserted and deasserted following the timing of afi_rdata_en_full. The
   // afi_wrank signal must be asserted and deasserted following the timing of 
   // afi_dqs_burst (for DDRx) or afi_wdata_valid (for non-DDRx).
   assign afi_rrank = '0;
   assign afi_wrank = '0;
   
   assign afi_mps_req = '0;
endmodule
