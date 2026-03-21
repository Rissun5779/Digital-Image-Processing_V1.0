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


proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_bypass_rx_detection_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_bypass_rx_detection_enable hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_bypass_rx_detection_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_bypass_rx_detection_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_bypass_rx_detection_enable $hssi_pipe_gen3_bypass_rx_detection_enable $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_bypass_rx_preset { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_bypass_rx_preset hssi_pipe_gen3_bypass_rx_preset_enable } {

   set legal_values [list 0:7]

   if [expr { ($hssi_pipe_gen3_bypass_rx_preset_enable=="false") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen3_bypass_rx_preset.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen3_bypass_rx_preset $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen3_bypass_rx_preset $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen3_bypass_rx_preset $hssi_pipe_gen3_bypass_rx_preset $legal_values { hssi_pipe_gen3_bypass_rx_preset_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_bypass_rx_preset_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_bypass_rx_preset_enable hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_bypass_rx_preset_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_bypass_rx_preset_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_bypass_rx_preset_enable $hssi_pipe_gen3_bypass_rx_preset_enable $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_bypass_tx_coefficent { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_bypass_tx_coefficent hssi_pipe_gen3_bypass_tx_coefficent_enable } {

   set legal_values [list 0:262143]

   if [expr { ($hssi_pipe_gen3_bypass_tx_coefficent_enable=="false") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen3_bypass_tx_coefficent.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen3_bypass_tx_coefficent $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen3_bypass_tx_coefficent $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen3_bypass_tx_coefficent $hssi_pipe_gen3_bypass_tx_coefficent $legal_values { hssi_pipe_gen3_bypass_tx_coefficent_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_bypass_tx_coefficent_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_bypass_tx_coefficent_enable hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_bypass_tx_coefficent_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_bypass_tx_coefficent_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_bypass_tx_coefficent_enable $hssi_pipe_gen3_bypass_tx_coefficent_enable $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_elecidle_delay_g3 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_elecidle_delay_g3 hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [compare_eq $legal_values 6]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
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

         ip_set "parameter.hssi_pipe_gen3_elecidle_delay_g3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen3_elecidle_delay_g3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen3_elecidle_delay_g3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen3_elecidle_delay_g3 $hssi_pipe_gen3_elecidle_delay_g3 $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_ind_error_reporting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_ind_error_reporting hssi_pipe_gen1_2_ind_error_reporting hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "dis_ind_error_reporting" "en_ind_error_reporting"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
      if [expr { ($hssi_pipe_gen1_2_ind_error_reporting=="dis_ind_error_reporting") }] {
         set legal_values [intersect $legal_values [list "dis_ind_error_reporting"]]
      }
      if [expr { ($hssi_pipe_gen1_2_ind_error_reporting=="en_ind_error_reporting") }] {
         set legal_values [intersect $legal_values [list "en_ind_error_reporting"]]
      }
   }
   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "dis_ind_error_reporting" "en_ind_error_reporting"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "dis_ind_error_reporting"]]
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_ind_error_reporting" "en_ind_error_reporting"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_ind_error_reporting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_ind_error_reporting $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_ind_error_reporting $hssi_pipe_gen3_ind_error_reporting $legal_values { hssi_pipe_gen1_2_ind_error_reporting hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_mode hssi_rx_pld_pcs_interface_hd_g3_prot_mode } {

   set legal_values [list "disable_pcs" "pipe_g1" "pipe_g2" "pipe_g3"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "disable_pcs"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g1") }] {
      set legal_values [intersect $legal_values [list "pipe_g1"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g2") }] {
      set legal_values [intersect $legal_values [list "pipe_g2"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "pipe_g3"]]
   }
   set legal_values [intersect $legal_values [list "pipe_g1" "pipe_g2" "pipe_g3" "disable_pcs"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_mode $hssi_pipe_gen3_mode $legal_values { hssi_rx_pld_pcs_interface_hd_g3_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_phy_status_delay_g12 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_phy_status_delay_g12 hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [compare_eq $legal_values 5]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
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

         ip_set "parameter.hssi_pipe_gen3_phy_status_delay_g12.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen3_phy_status_delay_g12 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen3_phy_status_delay_g12 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen3_phy_status_delay_g12 $hssi_pipe_gen3_phy_status_delay_g12 $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_phy_status_delay_g3 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_phy_status_delay_g3 hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [compare_eq $legal_values 5]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
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

         ip_set "parameter.hssi_pipe_gen3_phy_status_delay_g3.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen3_phy_status_delay_g3 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen3_phy_status_delay_g3 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen3_phy_status_delay_g3 $hssi_pipe_gen3_phy_status_delay_g3 $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_phystatus_rst_toggle_g12 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_phystatus_rst_toggle_g12 hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list "dis_phystatus_rst_toggle" "en_phystatus_rst_toggle"]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { (($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2")) }] {
         set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="pipe_g3") }] {
            set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle"]]
         } else {
            if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
               set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle"]]
            }
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle" "en_phystatus_rst_toggle"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_phystatus_rst_toggle_g12.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_phystatus_rst_toggle_g12 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_phystatus_rst_toggle_g12 $hssi_pipe_gen3_phystatus_rst_toggle_g12 $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_phystatus_rst_toggle_g3 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_phystatus_rst_toggle_g3 hssi_pipe_gen3_mode hssi_pipe_gen3_phystatus_rst_toggle_g12 hssi_pipe_gen3_sup_mode } {

   set legal_values [list "dis_phystatus_rst_toggle_g3" "en_phystatus_rst_toggle_g3"]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { (($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2")) }] {
         set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle_g3"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="pipe_g3") }] {
            if [expr { ($hssi_pipe_gen3_phystatus_rst_toggle_g12=="dis_phystatus_rst_toggle") }] {
               set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle_g3"]]
            } else {
               set legal_values [intersect $legal_values [list "en_phystatus_rst_toggle_g3"]]
            }
         } else {
            if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
               set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle_g3"]]
            }
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle_g3" "en_phystatus_rst_toggle_g3"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_phystatus_rst_toggle_g3.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_phystatus_rst_toggle_g3 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_phystatus_rst_toggle_g3 $hssi_pipe_gen3_phystatus_rst_toggle_g3 $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_phystatus_rst_toggle_g12 hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_rate_match_pad_insertion { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_rate_match_pad_insertion hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list "dis_rm_fifo_pad_ins" "en_rm_fifo_pad_ins"]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "dis_rm_fifo_pad_ins"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "dis_rm_fifo_pad_ins"]]
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_rm_fifo_pad_ins" "en_rm_fifo_pad_ins"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_rate_match_pad_insertion.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_rate_match_pad_insertion $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_rate_match_pad_insertion $hssi_pipe_gen3_rate_match_pad_insertion $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_sup_mode hssi_rx_pld_pcs_interface_hd_g3_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_g3_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_sup_mode $hssi_pipe_gen3_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_g3_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen3_test_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen3_test_out_sel hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode } {

   set legal_values [list "disable_test_out" "pipe_ctrl_test_out" "pipe_test_out1" "pipe_test_out2" "pipe_test_out3" "rx_test_out" "tx_test_out"]

   if [expr { ($hssi_pipe_gen3_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_pipe_gen3_mode=="pipe_g1")||($hssi_pipe_gen3_mode=="pipe_g2"))||($hssi_pipe_gen3_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "disable_test_out"]]
      } else {
         if [expr { ($hssi_pipe_gen3_mode=="disable_pcs") }] {
            set legal_values [intersect $legal_values [list "disable_test_out"]]
         }
      }
   } else {
      if [expr { ($hssi_pipe_gen3_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "tx_test_out" "rx_test_out" "pipe_test_out1" "pipe_test_out2" "pipe_test_out3" "pipe_ctrl_test_out" "disable_test_out"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen3_test_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen3_test_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen3_test_out_sel $hssi_pipe_gen3_test_out_sel $legal_values { hssi_pipe_gen3_mode hssi_pipe_gen3_sup_mode }
   }
}

