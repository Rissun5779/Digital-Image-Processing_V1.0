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


proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_bypass_pma_txelecidle { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_bypass_pma_txelecidle hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="other_prot_mode")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_bypass_pma_txelecidle.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_bypass_pma_txelecidle $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_bypass_pma_txelecidle $hssi_tx_pcs_pma_interface_bypass_pma_txelecidle $legal_values { hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_channel_operation_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_channel_operation_mode hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_channel_operation_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_channel_operation_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_channel_operation_mode $hssi_tx_pcs_pma_interface_channel_operation_mode $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_lpbk_en hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_lpbk_en $hssi_tx_pcs_pma_interface_lpbk_en $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_master_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_master_clk_sel hssi_tx_pcs_pma_interface_sup_mode } {

   set legal_values [list "master_refclk_dig" "master_tx_pma_clk"]

   if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "master_tx_pma_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "master_tx_pma_clk" "master_refclk_dig"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_master_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_master_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_master_clk_sel $hssi_tx_pcs_pma_interface_master_clk_sel $legal_values { hssi_tx_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "other_prot_mode" "pipe_g12" "pipe_g3"]

   if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "pipe_g12"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "pipe_g3"]]
      } else {
         set legal_values [intersect $legal_values [list "other_prot_mode"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_pldif_datawidth_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_pldif_datawidth_mode hssi_tx_pcs_pma_interface_pma_dw_tx hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "pldif_data_10bit" "pldif_data_8bit"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="pcs_direct_mode_tx") }] {
      if [expr { (((($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_8b_tx")||($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_20b_tx")) }] {
         set legal_values [intersect $legal_values [list "pldif_data_8bit"]]
      } else {
         set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_pldif_datawidth_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_pldif_datawidth_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_pldif_datawidth_mode $hssi_tx_pcs_pma_interface_pldif_datawidth_mode $legal_values { hssi_tx_pcs_pma_interface_pma_dw_tx hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_pma_dw_tx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_pma_dw_tx hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_8b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_8b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_10b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_10b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_16b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_16b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_20b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_20b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_32b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_32b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_40b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_40b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_64b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pcie_g3_dyn_dw_tx") }] {
      set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_pma_dw_tx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_pma_dw_tx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_pma_dw_tx $hssi_tx_pcs_pma_interface_pma_dw_tx $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_pma_if_dft_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_pma_if_dft_en } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_pma_if_dft_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_pma_if_dft_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_pma_if_dft_en $hssi_tx_pcs_pma_interface_pma_if_dft_en $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_pmagate_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_pmagate_en hssi_tx_pcs_pma_interface_lpbk_en hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "pmagate_dis" "pmagate_en"]

   if [expr { (($hssi_tx_pcs_pma_interface_lpbk_en=="enable")&&((($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_krfec_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_basic_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_sfis_sdi_mode_tx"))) }] {
      set legal_values [intersect $legal_values [list "pmagate_dis" "pmagate_en"]]
   } else {
      set legal_values [intersect $legal_values [list "pmagate_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_pmagate_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_pmagate_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_pmagate_en $hssi_tx_pcs_pma_interface_pmagate_en $legal_values { hssi_tx_pcs_pma_interface_lpbk_en hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_prbs9_dwidth { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_prbs9_dwidth hssi_tx_pcs_pma_interface_prbs_gen_pat } {

   set legal_values [list "prbs9_10b" "prbs9_64b"]

   if [expr { ($hssi_tx_pcs_pma_interface_prbs_gen_pat=="prbs_9") }] {
      set legal_values [intersect $legal_values [list "prbs9_64b" "prbs9_10b"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs9_64b"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_prbs9_dwidth.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_prbs9_dwidth $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_prbs9_dwidth $hssi_tx_pcs_pma_interface_prbs9_dwidth $legal_values { hssi_tx_pcs_pma_interface_prbs_gen_pat }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_prbs_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_prbs_clken hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "prbs_clk_dis" "prbs_clk_en"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="prbs_mode_tx") }] {
      set legal_values [intersect $legal_values [list "prbs_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_clk_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_prbs_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_prbs_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_prbs_clken $hssi_tx_pcs_pma_interface_prbs_clken $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_prbs_gen_pat { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_prbs_gen_pat hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "prbs_15" "prbs_23" "prbs_31" "prbs_7" "prbs_9" "prbs_gen_dis"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="prbs_mode_tx") }] {
      set legal_values [intersect $legal_values [list "prbs_31" "prbs_23" "prbs_15" "prbs_9" "prbs_7"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_gen_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_prbs_gen_pat.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_prbs_gen_pat $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_prbs_gen_pat $hssi_tx_pcs_pma_interface_prbs_gen_pat $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_prot_mode_tx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "disabled_prot_mode_tx" "eightg_basic_mode_tx" "eightg_g3_pcie_g3_hip_mode_tx" "eightg_g3_pcie_g3_pld_mode_tx" "eightg_only_pld_mode_tx" "eightg_pcie_g12_hip_mode_tx" "eightg_pcie_g12_pld_mode_tx" "pcs_direct_mode_tx" "prbs_mode_tx" "sqwave_mode_tx" "teng_basic_mode_tx" "teng_krfec_mode_tx" "teng_sfis_sdi_mode_tx" "uhsif_direct_mode_tx" "uhsif_reg_mode_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="pcs_direct_mode_tx") }] {
      set legal_values [intersect $legal_values [list "pcs_direct_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_reg_mode_tx") }] {
      set legal_values [intersect $legal_values [list "uhsif_reg_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_direct_mode_tx") }] {
      set legal_values [intersect $legal_values [list "uhsif_direct_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_only_pld_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_only_pld_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_pld_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_hip_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_krfec_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_basic_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_basic_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_basic_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_basic_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_sfis_sdi_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="prbs_mode_tx") }] {
      set legal_values [intersect $legal_values [list "prbs_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="sqwave_mode_tx") }] {
      set legal_values [intersect $legal_values [list "sqwave_mode_tx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_prot_mode_tx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_prot_mode_tx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_sq_wave_num { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_sq_wave_num hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "sq_wave_1" "sq_wave_4" "sq_wave_6" "sq_wave_8" "sq_wave_default"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="sqwave_mode_tx") }] {
      set legal_values [intersect $legal_values [list "sq_wave_1" "sq_wave_4" "sq_wave_6" "sq_wave_8"]]
   } else {
      set legal_values [intersect $legal_values [list "sq_wave_default"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_sq_wave_num.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_sq_wave_num $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_sq_wave_num $hssi_tx_pcs_pma_interface_sq_wave_num $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_sqwgen_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_sqwgen_clken hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "sqwgen_clk_dis" "sqwgen_clk_en"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="sqwave_mode_tx") }] {
      set legal_values [intersect $legal_values [list "sqwgen_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "sqwgen_clk_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_sqwgen_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_sqwgen_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_sqwgen_clken $hssi_tx_pcs_pma_interface_sqwgen_clken $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_sup_mode $hssi_tx_pcs_pma_interface_sup_mode $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_tx_pma_data_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_pma_data_sel hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "block_sel_default" "directed_uhsif_dat" "eight_g_pcs" "pcie_gen3" "pld_dir" "prbs_pat" "registered_uhsif_dat" "sq_wave_pat" "ten_g_pcs"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="pcs_direct_mode_tx") }] {
      set legal_values [intersect $legal_values [list "pld_dir"]]
   } else {
      if [expr { (((($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "eight_g_pcs"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "pcie_gen3"]]
         } else {
            if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_krfec_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_basic_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_sfis_sdi_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "ten_g_pcs"]]
            } else {
               if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="prbs_mode_tx") }] {
                  set legal_values [intersect $legal_values [list "prbs_pat"]]
               } else {
                  if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="sqwave_mode_tx") }] {
                     set legal_values [intersect $legal_values [list "sq_wave_pat"]]
                  } else {
                     if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx") }] {
                        set legal_values [intersect $legal_values [list "registered_uhsif_dat"]]
                     } else {
                        if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx") }] {
                           set legal_values [intersect $legal_values [list "directed_uhsif_dat"]]
                        } else {
                           set legal_values [intersect $legal_values [list "pld_dir"]]
                        }
                     }
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_pma_data_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_pma_data_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_pma_data_sel $hssi_tx_pcs_pma_interface_tx_pma_data_sel $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_cnt_step_filt_before_lock { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_cnt_step_filt_before_lock hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_filt_stepsz_b4lock_2" "uhsif_filt_stepsz_b4lock_4" "uhsif_filt_stepsz_b4lock_6" "uhsif_filt_stepsz_b4lock_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_filt_stepsz_b4lock_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_filt_stepsz_b4lock_2" "uhsif_filt_stepsz_b4lock_4" "uhsif_filt_stepsz_b4lock_6" "uhsif_filt_stepsz_b4lock_8"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_filt_stepsz_b4lock_2"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_cnt_step_filt_before_lock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_cnt_step_filt_before_lock $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_cnt_step_filt_before_lock $hssi_tx_pcs_pma_interface_uhsif_cnt_step_filt_before_lock $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 11]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value $hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_before_lock { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_before_lock hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_filt_cntthr_b4lock_16" "uhsif_filt_cntthr_b4lock_24" "uhsif_filt_cntthr_b4lock_32" "uhsif_filt_cntthr_b4lock_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_filt_cntthr_b4lock_16"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_filt_cntthr_b4lock_8" "uhsif_filt_cntthr_b4lock_16" "uhsif_filt_cntthr_b4lock_24" "uhsif_filt_cntthr_b4lock_32"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_filt_cntthr_b4lock_8"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_before_lock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_before_lock $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_before_lock $hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_before_lock $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dcn_test_update_period { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dcn_test_update_period hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dcn_test_period_12" "uhsif_dcn_test_period_16" "uhsif_dcn_test_period_4" "uhsif_dcn_test_period_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dcn_test_period_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dcn_test_period_4" "uhsif_dcn_test_period_8" "uhsif_dcn_test_period_12" "uhsif_dcn_test_period_16"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dcn_test_period_4"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dcn_test_update_period.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dcn_test_update_period $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dcn_test_update_period $hssi_tx_pcs_pma_interface_uhsif_dcn_test_update_period $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dcn_testmode_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dcn_testmode_enable hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dcn_test_mode_disable" "uhsif_dcn_test_mode_enable"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dcn_test_mode_disable"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dcn_test_mode_enable" "uhsif_dcn_test_mode_disable"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dcn_test_mode_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dcn_testmode_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dcn_testmode_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dcn_testmode_enable $hssi_tx_pcs_pma_interface_uhsif_dcn_testmode_enable $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dead_zone_count_thresh { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dead_zone_count_thresh hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_cnt_thr_2" "uhsif_dzt_cnt_thr_4" "uhsif_dzt_cnt_thr_6" "uhsif_dzt_cnt_thr_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_cnt_thr_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_cnt_thr_2" "uhsif_dzt_cnt_thr_4" "uhsif_dzt_cnt_thr_6" "uhsif_dzt_cnt_thr_8"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_cnt_thr_2"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dead_zone_count_thresh.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dead_zone_count_thresh $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dead_zone_count_thresh $hssi_tx_pcs_pma_interface_uhsif_dead_zone_count_thresh $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dead_zone_detection_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dead_zone_detection_enable hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_disable" "uhsif_dzt_enable"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_enable"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_enable" "uhsif_dzt_disable"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dead_zone_detection_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dead_zone_detection_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dead_zone_detection_enable $hssi_tx_pcs_pma_interface_uhsif_dead_zone_detection_enable $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dead_zone_obser_window { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dead_zone_obser_window hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_obr_win_16" "uhsif_dzt_obr_win_32" "uhsif_dzt_obr_win_48" "uhsif_dzt_obr_win_64"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_obr_win_32"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_obr_win_16" "uhsif_dzt_obr_win_32" "uhsif_dzt_obr_win_48" "uhsif_dzt_obr_win_64"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_obr_win_16"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dead_zone_obser_window.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dead_zone_obser_window $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dead_zone_obser_window $hssi_tx_pcs_pma_interface_uhsif_dead_zone_obser_window $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dead_zone_skip_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dead_zone_skip_size hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_skipsz_12" "uhsif_dzt_skipsz_16" "uhsif_dzt_skipsz_4" "uhsif_dzt_skipsz_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_skipsz_8"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_skipsz_4" "uhsif_dzt_skipsz_8" "uhsif_dzt_skipsz_12" "uhsif_dzt_skipsz_16"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_skipsz_4"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dead_zone_skip_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dead_zone_skip_size $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dead_zone_skip_size $hssi_tx_pcs_pma_interface_uhsif_dead_zone_skip_size $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_delay_cell_index_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_delay_cell_index_sel hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_index_cram" "uhsif_index_internal"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_index_internal"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_index_internal" "uhsif_index_cram"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_index_cram"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_delay_cell_index_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_delay_cell_index_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_delay_cell_index_sel $hssi_tx_pcs_pma_interface_uhsif_delay_cell_index_sel $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_delay_cell_margin { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_delay_cell_margin hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dcn_margin_2" "uhsif_dcn_margin_3" "uhsif_dcn_margin_4" "uhsif_dcn_margin_5"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dcn_margin_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dcn_margin_2" "uhsif_dcn_margin_3" "uhsif_dcn_margin_4" "uhsif_dcn_margin_5"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dcn_margin_2"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_delay_cell_margin.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_delay_cell_margin $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_delay_cell_margin $hssi_tx_pcs_pma_interface_uhsif_delay_cell_margin $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:255]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 128]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value $hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dft_dead_zone_control { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dft_dead_zone_control hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dft_dz_det_val_0" "uhsif_dft_dz_det_val_1"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dft_dz_det_val_0"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dft_dz_det_val_0" "uhsif_dft_dz_det_val_1"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dft_dz_det_val_0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dft_dead_zone_control.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dft_dead_zone_control $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dft_dead_zone_control $hssi_tx_pcs_pma_interface_uhsif_dft_dead_zone_control $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_dft_up_filt_control { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_dft_up_filt_control hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dft_up_val_0" "uhsif_dft_up_val_1"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dft_up_val_0"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dft_up_val_0" "uhsif_dft_up_val_1"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dft_up_val_0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_dft_up_filt_control.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_dft_up_filt_control $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_dft_up_filt_control $hssi_tx_pcs_pma_interface_uhsif_dft_up_filt_control $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_enable hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "uhsif_disable" "uhsif_enable"]

   if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "uhsif_enable"]]
   } else {
      set legal_values [intersect $legal_values [list "uhsif_disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_enable $hssi_tx_pcs_pma_interface_uhsif_enable $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_after_lock { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_after_lock hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_lkd_segsz_aflock_1024" "uhsif_lkd_segsz_aflock_2048" "uhsif_lkd_segsz_aflock_4096" "uhsif_lkd_segsz_aflock_512"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_aflock_2048"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_aflock_512" "uhsif_lkd_segsz_aflock_1024" "uhsif_lkd_segsz_aflock_2048" "uhsif_lkd_segsz_aflock_4096"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_aflock_512"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_after_lock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_after_lock $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_after_lock $hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_after_lock $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_before_lock { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_before_lock hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_lkd_segsz_b4lock_128" "uhsif_lkd_segsz_b4lock_16" "uhsif_lkd_segsz_b4lock_32" "uhsif_lkd_segsz_b4lock_64"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_b4lock_32"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_b4lock_16" "uhsif_lkd_segsz_b4lock_32" "uhsif_lkd_segsz_b4lock_64" "uhsif_lkd_segsz_b4lock_128"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_b4lock_16"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_before_lock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_before_lock $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_before_lock $hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_before_lock $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value $hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value $hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 3]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value $hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 3]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value $hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value $legal_values { hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable }
   }
}

proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_tx_pcs_pma_interface_tx_static_polarity_inversion hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_tx_pcs_pma_interface_tx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $hssi_tx_pcs_pma_interface_tx_static_polarity_inversion $legal_values { hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


