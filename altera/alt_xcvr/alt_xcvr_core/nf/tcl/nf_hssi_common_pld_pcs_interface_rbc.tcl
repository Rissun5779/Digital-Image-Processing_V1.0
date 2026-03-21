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


proc ::nf_xcvr_native::parameters::validate_hssi_common_pld_pcs_interface_dft_clk_out_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pld_pcs_interface_dft_clk_out_en } {

   set legal_values [list "dft_clk_out_disable" "dft_clk_out_enable"]

   set legal_values [intersect $legal_values [list "dft_clk_out_disable"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pld_pcs_interface_dft_clk_out_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pld_pcs_interface_dft_clk_out_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pld_pcs_interface_dft_clk_out_en $hssi_common_pld_pcs_interface_dft_clk_out_en $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pld_pcs_interface_dft_clk_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pld_pcs_interface_dft_clk_out_sel } {

   set legal_values [list "eightg_rx_dft_clk" "eightg_tx_dft_clk" "pmaif_dft_clk" "teng_rx_dft_clk" "teng_tx_dft_clk"]

   set legal_values [intersect $legal_values [list "teng_rx_dft_clk"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pld_pcs_interface_dft_clk_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pld_pcs_interface_dft_clk_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pld_pcs_interface_dft_clk_out_sel $hssi_common_pld_pcs_interface_dft_clk_out_sel $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pld_pcs_interface_hrdrstctrl_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pld_pcs_interface_hrdrstctrl_en hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "hrst_dis" "hrst_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="eightg_and_g3_reg_mode_hip_tx") }] {
      set legal_values [intersect $legal_values [list "hrst_dis"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en=="enable") }] {
      set legal_values [intersect $legal_values [list "hrst_en"]]
   } else {
      set legal_values [intersect $legal_values [list "hrst_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pld_pcs_interface_hrdrstctrl_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pld_pcs_interface_hrdrstctrl_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pld_pcs_interface_hrdrstctrl_en $hssi_common_pld_pcs_interface_hrdrstctrl_en $legal_values { hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pld_pcs_interface_pcs_testbus_block_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pld_pcs_interface_pcs_testbus_block_sel hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "eightg" "g3pcs" "krfec" "pma_if" "teng"]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="disabled_prot_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "pma_if"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pld_pcs_interface_pcs_testbus_block_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pld_pcs_interface_pcs_testbus_block_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pld_pcs_interface_pcs_testbus_block_sel $hssi_common_pld_pcs_interface_pcs_testbus_block_sel $legal_values { hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx }
   }
}

