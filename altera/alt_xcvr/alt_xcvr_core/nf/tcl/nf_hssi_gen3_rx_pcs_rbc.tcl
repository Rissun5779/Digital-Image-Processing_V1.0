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


proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_block_sync { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_block_sync hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "bypass_block_sync" "enable_block_sync"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "enable_block_sync"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "bypass_block_sync"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bypass_block_sync" "enable_block_sync"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_block_sync.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_block_sync $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_block_sync $hssi_gen3_rx_pcs_block_sync $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_block_sync_sm { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_block_sync_sm hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "disable_blk_sync_sm" "enable_blk_sync_sm"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "enable_blk_sync_sm"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "disable_blk_sync_sm"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "disable_blk_sync_sm" "enable_blk_sync_sm"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_block_sync_sm.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_block_sync_sm $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_block_sync_sm $hssi_gen3_rx_pcs_block_sync_sm $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_cdr_ctrl_force_unalgn { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_cdr_ctrl_force_unalgn hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "disable"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "enable" "disable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_cdr_ctrl_force_unalgn.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_cdr_ctrl_force_unalgn $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_cdr_ctrl_force_unalgn $hssi_gen3_rx_pcs_cdr_ctrl_force_unalgn $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_lpbk_force { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_lpbk_force hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "lpbk_frce_dis" "lpbk_frce_en"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "lpbk_frce_en"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "lpbk_frce_dis"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "lpbk_frce_en" "lpbk_frce_dis"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_lpbk_force.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_lpbk_force $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_lpbk_force $hssi_gen3_rx_pcs_lpbk_force $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_mode hssi_rx_pld_pcs_interface_hd_g3_prot_mode } {

   set legal_values [list "disable_pcs" "gen3_func"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g1") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g2") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "gen3_func"]]
   }
   set legal_values [intersect $legal_values [list "gen3_func" "disable_pcs"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_mode $hssi_gen3_rx_pcs_mode $legal_values { hssi_rx_pld_pcs_interface_hd_g3_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_rate_match_fifo { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_rate_match_fifo hssi_8g_rx_pcs_rate_match hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx } {

   set legal_values [list "bypass_rm_fifo" "enable_rm_fifo_0ppm" "enable_rm_fifo_600ppm"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm") }] {
         set legal_values [intersect $legal_values [list "enable_rm_fifo_600ppm"]]
      }
      if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm") }] {
         set legal_values [intersect $legal_values [list "enable_rm_fifo_0ppm"]]
      }
   }
   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "enable_rm_fifo_600ppm" "enable_rm_fifo_0ppm"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "bypass_rm_fifo"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bypass_rm_fifo" "enable_rm_fifo_600ppm" "enable_rm_fifo_0ppm"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_rate_match_fifo.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_rate_match_fifo $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_rate_match_fifo $hssi_gen3_rx_pcs_rate_match_fifo $legal_values { hssi_8g_rx_pcs_rate_match hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_rate_match_fifo_latency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_rate_match_fifo_latency hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "low_latency" "regular_latency"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "regular_latency"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "low_latency"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "regular_latency" "low_latency"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_rate_match_fifo_latency.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_rate_match_fifo_latency $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_rate_match_fifo_latency $hssi_gen3_rx_pcs_rate_match_fifo_latency $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_reverse_lpbk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_reverse_lpbk hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "rev_lpbk_dis" "rev_lpbk_en"]

   if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
      set legal_values [intersect $legal_values [list "rev_lpbk_en"]]
   } else {
      if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
         set legal_values [intersect $legal_values [list "rev_lpbk_dis"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "rev_lpbk_dis" "rev_lpbk_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_reverse_lpbk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_reverse_lpbk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_reverse_lpbk $hssi_gen3_rx_pcs_reverse_lpbk $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_rx_b4gb_par_lpbk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_rx_b4gb_par_lpbk hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "b4gb_par_lpbk_dis" "b4gb_par_lpbk_en"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "b4gb_par_lpbk_dis"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "b4gb_par_lpbk_dis"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "b4gb_par_lpbk_dis" "b4gb_par_lpbk_en"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_rx_b4gb_par_lpbk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_rx_b4gb_par_lpbk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_rx_b4gb_par_lpbk $hssi_gen3_rx_pcs_rx_b4gb_par_lpbk $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_rx_force_balign { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_rx_force_balign hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "dis_force_balign" "en_force_balign"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "en_force_balign"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "dis_force_balign"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "en_force_balign" "dis_force_balign"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_rx_force_balign.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_rx_force_balign $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_rx_force_balign $hssi_gen3_rx_pcs_rx_force_balign $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_rx_ins_del_one_skip { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_rx_ins_del_one_skip hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "ins_del_one_skip_dis" "ins_del_one_skip_en"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "ins_del_one_skip_en"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "ins_del_one_skip_dis"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "ins_del_one_skip_dis" "ins_del_one_skip_en"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_rx_ins_del_one_skip.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_rx_ins_del_one_skip $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_rx_ins_del_one_skip $hssi_gen3_rx_pcs_rx_ins_del_one_skip $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_rx_num_fixed_pat { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_rx_num_fixed_pat hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list 0:15]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [compare_eq $legal_values 8]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
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

         ip_set "parameter.hssi_gen3_rx_pcs_rx_num_fixed_pat.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_gen3_rx_pcs_rx_num_fixed_pat $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_gen3_rx_pcs_rx_num_fixed_pat $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_gen3_rx_pcs_rx_num_fixed_pat $hssi_gen3_rx_pcs_rx_num_fixed_pat $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_rx_test_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_rx_test_out_sel hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode } {

   set legal_values [list "rx_test_out0" "rx_test_out1"]

   if [expr { ($hssi_gen3_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_gen3_rx_pcs_mode=="gen3_func") }] {
         set legal_values [intersect $legal_values [list "rx_test_out0"]]
      } else {
         if [expr { ($hssi_gen3_rx_pcs_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "rx_test_out0"]]
         }
      }
   } else {
      if [expr { ($hssi_gen3_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "rx_test_out0" "rx_test_out1"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_rx_test_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_rx_test_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_rx_test_out_sel $hssi_gen3_rx_pcs_rx_test_out_sel $legal_values { hssi_gen3_rx_pcs_mode hssi_gen3_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_gen3_rx_pcs_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_gen3_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_g3_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_gen3_rx_pcs_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_gen3_rx_pcs_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_gen3_rx_pcs_sup_mode $hssi_gen3_rx_pcs_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_g3_sup_mode }
   }
}

