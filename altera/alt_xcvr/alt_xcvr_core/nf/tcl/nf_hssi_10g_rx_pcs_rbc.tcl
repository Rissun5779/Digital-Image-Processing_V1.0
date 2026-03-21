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


proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_advanced_user_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_advanced_user_mode hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   set legal_values [intersect $legal_values [list "disable"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_advanced_user_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_advanced_user_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_advanced_user_mode $hssi_10g_rx_pcs_advanced_user_mode $legal_values { hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_align_del { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_align_del hssi_10g_rx_pcs_control_del hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "align_del_dis" "align_del_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_control_del=="control_del_all") }] {
            set legal_values [intersect $legal_values [list "align_del_en"]]
         } else {
            set legal_values [intersect $legal_values [list "align_del_dis" "align_del_en"]]
         }
      } else {
         if [expr { ($hssi_10g_rx_pcs_control_del=="control_del_all") }] {
            set legal_values [intersect $legal_values [list "align_del_en"]]
         } else {
            set legal_values [intersect $legal_values [list "align_del_dis"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "align_del_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_align_del.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_align_del $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_align_del $hssi_10g_rx_pcs_align_del $legal_values { hssi_10g_rx_pcs_control_del hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_ber_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_ber_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "ber_clk_dis" "ber_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "ber_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "ber_clk_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "ber_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "ber_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "ber_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_ber_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_ber_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_ber_clken $hssi_10g_rx_pcs_ber_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_ber_xus_timer_window { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_ber_xus_timer_window hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list 0:2097151]

   if [expr { ($hssi_10g_rx_pcs_sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 19530]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_10g_rx_pcs_ber_xus_timer_window.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_10g_rx_pcs_ber_xus_timer_window $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_10g_rx_pcs_ber_xus_timer_window $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_10g_rx_pcs_ber_xus_timer_window $hssi_10g_rx_pcs_ber_xus_timer_window $legal_values { hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_10g_rx_pcs_bitslip_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_bitslip_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_bitslip_type hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_comb" "bitslip_reg"]

   if [expr { ((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="interlaken_mode"))||(($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_comb" "bitslip_reg"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_comb"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "bitslip_comb"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_bitslip_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_bitslip_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_bitslip_type $hssi_10g_rx_pcs_blksync_bitslip_type $legal_values { hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_bitslip_wait_cnt { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_bitslip_wait_cnt hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list 0:7]

   if [expr { ((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="interlaken_mode"))||(($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [compare_ge $legal_values 0]
         set legal_values [compare_le $legal_values 7]
      } else {
         set legal_values [compare_eq $legal_values 1]
      }
   } else {
      set legal_values [compare_eq $legal_values 1]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_10g_rx_pcs_blksync_bitslip_wait_cnt.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_10g_rx_pcs_blksync_bitslip_wait_cnt $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_10g_rx_pcs_blksync_bitslip_wait_cnt $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_10g_rx_pcs_blksync_bitslip_wait_cnt $hssi_10g_rx_pcs_blksync_bitslip_wait_cnt $legal_values { hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_bitslip_wait_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_bitslip_wait_type hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_cnt" "bitslip_match"]

   if [expr { ((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="interlaken_mode"))||(($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_match" "bitslip_cnt"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_cnt"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "bitslip_cnt"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_bitslip_wait_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_bitslip_wait_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_bitslip_wait_type $hssi_10g_rx_pcs_blksync_bitslip_wait_type $legal_values { hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "blksync_bypass_dis" "blksync_bypass_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "blksync_bypass_dis"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "blksync_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "blksync_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { ((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))&&($hssi_10g_rx_pcs_sup_mode=="engineering_mode")) }] {
                  set legal_values [intersect $legal_values [list "blksync_bypass_dis" "blksync_bypass_en"]]
               } else {
                  if [expr { (($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67")) }] {
                     set legal_values [intersect $legal_values [list "blksync_bypass_dis" "blksync_bypass_en"]]
                  } else {
                     set legal_values [intersect $legal_values [list "blksync_bypass_en"]]
                  }
               }
            } else {
               set legal_values [intersect $legal_values [list "blksync_bypass_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_blksync_bypass $legal_values { hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_clken hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "blksync_clk_dis" "blksync_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "blksync_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "blksync_clk_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "blksync_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { ((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))&&($hssi_10g_rx_pcs_sup_mode=="engineering_mode")) }] {
                  set legal_values [intersect $legal_values [list "blksync_clk_en"]]
               } else {
                  if [expr { (($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67")) }] {
                     set legal_values [intersect $legal_values [list "blksync_clk_en"]]
                  } else {
                     set legal_values [intersect $legal_values [list "blksync_clk_dis"]]
                  }
               }
            } else {
               set legal_values [intersect $legal_values [list "blksync_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_clken $hssi_10g_rx_pcs_blksync_clken $legal_values { hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_enum_invalid_sh_cnt { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_enum_invalid_sh_cnt } {

   set legal_values [list "enum_invalid_sh_cnt_10g"]

   set legal_values [intersect $legal_values [list "enum_invalid_sh_cnt_10g"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_enum_invalid_sh_cnt.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_enum_invalid_sh_cnt $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_enum_invalid_sh_cnt $hssi_10g_rx_pcs_blksync_enum_invalid_sh_cnt $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_knum_sh_cnt_postlock { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_knum_sh_cnt_postlock } {

   set legal_values [list "knum_sh_cnt_postlock_10g"]

   set legal_values [intersect $legal_values [list "knum_sh_cnt_postlock_10g"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_knum_sh_cnt_postlock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_knum_sh_cnt_postlock $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_knum_sh_cnt_postlock $hssi_10g_rx_pcs_blksync_knum_sh_cnt_postlock $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_knum_sh_cnt_prelock { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_knum_sh_cnt_prelock } {

   set legal_values [list "knum_sh_cnt_prelock_10g"]

   set legal_values [intersect $legal_values [list "knum_sh_cnt_prelock_10g"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_knum_sh_cnt_prelock.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_knum_sh_cnt_prelock $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_knum_sh_cnt_prelock $hssi_10g_rx_pcs_blksync_knum_sh_cnt_prelock $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_blksync_pipeln { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_blksync_pipeln hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "blksync_pipeln_dis" "blksync_pipeln_en"]

   if [expr { ((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="interlaken_mode"))||(($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "blksync_pipeln_en" "blksync_pipeln_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "blksync_pipeln_dis"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "blksync_pipeln_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_blksync_pipeln.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_blksync_pipeln $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_blksync_pipeln $hssi_10g_rx_pcs_blksync_pipeln $legal_values { hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_clr_errblk_cnt_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_clr_errblk_cnt_en hssi_10g_rx_pcs_dec64b66b_clken } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_10g_rx_pcs_dec64b66b_clken=="dec64b66b_clk_en") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_clr_errblk_cnt_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_clr_errblk_cnt_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_clr_errblk_cnt_en $hssi_10g_rx_pcs_clr_errblk_cnt_en $legal_values { hssi_10g_rx_pcs_dec64b66b_clken }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_control_del { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_control_del hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "control_del_all" "control_del_none"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "control_del_all" "control_del_none"]]
   } else {
      set legal_values [intersect $legal_values [list "control_del_none"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_control_del.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_control_del $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_control_del $hssi_10g_rx_pcs_control_del $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_crcchk_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_crcchk_bypass hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "crcchk_bypass_dis" "crcchk_bypass_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "crcchk_bypass_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "crcchk_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "crcchk_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "crcchk_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "crcchk_bypass_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_crcchk_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_crcchk_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_crcchk_bypass $hssi_10g_rx_pcs_crcchk_bypass $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_crcchk_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_crcchk_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "crcchk_clk_dis" "crcchk_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "crcchk_clk_dis"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "crcchk_clk_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "crcchk_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "crcchk_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "crcchk_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_crcchk_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_crcchk_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_crcchk_clken $hssi_10g_rx_pcs_crcchk_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_crcchk_inv { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_crcchk_inv hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "crcchk_inv_dis" "crcchk_inv_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "crcchk_inv_en"]]
   } else {
      set legal_values [intersect $legal_values [list "crcchk_inv_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_crcchk_inv.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_crcchk_inv $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_crcchk_inv $hssi_10g_rx_pcs_crcchk_inv $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_crcchk_pipeln { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_crcchk_pipeln hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "crcchk_pipeln_dis" "crcchk_pipeln_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "crcchk_pipeln_dis" "crcchk_pipeln_en"]]
      } else {
         set legal_values [intersect $legal_values [list "crcchk_pipeln_dis"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "crcchk_pipeln_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_crcchk_pipeln.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_crcchk_pipeln $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_crcchk_pipeln $hssi_10g_rx_pcs_crcchk_pipeln $legal_values { hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_crcflag_pipeln { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_crcflag_pipeln hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "crcflag_pipeln_dis" "crcflag_pipeln_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "crcflag_pipeln_dis" "crcflag_pipeln_en"]]
      } else {
         set legal_values [intersect $legal_values [list "crcflag_pipeln_en"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "crcflag_pipeln_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_crcflag_pipeln.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_crcflag_pipeln $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_crcflag_pipeln $hssi_10g_rx_pcs_crcflag_pipeln $legal_values { hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_ctrl_bit_reverse { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_ctrl_bit_reverse hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "ctrl_bit_reverse_dis" "ctrl_bit_reverse_en"]

   if [expr { ((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]
      } else {
         set legal_values [intersect $legal_values [list "ctrl_bit_reverse_dis"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_ctrl_bit_reverse.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_ctrl_bit_reverse $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_ctrl_bit_reverse $hssi_10g_rx_pcs_ctrl_bit_reverse $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_data_bit_reverse { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_data_bit_reverse hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "data_bit_reverse_dis" "data_bit_reverse_en"]

   if [expr { ((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "data_bit_reverse_en"]]
      } else {
         set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_data_bit_reverse.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_data_bit_reverse $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_data_bit_reverse $hssi_10g_rx_pcs_data_bit_reverse $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_dec64b66b_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_dec64b66b_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "dec64b66b_clk_dis" "dec64b66b_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "dec64b66b_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "dec64b66b_clk_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "dec64b66b_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "dec64b66b_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "dec64b66b_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_dec64b66b_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_dec64b66b_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_dec64b66b_clken $hssi_10g_rx_pcs_dec64b66b_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "dec_64b66b_rxsm_bypass_dis" "dec_64b66b_rxsm_bypass_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "dec_64b66b_rxsm_bypass_dis"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "dec_64b66b_rxsm_bypass_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "dec_64b66b_rxsm_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "dec_64b66b_rxsm_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "dec_64b66b_rxsm_bypass_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass $hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_descrm_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_descrm_bypass hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "descrm_bypass_dis" "descrm_bypass_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "descrm_bypass_dis"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "descrm_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "descrm_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66"))||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))&&($hssi_10g_rx_pcs_sup_mode=="engineering_mode")) }] {
                  set legal_values [intersect $legal_values [list "descrm_bypass_en" "descrm_bypass_dis"]]
               } else {
                  if [expr { (((($hssi_10g_rx_pcs_sup_mode=="user_mode")&&($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66"))&&($hssi_10g_rx_pcs_prot_mode=="basic_mode"))&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_dis")) }] {
                     if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32") }] {
                        set legal_values [intersect $legal_values [list "descrm_bypass_dis"]]
                     } else {
                        set legal_values [intersect $legal_values [list "descrm_bypass_en" "descrm_bypass_dis"]]
                     }
                  } else {
                     set legal_values [intersect $legal_values [list "descrm_bypass_en"]]
                  }
               }
            } else {
               set legal_values [intersect $legal_values [list "descrm_bypass_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_descrm_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_descrm_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_descrm_bypass $hssi_10g_rx_pcs_descrm_bypass $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_descrm_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_descrm_clken hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_descrm_bypass hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "descrm_clk_dis" "descrm_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "descrm_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "descrm_clk_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "descrm_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66"))||($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67"))&&($hssi_10g_rx_pcs_sup_mode=="engineering_mode")) }] {
                  set legal_values [intersect $legal_values [list "descrm_clk_en"]]
               } else {
                  if [expr { (((($hssi_10g_rx_pcs_sup_mode=="user_mode")&&($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66"))&&($hssi_10g_rx_pcs_prot_mode=="basic_mode"))&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_dis")) }] {
                     if [expr { ($hssi_10g_rx_pcs_descrm_bypass=="descrm_bypass_dis") }] {
                        set legal_values [intersect $legal_values [list "descrm_clk_en"]]
                     } else {
                        set legal_values [intersect $legal_values [list "descrm_clk_dis"]]
                     }
                  } else {
                     set legal_values [intersect $legal_values [list "descrm_clk_dis"]]
                  }
               }
            } else {
               set legal_values [intersect $legal_values [list "descrm_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_descrm_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_descrm_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_descrm_clken $hssi_10g_rx_pcs_descrm_clken $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_descrm_bypass hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_descrm_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_descrm_mode hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "async" "sync"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "sync"]]
   } else {
      set legal_values [intersect $legal_values [list "async"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_descrm_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_descrm_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_descrm_mode $hssi_10g_rx_pcs_descrm_mode $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_descrm_pipeln { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_descrm_pipeln hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      if [expr { (($hssi_10g_rx_pcs_low_latency_en=="enable")&&($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")) }] {
         set legal_values [intersect $legal_values [list "disable"]]
      } else {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_descrm_pipeln.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_descrm_pipeln $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_descrm_pipeln $hssi_10g_rx_pcs_descrm_pipeln $legal_values { hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_dft_clk_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_dft_clk_out_sel } {

   set legal_values [list "rx_64b66bdec_clk" "rx_ber_clk" "rx_blksync_clk" "rx_crcchk_clk" "rx_descrm_clk" "rx_fec_clk" "rx_frmsync_clk" "rx_gbexp_clk" "rx_master_clk" "rx_rand_clk" "rx_rdfifo_clk" "rx_wrfifo_clk"]

   set legal_values [intersect $legal_values [list "rx_master_clk"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_dft_clk_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_dft_clk_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_dft_clk_out_sel $hssi_10g_rx_pcs_dft_clk_out_sel $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_dis_signal_ok { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_dis_signal_ok hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "dis_signal_ok_dis" "dis_signal_ok_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "dis_signal_ok_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_lpbk_mode=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "dis_signal_ok_dis"]]
      } else {
         if [expr { ((($hssi_10g_rx_pcs_prot_mode=="interlaken_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
            set legal_values [intersect $legal_values [list "dis_signal_ok_en"]]
         } else {
            set legal_values [intersect $legal_values [list "dis_signal_ok_dis" "dis_signal_ok_en"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_dis_signal_ok.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_dis_signal_ok $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_dis_signal_ok $hssi_10g_rx_pcs_dis_signal_ok $legal_values { hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_dispchk_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_dispchk_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "dispchk_bypass_dis" "dispchk_bypass_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "dispchk_bypass_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "dispchk_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "dispchk_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { (($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64")) }] {
                  set legal_values [intersect $legal_values [list "dispchk_bypass_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "dispchk_bypass_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "dispchk_bypass_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_dispchk_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_dispchk_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_dispchk_bypass $hssi_10g_rx_pcs_dispchk_bypass $legal_values { hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_empty_flag_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_empty_flag_type } {

   set legal_values [list "empty_rd_side" "empty_wr_side"]

   set legal_values [intersect $legal_values [list "empty_rd_side"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_empty_flag_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_empty_flag_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_empty_flag_type $hssi_10g_rx_pcs_empty_flag_type $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_fast_path { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_fast_path hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_crcchk_bypass hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass hssi_10g_rx_pcs_descrm_bypass hssi_10g_rx_pcs_dispchk_bypass hssi_10g_rx_pcs_fec_enable hssi_10g_rx_pcs_frmsync_bypass } {

   set legal_values [list "fast_path_dis" "fast_path_en"]

   if [expr { ((((((($hssi_10g_rx_pcs_descrm_bypass=="descrm_bypass_en")&&($hssi_10g_rx_pcs_frmsync_bypass=="frmsync_bypass_en"))&&($hssi_10g_rx_pcs_crcchk_bypass=="crcchk_bypass_en"))&&($hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass=="dec_64b66b_rxsm_bypass_en"))&&($hssi_10g_rx_pcs_dispchk_bypass=="dispchk_bypass_en"))&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en"))&&($hssi_10g_rx_pcs_fec_enable=="fec_dis")) }] {
      set legal_values [intersect $legal_values [list "fast_path_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fast_path_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_fast_path.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_fast_path $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_fast_path $hssi_10g_rx_pcs_fast_path $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_crcchk_bypass hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass hssi_10g_rx_pcs_descrm_bypass hssi_10g_rx_pcs_dispchk_bypass hssi_10g_rx_pcs_fec_enable hssi_10g_rx_pcs_frmsync_bypass }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_fec_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_fec_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "fec_clk_dis" "fec_clk_en"]

   if [expr { (((($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "fec_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fec_clk_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_fec_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_fec_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_fec_clken $hssi_10g_rx_pcs_fec_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_fec_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_fec_enable hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "fec_dis" "fec_en"]

   if [expr { (((($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "fec_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fec_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_fec_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_fec_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_fec_enable $hssi_10g_rx_pcs_fec_enable $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_fifo_double_read { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_fifo_double_read hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "fifo_double_read_dis" "fifo_double_read_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx=="single_rx") }] {
      set legal_values [intersect $legal_values [list "fifo_double_read_dis"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx=="double_rx") }] {
      set legal_values [intersect $legal_values [list "fifo_double_read_en"]]
   }
   if [expr { (((($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode"))&&($hssi_10g_rx_pcs_rxfifo_mode=="phase_comp"))&&(((($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")&&($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40"))||(($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64")&&($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")))||(($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64")&&($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")))) }] {
      set legal_values [intersect $legal_values [list "fifo_double_read_en" "fifo_double_read_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "fifo_double_read_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_fifo_double_read.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_fifo_double_read $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_fifo_double_read $hssi_10g_rx_pcs_fifo_double_read $legal_values { hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_fifo_stop_rd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_fifo_stop_rd hssi_10g_rx_pcs_fifo_double_read hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "n_rd_empty" "rd_empty"]

   if [expr { (($hssi_10g_rx_pcs_rxfifo_mode=="phase_comp")&&($hssi_10g_rx_pcs_prot_mode!="disable_mode")) }] {
      if [expr { ($hssi_10g_rx_pcs_low_latency_en=="enable") }] {
         set legal_values [intersect $legal_values [list "rd_empty"]]
      } else {
         if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64")))&&($hssi_10g_rx_pcs_fifo_double_read=="fifo_double_read_dis")) }] {
            set legal_values [intersect $legal_values [list "rd_empty" "n_rd_empty"]]
         } else {
            set legal_values [intersect $legal_values [list "rd_empty"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "n_rd_empty"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_fifo_stop_rd.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_fifo_stop_rd $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_fifo_stop_rd $hssi_10g_rx_pcs_fifo_stop_rd $legal_values { hssi_10g_rx_pcs_fifo_double_read hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_fifo_stop_wr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_fifo_stop_wr } {

   set legal_values [list "n_wr_full" "wr_full"]

   set legal_values [intersect $legal_values [list "n_wr_full"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_fifo_stop_wr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_fifo_stop_wr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_fifo_stop_wr $hssi_10g_rx_pcs_fifo_stop_wr $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_force_align { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_force_align hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "force_align_dis" "force_align_en"]

   if [expr { (($hssi_10g_rx_pcs_prot_mode=="interlaken_mode")&&($hssi_10g_rx_pcs_sup_mode=="engineering_mode")) }] {
      set legal_values [intersect $legal_values [list "force_align_en" "force_align_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "force_align_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_force_align.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_force_align $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_force_align $hssi_10g_rx_pcs_force_align $legal_values { hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_frmsync_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_frmsync_bypass hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "frmsync_bypass_dis" "frmsync_bypass_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "frmsync_bypass_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "frmsync_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "frmsync_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "frmsync_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "frmsync_bypass_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_frmsync_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_frmsync_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_frmsync_bypass $hssi_10g_rx_pcs_frmsync_bypass $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_frmsync_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_frmsync_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "frmsync_clk_dis" "frmsync_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "frmsync_clk_dis"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "frmsync_clk_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "frmsync_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "frmsync_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "frmsync_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_frmsync_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_frmsync_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_frmsync_clken $hssi_10g_rx_pcs_frmsync_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_frmsync_flag_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_frmsync_flag_type } {

   set legal_values [list "all_framing_words" "location_only"]

   set legal_values [intersect $legal_values [list "location_only"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_frmsync_flag_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_frmsync_flag_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_frmsync_flag_type $hssi_10g_rx_pcs_frmsync_flag_type $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_frmsync_mfrm_length { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_frmsync_mfrm_length hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [compare_ge $legal_values 5]
      set legal_values [compare_le $legal_values 65535]
   } else {
      set legal_values [compare_eq $legal_values 2048]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_10g_rx_pcs_frmsync_mfrm_length.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_10g_rx_pcs_frmsync_mfrm_length $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_10g_rx_pcs_frmsync_mfrm_length $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_10g_rx_pcs_frmsync_mfrm_length $hssi_10g_rx_pcs_frmsync_mfrm_length $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_frmsync_pipeln { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_frmsync_pipeln hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "frmsync_pipeln_dis" "frmsync_pipeln_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "frmsync_pipeln_en" "frmsync_pipeln_dis"]]
      } else {
         if [expr { ($hssi_10g_rx_pcs_low_latency_en=="enable") }] {
            set legal_values [intersect $legal_values [list "frmsync_pipeln_dis"]]
         } else {
            set legal_values [intersect $legal_values [list "frmsync_pipeln_en"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "frmsync_pipeln_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_frmsync_pipeln.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_frmsync_pipeln $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_frmsync_pipeln $hssi_10g_rx_pcs_frmsync_pipeln $legal_values { hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_full_flag_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_full_flag_type } {

   set legal_values [list "full_rd_side" "full_wr_side"]

   set legal_values [intersect $legal_values [list "full_wr_side"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_full_flag_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_full_flag_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_full_flag_type $hssi_10g_rx_pcs_full_flag_type $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_gb_rx_idwidth { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_gb_rx_idwidth hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx } {

   set legal_values [list "idwidth_32" "idwidth_40" "idwidth_64"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx=="pma_64b_rx") }] {
      set legal_values [intersect $legal_values [list "idwidth_64"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx=="pma_40b_rx") }] {
         set legal_values [intersect $legal_values [list "idwidth_40"]]
      } else {
         set legal_values [intersect $legal_values [list "idwidth_32"]]
      }
   }

   set legal_values [convert_b2a_hssi_10g_rx_pcs_gb_rx_idwidth $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_gb_rx_idwidth.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_gb_rx_idwidth $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth $legal_values { hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_gb_rx_odwidth { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]

   set legal_values [list "odwidth_32" "odwidth_40" "odwidth_50" "odwidth_64" "odwidth_66" "odwidth_67"]

   if [expr { ((((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "odwidth_66"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "odwidth_67"]]
      } else {
         if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
            if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32") }] {
               set legal_values [intersect $legal_values [list "odwidth_64" "odwidth_32"]]
            } else {
               if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40") }] {
                  if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
                     set legal_values [intersect $legal_values [list "odwidth_64" "odwidth_40"]]
                  } else {
                     set legal_values [intersect $legal_values [list "odwidth_40"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "odwidth_64"]]
               }
            }
         } else {
            if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
               if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
                  set legal_values [intersect $legal_values [list "odwidth_40" "odwidth_50"]]
               } else {
                  set legal_values [intersect $legal_values [list "odwidth_50"]]
               }
            } else {
               if [expr { ($hssi_10g_rx_pcs_prot_mode=="basic_mode") }] {
                  if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32") }] {
                     if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
                        set legal_values [intersect $legal_values [list "odwidth_32" "odwidth_64" "odwidth_66" "odwidth_67"]]
                     } else {
                        set legal_values [intersect $legal_values [list "odwidth_32" "odwidth_64" "odwidth_66"]]
                     }
                  } else {
                     if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40") }] {
                        if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
                           set legal_values [intersect $legal_values [list "odwidth_40" "odwidth_64" "odwidth_66" "odwidth_67"]]
                        } else {
                           set legal_values [intersect $legal_values [list "odwidth_40" "odwidth_66"]]
                        }
                     } else {
                        set legal_values [intersect $legal_values [list "odwidth_64" "odwidth_66" "odwidth_67"]]
                     }
                  }
               } else {
                  if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32") }] {
                     set legal_values [intersect $legal_values [list "odwidth_32"]]
                  } else {
                     if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40") }] {
                        set legal_values [intersect $legal_values [list "odwidth_40"]]
                     } else {
                        set legal_values [intersect $legal_values [list "odwidth_64"]]
                     }
                  }
               }
            }
         }
      }
   }

   set legal_values [convert_b2a_hssi_10g_rx_pcs_gb_rx_odwidth $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_gb_rx_odwidth.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_gb_rx_odwidth $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth $legal_values { hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_gbexp_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_gbexp_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "gbexp_clk_dis" "gbexp_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "gbexp_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "gbexp_clk_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "gbexp_clk_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "gbexp_clk_en"]]
            } else {
               set legal_values [intersect $legal_values [list "gbexp_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_gbexp_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_gbexp_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_gbexp_clken $hssi_10g_rx_pcs_gbexp_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_low_latency_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_low_latency_en hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_low_latency_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_low_latency_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_low_latency_en $hssi_10g_rx_pcs_low_latency_en $legal_values { hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_lpbk_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_lpbk_mode hssi_rx_pld_pcs_interface_hd_10g_lpbk_en } {

   set legal_values [list "lpbk_dis" "lpbk_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "lpbk_en"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_lpbk_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_lpbk_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_lpbk_mode $hssi_10g_rx_pcs_lpbk_mode $legal_values { hssi_rx_pld_pcs_interface_hd_10g_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_master_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_master_clk_sel hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "master_refclk_dig" "master_rx_pma_clk" "master_tx_pma_clk"]

   if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_lpbk_mode=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "master_tx_pma_clk" "master_refclk_dig"]]
      } else {
         set legal_values [intersect $legal_values [list "master_rx_pma_clk" "master_refclk_dig"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_lpbk_mode=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "master_tx_pma_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "master_rx_pma_clk"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_master_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_master_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_master_clk_sel $hssi_10g_rx_pcs_master_clk_sel $legal_values { hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_pempty_flag_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_pempty_flag_type } {

   set legal_values [list "pempty_rd_side" "pempty_wr_side"]

   set legal_values [intersect $legal_values [list "pempty_rd_side"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_pempty_flag_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_pempty_flag_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_pempty_flag_type $hssi_10g_rx_pcs_pempty_flag_type $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_pfull_flag_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_pfull_flag_type } {

   set legal_values [list "pfull_rd_side" "pfull_wr_side"]

   set legal_values [intersect $legal_values [list "pfull_wr_side"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_pfull_flag_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_pfull_flag_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_pfull_flag_type $hssi_10g_rx_pcs_pfull_flag_type $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_phcomp_rd_del { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_phcomp_rd_del hssi_10g_rx_pcs_fifo_stop_rd hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "phcomp_rd_del2" "phcomp_rd_del3" "phcomp_rd_del4"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "phcomp_rd_del2"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="phase_comp") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "phcomp_rd_del4" "phcomp_rd_del3" "phcomp_rd_del2"]]
         } else {
            if [expr { ($hssi_10g_rx_pcs_low_latency_en=="disable") }] {
               if [expr { ($hssi_10g_rx_pcs_fifo_stop_rd=="n_rd_empty") }] {
                  set legal_values [intersect $legal_values [list "phcomp_rd_del4"]]
               } else {
                  set legal_values [intersect $legal_values [list "phcomp_rd_del3"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "phcomp_rd_del2"]]
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "phcomp_rd_del2"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_phcomp_rd_del.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_phcomp_rd_del $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_phcomp_rd_del $hssi_10g_rx_pcs_phcomp_rd_del $legal_values { hssi_10g_rx_pcs_fifo_stop_rd hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_pld_if_type { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_pld_if_type hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx } {

   set legal_values [list "fifo" "reg"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx=="reg_rx") }] {
      set legal_values [intersect $legal_values [list "reg"]]
   } else {
      set legal_values [intersect $legal_values [list "fifo"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_pld_if_type.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_pld_if_type $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_pld_if_type $hssi_10g_rx_pcs_pld_if_type $legal_values { hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx } {

   set legal_values [list "basic_krfec_mode" "basic_mode" "disable_mode" "interlaken_mode" "sfis_mode" "teng_1588_krfec_mode" "teng_1588_mode" "teng_baser_krfec_mode" "teng_baser_mode" "teng_sdi_mode" "test_prp_krfec_mode" "test_prp_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_baser_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_1588_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_1588_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="interlaken_mode_rx") }] {
      set legal_values [intersect $legal_values [list "interlaken_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="sfis_mode_rx") }] {
      set legal_values [intersect $legal_values [list "sfis_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_sdi_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_sdi_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "basic_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="test_prp_mode_rx") }] {
      set legal_values [intersect $legal_values [list "test_prp_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="test_prp_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "test_prp_krfec_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_baser_krfec_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_1588_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_1588_krfec_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "basic_krfec_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_prot_mode $legal_values { hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rand_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rand_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "rand_clk_dis" "rand_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "rand_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "rand_clk_dis"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "rand_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "rand_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rand_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rand_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rand_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rand_clken $hssi_10g_rx_pcs_rand_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rd_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rd_clk_sel hssi_10g_rx_pcs_master_clk_sel hssi_10g_rx_pcs_rxfifo_mode } {

   set legal_values [list "rd_refclk_dig" "rd_rx_pld_clk" "rd_rx_pma_clk"]

   if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="register_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_master_clk_sel=="master_refclk_dig") }] {
         set legal_values [intersect $legal_values [list "rd_refclk_dig"]]
      } else {
         set legal_values [intersect $legal_values [list "rd_rx_pma_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "rd_rx_pld_clk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rd_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rd_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rd_clk_sel $hssi_10g_rx_pcs_rd_clk_sel $legal_values { hssi_10g_rx_pcs_master_clk_sel hssi_10g_rx_pcs_rxfifo_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rdfifo_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rdfifo_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "rdfifo_clk_dis" "rdfifo_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rdfifo_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rdfifo_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rdfifo_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rdfifo_clken $hssi_10g_rx_pcs_rdfifo_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_fifo_write_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_fifo_write_ctrl } {

   set legal_values [list "blklock_ignore" "blklock_stops"]

   set legal_values [intersect $legal_values [list "blklock_stops"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_fifo_write_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_fifo_write_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_fifo_write_ctrl $hssi_10g_rx_pcs_rx_fifo_write_ctrl $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_scrm_width { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_scrm_width hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "bit64" "bit66" "bit67"]

   if [expr { ((($hssi_10g_rx_pcs_prot_mode=="interlaken_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      set legal_values [intersect $legal_values [list "bit64"]]
   } else {
      set legal_values [intersect $legal_values [list "bit64"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_scrm_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_scrm_width $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_scrm_width $hssi_10g_rx_pcs_rx_scrm_width $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_sh_location { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_sh_location hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "lsb" "msb"]

   if [expr { ((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      set legal_values [intersect $legal_values [list "lsb"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "lsb"]]
      } else {
         set legal_values [intersect $legal_values [list "msb"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_sh_location.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_sh_location $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_sh_location $hssi_10g_rx_pcs_rx_sh_location $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_signal_ok_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_signal_ok_sel hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "nonsync_ver" "synchronized_ver"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "synchronized_ver"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_lpbk_mode=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "synchronized_ver"]]
      } else {
         if [expr { ((($hssi_10g_rx_pcs_prot_mode=="interlaken_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
            set legal_values [intersect $legal_values [list "synchronized_ver"]]
         } else {
            set legal_values [intersect $legal_values [list "synchronized_ver"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_signal_ok_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_signal_ok_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_signal_ok_sel $hssi_10g_rx_pcs_rx_signal_ok_sel $legal_values { hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_sm_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_sm_bypass hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "rx_sm_bypass_dis" "rx_sm_bypass_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "rx_sm_bypass_dis"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "rx_sm_bypass_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "rx_sm_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "rx_sm_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_sm_bypass_en"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_sm_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_sm_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_sm_bypass $hssi_10g_rx_pcs_rx_sm_bypass $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_sm_hiber { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_sm_hiber hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "rx_sm_hiber_dis" "rx_sm_hiber_en"]

   if [expr { (((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "rx_sm_hiber_en" "rx_sm_hiber_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "rx_sm_hiber_en"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "rx_sm_hiber_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_sm_hiber.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_sm_hiber $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_sm_hiber $hssi_10g_rx_pcs_rx_sm_hiber $legal_values { hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_sm_pipeln { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_sm_pipeln hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "rx_sm_pipeln_dis" "rx_sm_pipeln_en"]

   if [expr { (((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "rx_sm_pipeln_en" "rx_sm_pipeln_dis"]]
      } else {
         if [expr { ($hssi_10g_rx_pcs_low_latency_en=="enable") }] {
            set legal_values [intersect $legal_values [list "rx_sm_pipeln_dis"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_sm_pipeln_en"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "rx_sm_pipeln_en"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_sm_pipeln.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_sm_pipeln $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_sm_pipeln $hssi_10g_rx_pcs_rx_sm_pipeln $legal_values { hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_testbus_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_testbus_sel hssi_10g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "ber_testbus" "blank_testbus" "blksync_testbus1" "blksync_testbus2" "crc32_chk_testbus1" "crc32_chk_testbus2" "dec64b66b_testbus" "descramble_testbus" "frame_sync_testbus1" "frame_sync_testbus2" "gearbox_exp_testbus" "random_ver_testbus" "rxsm_testbus" "rx_fifo_testbus1" "rx_fifo_testbus2"]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx")&&($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="disabled_prot_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "rx_fifo_testbus1"]]
   } else {
      if [expr { !(($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx")) }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode=="tx") }] {
            set legal_values [intersect $legal_values [list "rx_fifo_testbus1"]]
         }
      }
   }
   if [expr { ($hssi_10g_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "rx_fifo_testbus1"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_testbus_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_testbus_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_testbus_sel $hssi_10g_rx_pcs_rx_testbus_sel $legal_values { hssi_10g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rx_true_b2b { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rx_true_b2b hssi_10g_rx_pcs_rxfifo_mode } {

   set legal_values [list "b2b" "single"]

   if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="clk_comp_10g") }] {
      set legal_values [intersect $legal_values [list "b2b" "single"]]
   } else {
      set legal_values [intersect $legal_values [list "b2b"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rx_true_b2b.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rx_true_b2b $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rx_true_b2b $hssi_10g_rx_pcs_rx_true_b2b $legal_values { hssi_10g_rx_pcs_rxfifo_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rxfifo_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_pld_if_type hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "clk_comp_10g" "generic_basic" "generic_interlaken" "phase_comp" "phase_comp_dv" "register_mode"]

   if [expr { ($hssi_10g_rx_pcs_pld_if_type=="reg") }] {
      set legal_values [intersect $legal_values [list "register_mode"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "generic_interlaken"]]
      } else {
         if [expr { ($hssi_10g_rx_pcs_prot_mode=="basic_mode") }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                  set legal_values [intersect $legal_values [list "generic_basic" "phase_comp"]]
               } else {
                  set legal_values [intersect $legal_values [list "generic_basic" "phase_comp" "phase_comp_dv"]]
               }
            } else {
               if [expr { (($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_67")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64")) }] {
                  set legal_values [intersect $legal_values [list "generic_basic"]]
               } else {
                  set legal_values [intersect $legal_values [list "generic_basic" "phase_comp"]]
               }
            }
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode")) }] {
               if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
                  set legal_values [intersect $legal_values [list "clk_comp_10g" "phase_comp"]]
               } else {
                  set legal_values [intersect $legal_values [list "clk_comp_10g"]]
               }
            } else {
               if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
                  if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
                     set legal_values [intersect $legal_values [list "phase_comp" "phase_comp_dv"]]
                  } else {
                     set legal_values [intersect $legal_values [list "phase_comp"]]
                  }
               } else {
                  if [expr { ($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode") }] {
                     set legal_values [intersect $legal_values [list "generic_basic" "phase_comp"]]
                  } else {
                     set legal_values [intersect $legal_values [list "phase_comp"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_rxfifo_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_rxfifo_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_rxfifo_mode $legal_values { hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_pld_if_type hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rxfifo_pempty { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rxfifo_pempty hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
      if [expr { ((($hssi_10g_rx_pcs_rxfifo_mode=="generic_interlaken")||($hssi_10g_rx_pcs_rxfifo_mode=="clk_comp_10g"))||($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic")) }] {
         set legal_values [compare_ge $legal_values 1]
         set legal_values [compare_le $legal_values 10]
      } else {
         set legal_values [compare_eq $legal_values 2]
      }
   } else {
      if [expr { (($hssi_10g_rx_pcs_rxfifo_mode=="generic_interlaken")||($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic")) }] {
         set legal_values [compare_ge $legal_values 2]
         set legal_values [compare_le $legal_values 10]
      } else {
         if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="clk_comp_10g") }] {
            if [expr { ($hssi_10g_rx_pcs_low_latency_en=="enable") }] {
               set legal_values [compare_eq $legal_values 2]
            } else {
               set legal_values [compare_ge $legal_values 2]
               set legal_values [compare_le $legal_values 10]
            }
         } else {
            set legal_values [compare_eq $legal_values 2]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_10g_rx_pcs_rxfifo_pempty.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_10g_rx_pcs_rxfifo_pempty $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_10g_rx_pcs_rxfifo_pempty $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_10g_rx_pcs_rxfifo_pempty $hssi_10g_rx_pcs_rxfifo_pempty $legal_values { hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_rxfifo_pfull { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_rxfifo_pfull hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_rxfifo_pempty hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
      if [expr { ((($hssi_10g_rx_pcs_rxfifo_mode=="generic_interlaken")||($hssi_10g_rx_pcs_rxfifo_mode=="clk_comp_10g"))||($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic")) }] {
         set legal_values [compare_ge $legal_values 10]
         set legal_values [compare_le $legal_values 30]
      } else {
         set legal_values [compare_eq $legal_values 23]
      }
   } else {
      set legal_values [compare_le $legal_values 29]
      if [expr { (($hssi_10g_rx_pcs_rxfifo_mode=="generic_interlaken")||($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic")) }] {
         set legal_values [compare_ge $legal_values [expr { ($hssi_10g_rx_pcs_rxfifo_pempty+8) }]]
      } else {
         if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="clk_comp_10g") }] {
            if [expr { ($hssi_10g_rx_pcs_low_latency_en=="enable") }] {
               set legal_values [compare_eq $legal_values [expr { ($hssi_10g_rx_pcs_rxfifo_pempty+8) }]]
            } else {
               set legal_values [compare_ge $legal_values [expr { ($hssi_10g_rx_pcs_rxfifo_pempty+8) }]]
            }
         } else {
            set legal_values [compare_eq $legal_values 23]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_10g_rx_pcs_rxfifo_pfull.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_10g_rx_pcs_rxfifo_pfull $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_10g_rx_pcs_rxfifo_pfull $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_10g_rx_pcs_rxfifo_pfull $hssi_10g_rx_pcs_rxfifo_pfull $legal_values { hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_rxfifo_pempty hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_stretch_num_stages { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_stretch_num_stages hssi_10g_rx_pcs_fifo_double_read hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "one_stage" "three_stage" "two_stage" "zero_stage"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "zero_stage"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "zero_stage" "one_stage" "two_stage" "three_stage"]]
      } else {
         if [expr { ($hssi_10g_rx_pcs_fifo_double_read=="fifo_double_read_dis") }] {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "one_stage"]]
            } else {
               if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40") }] {
                  set legal_values [intersect $legal_values [list "one_stage"]]
               } else {
                  if [expr { ($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32") }] {
                     if [expr { ($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64") }] {
                        set legal_values [intersect $legal_values [list "two_stage"]]
                     } else {
                        set legal_values [intersect $legal_values [list "two_stage"]]
                     }
                  } else {
                     set legal_values [intersect $legal_values [list "one_stage"]]
                  }
               }
            }
         } else {
            if [expr { (($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64")&&($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")) }] {
               set legal_values [intersect $legal_values [list "two_stage"]]
            } else {
               set legal_values [intersect $legal_values [list "two_stage"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_stretch_num_stages.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_stretch_num_stages $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_stretch_num_stages $hssi_10g_rx_pcs_stretch_num_stages $legal_values { hssi_10g_rx_pcs_fifo_double_read hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_10g_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_sup_mode $hssi_10g_rx_pcs_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_10g_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_test_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_test_mode hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "pseudo_random" "test_off"]

   if [expr { (($hssi_10g_rx_pcs_prot_mode=="test_prp_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "pseudo_random"]]
   } else {
      set legal_values [intersect $legal_values [list "test_off"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_test_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_test_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_test_mode $hssi_10g_rx_pcs_test_mode $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_10g_rx_pcs_wrfifo_clken { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_wrfifo_clken hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "wrfifo_clk_dis" "wrfifo_clk_en"]

   if [expr { (((((($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="sfis_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
         } else {
            if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
            } else {
               set legal_values [intersect $legal_values [list "wrfifo_clk_dis"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_wrfifo_clken.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_wrfifo_clken $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_wrfifo_clken $hssi_10g_rx_pcs_wrfifo_clken $legal_values { hssi_10g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm1_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic") }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                     set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
                  } else {
                     set legal_values [intersect $legal_values [list "bitslip_dis"]]
                  }
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm2_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic") }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                     set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
                  } else {
                     set legal_values [intersect $legal_values [list "bitslip_dis"]]
                  }
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm3_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic") }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                     set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
                  } else {
                     set legal_values [intersect $legal_values [list "bitslip_dis"]]
                  }
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm4_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic") }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                     set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
                  } else {
                     set legal_values [intersect $legal_values [list "bitslip_dis"]]
                  }
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm4es_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  set legal_values [intersect $legal_values [list "bitslip_dis"]]
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm5_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="generic_basic") }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                     set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
                  } else {
                     set legal_values [intersect $legal_values [list "bitslip_dis"]]
                  }
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm5es2_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  set legal_values [intersect $legal_values [list "bitslip_dis"]]
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_10g_rx_pcs_bitslip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_10g_rx_pcs_bitslip_mode hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
   set hssi_10g_rx_pcs_gb_rx_idwidth [20nm5es_convert_a2b_hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_idwidth]
   set hssi_10g_rx_pcs_gb_rx_odwidth [convert_a2b_hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_gb_rx_odwidth]

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="teng_sdi_mode") }] {
      if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ($hssi_10g_rx_pcs_prot_mode=="sfis_mode") }] {
         if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
         } else {
            if [expr { (((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               set legal_values [intersect $legal_values [list "bitslip_dis"]]
            }
         }
      } else {
         if [expr { (($hssi_10g_rx_pcs_prot_mode=="basic_mode")&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en")) }] {
            if [expr { ($hssi_10g_rx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
            } else {
               if [expr { ((((($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_32")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_32"))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_40")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_66")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_40")))||(($hssi_10g_rx_pcs_gb_rx_odwidth=="odwidth_64")&&($hssi_10g_rx_pcs_gb_rx_idwidth=="idwidth_64"))) }] {
                  set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
               } else {
                  set legal_values [intersect $legal_values [list "bitslip_dis"]]
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "bitslip_dis"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_10g_rx_pcs_bitslip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_10g_rx_pcs_bitslip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_10g_rx_pcs_bitslip_mode $hssi_10g_rx_pcs_bitslip_mode $legal_values { hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode }
   }
}


