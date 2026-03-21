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


proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_elec_idle_delay_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_elec_idle_delay_val hssi_pipe_gen1_2_prot_mode } {

   set legal_values [list 0:7]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_eq $legal_values 3]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_elec_idle_delay_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_elec_idle_delay_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_elec_idle_delay_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_elec_idle_delay_val $hssi_pipe_gen1_2_elec_idle_delay_val $legal_values { hssi_pipe_gen1_2_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_error_replace_pad { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_error_replace_pad } {

   set legal_values [list "replace_edb" "replace_pad"]

   set legal_values [intersect $legal_values [list "replace_edb"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_error_replace_pad.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_error_replace_pad $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_error_replace_pad $hssi_pipe_gen1_2_error_replace_pad $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_hip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_hip_mode hssi_pipe_gen1_2_prot_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode } {

   set legal_values [list "dis_hip" "en_hip"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_hip_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_hip_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "en_hip"]]
      }
   }
   if [expr { ((($hssi_pipe_gen1_2_prot_mode=="pipe_g1")||($hssi_pipe_gen1_2_prot_mode=="pipe_g2"))||($hssi_pipe_gen1_2_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "dis_hip" "en_hip"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_hip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_hip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_hip_mode $hssi_pipe_gen1_2_hip_mode $legal_values { hssi_pipe_gen1_2_prot_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_ind_error_reporting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_ind_error_reporting hssi_pipe_gen1_2_rx_pipe_enable } {

   set legal_values [list "dis_ind_error_reporting" "en_ind_error_reporting"]

   if [expr { ($hssi_pipe_gen1_2_rx_pipe_enable=="en_pipe_rx") }] {
      set legal_values [intersect $legal_values [list "en_ind_error_reporting" "dis_ind_error_reporting"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_ind_error_reporting"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_ind_error_reporting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_ind_error_reporting $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_ind_error_reporting $hssi_pipe_gen1_2_ind_error_reporting $legal_values { hssi_pipe_gen1_2_rx_pipe_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_phystatus_delay_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_phystatus_delay_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:7]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_phystatus_delay_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_phystatus_delay_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_phystatus_delay_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_phystatus_delay_val $hssi_pipe_gen1_2_phystatus_delay_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_phystatus_rst_toggle { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_phystatus_rst_toggle } {

   set legal_values [list "dis_phystatus_rst_toggle" "en_phystatus_rst_toggle"]

   set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_phystatus_rst_toggle.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_phystatus_rst_toggle $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_phystatus_rst_toggle $hssi_pipe_gen1_2_phystatus_rst_toggle $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_pipe_byte_de_serializer_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_pipe_byte_de_serializer_en hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_pipe_if_enable hssi_pipe_gen1_2_rx_pipe_enable } {

   set legal_values [list "dis_bds" "dont_care_bds" "en_bds_by_2"]

   if [expr { ($hssi_8g_rx_pcs_pipe_if_enable=="en_pipe_rx") }] {
      if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
         set legal_values [intersect $legal_values [list "dis_bds"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
            set legal_values [intersect $legal_values [list "en_bds_by_2"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "dont_care_bds"]]
   }
   if [expr { ($hssi_pipe_gen1_2_rx_pipe_enable=="en_pipe_rx") }] {
      set legal_values [intersect $legal_values [list "dis_bds" "en_bds_by_2"]]
   } else {
      set legal_values [intersect $legal_values [list "dont_care_bds"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_pipe_byte_de_serializer_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_pipe_byte_de_serializer_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_pipe_byte_de_serializer_en $hssi_pipe_gen1_2_pipe_byte_de_serializer_en $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_pipe_if_enable hssi_pipe_gen1_2_rx_pipe_enable }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_prot_mode hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx } {

   set legal_values [list "basic" "disabled_prot_mode" "pipe_g1" "pipe_g2" "pipe_g3"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g1_tx") }] {
      set legal_values [intersect $legal_values [list "pipe_g1"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g2_tx") }] {
         set legal_values [intersect $legal_values [list "pipe_g2"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g3_tx") }] {
            set legal_values [intersect $legal_values [list "pipe_g3"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="basic_tx") }] {
               set legal_values [intersect $legal_values [list "basic"]]
            } else {
               set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_prot_mode $legal_values { hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rpre_emph_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rpre_emph_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_b_val $hssi_pipe_gen1_2_rpre_emph_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rpre_emph_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rpre_emph_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rpre_emph_e_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_e_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 6]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_e_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_e_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_e_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_e_val $hssi_pipe_gen1_2_rpre_emph_e_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_a_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_b_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_c_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_d_val  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rvod_sel_e_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_e_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_e_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_e_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_e_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_e_val $hssi_pipe_gen1_2_rvod_sel_e_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rx_pipe_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rx_pipe_enable hssi_pipe_gen1_2_hip_mode hssi_pipe_gen1_2_prot_mode } {

   set legal_values [list "dis_pipe_rx" "en_pipe3_rx" "en_pipe_rx"]

   if [expr { (($hssi_pipe_gen1_2_prot_mode=="pipe_g3")||($hssi_pipe_gen1_2_hip_mode=="en_hip")) }] {
      set legal_values [intersect $legal_values [list "en_pipe3_rx"]]
   } else {
      if [expr { (($hssi_pipe_gen1_2_prot_mode=="pipe_g1")||($hssi_pipe_gen1_2_prot_mode=="pipe_g2")) }] {
         set legal_values [intersect $legal_values [list "en_pipe_rx"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_pipe_rx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_rx_pipe_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_rx_pipe_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_rx_pipe_enable $hssi_pipe_gen1_2_rx_pipe_enable $legal_values { hssi_pipe_gen1_2_hip_mode hssi_pipe_gen1_2_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_rxdetect_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rxdetect_bypass hssi_pipe_gen1_2_rx_pipe_enable hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list "dis_rxdetect_bypass" "en_rxdetect_bypass"]

   if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "dis_rxdetect_bypass"]]
   } else {
      if [expr { ($hssi_pipe_gen1_2_rx_pipe_enable=="en_pipe_rx") }] {
         set legal_values [intersect $legal_values [list "dis_rxdetect_bypass" "en_rxdetect_bypass"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_rxdetect_bypass"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_rxdetect_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_rxdetect_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_rxdetect_bypass $hssi_pipe_gen1_2_rxdetect_bypass $legal_values { hssi_pipe_gen1_2_rx_pipe_enable hssi_pipe_gen1_2_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_sup_mode hssi_rx_pld_pcs_interface_hd_8g_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "engineering_mode"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_sup_mode $hssi_pipe_gen1_2_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_8g_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_tx_pipe_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_tx_pipe_enable hssi_pipe_gen1_2_hip_mode hssi_pipe_gen1_2_prot_mode } {

   set legal_values [list "dis_pipe_tx" "en_pipe3_tx" "en_pipe_tx"]

   if [expr { (($hssi_pipe_gen1_2_prot_mode=="pipe_g3")||($hssi_pipe_gen1_2_hip_mode=="en_hip")) }] {
      set legal_values [intersect $legal_values [list "en_pipe3_tx"]]
   } else {
      if [expr { (($hssi_pipe_gen1_2_prot_mode=="pipe_g1")||($hssi_pipe_gen1_2_prot_mode=="pipe_g2")) }] {
         set legal_values [intersect $legal_values [list "en_pipe_tx"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_pipe_tx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_tx_pipe_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_tx_pipe_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_tx_pipe_enable $hssi_pipe_gen1_2_tx_pipe_enable $legal_values { hssi_pipe_gen1_2_hip_mode hssi_pipe_gen1_2_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_pipe_gen1_2_txswing { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_txswing hssi_pipe_gen1_2_rx_pipe_enable } {

   set legal_values [list "dis_txswing" "en_txswing"]

   if [expr { ($hssi_pipe_gen1_2_rx_pipe_enable=="en_pipe_rx") }] {
      set legal_values [intersect $legal_values [list "en_txswing" "dis_txswing"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_txswing"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_pipe_gen1_2_txswing.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_pipe_gen1_2_txswing $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_pipe_gen1_2_txswing $hssi_pipe_gen1_2_txswing $legal_values { hssi_pipe_gen1_2_rx_pipe_enable }
   }
}

proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 60]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 45]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 60]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 45]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rpre_emph_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_a_val $hssi_pipe_gen1_2_rpre_emph_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rpre_emph_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_c_val $hssi_pipe_gen1_2_rpre_emph_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rpre_emph_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rpre_emph_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rpre_emph_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rpre_emph_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rpre_emph_d_val $hssi_pipe_gen1_2_rpre_emph_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_a_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_a_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_a_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_a_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_a_val $hssi_pipe_gen1_2_rvod_sel_a_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_b_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_b_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_b_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_b_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_b_val $hssi_pipe_gen1_2_rvod_sel_b_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_c_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_c_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_c_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_c_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_c_val $hssi_pipe_gen1_2_rvod_sel_c_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_pipe_gen1_2_rvod_sel_d_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_pipe_gen1_2_rvod_sel_d_val hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_pipe_gen1_2_rvod_sel_d_val.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_pipe_gen1_2_rvod_sel_d_val $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_pipe_gen1_2_rvod_sel_d_val $hssi_pipe_gen1_2_rvod_sel_d_val $legal_values { hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode }
   }
}


