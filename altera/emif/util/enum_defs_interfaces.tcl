# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


package provide altera_emif::util::enum_defs_interfaces 0.1

package require altera_emif::util::enums

namespace eval ::altera_emif::util::enum_defs_interfaces:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::util::enum_defs_interfaces::def_enums {} {

   def_enum_type IF                               {      QSYS_NAME                   OLD_QSYS_NAME               QSYS_TYPE           QSYS_DIR  PORT_ENUM_TYPE                 HIDDEN  PROTOCOLS                                                                       }
   def_enum      IF  IF_GLOBAL_RESET              [list  "global_reset_n"            "global_reset"              "reset"             "sink"    PORT_GLOBAL_RESET                   0  [list ALL]                                                                      ]
   def_enum      IF  IF_PLL_REF_CLK               [list  "pll_ref_clk"               "pll_ref_clk"               "clock"             "sink"    PORT_PLL_REF_CLK                    0  [list ALL]                                                                      ]
   def_enum      IF  IF_OCT                       [list  "oct"                       "oct"                       "conduit"           "end"     PORT_OCT                            0  [list ALL]                                                                      ]
   def_enum      IF  IF_MEM                       [list  "mem"                       "mem"                       "conduit"           "end"     PORT_MEM                            0  [list ]                                                                         ]
   def_enum      IF  IF_STATUS                    [list  "status"                    "status"                    "conduit"           "end"     PORT_STATUS                         0  [list ALL]                                                                      ]
   def_enum      IF  IF_VID_CAL_DONE              [list  "vid_cal_done_persist"      "vid_cal_done_persist"      "conduit"           "end"     PORT_VID_CAL_DONE                   0  [list ]                                                                         ]
   def_enum      IF  IF_AFI_RESET                 [list  "afi_reset_n"               "afi_reset"                 "reset"             "source"  PORT_AFI_RESET                      0  [list ]                                                                         ]
   def_enum      IF  IF_AFI_CLK                   [list  "afi_clk"                   "afi_clk"                   "clock"             "source"  PORT_AFI_CLK                        0  [list ]                                                                         ]
   def_enum      IF  IF_AFI_HALF_CLK              [list  "afi_half_clk"              "afi_half_clk"              "clock"             "source"  PORT_AFI_HALF_CLK                   0  [list ]                                                                         ]
   def_enum      IF  IF_AFI                       [list  "afi"                       "afi"                       "conduit"           "end"     PORT_AFI                            0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_RESET            [list  "emif_usr_reset_n"          "emif_usr_reset"            "reset"             "source"  PORT_EMIF_USR_RESET                 0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4 PROTOCOL_LPDDR3]  ]
   def_enum      IF  IF_EMIF_USR_CLK              [list  "emif_usr_clk"              "emif_usr_clk"              "clock"             "source"  PORT_EMIF_USR_CLK                   0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4 PROTOCOL_LPDDR3]  ]
   def_enum      IF  IF_EMIF_USR_HALF_CLK         [list  "emif_usr_half_clk"         "emif_usr_half_clk"         "clock"             "source"  PORT_EMIF_USR_HALF_CLK              0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_RESET_IN         [list  "emif_usr_reset_n_in"       "emif_usr_reset_in"         "reset"             "sink"    PORT_EMIF_USR_RESET_IN              0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_CLK_IN           [list  "emif_usr_clk_in"           "emif_usr_clk_in"           "clock"             "sink"    PORT_EMIF_USR_CLK_IN                0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_HALF_CLK_IN      [list  "emif_usr_half_clk_in"      "emif_usr_half_clk_in"      "clock"             "sink"    PORT_EMIF_USR_HALF_CLK_IN           0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_RESET_SEC        [list  "emif_usr_reset_n_sec"      "emif_usr_reset_sec"        "reset"             "source"  PORT_EMIF_USR_RESET_SEC             0  [list PROTOCOL_DDR3 PROTOCOL_DDR4]                                              ]
   def_enum      IF  IF_EMIF_USR_CLK_SEC          [list  "emif_usr_clk_sec"          "emif_usr_clk_sec"          "clock"             "source"  PORT_EMIF_USR_CLK_SEC               0  [list PROTOCOL_DDR3 PROTOCOL_DDR4]                                              ]
   def_enum      IF  IF_EMIF_USR_HALF_CLK_SEC     [list  "emif_usr_half_clk_sec"     "emif_usr_half_clk_sec"     "clock"             "source"  PORT_EMIF_USR_HALF_CLK_SEC          0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_RESET_SEC_IN     [list  "emif_usr_reset_n_sec_in"   "emif_usr_reset_sec_in"     "reset"             "sink"    PORT_EMIF_USR_RESET_SEC_IN          0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_CLK_SEC_IN       [list  "emif_usr_clk_sec_in"       "emif_usr_clk_sec_in"       "clock"             "sink"    PORT_EMIF_USR_CLK_SEC_IN            0  [list ]                                                                         ]
   def_enum      IF  IF_EMIF_USR_HALF_CLK_SEC_IN  [list  "emif_usr_half_clk_sec_in"  "emif_usr_half_clk_sec_in"  "clock"             "sink"    PORT_EMIF_USR_HALF_CLK_SEC_IN       0  [list ]                                                                         ]
   def_enum      IF  IF_CAL_MASTER_RESET          [list  "cal_master_reset_n"        "cal_master_reset_n"        "reset"             "source"  PORT_CAL_MASTER_RESET               0  [list ]                                                                         ]
   def_enum      IF  IF_CAL_MASTER_CLK            [list  "cal_master_clk"            "cal_master_clk"            "clock"             "source"  PORT_CAL_MASTER_CLK                 0  [list ]                                                                         ]
   def_enum      IF  IF_CAL_SLAVE_RESET           [list  "cal_slave_reset_n"         "cal_slave_reset_n"         "reset"             "source"  PORT_CAL_SLAVE_RESET                0  [list ]                                                                         ]
   def_enum      IF  IF_CAL_SLAVE_CLK             [list  "cal_slave_clk"             "cal_slave_clk"             "clock"             "source"  PORT_CAL_SLAVE_CLK                  0  [list ]                                                                         ]
   def_enum      IF  IF_CAL_SLAVE_RESET_IN        [list  "cal_slave_reset_n_in"      "cal_slave_reset_n_in"      "reset"             "sink"    PORT_CAL_SLAVE_RESET_IN             0  [list ]                                                                         ]
   def_enum      IF  IF_CAL_SLAVE_CLK_IN          [list  "cal_slave_clk_in"          "cal_slave_clk_in"          "clock"             "sink"    PORT_CAL_SLAVE_CLK_IN               0  [list ]                                                                         ]
   def_enum      IF  IF_CAL_DEBUG_RESET           [list  "cal_debug_reset_n"         "cal_debug_reset"           "reset"             "sink"    PORT_CAL_DEBUG_RESET                0  [list ALL]                                                                      ]
   def_enum      IF  IF_CAL_DEBUG_CLK             [list  "cal_debug_clk"             "cal_debug_clk"             "clock"             "sink"    PORT_CAL_DEBUG_CLK                  0  [list ALL]                                                                      ]
   def_enum      IF  IF_CAL_DEBUG_OUT_RESET       [list  "cal_debug_out_reset_n"     "cal_debug_out_reset"       "reset"             "source"  PORT_CAL_DEBUG_OUT_RESET            0  [list ALL]                                                                      ]
   def_enum      IF  IF_CAL_DEBUG_OUT_CLK         [list  "cal_debug_out_clk"         "cal_debug_out_clk"         "clock"             "source"  PORT_CAL_DEBUG_OUT_CLK              0  [list ALL]                                                                      ]
   def_enum      IF  IF_CLKS_SHARING_MASTER_OUT   [list  "clks_sharing_master_out"   "clks_sharing_master_out"   "conduit"           "end"     PORT_CLKS_SHARING_MASTER_OUT        0  [list ALL]                                                                      ]
   def_enum      IF  IF_CLKS_SHARING_SLAVE_IN     [list  "clks_sharing_slave_in"     "clks_sharing_slave_in"     "conduit"           "end"     PORT_CLKS_SHARING_SLAVE_IN          0  [list ALL]                                                                      ]
   def_enum      IF  IF_CTRL_AST_CMD              [list  "ctrl_ast_cmd"              "ctrl_ast_cmd"              "avalon_streaming"  "sink"    PORT_CTRL_AST_CMD                   0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_AST_WR               [list  "ctrl_ast_wr"               "ctrl_ast_wr"               "avalon_streaming"  "sink"    PORT_CTRL_AST_WR                    0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_AST_RD               [list  "ctrl_ast_rd"               "ctrl_ast_rd"               "avalon_streaming"  "source"  PORT_CTRL_AST_RD                    0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_AMM                  [list  "ctrl_amm"                  "ctrl_amm"                  "avalon"            "slave"   PORT_CTRL_AMM                       0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_AUTO_PRECHARGE       [list  "ctrl_auto_precharge"       "ctrl_auto_precharge"       "conduit"           "end"     PORT_CTRL_AUTO_PRECHARGE            0  [list PROTOCOL_DDR3 PROTOCOL_DDR4]                                              ]
   def_enum      IF  IF_CTRL_USER_PRIORITY        [list  "ctrl_user_priority"        "ctrl_user_priority"        "conduit"           "end"     PORT_CTRL_USER_PRIORITY             0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                              ]
   def_enum      IF  IF_CTRL_USER_REFRESH         [list  "ctrl_user_refresh"         "ctrl_user_refresh"         "conduit"           "end"     PORT_CTRL_USER_REFRESH              0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_SELF_REFRESH         [list  "ctrl_self_refresh"         "ctrl_self_refresh"         "conduit"           "end"     PORT_CTRL_SELF_REFRESH              0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_WILL_REFRESH         [list  "ctrl_will_refresh"         "ctrl_will_refresh"         "conduit"           "end"     PORT_CTRL_WILL_REFRESH              0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_DEEP_POWER_DOWN      [list  "ctrl_deep_power_down"      "ctrl_deep_power_down"      "conduit"           "end"     PORT_CTRL_DEEP_POWER_DOWN           0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_POWER_DOWN           [list  "ctrl_power_down"           "ctrl_power_down"           "conduit"           "end"     PORT_CTRL_POWER_DOWN                0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                              ]
   def_enum      IF  IF_CTRL_ZQ_CAL               [list  "ctrl_zq_cal"               "ctrl_zq_cal"               "conduit"           "end"     PORT_CTRL_ZQ_CAL                    0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_ECC                  [list  "ctrl_ecc"                  "ctrl_ecc"                  "conduit"           "end"     PORT_CTRL_ECC                       0  [list ]                                                                         ]
   def_enum      IF  IF_CTRL_ECC_USER_INTERRUPT   [list  "ctrl_ecc_user_interrupt"   "ctrl_ecc_user_interrupt"   "conduit"           "end"     PORT_CTRL_ECC_USER_INTERRUPT        0  [list PROTOCOL_DDR3 PROTOCOL_DDR4]                                              ]
   def_enum      IF  IF_CTRL_MMR_SLAVE            [list  "ctrl_mmr_slave"            "ctrl_mmr_slave"            "avalon"            "slave"   PORT_CTRL_MMR_SLAVE                 0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                              ]
   def_enum      IF  IF_CTRL_MMR_MASTER           [list  "ctrl_mmr_master"           "ctrl_mmr_master"           "avalon"            "master"  PORT_CTRL_MMR_MASTER                0  [list ]                                                                         ]
   def_enum      IF  IF_HPS_EMIF                  [list  "hps_emif"                  "hps_emif"                  "conduit"           "end"     PORT_HPS_EMIF                       0  [list ALL]                                                                      ]
   def_enum      IF  IF_CAL_DEBUG                 [list  "cal_debug"                 "cal_debug"                 "avalon"            "slave"   PORT_CAL_DEBUG                      0  [list ALL]                                                                      ]
   def_enum      IF  IF_CAL_DEBUG_OUT             [list  "cal_debug_out"             "cal_debug_out"             "avalon"            "master"  PORT_CAL_DEBUG_OUT                  0  [list ALL]                                                                      ]
   def_enum      IF  IF_CAL_MASTER                [list  "cal_master"                "cal_master"                "avalon"            "master"  PORT_CAL_MASTER                     0  [list ]                                                                         ]
   def_enum      IF  IF_VJI                       [list  "vji"                       "vji"                       "conduit"           "end"     PORT_VJI                            0  [list ]                                                                         ]
   def_enum      IF  IF_TG_STATUS                 [list  "tg_status"                 "tg_status"                 "conduit"           "end"     PORT_TG_STATUS                      0  [list ]                                                                         ]
   def_enum      IF  IF_DFT_NF                    [list  "dft_nf"                    "dft_nf"                    "conduit"           "end"     PORT_DFT_NF                         0  [list ]                                                                         ]
   def_enum      IF  IF_DFT_ND                    [list  "dft_nd"                    "dft_nd"                    "conduit"           "end"     PORT_DFT_ND                         0  [list ]                                                                         ]
   def_enum      IF  IF_EFFMON_STATUS_IN          [list  "effmon_status_in"          "effmon_status_in"          "conduit"           "end"     PORT_EFFMON_STATUS_IN               0  [list ]                                                                         ]
   def_enum      IF  IF_EFFMON_AMM_MASTER         [list  "effmon_amm_master"         "effmon_amm_master"         "avalon"            "master"  PORT_EFFMON_AMM_MASTER              0  [list ]                                                                         ]
   def_enum      IF  IF_EFFMON_CSR                [list  "effmon_csr"                "effmon_csr"                "avalon"            "slave"   PORT_EFFMON_CSR                     0  [list ]                                                                         ]
   def_enum      IF  IF_TG_CFG                    [list  "tg_cfg"                    "tg_cfg"                    "avalon"            "slave"   PORT_TG_CFG                         0  [list ]                                                                         ]

   def_enum_type PORT_MEM                      {     RTL_NAME        QSYS_ROLE   QSYS_DIR    IS_BUS  DEFAULT_WIDTH  MAX_WIDTH  IS_AC_CLK  IS_AC   IS_RCLK  IS_CP_RCLK  IS_WCLK  IS_RDATA  IS_WDATA  IS_DM  IS_DBI  IS_NEG_LEG  IS_ASYNC  PORT_INDEX  PROTOCOLS                                                         }
   def_enum      PORT_MEM   PORT_MEM_CK        [list "mem_ck"        ""          "output"    true    1                     16          1      0         0          0         0         0         0      0       0           0         0           0  [list ALL]                                                        ]
   def_enum      PORT_MEM   PORT_MEM_CK_N      [list "mem_ck_n"      ""          "output"    true    1                     16          1      0         0          0         0         0         0      0       0           1         0           0  [list ALL]                                                        ]
   def_enum      PORT_MEM   PORT_MEM_DK        [list "mem_dk"        ""          "output"    true    1                     16          0      0         0          0         1         0         0      0       0           0         0           0  [list PROTOCOL_RLD3]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DK_N      [list "mem_dk_n"      ""          "output"    true    1                     16          0      0         0          0         1         0         0      0       0           1         0           0  [list PROTOCOL_RLD3]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DKA       [list "mem_dka"       ""          "output"    true    1                     16          0      0         0          0         1         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DKA_N     [list "mem_dka_n"     ""          "output"    true    1                     16          0      0         0          0         1         0         0      0       0           1         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DKB       [list "mem_dkb"       ""          "output"    true    1                     16          0      0         0          0         1         0         0      0       0           0         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DKB_N     [list "mem_dkb_n"     ""          "output"    true    1                     16          0      0         0          0         1         0         0      0       0           1         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_K         [list "mem_k"         ""          "output"    true    1                     16          1      0         0          0         1         0         0      0       0           0         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_K_N       [list "mem_k_n"       ""          "output"    true    1                     16          1      0         0          0         1         0         0      0       0           1         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_A         [list "mem_a"         ""          "output"    true    1                     48          0      1         0          0         0         0         0      0       0           0         0           0  [list ALL]                                                        ]
   def_enum      PORT_MEM   PORT_MEM_BA        [list "mem_ba"        ""          "output"    true    1                     16          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3]                  ]
   def_enum      PORT_MEM   PORT_MEM_BG        [list "mem_bg"        ""          "output"    true    1                     16          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_C         [list "mem_c"         ""          "output"    true    1                     16          0      1         0          0         0         0         0      0       0           0         0           0  [list ]                                                           ]
   def_enum      PORT_MEM   PORT_MEM_CKE       [list "mem_cke"       ""          "output"    true    1                     16          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_MEM   PORT_MEM_CS_N      [list "mem_cs_n"      ""          "output"    true    1                     16          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]  ]
   def_enum      PORT_MEM   PORT_MEM_RM        [list "mem_rm"        ""          "output"    true    1                     16          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_RLD3]                                ]
   def_enum      PORT_MEM   PORT_MEM_ODT       [list "mem_odt"       ""          "output"    true    1                     16          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_MEM   PORT_MEM_RAS_N     [list "mem_ras_n"     ""          "output"    true    1                      4          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3]                                              ]
   def_enum      PORT_MEM   PORT_MEM_CAS_N     [list "mem_cas_n"     ""          "output"    true    1                      4          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3]                                              ]
   def_enum      PORT_MEM   PORT_MEM_WE_N      [list "mem_we_n"      ""          "output"    true    1                      4          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_RLD3]                                ]
   def_enum      PORT_MEM   PORT_MEM_RESET_N   [list "mem_reset_n"   ""          "output"    true    1                      4          0      1         0          0         0         0         0      0       0           0         1           0  [list ALL]                                                        ]
   def_enum      PORT_MEM   PORT_MEM_ACT_N     [list "mem_act_n"     ""          "output"    true    1                      4          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_PAR       [list "mem_par"       ""          "output"    true    1                      4          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4]                                ]
   def_enum      PORT_MEM   PORT_MEM_CA        [list "mem_ca"        ""          "output"    true    1                     48          0      1         0          0         0         0         0      0       0           0         0           0  [list ]                                                           ]
   def_enum      PORT_MEM   PORT_MEM_REF_N     [list "mem_ref_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_RLD3]                                              ]
   def_enum      PORT_MEM   PORT_MEM_WPS_N     [list "mem_wps_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_RPS_N     [list "mem_rps_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DOFF_N    [list "mem_doff_n"    ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         1           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_LDA_N     [list "mem_lda_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_LDB_N     [list "mem_ldb_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_RWA_N     [list "mem_rwa_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_RWB_N     [list "mem_rwb_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_LBK0_N    [list "mem_lbk0_n"    ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_LBK1_N    [list "mem_lbk1_n"    ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_CFG_N     [list "mem_cfg_n"     ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_AP        [list "mem_ap"        ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_AINV      [list "mem_ainv"      ""          "output"    true    1                      2          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DM        [list "mem_dm"        ""          "output"    true    1                     36          0      0         0          0         0         0         0      1       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_MEM   PORT_MEM_BWS_N     [list "mem_bws_n"     ""          "output"    true    1                      8          0      0         0          0         0         0         0      1       0           0         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_D         [list "mem_d"         ""          "output"    true    1                    144          0      0         0          0         0         0         1      0       0           0         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DQ        [list "mem_dq"        ""          "bidir"     true    1                    144          0      0         0          0         0         1         1      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]  ]
   def_enum      PORT_MEM   PORT_MEM_DBI_N     [list "mem_dbi_n"     ""          "bidir"     true    1                     18          0      0         0          0         0         0         0      0       1           0         0           0  [list PROTOCOL_DDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DQA       [list "mem_dqa"       ""          "bidir"     true    1                    144          0      0         0          0         0         1         1      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DQB       [list "mem_dqb"       ""          "bidir"     true    1                    144          0      0         0          0         0         1         1      0       0           0         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DINVA     [list "mem_dinva"     ""          "bidir"     true    1                      8          0      0         0          0         0         0         0      0       1           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DINVB     [list "mem_dinvb"     ""          "bidir"     true    1                      8          0      0         0          0         0         0         0      0       1           0         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_Q         [list "mem_q"         ""          "input"     true    1                    144          0      0         0          0         0         1         0      0       0           0         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_DQS       [list "mem_dqs"       ""          "bidir"     true    1                     36          0      0         1          0         1         0         0      0       0           0         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_MEM   PORT_MEM_DQS_N     [list "mem_dqs_n"     ""          "bidir"     true    1                     36          0      0         1          0         1         0         0      0       0           1         0           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_MEM   PORT_MEM_QK        [list "mem_qk"        ""          "input"     true    1                     16          0      0         1          0         0         0         0      0       0           0         0           0  [list PROTOCOL_RLD3]                                              ]
   def_enum      PORT_MEM   PORT_MEM_QK_N      [list "mem_qk_n"      ""          "input"     true    1                     16          0      0         1          0         0         0         0      0       0           1         0           0  [list PROTOCOL_RLD3]                                              ]
   def_enum      PORT_MEM   PORT_MEM_QKA       [list "mem_qka"       ""          "input"     true    1                     16          0      0         1          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_QKA_N     [list "mem_qka_n"     ""          "input"     true    1                     16          0      0         1          0         0         0         0      0       0           1         0           0  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_QKB       [list "mem_qkb"       ""          "input"     true    1                     16          0      0         1          0         0         0         0      0       0           0         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_QKB_N     [list "mem_qkb_n"     ""          "input"     true    1                     16          0      0         1          0         0         0         0      0       0           1         0           1  [list PROTOCOL_QDR4]                                              ]
   def_enum      PORT_MEM   PORT_MEM_CQ        [list "mem_cq"        ""          "input"     true    1                      4          0      0         1          1         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_CQ_N      [list "mem_cq_n"      ""          "input"     true    1                      4          0      0         1          1         0         0         0      0       0           1         0           0  [list PROTOCOL_QDR2]                                              ]
   def_enum      PORT_MEM   PORT_MEM_ALERT_N   [list "mem_alert_n"   ""          "input"     true    1                      4          0      1         0          0         0         0         0      0       0           0         1           0  [list PROTOCOL_DDR3 PROTOCOL_DDR4]                                ]
   def_enum      PORT_MEM   PORT_MEM_PE_N      [list "mem_pe_n"      ""          "input"     true    1                      4          0      1         0          0         0         0         0      0       0           0         0           0  [list PROTOCOL_QDR4]                                              ]

   def_enum_type PORT_GLOBAL_RESET                                                 {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_GLOBAL_RESET              PORT_GLOBAL_RESET_GLOBAL_RESET_N   [list "global_reset_n"                 "reset_n"                "input"    false     1                 ]

   def_enum_type PORT_STATUS                                                       {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_STATUS                    PORT_STATUS_CAL_SUCCESS            [list "local_cal_success"              ""                       "output"   false     1                 ]
   def_enum      PORT_STATUS                    PORT_STATUS_CAL_FAIL               [list "local_cal_fail"                 ""                       "output"   false     1                 ]

   def_enum_type PORT_PLL_REF_CLK                                                  {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH   IS_NEG_LEG   IS_CP_RCLK  }
   def_enum      PORT_PLL_REF_CLK               PORT_PLL_REF_CLK                   [list "pll_ref_clk"                    "clk"                    "input"    false     1                  0            0        ]

   def_enum_type PORT_OCT                                                          {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_OCT                       PORT_OCT_RZQIN                     [list "oct_rzqin"                      ""                       "input"    false     1                 ]

   def_enum_type PORT_VID_CAL_DONE                                                 {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_VID_CAL_DONE              PORT_VID_CAL_DONE_PERSIST          [list "vid_cal_done_persist"           "export"                 "input"    false     1                 ]

   def_enum_type PORT_AFI_RESET                                                    {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     PROTOCOLS                                                                       }
   def_enum      PORT_AFI_RESET                 PORT_AFI_RESET_N                   [list "afi_reset_n"                    "reset_n"                "output"   false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]  ]

   def_enum_type PORT_AFI_CLK                                                      {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     PROTOCOLS                                                                       }
   def_enum      PORT_AFI_CLK                   PORT_AFI_CLK                       [list "afi_clk"                        "clk"                    "output"   false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]  ]

   def_enum_type PORT_AFI_HALF_CLK                                                 {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     PROTOCOLS                                                                       }
   def_enum      PORT_AFI_HALF_CLK              PORT_AFI_HALF_CLK                  [list "afi_half_clk"                   "clk"                    "output"   false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]  ]

   def_enum_type PORT_AFI                                                          {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     PROTOCOLS                                                                       }
   def_enum      PORT_AFI                       PORT_AFI_CAL_SUCCESS               [list "afi_cal_success"                ""                       "output"   false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_CAL_FAIL                  [list "afi_cal_fail"                   ""                       "output"   false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_CAL_REQ                   [list "afi_cal_req"                    ""                       "input"    false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_RLAT                      [list "afi_rlat"                       ""                       "output"   true      6                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_WLAT                      [list "afi_wlat"                       ""                       "output"   true      6                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_SEQ_BUSY                  [list "afi_seq_busy"                   ""                       "output"   true      4                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_CTL_REFRESH_DONE          [list "afi_ctl_refresh_done"           ""                       "input"    false     1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_CTL_LONG_IDLE             [list "afi_ctl_long_idle"              ""                       "input"    false     1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_MPS_REQ                   [list "afi_mps_req"                    ""                       "input"    false     1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_MPS_ACK                   [list "afi_mps_ack"                    ""                       "output"   false     1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_ADDR                      [list "afi_addr"                       ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_BA                        [list "afi_ba"                         ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3]                                ]
   def_enum      PORT_AFI                       PORT_AFI_BG                        [list "afi_bg"                         ""                       "input"    true      1                 [list PROTOCOL_DDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_C                         [list "afi_c"                          ""                       "input"    true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_CKE                       [list "afi_cke"                        ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                              ]
   def_enum      PORT_AFI                       PORT_AFI_CS_N                      [list "afi_cs_n"                       ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_RM                        [list "afi_rm"                         ""                       "input"    true      1                 [list PROTOCOL_DDR3]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_ODT                       [list "afi_odt"                        ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                              ]
   def_enum      PORT_AFI                       PORT_AFI_RAS_N                     [list "afi_ras_n"                      ""                       "input"    true      1                 [list PROTOCOL_DDR3]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_CAS_N                     [list "afi_cas_n"                      ""                       "input"    true      1                 [list PROTOCOL_DDR3]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_WE_N                      [list "afi_we_n"                       ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_RLD3]                                              ]
   def_enum      PORT_AFI                       PORT_AFI_RST_N                     [list "afi_rst_n"                      ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_ACT_N                     [list "afi_act_n"                      ""                       "input"    true      1                 [list PROTOCOL_DDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_PAR                       [list "afi_par"                        ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4]                                              ]
   def_enum      PORT_AFI                       PORT_AFI_CA                        [list "afi_ca"                         ""                       "input"    true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_REF_N                     [list "afi_ref_n"                      ""                       "input"    true      1                 [list PROTOCOL_RLD3]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_WPS_N                     [list "afi_wps_n"                      ""                       "input"    true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_RPS_N                     [list "afi_rps_n"                      ""                       "input"    true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_DOFF_N                    [list "afi_doff_n"                     ""                       "input"    true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_LD_N                      [list "afi_ld_n"                       ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_RW_N                      [list "afi_rw_n"                       ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_LBK0_N                    [list "afi_lbk0_n"                     ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_LBK1_N                    [list "afi_lbk1_n"                     ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_CFG_N                     [list "afi_cfg_n"                      ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_AP                        [list "afi_ap"                         ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_AINV                      [list "afi_ainv"                       ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_DM                        [list "afi_dm"                         ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                              ]
   def_enum      PORT_AFI                       PORT_AFI_DM_N                      [list "afi_dm_n"                       ""                       "input"    true      1                 [list PROTOCOL_DDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_BWS_N                     [list "afi_bws_n"                      ""                       "input"    true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_RDATA_DBI_N               [list "afi_rdata_dbi_n"                ""                       "output"   true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_WDATA_DBI_N               [list "afi_wdata_dbi_n"                ""                       "input"    true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_RDATA_DINV                [list "afi_rdata_dinv"                 ""                       "output"   true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_WDATA_DINV                [list "afi_wdata_dinv"                 ""                       "input"    true      1                 [list PROTOCOL_QDR4]                                                            ]
   def_enum      PORT_AFI                       PORT_AFI_DQS_BURST                 [list "afi_dqs_burst"                  ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_LPDDR3]                              ]
   def_enum      PORT_AFI                       PORT_AFI_WDATA_VALID               [list "afi_wdata_valid"                ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_WDATA                     [list "afi_wdata"                      ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_RDATA_EN_FULL             [list "afi_rdata_en_full"              ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_RDATA                     [list "afi_rdata"                      ""                       "output"   true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_RDATA_VALID               [list "afi_rdata_valid"                ""                       "output"   true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_RRANK                     [list "afi_rrank"                      ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_WRANK                     [list "afi_wrank"                      ""                       "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_RLD3 PROTOCOL_LPDDR3]                ]
   def_enum      PORT_AFI                       PORT_AFI_ALERT_N                   [list "afi_alert_n"                    ""                       "output"   true      1                 [list ]                                                                         ]
   def_enum      PORT_AFI                       PORT_AFI_PE_N                      [list "afi_pe_n"                       ""                       "output"   true      1                 [list PROTOCOL_QDR4]                                                            ]

   def_enum_type PORT_EMIF_USR_RESET                                               {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_RESET            PORT_EMIF_USR_RESET_N              [list "emif_usr_reset_n"               "reset_n"                "output"   false     1                 ]

   def_enum_type PORT_EMIF_USR_CLK                                                 {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_CLK              PORT_EMIF_USR_CLK                  [list "emif_usr_clk"                   "clk"                    "output"   false     1                 ]

   def_enum_type PORT_EMIF_USR_HALF_CLK                                            {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_HALF_CLK         PORT_EMIF_USR_HALF_CLK             [list "emif_usr_half_clk"              "clk"                    "output"   false     1                 ]

   def_enum_type PORT_EMIF_USR_RESET_IN                                            {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_RESET_IN         PORT_EMIF_USR_RESET_N_IN           [list "emif_usr_reset_n_in"            "reset_n"                "input"    false     1                 ]

   def_enum_type PORT_EMIF_USR_CLK_IN                                              {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_CLK_IN           PORT_EMIF_USR_CLK_IN               [list "emif_usr_clk_in"                "clk"                    "input"    false     1                 ]

   def_enum_type PORT_EMIF_USR_HALF_CLK_IN                                         {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_HALF_CLK_IN      PORT_EMIF_USR_HALF_CLK_IN          [list "emif_usr_half_clk_in"           "clk"                    "input"    false     1                 ]

   def_enum_type PORT_EMIF_USR_RESET_SEC                                           {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_RESET_SEC        PORT_EMIF_USR_RESET_N_SEC          [list "emif_usr_reset_n_sec"           "reset_n"                "output"   false     1                 ]

   def_enum_type PORT_EMIF_USR_CLK_SEC                                             {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_CLK_SEC          PORT_EMIF_USR_CLK_SEC              [list "emif_usr_clk_sec"               "clk"                    "output"   false     1                 ]

   def_enum_type PORT_EMIF_USR_HALF_CLK_SEC                                        {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_HALF_CLK_SEC     PORT_EMIF_USR_HALF_CLK_SEC         [list "emif_usr_half_clk_sec"          "clk"                    "output"   false     1                 ]

   def_enum_type PORT_EMIF_USR_RESET_SEC_IN                                        {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_RESET_SEC_IN     PORT_EMIF_USR_RESET_N_SEC_IN       [list "emif_usr_reset_n_sec_in"        "reset_n"                "input"    false     1                 ]

   def_enum_type PORT_EMIF_USR_CLK_SEC_IN                                          {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_CLK_SEC_IN       PORT_EMIF_USR_CLK_SEC_IN           [list "emif_usr_clk_sec_in"            "clk"                    "input"    false     1                 ]

   def_enum_type PORT_EMIF_USR_HALF_CLK_SEC_IN                                     {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_EMIF_USR_HALF_CLK_SEC_IN  PORT_EMIF_USR_HALF_CLK_SEC_IN      [list "emif_usr_half_clk_sec_in"       "clk"                    "input"    false     1                 ]

   def_enum_type PORT_CAL_MASTER_RESET                                             {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_MASTER_RESET          PORT_CAL_MASTER_RESET_N            [list "cal_master_reset_n"             "reset_n"                "output"   false     1                 ]

   def_enum_type PORT_CAL_MASTER_CLK                                               {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_MASTER_CLK            PORT_CAL_MASTER_CLK                [list "cal_master_clk"                 "clk"                    "output"   false     1                 ]

   def_enum_type PORT_CAL_SLAVE_RESET                                              {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_SLAVE_RESET           PORT_CAL_SLAVE_RESET_N             [list "cal_slave_reset_n"              "reset_n"                "output"   false     1                 ]

   def_enum_type PORT_CAL_SLAVE_CLK                                                {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_SLAVE_CLK             PORT_CAL_SLAVE_CLK                 [list "cal_slave_clk"                  "clk"                    "output"   false     1                 ]

   def_enum_type PORT_CAL_SLAVE_RESET_IN                                           {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_SLAVE_RESET_IN        PORT_CAL_SLAVE_RESET_N_IN          [list "cal_slave_reset_n_in"           "reset_n"                "input"    false     1                 ]

   def_enum_type PORT_CAL_SLAVE_CLK_IN                                             {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_SLAVE_CLK_IN          PORT_CAL_SLAVE_CLK_IN              [list "cal_slave_clk_in"               "clk"                    "input"    false     1                 ]

   def_enum_type PORT_CAL_DEBUG_OUT_RESET                                          {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_DEBUG_OUT_RESET       PORT_CAL_DEBUG_OUT_RESET_N         [list "cal_debug_out_reset_n"          "reset_n"                "output"   false     1                 ]

   def_enum_type PORT_CAL_DEBUG_OUT_CLK                                            {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_DEBUG_OUT_CLK         PORT_CAL_DEBUG_OUT_CLK             [list "cal_debug_out_clk"              "clk"                    "output"   false     1                 ]

   def_enum_type PORT_CAL_DEBUG_RESET                                              {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_DEBUG_RESET           PORT_CAL_DEBUG_RESET_N             [list "cal_debug_reset_n"              "reset_n"                "input"    false     1                 ]

   def_enum_type PORT_CAL_DEBUG_CLK                                                {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_DEBUG_CLK             PORT_CAL_DEBUG_CLK                 [list "cal_debug_clk"                  "clk"                    "input"    false     1                 ]

   def_enum_type PORT_CLKS_SHARING_MASTER_OUT                                      {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CLKS_SHARING_MASTER_OUT   PORT_CLKS_SHARING_MASTER_OUT       [list "clks_sharing_master_out"        "clks_sharing"           "output"   true      32                ]

   def_enum_type PORT_CLKS_SHARING_SLAVE_IN                                        {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CLKS_SHARING_SLAVE_IN     PORT_CLKS_SHARING_SLAVE_IN         [list "clks_sharing_slave_in"          "clks_sharing"           "input"    true      32                ]

   def_enum_type PORT_CTRL_AST_CMD                                                 {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_AST_CMD              PORT_CTRL_AST_CMD_DATA             [list "ast_cmd_data"                   "data"                   "input"    true      1                 ]
   def_enum      PORT_CTRL_AST_CMD              PORT_CTRL_AST_CMD_VALID            [list "ast_cmd_valid"                  "valid"                  "input"    false     1                 ]
   def_enum      PORT_CTRL_AST_CMD              PORT_CTRL_AST_CMD_READY            [list "ast_cmd_ready"                  "ready"                  "output"   false     1                 ]

   def_enum_type PORT_CTRL_AST_WR                                                  {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_AST_WR               PORT_CTRL_AST_WR_DATA              [list "ast_wr_data"                    "data"                   "input"    true      1                 ]
   def_enum      PORT_CTRL_AST_WR               PORT_CTRL_AST_WR_VALID             [list "ast_wr_valid"                   "valid"                  "input"    false     1                 ]
   def_enum      PORT_CTRL_AST_WR               PORT_CTRL_AST_WR_READY             [list "ast_wr_ready"                   "ready"                  "output"   false     1                 ]

   def_enum_type PORT_CTRL_AST_RD                                                  {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_AST_RD               PORT_CTRL_AST_RD_DATA              [list "ast_rd_data"                    "data"                   "output"   true      1                 ]
   def_enum      PORT_CTRL_AST_RD               PORT_CTRL_AST_RD_VALID             [list "ast_rd_valid"                   "valid"                  "output"   false     1                 ]
   def_enum      PORT_CTRL_AST_RD               PORT_CTRL_AST_RD_READY             [list "ast_rd_ready"                   "ready"                  "input"    false     1                 ]

   def_enum_type PORT_CTRL_AMM                                                     {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     PROTOCOLS                                                       }
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_READY                [list "amm_ready"                      "waitrequest_n"          "output"   false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_READ                 [list "amm_read"                       "read"                   "input"    false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_WRITE                [list "amm_write"                      "write"                  "input"    false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_ADDRESS              [list "amm_address"                    "address"                "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_RDATA                [list "amm_readdata"                   "readdata"               "output"   true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_WDATA                [list "amm_writedata"                  "writedata"              "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_BCOUNT               [list "amm_burstcount"                 "burstcount"             "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_BYTEEN               [list "amm_byteenable"                 "byteenable"             "input"    true      1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2]                ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_BEGINXFER            [list "amm_beginbursttransfer"         "beginbursttransfer"     "input"    false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]
   def_enum      PORT_CTRL_AMM                  PORT_CTRL_AMM_RDATA_VALID          [list "amm_readdatavalid"              "readdatavalid"          "output"   false     1                 [list PROTOCOL_DDR3 PROTOCOL_DDR4 PROTOCOL_QDR2 PROTOCOL_QDR4]  ]

   def_enum_type PORT_CAL_DEBUG                                                    {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_WAITREQUEST         [list "cal_debug_waitrequest"          "waitrequest"            "output"   false     0                 ]
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_READ                [list "cal_debug_read"                 "read"                   "input"    false     0                 ]
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_WRITE               [list "cal_debug_write"                "write"                  "input"    false     0                 ]
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_ADDRESS             [list "cal_debug_addr"                 "address"                "input"    true      0                 ]
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_RDATA               [list "cal_debug_read_data"            "readdata"               "output"   true      0                 ]
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_WDATA               [list "cal_debug_write_data"           "writedata"              "input"    true      0                 ]
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_BYTEEN              [list "cal_debug_byteenable"           "byteenable"             "input"    true      0                 ]
   def_enum      PORT_CAL_DEBUG                 PORT_CAL_DEBUG_RDATA_VALID         [list "cal_debug_read_data_valid"      "readdatavalid"          "output"   false     0                 ]

   def_enum_type PORT_CAL_DEBUG_OUT                                                {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_WAITREQUEST     [list "cal_debug_out_waitrequest"      "waitrequest"            "input"    false     0                 ]
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_READ            [list "cal_debug_out_read"             "read"                   "output"   false     0                 ]
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_WRITE           [list "cal_debug_out_write"            "write"                  "output"   false     0                 ]
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_ADDRESS         [list "cal_debug_out_addr"             "address"                "output"   true      0                 ]
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_RDATA           [list "cal_debug_out_read_data"        "readdata"               "input"    true      0                 ]
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_WDATA           [list "cal_debug_out_write_data"       "writedata"              "output"   true      0                 ]
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_BYTEEN          [list "cal_debug_out_byteenable"       "byteenable"             "output"   true      0                 ]
   def_enum      PORT_CAL_DEBUG_OUT             PORT_CAL_DEBUG_OUT_RDATA_VALID     [list "cal_debug_out_read_data_valid"  "readdatavalid"          "input"    false     0                 ]

   def_enum_type PORT_CAL_MASTER                                                   {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_WAITREQUEST        [list "cal_master_waitrequest"         "waitrequest"            "input"    false     0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_READ               [list "cal_master_read"                "read"                   "output"   false     0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_WRITE              [list "cal_master_write"               "write"                  "output"   false     0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_ADDRESS            [list "cal_master_addr"                "address"                "output"   true      0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_RDATA              [list "cal_master_read_data"           "readdata"               "input"    true      0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_WDATA              [list "cal_master_write_data"          "writedata"              "output"   true      0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_BYTEEN             [list "cal_master_byteenable"          "byteenable"             "output"   true      0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_RDATA_VALID        [list "cal_master_read_data_valid"     "readdatavalid"          "input"    false     0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_BURSTCOUNT         [list "cal_master_burstcount"          "burstcount"             "output"   false     0                 ]
   def_enum      PORT_CAL_MASTER                PORT_CAL_MASTER_DEBUGACCESS        [list "cal_master_debugaccess"         "debugaccess"            "output"   false     0                 ]

   def_enum_type PORT_VJI                                                          {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_VJI                       PORT_VJI_IR_IN                     [list "vji_ir_in"                      ""                       "input"    true      2                 ]
   def_enum      PORT_VJI                       PORT_VJI_IR_OUT                    [list "vji_ir_out"                     ""                       "output"   true      2                 ]
   def_enum      PORT_VJI                       PORT_VJI_JTAG_STATE_RTI            [list "vji_jtag_state_rti"             ""                       "input"    false     1                 ]
   def_enum      PORT_VJI                       PORT_VJI_TCK                       [list "vji_tck"                        ""                       "input"    false     1                 ]
   def_enum      PORT_VJI                       PORT_VJI_TDI                       [list "vji_tdi"                        ""                       "input"    false     1                 ]
   def_enum      PORT_VJI                       PORT_VJI_TDO                       [list "vji_tdo"                        ""                       "output"   false     1                 ]
   def_enum      PORT_VJI                       PORT_VJI_VIRTUAL_STATE_CDR         [list "vji_virtual_state_cdr"          ""                       "input"    false     1                 ]
   def_enum      PORT_VJI                       PORT_VJI_VIRTUAL_STATE_SDR         [list "vji_virtual_state_sdr"          ""                       "input"    false     1                 ]
   def_enum      PORT_VJI                       PORT_VJI_VIRTUAL_STATE_UDR         [list "vji_virtual_state_udr"          ""                       "input"    false     1                 ]
   def_enum      PORT_VJI                       PORT_VJI_VIRTUAL_STATE_UIR         [list "vji_virtual_state_uir"          ""                       "input"    false     1                 ]

   def_enum_type PORT_CTRL_AUTO_PRECHARGE                                          {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_AUTO_PRECHARGE       PORT_CTRL_AUTO_PRECHARGE_REQ       [list "ctrl_auto_precharge_req"        ""                       "input"    false     1                 ]

   def_enum_type PORT_CTRL_USER_REFRESH                                            {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_USER_REFRESH         PORT_CTRL_USER_REFRESH_REQ         [list "ctrl_user_refresh_req"          ""                       "input"    true      4                 ]
   def_enum      PORT_CTRL_USER_REFRESH         PORT_CTRL_USER_REFRESH_BANK        [list "ctrl_user_refresh_bank"         ""                       "input"    true      16                ]
   def_enum      PORT_CTRL_USER_REFRESH         PORT_CTRL_USER_REFRESH_ACK         [list "ctrl_user_refresh_ack"          ""                       "output"   false     1                 ]

   def_enum_type PORT_CTRL_USER_PRIORITY                                           {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_USER_PRIORITY        PORT_CTRL_USER_PRIORITY_HI         [list "ctrl_user_priority_hi"          ""                       "input"    false     1                 ]

   def_enum_type PORT_CTRL_SELF_REFRESH                                            {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_SELF_REFRESH         PORT_CTRL_SELF_REFRESH_REQ         [list "ctrl_self_refresh_req"          ""                       "input"    true      4                 ]
   def_enum      PORT_CTRL_SELF_REFRESH         PORT_CTRL_SELF_REFRESH_ACK         [list "ctrl_self_refresh_ack"          ""                       "output"   false     1                 ]

   def_enum_type PORT_CTRL_WILL_REFRESH                                            {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_WILL_REFRESH         PORT_CTRL_WILL_REFRESH_SIG         [list "ctrl_will_refresh"              ""                       "output"   false     1                 ]

   def_enum_type PORT_CTRL_DEEP_POWER_DOWN                                         {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_DEEP_POWER_DOWN      PORT_CTRL_DEEP_POWER_DOWN_REQ      [list "ctrl_deep_power_down_req"       ""                       "input"    false     1                 ]
   def_enum      PORT_CTRL_DEEP_POWER_DOWN      PORT_CTRL_DEEP_POWER_DOWN_ACK      [list "ctrl_deep_power_down_ack"       ""                       "output"   false     1                 ]

   def_enum_type PORT_CTRL_POWER_DOWN                                              {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_POWER_DOWN           PORT_CTRL_POWER_DOWN_ACK           [list "ctrl_power_down_ack"            ""                       "output"   false     1                 ]

   def_enum_type PORT_CTRL_ZQ_CAL                                                  {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_ZQ_CAL               PORT_CTRL_ZQ_CAL_LONG_REQ          [list "ctrl_zq_cal_long_req"           ""                       "input"    false     1                 ]
   def_enum      PORT_CTRL_ZQ_CAL               PORT_CTRL_ZQ_CAL_SHORT_REQ         [list "ctrl_zq_cal_short_req"          ""                       "input"    false     1                 ]
   def_enum      PORT_CTRL_ZQ_CAL               PORT_CTRL_ZQ_CAL_ACK               [list "ctrl_zq_cal_ack"                ""                       "output"   false     1                 ]

   def_enum_type PORT_CTRL_ECC                                                     {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_ECC                  PORT_CTRL_ECC_WRITE_INFO           [list "ctrl_ecc_write_info"            ""                       "input"    true      15                ]
   def_enum      PORT_CTRL_ECC                  PORT_CTRL_ECC_RDATA_ID             [list "ctrl_ecc_rdata_id"              ""                       "output"   true      13                ]
   def_enum      PORT_CTRL_ECC                  PORT_CTRL_ECC_READ_INFO            [list "ctrl_ecc_read_info"             ""                       "output"   true      3                 ]
   def_enum      PORT_CTRL_ECC                  PORT_CTRL_ECC_CMD_INFO             [list "ctrl_ecc_cmd_info"              ""                       "output"   true      3                 ]
   def_enum      PORT_CTRL_ECC                  PORT_CTRL_ECC_IDLE                 [list "ctrl_ecc_idle"                  ""                       "output"   false     1                 ]
   def_enum      PORT_CTRL_ECC                  PORT_CTRL_ECC_WB_POINTER           [list "ctrl_ecc_wr_pointer_info"       ""                       "output"   true      12                ]

   def_enum_type PORT_CTRL_ECC_USER_INTERRUPT                                      {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_ECC_USER_INTERRUPT   PORT_CTRL_ECC_USER_INTERRUPT       [list "ctrl_ecc_user_interrupt"        ""                       "output"   false     1                 ]

   def_enum_type PORT_CTRL_MMR_SLAVE                                               {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_WAITREQUEST    [list "mmr_slave_waitrequest"          "waitrequest"            "output"   false     1                 ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_READ           [list "mmr_slave_read"                 "read"                   "input"    false     1                 ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_WRITE          [list "mmr_slave_write"                "write"                  "input"    false     1                 ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_ADDRESS        [list "mmr_slave_address"              "address"                "input"    true      10                ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_RDATA          [list "mmr_slave_readdata"             "readdata"               "output"   true      32                ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_WDATA          [list "mmr_slave_writedata"            "writedata"              "input"    true      32                ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_BCOUNT         [list "mmr_slave_burstcount"           "burstcount"             "input"    true      2                 ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_BEGINXFER      [list "mmr_slave_beginbursttransfer"   "beginbursttransfer"     "input"    false     1                 ]
   def_enum      PORT_CTRL_MMR_SLAVE            PORT_CTRL_MMR_SLAVE_RDATA_VALID    [list "mmr_slave_readdatavalid"        "readdatavalid"          "output"   false     1                 ]

   def_enum_type PORT_CTRL_MMR_MASTER                                              {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_WAITREQUEST   [list "mmr_master_waitrequest"         "waitrequest"            "input"    false     1                 ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_READ          [list "mmr_master_read"                "read"                   "output"   false     1                 ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_WRITE         [list "mmr_master_write"               "write"                  "output"   false     1                 ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_ADDRESS       [list "mmr_master_address"             "address"                "output"   true      10                ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_RDATA         [list "mmr_master_readdata"            "readdata"               "input"    true      32                ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_WDATA         [list "mmr_master_writedata"           "writedata"              "output"   true      32                ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_BCOUNT        [list "mmr_master_burstcount"          "burstcount"             "output"   true      2                 ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_BEGINXFER     [list "mmr_master_beginbursttransfer"  "beginbursttransfer"     "output"   false     1                 ]
   def_enum      PORT_CTRL_MMR_MASTER           PORT_CTRL_MMR_MASTER_RDATA_VALID   [list "mmr_master_readdatavalid"       "readdatavalid"          "input"    false     1                 ]

   def_enum_type PORT_HPS_EMIF                                                     {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_HPS_EMIF                  PORT_HPS_EMIF_H2E                  [list "hps_to_emif"                    "hps_to_emif"            "input"    true      4096              ]
   def_enum      PORT_HPS_EMIF                  PORT_HPS_EMIF_E2H                  [list "emif_to_hps"                    "emif_to_hps"            "output"   true      4096              ]
   def_enum      PORT_HPS_EMIF                  PORT_HPS_EMIF_H2E_GP               [list "hps_to_emif_gp"                 "gp_to_emif"             "input"    true      2                 ]
   def_enum      PORT_HPS_EMIF                  PORT_HPS_EMIF_E2H_GP               [list "emif_to_hps_gp"                 "emif_to_gp"             "output"   true      1                 ]

   def_enum_type PORT_TG_STATUS                                                    {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_TG_STATUS                 PORT_TG_STATUS_PASS                [list "traffic_gen_pass"               "traffic_gen_pass"       "output"   false     1                 ]
   def_enum      PORT_TG_STATUS                 PORT_TG_STATUS_FAIL                [list "traffic_gen_fail"               "traffic_gen_fail"       "output"   false     1                 ]
   def_enum      PORT_TG_STATUS                 PORT_TG_STATUS_TIMEOUT             [list "traffic_gen_timeout"            "traffic_gen_timeout"    "output"   false     1                 ]

   def_enum_type PORT_DFT_NF                                                       {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_IOAUX_PIO_IN           [list "ioaux_pio_in"                   "ioaux_pio_in"           "input"    true      8                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_IOAUX_PIO_OUT          [list "ioaux_pio_out"                  "ioaux_pio_out"          "output"   true      8                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_CLK           [list "pa_dprio_clk"                   "pa_dprio_clk"           "input"    false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_READ          [list "pa_dprio_read"                  "pa_dprio_read"          "input"    false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_REG_ADDR      [list "pa_dprio_reg_addr"              "pa_dprio_reg_addr"      "input"    true      9                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_RST_N         [list "pa_dprio_rst_n"                 "pa_dprio_rst_n"         "input"    false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_WRITE         [list "pa_dprio_write"                 "pa_dprio_write"         "input"    false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_WRITEDATA     [list "pa_dprio_writedata"             "pa_dprio_writedata"     "input"    true      8                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_BLOCK_SELECT  [list "pa_dprio_block_select"          "pa_dprio_block_select"  "output"   false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PA_DPRIO_READDATA      [list "pa_dprio_readdata"              "pa_dprio_readdata"      "output"   true      8                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PLL_PHASE_EN           [list "pll_phase_en"                   "pll_phase_en"           "input"    false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PLL_UPDN               [list "pll_up_dn"                      "pll_up_dn"              "input"    false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PLL_CNTSEL             [list "pll_cnt_sel"                    "pll_cnt_sel"            "input"    true      4                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PLL_NUM_SHIFT          [list "pll_num_phase_shifts"           "pll_num_phase_shifts"   "input"    true      3                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_PLL_PHASE_DONE         [list "pll_phase_done"                 "pll_phase_done"         "output"   false     1                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_CORE_CLK_BUF_OUT       [list "dft_core_clk_buf_out"           "dft_core_clk_buf_out"   "output"   true      2                 ]
   def_enum      PORT_DFT_NF                    PORT_DFT_NF_CORE_CLK_LOCKED        [list "dft_core_clk_locked"            "dft_core_clk_locked"    "output"   true      2                 ]

   def_enum_type PORT_DFT_ND                                                       {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_CLK           [list "pa_dprio_clk"                   "pa_dprio_clk"           "input"    false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_READ          [list "pa_dprio_read"                  "pa_dprio_read"          "input"    false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_REG_ADDR      [list "pa_dprio_reg_addr"              "pa_dprio_reg_addr"      "input"    true      9                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_RST_N         [list "pa_dprio_rst_n"                 "pa_dprio_rst_n"         "input"    false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_WRITE         [list "pa_dprio_write"                 "pa_dprio_write"         "input"    false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_WRITEDATA     [list "pa_dprio_writedata"             "pa_dprio_writedata"     "input"    true      8                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_BLOCK_SELECT  [list "pa_dprio_block_select"          "pa_dprio_block_select"  "output"   false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PA_DPRIO_READDATA      [list "pa_dprio_readdata"              "pa_dprio_readdata"      "output"   true      8                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PLL_PHASE_EN           [list "pll_phase_en"                   "pll_phase_en"           "input"    false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PLL_UPDN               [list "pll_up_dn"                      "pll_up_dn"              "input"    false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PLL_CNTSEL             [list "pll_cnt_sel"                    "pll_cnt_sel"            "input"    true      4                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PLL_NUM_SHIFT          [list "pll_num_phase_shifts"           "pll_num_phase_shifts"   "input"    true      3                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_PLL_PHASE_DONE         [list "pll_phase_done"                 "pll_phase_done"         "output"   false     1                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_CORE_CLK_BUF_OUT       [list "dft_core_clk_buf_out"           "dft_core_clk_buf_out"   "output"   true      2                 ]
   def_enum      PORT_DFT_ND                    PORT_DFT_ND_CORE_CLK_LOCKED        [list "dft_core_clk_locked"            "dft_core_clk_locked"    "output"   true      2                 ]

   def_enum_type PORT_TG_CFG                                                       {     RTL_NAME                         QSYS_ROLE                QSYS_DIR   IS_BUS    DEFAULT_WIDTH     }
   def_enum      PORT_TG_CFG                    PORT_TG_CFG_WAITREQUEST            [list "tg_cfg_waitrequest"             "waitrequest"            "output"   false     1                 ]
   def_enum      PORT_TG_CFG                    PORT_TG_CFG_READ                   [list "tg_cfg_read"                    "read"                   "input"    false     1                 ]
   def_enum      PORT_TG_CFG                    PORT_TG_CFG_WRITE                  [list "tg_cfg_write"                   "write"                  "input"    false     1                 ]
   def_enum      PORT_TG_CFG                    PORT_TG_CFG_ADDRESS                [list "tg_cfg_address"                 "address"                "input"    true      10                ]
   def_enum      PORT_TG_CFG                    PORT_TG_CFG_RDATA                  [list "tg_cfg_readdata"                "readdata"               "output"   true      32                ]
   def_enum      PORT_TG_CFG                    PORT_TG_CFG_WDATA                  [list "tg_cfg_writedata"               "writedata"              "input"    true      32                ]
   def_enum      PORT_TG_CFG                    PORT_TG_CFG_RDATA_VALID            [list "tg_cfg_readdatavalid"           "readdatavalid"          "output"   false     1                 ]
}


proc ::altera_emif::util::enum_defs_interfaces::_init {} {
   ::altera_emif::util::enum_defs_interfaces::def_enums
}

::altera_emif::util::enum_defs_interfaces::_init



