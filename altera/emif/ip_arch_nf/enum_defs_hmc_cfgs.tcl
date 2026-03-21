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


package provide altera_emif::ip_arch_nf::enum_defs_hmc_cfgs 0.1

package require altera_emif::util::enums

namespace eval ::altera_emif::ip_arch_nf::enum_defs_hmc_cfgs:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::ip_arch_nf::enum_defs_hmc_cfgs::def_enums {} {

   def_enum_type HMC_CFG                                      {     WYSIWYG_NAME                          DATA_TYPE            WIDTH  DEFAULT               COMMENT}
   def_enum      HMC_CFG    HMC_CFG_ENABLE_ECC                [list "hmc_*_enable_ecc"                    "string"             0      "disable"             "Enable ECC"]
   def_enum      HMC_CFG    HMC_CFG_REORDER_DATA              [list "hmc_reorder_data"                    "string"             0      "enable"              "Enable command reodering"]
   def_enum      HMC_CFG    HMC_CFG_REORDER_READ              [list "hmc_reorder_read"                    "string"             0      "enable"              "Enable read command reordering if command reordering is enabled"]
   def_enum      HMC_CFG    HMC_CFG_REORDER_RDATA             [list "hmc_*_reorder_rdata"                 "string"             0      "enable"              "Enable in-order read data return when read command reordering is enabled"]
   def_enum      HMC_CFG    HMC_CFG_STARVE_LIMIT              [list "hmc_starve_limit"                    "integer"            6      63                    "When command reordering is enabled, specifies the number of commands that can be served before a starved command is starved."]
   def_enum      HMC_CFG    HMC_CFG_DQS_TRACKING_EN           [list "hmc_enable_dqs_tracking"             "string"             0      "disable"             "Enable DQS tracking"]
   def_enum      HMC_CFG    HMC_CFG_ARBITER_TYPE              [list "hmc_arbiter_type"                    "string"             0      "twot"                "Arbiter Type"]
   def_enum      HMC_CFG    HMC_CFG_OPEN_PAGE_EN              [list "hmc_open_page_en"                    "string"             0      "enable"              "Unused"]
   def_enum      HMC_CFG    HMC_CFG_GEAR_DOWN_EN              [list "hmc_geardn_en"                       "string"             0      "disable"             "Gear-down (DDR4)"]
   def_enum      HMC_CFG    HMC_CFG_RLD3_MULTIBANK_MODE       [list "hmc_rld3_multibank_mode"             "string"             0      "singlebank"          "RLD3 multi-bank mode"]
   def_enum      HMC_CFG    HMC_CFG_PING_PONG_MODE            [list "hmc_cfg_pinpong_mode"                "string"             0      "pingpong_off"        "Ping-Pong PHY mode"]
   def_enum      HMC_CFG    HMC_CFG_SLOT_ROTATE_EN            [list "hmc_*_slot_rotate_en"                "integer"            2      0                     "Command slot rotation"]
   def_enum      HMC_CFG    HMC_CFG_SLOT_OFFSET               [list "hmc_*_slot_offset"                   "integer"            2      0                     "Command slot offset"]
   def_enum      HMC_CFG    HMC_CFG_COL_CMD_SLOT              [list "hmc_col_cmd_slot"                    "integer"            4      2                     "Command slot for column commands"]
   def_enum      HMC_CFG    HMC_CFG_ROW_CMD_SLOT              [list "hmc_row_cmd_slot"                    "integer"            4      1                     "Command slot for row commands"]
   def_enum      HMC_CFG    HMC_CFG_ENABLE_RC                 [list "hmc_*_rc_en"                         "string"             0      "disable"             "Enable rate-conversion feature"]
   def_enum      HMC_CFG    HMC_CFG_CS_TO_CHIP_MAPPING        [list "hmc_cs_chip"                         "integer"           16      33825                 "Chip select mapping scheme"]
   def_enum      HMC_CFG    HMC_CFG_RB_RESERVED_ENTRY         [list "hmc_rb_reserved_entry"               "integer"            7      8                     "Number of entries reserved in read buffer before almost full is asserted. Should be set to 4 + 2 * user_pipe_stages"]
   def_enum      HMC_CFG    HMC_CFG_WB_RESERVED_ENTRY         [list "hmc_wb_reserved_entry"               "integer"            7      8                     "Number of entries reserved in write buffer before almost full is asserted. Should be set to 4 + 2 * user_pipe_stages"]
   def_enum      HMC_CFG    HMC_CFG_TCL                       [list "hmc_tcl"                             "integer"            7      8                     "Memory CAS latency"]
   def_enum      HMC_CFG    HMC_CFG_POWER_SAVING_EXIT_CYC     [list "hmc_power_saving_exit_cycles"        "integer"            6      10                    "The minimum number of cycles to stay in a low power state. This applies to both power down and self-refresh and should be set to the greater of tPD and tCKESR"]
   def_enum      HMC_CFG    HMC_CFG_MEM_CLK_DISABLE_ENTRY_CYC [list "hmc_mem_clk_disable_entry_cycles"    "integer"            6      4                     "Set to a the number of clocks after the execution of an self-refresh to stop the clock.  This register is generally set based on PHY design latency and should generally not be changed"]
   def_enum      HMC_CFG    HMC_CFG_WRITE_ODT_CHIP            [list "hmc_write_odt_chip"                  "integer"           16      47822                 "ODT scheme setting for write command"]
   def_enum      HMC_CFG    HMC_CFG_READ_ODT_CHIP             [list "hmc_read_odt_chip"                   "integer"           16      795                   "ODT scheme setting for read command"]
   def_enum      HMC_CFG    HMC_CFG_WR_ODT_ON                 [list "hmc_wr_odt_on"                       "integer"            6      0                     "Indicates number of memory clock cycle gap between write command and ODT signal rising edge"]
   def_enum      HMC_CFG    HMC_CFG_RD_ODT_ON                 [list "hmc_rd_odt_on"                       "integer"            6      2                     "Indicates number of memory clock cycle gap between read command and ODT signal rising edge"]
   def_enum      HMC_CFG    HMC_CFG_WR_ODT_PERIOD             [list "hmc_wr_odt_period"                   "integer"            6      6                     "Indicates number of memory clock cycle write ODT signal should stay asserted after rising edge"]
   def_enum      HMC_CFG    HMC_CFG_RD_ODT_PERIOD             [list "hmc_rd_odt_period"                   "integer"            6      6                     "Indicates number of memory clock cycle read ODT signal should stay asserted after rising edge"]
   def_enum      HMC_CFG    HMC_CFG_RLD3_REFRESH_SEQ0         [list "hmc_rld3_refresh_seq0"               "integer"           16      15                    "Banks to refresh for RLD3 in sequence 0. Must not be more than 4 banks"]
   def_enum      HMC_CFG    HMC_CFG_RLD3_REFRESH_SEQ1         [list "hmc_rld3_refresh_seq1"               "integer"           16      240                   "Banks to refresh for RLD3 in sequence 1. Must not be more than 4 banks"]
   def_enum      HMC_CFG    HMC_CFG_RLD3_REFRESH_SEQ2         [list "hmc_rld3_refresh_seq2"               "integer"           16      3840                  "Banks to refresh for RLD3 in sequence 2. Must not be more than 4 banks"]
   def_enum      HMC_CFG    HMC_CFG_RLD3_REFRESH_SEQ3         [list "hmc_rld3_refresh_seq3"               "integer"           16      61440                 "Banks to refresh for RLD3 in sequence 3. Must not be more than 4 banks"]
   def_enum      HMC_CFG    HMC_CFG_SRF_ZQCAL_DISABLE         [list "hmc_srf_zqcal_disable"               "string"             0      "disable"             "Setting to disable ZQ Calibration after self refresh"]
   def_enum      HMC_CFG    HMC_CFG_MPS_ZQCAL_DISABLE         [list "hmc_mps_zqcal_disable"               "string"             0      "disable"             "Setting to disable ZQ Calibration after Maximum Power Saving exit"]
   def_enum      HMC_CFG    HMC_CFG_MPS_DQSTRK_DISABLE        [list "hmc_mps_dqstrk_disable"              "string"             0      "disable"             "Setting to disable DQS Tracking after Maximum Power Saving exit"]
   def_enum      HMC_CFG    HMC_CFG_SHORT_DQSTRK_CTRL_EN      [list "hmc_short_dqstrk_ctrl_en"            "string"             0      "disable"             ""]
   def_enum      HMC_CFG    HMC_CFG_PERIOD_DQSTRK_CTRL_EN     [list "hmc_period_dqstrk_ctrl_en"           "string"             0      "disable"             ""]
   def_enum      HMC_CFG    HMC_CFG_PERIOD_DQSTRK_INTERVAL    [list "hmc_period_dqstrk_interval"          "integer"           16      512                   ""]
   def_enum      HMC_CFG    HMC_CFG_DQSTRK_TO_VALID_LAST      [list "hmc_dqstrk_to_valid_last"            "integer"            8      8                     ""]
   def_enum      HMC_CFG    HMC_CFG_DQSTRK_TO_VALID           [list "hmc_dqstrk_to_valid"                 "integer"            8      4                     ""]
   def_enum      HMC_CFG    HMC_CFG_RFSH_WARN_THRESHOLD       [list "hmc_rfsh_warn_threshold"             "integer"            7      4                     ""]
   def_enum      HMC_CFG    HMC_CFG_SB_CG_DISABLE             [list "hmc_sb_cg_disable"                   "string"             0      "disable"             "Setting to disable mem_ck gating during self refresh and deep power down"]
   def_enum      HMC_CFG    HMC_CFG_USER_RFSH_EN              [list "hmc_user_rfsh_en"                    "string"             0      "disable"             "Setting to enable user refresh "]
   def_enum      HMC_CFG    HMC_CFG_SRF_AUTOEXIT_EN           [list "hmc_srf_autoexit_en"                 "string"             0      "disable"             "Setting to enable controller to exit Self Refresh when new command is detected"]
   def_enum      HMC_CFG    HMC_CFG_SRF_ENTRY_EXIT_BLOCK      [list "hmc_srf_entry_exit_block"            "string"             0      "presrfenter"         "Blocking arbiter from issuing commands"]
   def_enum      HMC_CFG    HMC_CFG_SB_DDR4_MR3               [list "hmc_sb_ddr4_mr3"                     "integer"           20      242406                "DDR4 MR3"]
   def_enum      HMC_CFG    HMC_CFG_SB_DDR4_MR4               [list "hmc_sb_ddr4_mr4"                     "integer"           20      961412                "DDR4 MR4"]
   def_enum      HMC_CFG    HMC_CFG_SB_DDR4_MR5               [list "hmc_sb_ddr4_mr5"                     "integer"           16      0                     "DDR4 MR5"]
   def_enum      HMC_CFG    HMC_CFG_DDR4_MPS_ADDR_MIRROR      [list "hmc_ddr4_mps_addr_mirror"            "integer"            1      0                     "DDR4 MPS Address Mirror"]
   def_enum      HMC_CFG    HMC_CFG_MEM_IF_COLADDR_WIDTH      [list "hmc_mem_if_coladdr_width"            "string"             0      "col_width_10"        "Column address width"]
   def_enum      HMC_CFG    HMC_CFG_MEM_IF_ROWADDR_WIDTH      [list "hmc_mem_if_rowaddr_width"            "string"             0      "row_width_13"        "Row address width"]
   def_enum      HMC_CFG    HMC_CFG_MEM_IF_BANKADDR_WIDTH     [list "hmc_mem_if_bankaddr_width"           "string"             0      "bank_width_3"        "Bank address width"]
   def_enum      HMC_CFG    HMC_CFG_MEM_IF_BGADDR_WIDTH       [list "hmc_mem_if_bgaddr_width"             "string"             0      "bg_width_0"          "Bank group address width"]
   def_enum      HMC_CFG    HMC_CFG_LOCAL_IF_CS_WIDTH         [list "hmc_local_if_cs_width"               "string"             0      "cs_width_0"          "Address width in bits required to access every CS in interface"]
   def_enum      HMC_CFG    HMC_CFG_ADDR_ORDER                [list "hmc_addr_order"                      "string"             0      "chip_bank_row_col"   "Mapping of Avalon address to physical address of the memory device"]
   def_enum      HMC_CFG    HMC_CFG_ACT_TO_RDWR               [list "hmc_act_to_rdwr"                     "integer"            6      3                     "Activate to Read/write command timing (e.g. tRCD)"]
   def_enum      HMC_CFG    HMC_CFG_ACT_TO_PCH                [list "hmc_act_to_pch"                      "integer"            6      14                    "Active to precharge (e.g. tRAS)"]
   def_enum      HMC_CFG    HMC_CFG_ACT_TO_ACT                [list "hmc_act_to_act"                      "integer"            6      18                    "Active to activate timing on same bank (e.g. tRC)"]
   def_enum      HMC_CFG    HMC_CFG_ACT_TO_ACT_DIFF_BANK      [list "hmc_act_to_act_diff_bank"            "integer"            6      3                     "Active to activate timing on different banks, for DDR4 same bank group (e.g. tRRD)"]
   def_enum      HMC_CFG    HMC_CFG_ACT_TO_ACT_DIFF_BG        [list "hmc_act_to_act_diff_bg"              "integer"            6      0                     "Active to activate timing on different bank groups, DDR4 only"]
   def_enum      HMC_CFG    HMC_CFG_RD_TO_RD                  [list "hmc_rd_to_rd"                        "integer"            6      2                     "Read to read command timing on same bank (e.g. tCCD)"]
   def_enum      HMC_CFG    HMC_CFG_RD_TO_RD_DIFF_CHIP        [list "hmc_rd_to_rd_diff_chip"              "integer"            6      3                     "Read to read command timing on different chips"]
   def_enum      HMC_CFG    HMC_CFG_RD_TO_RD_DIFF_BG          [list "hmc_rd_to_rd_diff_bg"                "integer"            6      0                     "Read to read command timing on different chips"]
   def_enum      HMC_CFG    HMC_CFG_RD_TO_WR                  [list "hmc_rd_to_wr"                        "integer"            6      3                     "Read to write command timing on same bank"]
   def_enum      HMC_CFG    HMC_CFG_RD_TO_WR_DIFF_CHIP        [list "hmc_rd_to_wr_diff_chip"              "integer"            6      3                     "Read to write command timing on different chips"]
   def_enum      HMC_CFG    HMC_CFG_RD_TO_WR_DIFF_BG          [list "hmc_rd_to_wr_diff_bg"                "integer"            6      0                     "Read to write command timing on different bank groups"]
   def_enum      HMC_CFG    HMC_CFG_RD_TO_PCH                 [list "hmc_rd_to_pch"                       "integer"            6      4                     "Read to precharge command timing (e.g. tRTP)"]
   def_enum      HMC_CFG    HMC_CFG_RD_AP_TO_VALID            [list "hmc_rd_ap_to_valid"                  "integer"            6      8                     "Read command with autoprecharge to data valid timing"]
   def_enum      HMC_CFG    HMC_CFG_WR_TO_WR                  [list "hmc_wr_to_wr"                        "integer"            6      2                     "Write to write command timing on same bank. (e.g. tCCD)"]
   def_enum      HMC_CFG    HMC_CFG_WR_TO_WR_DIFF_CHIP        [list "hmc_wr_to_wr_diff_chip"              "integer"            6      3                     "Write to write command timing on different chips."]
   def_enum      HMC_CFG    HMC_CFG_WR_TO_WR_DIFF_BG          [list "hmc_wr_to_wr_diff_bg"                "integer"            6      0                     "Write to write command timing on different bank groups."]
   def_enum      HMC_CFG    HMC_CFG_WR_TO_RD                  [list "hmc_wr_to_rd"                        "integer"            6      9                     "Write to read command timing. (e.g. tWTR)"]
   def_enum      HMC_CFG    HMC_CFG_WR_TO_RD_DIFF_CHIP        [list "hmc_wr_to_rd_diff_chip"              "integer"            6      7                     "Write to read command timing on different chips."]
   def_enum      HMC_CFG    HMC_CFG_WR_TO_RD_DIFF_BG          [list "hmc_wr_to_rd_diff_bg"                "integer"            6      0                     "Write to read command timing on different bank groups"]
   def_enum      HMC_CFG    HMC_CFG_WR_TO_PCH                 [list "hmc_wr_to_pch"                       "integer"            6      13                    "Write to precharge command timing. (e.g. tWR)"]
   def_enum      HMC_CFG    HMC_CFG_WR_AP_TO_VALID            [list "hmc_wr_ap_to_valid"                  "integer"            6      17                    "Write with autoprecharge to valid command timing."]
   def_enum      HMC_CFG    HMC_CFG_PCH_TO_VALID              [list "hmc_pch_to_valid"                    "integer"            6      4                     "Precharge to valid command timing. (e.g. tRP)"]
   def_enum      HMC_CFG    HMC_CFG_PCH_ALL_TO_VALID          [list "hmc_pch_all_to_valid"                "integer"            6      4                     "Precharge all to banks being ready for bank activation command."]
   def_enum      HMC_CFG    HMC_CFG_ARF_TO_VALID              [list "hmc_arf_to_valid"                    "integer"            8      36                    "Auto Refresh to valid DRAM command window."]
   def_enum      HMC_CFG    HMC_CFG_PDN_TO_VALID              [list "hmc_pdn_to_valid"                    "integer"            6      3                     "Power down to valid bank command window."]
   def_enum      HMC_CFG    HMC_CFG_SRF_TO_VALID              [list "hmc_srf_to_valid"                    "integer"            10     256                   "Self-refresh to valid bank command window. (e.g. tRFC)"]
   def_enum      HMC_CFG    HMC_CFG_SRF_TO_ZQ_CAL             [list "hmc_srf_to_zq_cal"                   "integer"            10     128                   "Self refresh to ZQ calibration window"]
   def_enum      HMC_CFG    HMC_CFG_ARF_PERIOD                [list "hmc_arf_period"                      "integer"            13     3120                  "Auto-refresh period (e.g. tREFI)"]
   def_enum      HMC_CFG    HMC_CFG_PDN_PERIOD                [list "hmc_pdn_period"                      "integer"            16     0                     "Number of controller cycles before automatic power down."]
   def_enum      HMC_CFG    HMC_CFG_ZQCL_TO_VALID             [list "hmc_zqcl_to_valid"                   "integer"            9      128                   "Long ZQ calibration to valid"]
   def_enum      HMC_CFG    HMC_CFG_ZQCS_TO_VALID             [list "hmc_zqcs_to_valid"                   "integer"            7      32                    "Short ZQ calibration to valid"]
   def_enum      HMC_CFG    HMC_CFG_MRS_TO_VALID              [list "hmc_mrs_to_valid"                    "integer"            4      2                     "Mode Register Setting to valid (e.g. tMRD)"]
   def_enum      HMC_CFG    HMC_CFG_MPS_TO_VALID              [list "hmc_mps_to_valid"                    "integer"            10     0                     "Max Power Saving to Valid"]
   def_enum      HMC_CFG    HMC_CFG_MRR_TO_VALID              [list "hmc_mrr_to_valid"                    "integer"            4      0                     "Mode Register Read to Valid"]
   def_enum      HMC_CFG    HMC_CFG_MPR_TO_VALID              [list "hmc_mpr_to_valid"                    "integer"            5      0                     "Multi Purpose Register Read to Valid"]
   def_enum      HMC_CFG    HMC_CFG_MPS_EXIT_CS_TO_CKE        [list "hmc_mps_exit_cs_to_cke"              "integer"            4      0                     "Max Power Saving CS to CKE"]
   def_enum      HMC_CFG    HMC_CFG_MPS_EXIT_CKE_TO_CS        [list "hmc_mps_exit_cke_to_cs"              "integer"            4      0                     "Max Power Saving CKE to CS"]
   def_enum      HMC_CFG    HMC_CFG_RLD3_MULTIBANK_REF_DELAY  [list "hmc_rld3_multibank_ref_delay"        "integer"            3      0                     "RLD3 Multibank Refresh Delay"]
   def_enum      HMC_CFG    HMC_CFG_MMR_CMD_TO_VALID          [list "hmc_mmr_cmd_to_valid"                "integer"            8      4                     "MMR cmd to valid delay"]
   def_enum      HMC_CFG    HMC_CFG_4_ACT_TO_ACT              [list "hmc_4_act_to_act"                    "integer"            8      12                    "The four-activate window timing parameter. (e.g. tFAW)"]
   def_enum      HMC_CFG    HMC_CFG_16_ACT_TO_ACT             [list "hmc_16_act_to_act"                   "integer"            8      0                     "The 16-activate window timing parameter (RLD3) (e.g. tSAW)"]

   def_enum_type HMC_CFG_ADDR_ORDER                                    {            WYSIWYG_NAME }
   def_enum      HMC_CFG_ADDR_ORDER       HMC_CFG_ADDR_ORDER_CS_B_R_C  [list "chip_bank_row_col" ]
   def_enum      HMC_CFG_ADDR_ORDER       HMC_CFG_ADDR_ORDER_CS_R_B_C  [list "chip_row_bank_col" ]
   def_enum      HMC_CFG_ADDR_ORDER       HMC_CFG_ADDR_ORDER_R_CS_B_C  [list "row_chip_bank_col" ]
}


proc ::altera_emif::ip_arch_nf::enum_defs_hmc_cfgs::_init {} {
   ::altera_emif::ip_arch_nf::enum_defs_hmc_cfgs::def_enums
}

::altera_emif::ip_arch_nf::enum_defs_hmc_cfgs::_init

