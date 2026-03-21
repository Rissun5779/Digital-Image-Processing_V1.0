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


proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_asn_clk_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_asn_clk_enable hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_asn_clk_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_asn_clk_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_asn_clk_enable $hssi_common_pcs_pma_interface_asn_clk_enable $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_asn_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "dis_asn" "en_asn"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_asn"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "dis_asn"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "en_asn" "dis_asn"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_asn_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_asn_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_asn_enable $hssi_common_pcs_pma_interface_asn_enable $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_block_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_block_sel hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "eight_g_pcs" "pcie_gen3"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "pcie_gen3"]]
   } else {
      set legal_values [intersect $legal_values [list "eight_g_pcs"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_block_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_block_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_block_sel $hssi_common_pcs_pma_interface_block_sel $legal_values { hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_bypass_early_eios { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_bypass_early_eios hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_bypass_early_eios.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_bypass_early_eios $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_bypass_early_eios $hssi_common_pcs_pma_interface_bypass_early_eios $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_bypass_pcie_switch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_bypass_pcie_switch hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_bypass_pcie_switch.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_bypass_pcie_switch $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_bypass_pcie_switch $hssi_common_pcs_pma_interface_bypass_pcie_switch $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_bypass_pma_ltr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_bypass_pma_ltr hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_bypass_pma_ltr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_bypass_pma_ltr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_bypass_pma_ltr $hssi_common_pcs_pma_interface_bypass_pma_ltr $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_bypass_pma_sw_done { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_bypass_pma_sw_done hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { (($hssi_common_pcs_pma_interface_sup_mode=="user_mode")||($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode")) }] {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_bypass_pma_sw_done.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_bypass_pma_sw_done $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_bypass_pma_sw_done $hssi_common_pcs_pma_interface_bypass_pma_sw_done $legal_values { hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_bypass_ppm_lock { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_bypass_ppm_lock hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3"))||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_bypass_ppm_lock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_bypass_ppm_lock $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_bypass_ppm_lock $hssi_common_pcs_pma_interface_bypass_ppm_lock $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_bypass_send_syncp_fbkp { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_bypass_send_syncp_fbkp hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3") }] {
            set legal_values [intersect $legal_values [list "true"]]
         } else {
            if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
               set legal_values [intersect $legal_values [list "true"]]
            }
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_bypass_send_syncp_fbkp.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_bypass_send_syncp_fbkp $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_bypass_send_syncp_fbkp $hssi_common_pcs_pma_interface_bypass_send_syncp_fbkp $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_bypass_txdetectrx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_bypass_txdetectrx hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_bypass_txdetectrx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_bypass_txdetectrx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_bypass_txdetectrx $hssi_common_pcs_pma_interface_bypass_txdetectrx $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_cdr_control { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "dis_cdr_ctrl" "en_cdr_ctrl"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_cdr_ctrl"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_cdr_ctrl"]]
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_cdr_ctrl" "en_cdr_ctrl"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_cdr_control.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_cdr_control $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_cdr_control $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_cid_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_cid_enable hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "dis_cid_mode" "en_cid_mode"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
         set legal_values [intersect $legal_values [list "en_cid_mode"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="dis_cdr_ctrl") }] {
            set legal_values [intersect $legal_values [list "dis_cid_mode"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_cid_mode" "en_cid_mode"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_cid_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_cid_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_cid_enable $hssi_common_pcs_pma_interface_cid_enable $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_cp_cons_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_cp_cons_sel hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "cp_cons_default" "cp_cons_master" "cp_cons_slave_abv" "cp_cons_slave_blw"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "cp_cons_master"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "cp_cons_master"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "cp_cons_master"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "cp_cons_slave_blw"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "cp_cons_slave_abv"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_cp_cons_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_cp_cons_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_cp_cons_sel $hssi_common_pcs_pma_interface_cp_cons_sel $legal_values { hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_cp_dwn_mstr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_cp_dwn_mstr hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_cp_dwn_mstr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_cp_dwn_mstr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_cp_dwn_mstr $hssi_common_pcs_pma_interface_cp_dwn_mstr $legal_values { hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_cp_up_mstr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_cp_up_mstr hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_cp_up_mstr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_cp_up_mstr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_cp_up_mstr $hssi_common_pcs_pma_interface_cp_up_mstr $legal_values { hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ctrl_plane_bonding { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding } {

   set legal_values [list "ctrl_master" "ctrl_slave_abv" "ctrl_slave_blw" "individual"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "individual"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "ctrl_master"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "ctrl_slave_abv"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "ctrl_slave_blw"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ctrl_plane_bonding.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ctrl_plane_bonding $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ctrl_plane_bonding $hssi_common_pcs_pma_interface_ctrl_plane_bonding $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode hssi_common_pcs_pma_interface_data_mask_count_multi } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_common_pcs_pma_interface_data_mask_count  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_common_pcs_pma_interface_data_mask_count_multi  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_dft_observation_clock_selection { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_dft_observation_clock_selection } {

   set legal_values [list "dft_clk_obsrv_asn0" "dft_clk_obsrv_asn1" "dft_clk_obsrv_clklow" "dft_clk_obsrv_fref" "dft_clk_obsrv_hclk" "dft_clk_obsrv_rx" "dft_clk_obsrv_tx0" "dft_clk_obsrv_tx1" "dft_clk_obsrv_tx2" "dft_clk_obsrv_tx3" "dft_clk_obsrv_tx4"]

   set legal_values [intersect $legal_values [list "dft_clk_obsrv_tx0"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_dft_observation_clock_selection.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_dft_observation_clock_selection $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_dft_observation_clock_selection $hssi_common_pcs_pma_interface_dft_observation_clock_selection $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_early_eios_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_early_eios_counter hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:255]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 50]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 50]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_early_eios_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_early_eios_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_early_eios_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_early_eios_counter $hssi_common_pcs_pma_interface_early_eios_counter $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_force_freqdet { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_force_freqdet hssi_common_pcs_pma_interface_ppm_det_buckets } {

   set legal_values [list "force0_freqdet_en" "force1_freqdet_en" "force_freqdet_dis"]

   if [expr { ($hssi_common_pcs_pma_interface_ppm_det_buckets=="disable_prot") }] {
      set legal_values [intersect $legal_values [list "force1_freqdet_en"]]
   } else {
      set legal_values [intersect $legal_values [list "force_freqdet_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_force_freqdet.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_force_freqdet $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_force_freqdet $hssi_common_pcs_pma_interface_force_freqdet $legal_values { hssi_common_pcs_pma_interface_ppm_det_buckets }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_free_run_clk_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_free_run_clk_enable hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_free_run_clk_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_free_run_clk_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_free_run_clk_enable $hssi_common_pcs_pma_interface_free_run_clk_enable $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ignore_sigdet_g23 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ignore_sigdet_g23 hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ignore_sigdet_g23.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ignore_sigdet_g23 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ignore_sigdet_g23 $hssi_common_pcs_pma_interface_ignore_sigdet_g23 $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_pc_en_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_pc_en_counter hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:127]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 55]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 55]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_pc_en_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_pc_en_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_pc_en_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_pc_en_counter $hssi_common_pcs_pma_interface_pc_en_counter $legal_values { hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_pc_rst_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_pc_rst_counter hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 23]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 23]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_pc_rst_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_pc_rst_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_pc_rst_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_pc_rst_counter $hssi_common_pcs_pma_interface_pc_rst_counter $legal_values { hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_pcie_hip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_pcie_hip_mode hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "hip_disable" "hip_enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "hip_disable"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx") }] {
         set legal_values [intersect $legal_values [list "hip_disable"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx") }] {
            set legal_values [intersect $legal_values [list "hip_enable"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx") }] {
               set legal_values [intersect $legal_values [list "hip_disable"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx") }] {
                  set legal_values [intersect $legal_values [list "hip_enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "hip_disable"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_pcie_hip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_pcie_hip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_pcie_hip_mode $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ph_fifo_reg_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ph_fifo_reg_mode hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "phfifo_reg_mode_dis" "phfifo_reg_mode_en"]

   if [expr { ((($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3"))&&($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable")) }] {
      set legal_values [intersect $legal_values [list "phfifo_reg_mode_en"]]
   } else {
      set legal_values [intersect $legal_values [list "phfifo_reg_mode_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ph_fifo_reg_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ph_fifo_reg_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ph_fifo_reg_mode $hssi_common_pcs_pma_interface_ph_fifo_reg_mode $legal_values { hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_phfifo_flush_wait { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_phfifo_flush_wait hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:63]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 36]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 36]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_phfifo_flush_wait.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_phfifo_flush_wait $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_phfifo_flush_wait $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_phfifo_flush_wait $hssi_common_pcs_pma_interface_phfifo_flush_wait $legal_values { hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_pipe_if_g3pcs { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_pipe_if_g3pcs hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "pipe_if_8gpcs" "pipe_if_g3pcs"]

   if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")||($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable")) }] {
      set legal_values [intersect $legal_values [list "pipe_if_g3pcs"]]
   } else {
      set legal_values [intersect $legal_values [list "pipe_if_8gpcs"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_pipe_if_g3pcs.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_pipe_if_g3pcs $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_pipe_if_g3pcs $hssi_common_pcs_pma_interface_pipe_if_g3pcs $legal_values { hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_pma_done_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_pma_done_counter hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:262143]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 200]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 175000]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_pma_done_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_pma_done_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_pma_done_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_pma_done_counter $hssi_common_pcs_pma_interface_pma_done_counter $legal_values { hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_pma_if_dft_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_pma_if_dft_en } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_pma_if_dft_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_pma_if_dft_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_pma_if_dft_en $hssi_common_pcs_pma_interface_pma_if_dft_en $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_pma_if_dft_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_pma_if_dft_val } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_pma_if_dft_val.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_pma_if_dft_val $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_pma_if_dft_val $hssi_common_pcs_pma_interface_pma_if_dft_val $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ppm_cnt_rst { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ppm_cnt_rst } {

   set legal_values [list "ppm_cnt_rst_dis" "ppm_cnt_rst_en"]

   set legal_values [intersect $legal_values [list "ppm_cnt_rst_dis"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ppm_cnt_rst.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ppm_cnt_rst $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ppm_cnt_rst $hssi_common_pcs_pma_interface_ppm_cnt_rst $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ppm_deassert_early { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ppm_deassert_early hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "deassert_early_dis" "deassert_early_en"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "deassert_early_en"]]
   } else {
      set legal_values [intersect $legal_values [list "deassert_early_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ppm_deassert_early.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ppm_deassert_early $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ppm_deassert_early $hssi_common_pcs_pma_interface_ppm_deassert_early $legal_values { hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ppm_det_buckets { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ppm_det_buckets hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx } {

   set legal_values [list "disable_prot" "ppm_100_bucket" "ppm_300_100_bucket" "ppm_300_bucket"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable_prot"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="pcs_direct_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_only_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_sfis_sdi_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ppm_det_buckets.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ppm_det_buckets $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ppm_det_buckets $hssi_common_pcs_pma_interface_ppm_det_buckets $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ppm_gen1_2_cnt { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ppm_gen1_2_cnt hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "cnt_32k" "cnt_64k"]

   if [expr { (($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode")&&($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")) }] {
      set legal_values [intersect $legal_values [list "cnt_32k" "cnt_64k"]]
   } else {
      set legal_values [intersect $legal_values [list "cnt_32k"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ppm_gen1_2_cnt.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ppm_gen1_2_cnt $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ppm_gen1_2_cnt $hssi_common_pcs_pma_interface_ppm_gen1_2_cnt $legal_values { hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ppm_post_eidle_delay { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ppm_post_eidle_delay hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "cnt_200_cycles" "cnt_400_cycles"]

   if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "cnt_200_cycles" "cnt_400_cycles"]]
   } else {
      set legal_values [intersect $legal_values [list "cnt_200_cycles"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ppm_post_eidle_delay.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ppm_post_eidle_delay $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ppm_post_eidle_delay $hssi_common_pcs_pma_interface_ppm_post_eidle_delay $legal_values { hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_ppmsel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_ppmsel hssi_common_pcs_pma_interface_ppm_det_buckets hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "ppmsel_100" "ppmsel_1000" "ppmsel_125" "ppmsel_200" "ppmsel_250" "ppmsel_2500" "ppmsel_300" "ppmsel_500" "ppmsel_5000" "ppmsel_62p5" "ppmsel_disable" "ppm_other"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_ppm_det_buckets=="disable_prot") }] {
         set legal_values [intersect $legal_values [list "ppm_other"]]
      } else {
         set legal_values [intersect $legal_values [list "ppmsel_100" "ppmsel_300" "ppmsel_500" "ppmsel_1000" "ppmsel_5000"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "ppm_other" "ppmsel_62p5" "ppmsel_100" "ppmsel_125" "ppmsel_200" "ppmsel_250" "ppmsel_300" "ppmsel_500" "ppmsel_1000" "ppmsel_2500" "ppmsel_5000"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_ppmsel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_ppmsel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_ppmsel $hssi_common_pcs_pma_interface_ppmsel $legal_values { hssi_common_pcs_pma_interface_ppm_det_buckets hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_prot_mode hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "disable_prot_mode" "other_protocols" "pipe_g12" "pipe_g3"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disable_prot_mode"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx") }] {
         set legal_values [intersect $legal_values [list "pipe_g12"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx") }] {
            set legal_values [intersect $legal_values [list "pipe_g12"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx") }] {
               set legal_values [intersect $legal_values [list "pipe_g3"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx") }] {
                  set legal_values [intersect $legal_values [list "pipe_g3"]]
               } else {
                  set legal_values [intersect $legal_values [list "other_protocols"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_prot_mode $hssi_common_pcs_pma_interface_prot_mode $legal_values { hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_rxvalid_mask { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_rxvalid_mask hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "rxvalid_mask_dis" "rxvalid_mask_en"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
         set legal_values [intersect $legal_values [list "rxvalid_mask_en"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="dis_cdr_ctrl") }] {
            set legal_values [intersect $legal_values [list "rxvalid_mask_dis"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "rxvalid_mask_dis" "rxvalid_mask_en"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_rxvalid_mask.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_rxvalid_mask $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_rxvalid_mask $hssi_common_pcs_pma_interface_rxvalid_mask $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_sigdet_wait_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_sigdet_wait_counter hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:4095]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 200]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_sigdet_wait_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_sigdet_wait_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_sigdet_wait_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_sigdet_wait_counter $hssi_common_pcs_pma_interface_sigdet_wait_counter $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_sigdet_wait_counter_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_sigdet_wait_counter_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_sigdet_wait_counter_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_sigdet_wait_counter_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_sigdet_wait_counter_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_sigdet_wait_counter_multi $hssi_common_pcs_pma_interface_sigdet_wait_counter_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_sim_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_sim_mode hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_sim_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_sim_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_sim_mode $hssi_common_pcs_pma_interface_sim_mode $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_spd_chg_rst_wait_cnt_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_spd_chg_rst_wait_cnt_en hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_spd_chg_rst_wait_cnt_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_spd_chg_rst_wait_cnt_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_spd_chg_rst_wait_cnt_en $hssi_common_pcs_pma_interface_spd_chg_rst_wait_cnt_en $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_sup_mode hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode } {

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
         ip_set "parameter.hssi_common_pcs_pma_interface_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_sup_mode $hssi_common_pcs_pma_interface_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_testout_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_testout_sel hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "asn_test" "pma_pll_test" "ppm_det_test" "prbs_gen_test" "prbs_ver_test" "rxpmaif_test" "uhsif_1_test" "uhsif_2_test" "uhsif_3_test"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "ppm_det_test"]]
   } else {
      set legal_values [intersect $legal_values [list "ppm_det_test" "asn_test" "pma_pll_test" "rxpmaif_test" "prbs_gen_test" "prbs_ver_test" "uhsif_1_test" "uhsif_2_test" "uhsif_3_test"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_common_pcs_pma_interface_testout_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_common_pcs_pma_interface_testout_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_common_pcs_pma_interface_testout_sel $hssi_common_pcs_pma_interface_testout_sel $legal_values { hssi_common_pcs_pma_interface_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_wait_clk_on_off_timer { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_wait_clk_on_off_timer hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:15]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 0]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 0]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_wait_clk_on_off_timer.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_wait_clk_on_off_timer $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_wait_clk_on_off_timer $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_wait_clk_on_off_timer $hssi_common_pcs_pma_interface_wait_clk_on_off_timer $legal_values { hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_wait_pipe_synchronizing { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_wait_pipe_synchronizing hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 23]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 23]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_wait_pipe_synchronizing.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_wait_pipe_synchronizing $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_wait_pipe_synchronizing $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_wait_pipe_synchronizing $hssi_common_pcs_pma_interface_wait_pipe_synchronizing $legal_values { hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_common_pcs_pma_interface_wait_send_syncp_fbkp { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_wait_send_syncp_fbkp hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:2047]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 125]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 250]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_wait_send_syncp_fbkp.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_wait_send_syncp_fbkp $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_wait_send_syncp_fbkp $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_wait_send_syncp_fbkp $hssi_common_pcs_pma_interface_wait_send_syncp_fbkp $legal_values { hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode }
   }
}

proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_inside $legal_values [list 2500 58334]]
            if [expr { ($hssi_common_pcs_pma_interface_data_mask_count_multi==1) }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               if [expr { ($hssi_common_pcs_pma_interface_data_mask_count_multi==3) }] {
                  set legal_values [compare_eq $legal_values 58334]
               }
            }
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_inside $legal_values [list 1 3]]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_common_pcs_pma_interface_data_mask_count { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count $hssi_common_pcs_pma_interface_data_mask_count $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_common_pcs_pma_interface_data_mask_count_multi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
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

         ip_set "parameter.hssi_common_pcs_pma_interface_data_mask_count_multi.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_data_mask_count_multi $legal_values { hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode }
   }
}


