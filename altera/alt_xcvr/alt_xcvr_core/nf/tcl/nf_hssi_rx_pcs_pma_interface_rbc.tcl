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


proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_block_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_block_sel hssi_rx_pcs_pma_interface_pma_dw_rx hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "direct_pld" "eight_g_pcs" "ten_g_pcs"]

   if [expr { ((($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_krfec_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_basic_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_sfis_sdi_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "ten_g_pcs"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="pcs_direct_mode_rx") }] {
         if [expr { (((($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_8b_rx")||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_20b_rx")) }] {
            set legal_values [intersect $legal_values [list "direct_pld"]]
         } else {
            set legal_values [intersect $legal_values [list "direct_pld"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "eight_g_pcs"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_block_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_block_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_block_sel $hssi_rx_pcs_pma_interface_block_sel $legal_values { hssi_rx_pcs_pma_interface_pma_dw_rx hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_channel_operation_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_channel_operation_mode hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_channel_operation_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_channel_operation_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_channel_operation_mode $hssi_rx_pcs_pma_interface_channel_operation_mode $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_clkslip_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_clkslip_sel hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx } {

   set legal_values [list "pld" "slip_eight_g_pcs"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx") }] {
      set legal_values [intersect $legal_values [list "slip_eight_g_pcs"]]
   } else {
      set legal_values [intersect $legal_values [list "pld"]]
   }
   if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "slip_eight_g_pcs" "pld"]]
   } else {
      set legal_values [intersect $legal_values [list "pld"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_clkslip_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_clkslip_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_clkslip_sel $hssi_rx_pcs_pma_interface_clkslip_sel $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_lpbk_en hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_lpbk_en $hssi_rx_pcs_pma_interface_lpbk_en $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_master_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_master_clk_sel hssi_rx_pcs_pma_interface_rx_lpbk_en hssi_rx_pcs_pma_interface_sup_mode } {

   set legal_values [list "master_refclk_dig" "master_rx_pma_clk" "master_tx_pma_clk"]

   if [expr { ($hssi_rx_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_rx_pcs_pma_interface_rx_lpbk_en=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "master_tx_pma_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "master_rx_pma_clk"]]
      }
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_rx_lpbk_en=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "master_tx_pma_clk" "master_refclk_dig"]]
      } else {
         set legal_values [intersect $legal_values [list "master_rx_pma_clk" "master_refclk_dig"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_master_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_master_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_master_clk_sel $hssi_rx_pcs_pma_interface_master_clk_sel $legal_values { hssi_rx_pcs_pma_interface_rx_lpbk_en hssi_rx_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_pldif_datawidth_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_pldif_datawidth_mode hssi_rx_pcs_pma_interface_pma_dw_rx hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "pldif_data_10bit" "pldif_data_8bit"]

   if [expr { ((($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_krfec_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_basic_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_sfis_sdi_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="pcs_direct_mode_rx") }] {
         if [expr { (((($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_8b_rx")||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_20b_rx")) }] {
            set legal_values [intersect $legal_values [list "pldif_data_8bit"]]
         } else {
            set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_pldif_datawidth_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_pldif_datawidth_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_pldif_datawidth_mode $hssi_rx_pcs_pma_interface_pldif_datawidth_mode $legal_values { hssi_rx_pcs_pma_interface_pma_dw_rx hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_pma_dw_rx hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_8b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_8b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_10b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_10b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_16b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_16b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_20b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_20b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_32b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_32b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_40b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_40b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_64b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pcie_g3_dyn_dw_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_pma_dw_rx $hssi_rx_pcs_pma_interface_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_pma_if_dft_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_pma_if_dft_en } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_pma_if_dft_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_pma_if_dft_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_pma_if_dft_en $hssi_rx_pcs_pma_interface_pma_if_dft_en $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_pma_if_dft_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_pma_if_dft_val } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_pma_if_dft_val.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_pma_if_dft_val $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_pma_if_dft_val $hssi_rx_pcs_pma_interface_pma_if_dft_val $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_prbs9_dwidth { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_prbs9_dwidth hssi_rx_pcs_pma_interface_prbs_ver } {

   set legal_values [list "prbs9_10b" "prbs9_64b"]

   if [expr { ($hssi_rx_pcs_pma_interface_prbs_ver=="prbs_9") }] {
      set legal_values [intersect $legal_values [list "prbs9_64b" "prbs9_10b"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs9_64b"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_prbs9_dwidth.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_prbs9_dwidth $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_prbs9_dwidth $hssi_rx_pcs_pma_interface_prbs9_dwidth $legal_values { hssi_rx_pcs_pma_interface_prbs_ver }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_prbs_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_prbs_clken hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "prbs_clk_dis" "prbs_clk_en"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbs_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_clk_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_prbs_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_prbs_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_prbs_clken $hssi_rx_pcs_pma_interface_prbs_clken $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_prbs_ver { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_prbs_ver hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "prbs_15" "prbs_23" "prbs_31" "prbs_7" "prbs_9" "prbs_off"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbs_31" "prbs_15" "prbs_23" "prbs_9" "prbs_7"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_prbs_ver.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_prbs_ver $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_prbs_ver $hssi_rx_pcs_pma_interface_prbs_ver $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx } {

   set legal_values [list "disabled_prot_mode_rx" "eightg_basic_mode_rx" "eightg_g3_pcie_g3_hip_mode_rx" "eightg_g3_pcie_g3_pld_mode_rx" "eightg_only_pld_mode_rx" "eightg_pcie_g12_hip_mode_rx" "eightg_pcie_g12_pld_mode_rx" "pcs_direct_mode_rx" "prbs_mode_rx" "teng_basic_mode_rx" "teng_krfec_mode_rx" "teng_sfis_sdi_mode_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="pcs_direct_mode_rx") }] {
      set legal_values [intersect $legal_values [list "pcs_direct_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_only_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_only_pld_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_pld_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_hip_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_basic_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_basic_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_sfis_sdi_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbs_mode_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_lpbk_en hssi_rx_pcs_pma_interface_lpbk_en hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "lpbk_dis" "lpbk_en"]

   if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "lpbk_en"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "lpbk_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "lpbk_dis"]]
      }
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_lpbk_en $hssi_rx_pcs_pma_interface_rx_lpbk_en $legal_values { hssi_rx_pcs_pma_interface_lpbk_en hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_prbs_force_signal_ok { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_prbs_force_signal_ok hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "force_sig_ok" "unforce_sig_ok"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "unforce_sig_ok" "force_sig_ok"]]
   } else {
      set legal_values [intersect $legal_values [list "force_sig_ok"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_prbs_force_signal_ok.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_prbs_force_signal_ok $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_prbs_force_signal_ok $hssi_rx_pcs_pma_interface_rx_prbs_force_signal_ok $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_prbs_mask { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_prbs_mask hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "prbsmask1024" "prbsmask128" "prbsmask256" "prbsmask512"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbsmask128" "prbsmask256" "prbsmask512" "prbsmask1024"]]
   } else {
      set legal_values [intersect $legal_values [list "prbsmask128"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_prbs_mask.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_prbs_mask $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_prbs_mask $hssi_rx_pcs_pma_interface_rx_prbs_mask $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_prbs_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_prbs_mode hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "eightg_mode" "teng_mode"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_mode" "eightg_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "teng_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_prbs_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_prbs_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_prbs_mode $hssi_rx_pcs_pma_interface_rx_prbs_mode $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_signalok_signaldet_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_signalok_signaldet_sel hssi_rx_pcs_pma_interface_sup_mode } {

   set legal_values [list "sel_sig_det" "sel_sig_ok"]

   if [expr { ($hssi_rx_pcs_pma_interface_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "sel_sig_det"]]
   } else {
      set legal_values [intersect $legal_values [list "sel_sig_det" "sel_sig_ok"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_signalok_signaldet_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_signalok_signaldet_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_signalok_signaldet_sel $hssi_rx_pcs_pma_interface_rx_signalok_signaldet_sel $legal_values { hssi_rx_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en hssi_rx_pcs_pma_interface_lpbk_en } {

   set legal_values [list "uhsif_lpbk_dis" "uhsif_lpbk_en"]

   if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "uhsif_lpbk_en" "uhsif_lpbk_dis"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "uhsif_lpbk_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "uhsif_lpbk_dis"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en $hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en $legal_values { hssi_rx_pcs_pma_interface_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pcs_pma_interface_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_sup_mode hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_sup_mode $hssi_rx_pcs_pma_interface_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pcs_pma_interface_rx_static_polarity_inversion hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pcs_pma_interface_rx_static_polarity_inversion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $hssi_rx_pcs_pma_interface_rx_static_polarity_inversion $legal_values { hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en }
   }
}


