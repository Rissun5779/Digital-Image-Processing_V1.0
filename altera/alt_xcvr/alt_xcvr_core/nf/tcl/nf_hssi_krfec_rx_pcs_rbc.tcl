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


proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_blksync_cor_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_blksync_cor_en hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "correct" "detect"]

   if [expr { (((($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode")) }] {
      set legal_values [intersect $legal_values [list "detect"]]
   } else {
      if [expr { (($hssi_krfec_rx_pcs_prot_mode=="basic_mode")&&($hssi_krfec_rx_pcs_sup_mode=="engineering_mode")) }] {
         set legal_values [intersect $legal_values [list "detect" "correct"]]
      } else {
         set legal_values [intersect $legal_values [list "detect"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_blksync_cor_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_blksync_cor_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_blksync_cor_en $hssi_krfec_rx_pcs_blksync_cor_en $legal_values { hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_bypass_gb { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_bypass_gb hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "bypass_dis" "bypass_en"]

   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="basic_mode")&&($hssi_krfec_rx_pcs_sup_mode=="engineering_mode")) }] {
      set legal_values [intersect $legal_values [list "bypass_dis" "bypass_en"]]
   } else {
      set legal_values [intersect $legal_values [list "bypass_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_bypass_gb.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_bypass_gb $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_bypass_gb $hssi_krfec_rx_pcs_bypass_gb $legal_values { hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_clr_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_clr_ctrl hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "both_enabled" "corr_cnt_only" "uncorr_cnt_only"]

   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "both_enabled"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_clr_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_clr_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_clr_ctrl $hssi_krfec_rx_pcs_clr_ctrl $legal_values { hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_ctrl_bit_reverse { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_ctrl_bit_reverse } {

   set legal_values [list "ctrl_bit_reverse_dis" "ctrl_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_ctrl_bit_reverse.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_ctrl_bit_reverse $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_ctrl_bit_reverse $hssi_krfec_rx_pcs_ctrl_bit_reverse $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_data_bit_reverse { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_data_bit_reverse } {

   set legal_values [list "data_bit_reverse_dis" "data_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_data_bit_reverse.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_data_bit_reverse $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_data_bit_reverse $hssi_krfec_rx_pcs_data_bit_reverse $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_dv_start { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_dv_start hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "with_blklock" "with_blksync"]

   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "with_blklock"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_dv_start.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_dv_start $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_dv_start $hssi_krfec_rx_pcs_dv_start $legal_values { hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_err_mark_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_err_mark_type hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode } {

   set legal_values [list "err_mark_10g" "err_mark_40g"]

   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode") }] {
      set legal_values [intersect $legal_values [list "err_mark_10g"]]
   } else {
      if [expr { ($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode") }] {
         set legal_values [intersect $legal_values [list "err_mark_40g"]]
      } else {
         if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode") }] {
            set legal_values [intersect $legal_values [list "err_mark_10g"]]
         } else {
            if [expr { ($hssi_krfec_rx_pcs_prot_mode=="basic_mode") }] {
               if [expr { ($hssi_krfec_rx_pcs_error_marking_en=="err_mark_en") }] {
                  set legal_values [intersect $legal_values [list "err_mark_10g" "err_mark_40g"]]
               } else {
                  set legal_values [intersect $legal_values [list "err_mark_10g"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "err_mark_10g"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_err_mark_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_err_mark_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_err_mark_type $hssi_krfec_rx_pcs_err_mark_type $legal_values { hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_error_marking_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode } {

   set legal_values [list "err_mark_dis" "err_mark_en"]

   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode") }] {
      set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
   } else {
      if [expr { ($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode") }] {
         set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
      } else {
         if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode") }] {
            set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
         } else {
            if [expr { ($hssi_krfec_rx_pcs_prot_mode=="basic_mode") }] {
               set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
            } else {
               set legal_values [intersect $legal_values [list "err_mark_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_error_marking_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_error_marking_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_error_marking_en $hssi_krfec_rx_pcs_error_marking_en $legal_values { hssi_krfec_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_low_latency_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_low_latency_en hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_error_marking_en=="err_mark_en")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ((($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode")||($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode")) }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_low_latency_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_low_latency_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_low_latency_en $hssi_krfec_rx_pcs_low_latency_en $legal_values { hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_lpbk_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_lpbk_mode hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en } {

   set legal_values [list "lpbk_dis" "lpbk_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "lpbk_en"]]
   }
   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_lpbk_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_lpbk_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_lpbk_mode $hssi_krfec_rx_pcs_lpbk_mode $legal_values { hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_parity_invalid_enum { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_parity_invalid_enum hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (((($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode")) }] {
      set legal_values [compare_eq $legal_values 8]
   } else {
      if [expr { (($hssi_krfec_rx_pcs_prot_mode=="basic_mode")&&($hssi_krfec_rx_pcs_sup_mode=="engineering_mode")) }] {
         set legal_values [compare_inside $legal_values [list 0 8 255]]
      } else {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_krfec_rx_pcs_parity_invalid_enum.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_krfec_rx_pcs_parity_invalid_enum $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_krfec_rx_pcs_parity_invalid_enum $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_krfec_rx_pcs_parity_invalid_enum $hssi_krfec_rx_pcs_parity_invalid_enum $legal_values { hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_parity_valid_num { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_parity_valid_num } {

   set legal_values [list 0:15]

   set legal_values [compare_eq $legal_values 4]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_krfec_rx_pcs_parity_valid_num.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_krfec_rx_pcs_parity_valid_num $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_krfec_rx_pcs_parity_valid_num $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_krfec_rx_pcs_parity_valid_num $hssi_krfec_rx_pcs_parity_valid_num $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_blksync { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_blksync hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_blksync.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_blksync $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_blksync $hssi_krfec_rx_pcs_pipeln_blksync $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_descrm { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_descrm hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_descrm.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_descrm $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_descrm $hssi_krfec_rx_pcs_pipeln_descrm $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_errcorrect { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_errcorrect hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_errcorrect.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_errcorrect $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_errcorrect $hssi_krfec_rx_pcs_pipeln_errcorrect $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_errtrap_ind { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_errtrap_ind hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_errtrap_ind.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_errtrap_ind $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_errtrap_ind $hssi_krfec_rx_pcs_pipeln_errtrap_ind $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_errtrap_lfsr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_errtrap_lfsr hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_errtrap_lfsr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_errtrap_lfsr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_errtrap_lfsr $hssi_krfec_rx_pcs_pipeln_errtrap_lfsr $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_errtrap_loc { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_errtrap_loc hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_errtrap_loc.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_errtrap_loc $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_errtrap_loc $hssi_krfec_rx_pcs_pipeln_errtrap_loc $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_errtrap_pat { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_errtrap_pat hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_errtrap_pat.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_errtrap_pat $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_errtrap_pat $hssi_krfec_rx_pcs_pipeln_errtrap_pat $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_gearbox { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_gearbox hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_gearbox.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_gearbox $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_gearbox $hssi_krfec_rx_pcs_pipeln_gearbox $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_syndrm { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_syndrm hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_syndrm.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_syndrm $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_syndrm $hssi_krfec_rx_pcs_pipeln_syndrm $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_pipeln_trans_dec { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_pipeln_trans_dec hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_pipeln_trans_dec.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_pipeln_trans_dec $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_pipeln_trans_dec $hssi_krfec_rx_pcs_pipeln_trans_dec $legal_values { hssi_krfec_rx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx } {

   set legal_values [list "basic_mode" "disable_mode" "fortyg_basekr_mode" "teng_1588_basekr_mode" "teng_basekr_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="teng_basekr_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_basekr_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="fortyg_basekr_mode_rx") }] {
      set legal_values [intersect $legal_values [list "fortyg_basekr_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "basic_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="teng_1588_basekr_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_1588_basekr_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable_mode"]]
   }
   if [expr { ($hssi_krfec_rx_pcs_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "disable_mode" "teng_basekr_mode" "fortyg_basekr_mode" "teng_1588_basekr_mode" "basic_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "disable_mode" "teng_basekr_mode" "fortyg_basekr_mode" "basic_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_prot_mode $hssi_krfec_rx_pcs_prot_mode $legal_values { hssi_krfec_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_receive_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_receive_order } {

   set legal_values [list "receive_lsb" "receive_msb"]

   set legal_values [intersect $legal_values [list "receive_lsb"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_receive_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_receive_order $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_receive_order $hssi_krfec_rx_pcs_receive_order $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_rx_testbus_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_rx_testbus_sel hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode } {

   set legal_values [list "blksync" "blksync_cntrs" "decoder_master_sm" "decoder_master_sm_cntrs" "decoder_rd_sm" "errtrap_ind1" "errtrap_ind2" "errtrap_ind3" "errtrap_ind4" "errtrap_ind5" "errtrap_loc" "errtrap_pat1" "errtrap_pat2" "errtrap_pat3" "errtrap_pat4" "errtrap_sm" "fast_search" "fast_search_cntrs" "gb_and_trans" "overall" "syndrm1" "syndrm2" "syndrm_sm"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode=="tx") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }
   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_rx_testbus_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_rx_testbus_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_rx_testbus_sel $hssi_krfec_rx_pcs_rx_testbus_sel $legal_values { hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_signal_ok_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_signal_ok_en hssi_krfec_rx_pcs_lpbk_mode } {

   set legal_values [list "sig_ok_dis" "sig_ok_en"]

   if [expr { ($hssi_krfec_rx_pcs_lpbk_mode=="lpbk_en") }] {
      set legal_values [intersect $legal_values [list "sig_ok_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "sig_ok_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_signal_ok_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_signal_ok_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_signal_ok_en $hssi_krfec_rx_pcs_signal_ok_en $legal_values { hssi_krfec_rx_pcs_lpbk_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_rx_pcs_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_krfec_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_rx_pcs_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_rx_pcs_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_rx_pcs_sup_mode $hssi_krfec_rx_pcs_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_krfec_sup_mode }
   }
}

