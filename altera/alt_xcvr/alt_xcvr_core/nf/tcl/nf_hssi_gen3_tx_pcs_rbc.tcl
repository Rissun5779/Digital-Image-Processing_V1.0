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


proc ::nf_xcvr_native::parameters::validate_hssi_gen3_tx_pcs_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_tx_pcs_mode hssi_tx_pld_pcs_interface_hd_g3_prot_mode } {

   set legal_values [list "disable_pcs" "gen3_func"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g1") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g2") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "gen3_func"]]
   }
   set legal_values [intersect $legal_values [list "gen3_func" "disable_pcs"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_tx_pcs_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_tx_pcs_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_tx_pcs_mode $hssi_gen3_tx_pcs_mode $legal_values { hssi_tx_pld_pcs_interface_hd_g3_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_tx_pcs_reverse_lpbk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_tx_pcs_reverse_lpbk hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode } {

   set legal_values [list "rev_lpbk_dis" "rev_lpbk_en"]

   if [expr { ($hssi_gen3_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_tx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "rev_lpbk_en"]]
      } else {
         if [expr { ($hssi_gen3_tx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "rev_lpbk_dis"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "rev_lpbk_dis" "rev_lpbk_en"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_tx_pcs_reverse_lpbk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_tx_pcs_reverse_lpbk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_tx_pcs_reverse_lpbk $hssi_gen3_tx_pcs_reverse_lpbk $legal_values { hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_tx_pcs_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_tx_pcs_sup_mode hssi_tx_pld_pcs_interface_hd_g3_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_g3_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_tx_pcs_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_tx_pcs_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_tx_pcs_sup_mode $hssi_gen3_tx_pcs_sup_mode $legal_values { hssi_tx_pld_pcs_interface_hd_g3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_tx_pcs_tx_bitslip { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_tx_pcs_tx_bitslip hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_gen3_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_tx_pcs_mode=="gen3_func") }] {
         set legal_values [compare_eq $legal_values 0]
      } else {
         if [expr { ($hssi_gen3_tx_pcs_mode=="disable_pcs") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_gen3_tx_pcs_tx_bitslip.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_gen3_tx_pcs_tx_bitslip $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_gen3_tx_pcs_tx_bitslip $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_gen3_tx_pcs_tx_bitslip $hssi_gen3_tx_pcs_tx_bitslip $legal_values { hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_tx_pcs_tx_gbox_byp { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_tx_pcs_tx_gbox_byp hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode } {

   set legal_values [list "bypass_gbox" "enable_gbox"]

   if [expr { ($hssi_gen3_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_tx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "enable_gbox"]]
      } else {
         if [expr { ($hssi_gen3_tx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "bypass_gbox"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bypass_gbox" "enable_gbox"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_tx_pcs_tx_gbox_byp.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_tx_pcs_tx_gbox_byp $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_tx_pcs_tx_gbox_byp $hssi_gen3_tx_pcs_tx_gbox_byp $legal_values { hssi_gen3_tx_pcs_mode hssi_gen3_tx_pcs_sup_mode }
   }
}

