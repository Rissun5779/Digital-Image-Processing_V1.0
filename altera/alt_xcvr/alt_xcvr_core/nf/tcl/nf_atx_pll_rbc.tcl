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


proc ::nf_atx_pll::parameters::validate_atx_pll_cal_status { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cal_status atx_pll_initial_settings atx_pll_powerdown_mode } {

   set legal_values [list "cal_done" "cal_in_progress"]

   if [expr { (($atx_pll_powerdown_mode=="powerdown")||($atx_pll_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "cal_in_progress"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cal_status.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cal_status $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cal_status $atx_pll_cal_status $legal_values { atx_pll_initial_settings atx_pll_powerdown_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_calibration_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_calibration_mode atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cal_off" "uc_not_rst" "uc_rst_lf" "uc_rst_pll"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cal_off"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "cal_off"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_calibration_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_calibration_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_calibration_mode $atx_pll_calibration_mode $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_cascadeclk_test { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cascadeclk_test atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cascadetest_off" "cascadetest_on"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cascadetest_off"]]
   } else {
      set legal_values [intersect $legal_values [list "cascadetest_off" "cascadetest_on"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cascadeclk_test.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cascadeclk_test $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cascadeclk_test $atx_pll_cascadeclk_test $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_compensation_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_compensation_enable $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_current_setting  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_current_setting $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_lf_3rd_pole_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_3rd_pole_freq $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_lf_order  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cp_lf_order $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_cp_testmode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_testmode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_normal" "cp_test_dn" "cp_test_up" "cp_tristate"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cp_normal"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_testmode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_testmode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_testmode $atx_pll_cp_testmode $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_d2a_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_d2a_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "d2a_disable" "d2a_setting_0" "d2a_setting_1" "d2a_setting_2" "d2a_setting_3" "d2a_setting_4" "d2a_setting_5" "d2a_setting_6" "d2a_setting_7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "d2a_disable"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "d2a_setting_4"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_d2a_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_d2a_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_d2a_voltage $atx_pll_d2a_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_dsm_ecn_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_dsm_ecn_bypass atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pll_ecn_bypass_disable" "pll_ecn_bypass_enable"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "pll_ecn_bypass_disable"]]
   }

   set legal_values [convert_b2a_atx_pll_dsm_ecn_bypass $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_dsm_ecn_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_dsm_ecn_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_dsm_ecn_bypass $atx_pll_dsm_ecn_bypass $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_dsm_ecn_test_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_dsm_ecn_test_en atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pll_ecn_test_disable" "pll_ecn_test_enable"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "pll_ecn_test_disable"]]
   }

   set legal_values [convert_b2a_atx_pll_dsm_ecn_test_en $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_dsm_ecn_test_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_dsm_ecn_test_en $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_dsm_ecn_test_en $atx_pll_dsm_ecn_test_en $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_dsm_fractional_division { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_dsm_fractional_division atx_pll_prot_mode } {

   set legal_values [list -2147483648:2147483647]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_dsm_fractional_division.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_dsm_fractional_division $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_dsm_fractional_division $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_dsm_fractional_division $atx_pll_dsm_fractional_division $legal_values { atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_dsm_fractional_value_ready { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_dsm_fractional_value_ready atx_pll_initial_settings atx_pll_prot_mode } {

   set legal_values [list "pll_k_not_ready" "pll_k_ready"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "pll_k_ready"]]
   } else {
      if [expr { (($atx_pll_prot_mode!="unused")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "pll_k_ready"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_dsm_fractional_value_ready.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_dsm_fractional_value_ready $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_dsm_fractional_value_ready $atx_pll_dsm_fractional_value_ready $legal_values { atx_pll_initial_settings atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_dsm_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_dsm_mode atx_pll_prot_mode } {

   set legal_values [list "dsm_mode_integer" "dsm_mode_phase"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "dsm_mode_integer"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_dsm_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_dsm_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_dsm_mode $atx_pll_dsm_mode $legal_values { atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_dsm_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_dsm_out_sel atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pll_dsm_1st_order" "pll_dsm_2nd_order" "pll_dsm_3rd_order" "pll_dsm_disable"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "pll_dsm_disable"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "pll_dsm_disable"]]
         } else {
            set legal_values [intersect $legal_values [list "pll_dsm_3rd_order"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_dsm_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_dsm_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_dsm_out_sel $atx_pll_dsm_out_sel $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_enable_hclk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_enable_hclk atx_pll_prot_mode } {

   set legal_values [list "hclk_disabled" "hclk_enable"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="pcie_gen1_tx")&&($atx_pll_prot_mode!="pcie_gen2_tx"))) }] {
      set legal_values [intersect $legal_values [list "hclk_disabled"]]
   } else {
      set legal_values [intersect $legal_values [list "hclk_enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_enable_hclk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_enable_hclk $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_enable_hclk $atx_pll_enable_hclk $legal_values { atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_enable_lc_calibration { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_enable_lc_calibration atx_pll_powerdown_mode atx_pll_sup_mode } {

   set legal_values [list "lc_cal_off" "lc_cal_on"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "lc_cal_off"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "lc_cal_on"]]
      }
   }

   set legal_values [convert_b2a_atx_pll_enable_lc_calibration $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_enable_lc_calibration.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_enable_lc_calibration $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_enable_lc_calibration $atx_pll_enable_lc_calibration $legal_values { atx_pll_powerdown_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_enable_lc_vreg_calibration { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_enable_lc_vreg_calibration atx_pll_powerdown_mode atx_pll_sup_mode } {

   set legal_values [list "lc_cal_reg_off" "lc_cal_reg_on"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "lc_cal_reg_off"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "lc_cal_reg_on"]]
      }
   }

   set legal_values [convert_b2a_atx_pll_enable_lc_vreg_calibration $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_enable_lc_vreg_calibration.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_enable_lc_vreg_calibration $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_enable_lc_vreg_calibration $atx_pll_enable_lc_vreg_calibration $legal_values { atx_pll_powerdown_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_lcnt_fpll_cascading { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_lcnt_fpll_cascading } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_lcnt_fpll_cascading  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_lcnt_fpll_cascading
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_lcnt_fpll_cascading  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_lcnt_fpll_cascading
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_lcnt_fpll_cascading  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_lcnt_fpll_cascading
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_lcnt_fpll_cascading  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_lcnt_fpll_cascading
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_lcnt_fpll_cascading  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_lcnt_fpll_cascading
	} else {
		set legal_values [list 0:68719476735]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				set value_range [split_range [lindex $legal_values 0]]
				set min [lindex $value_range 0]
				set max [lindex $value_range 1]

				ip_set "parameter.atx_pll_f_max_lcnt_fpll_cascading.value" $min
				if { $min != $max && $PROP_M_AUTOWARN } {
					if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
						ip_message warning "The value of parameter atx_pll_f_max_lcnt_fpll_cascading cannot be automatically resolved. Valid value ranges are: ${legal_values}."
					}
				}
			}
			if { $len != 1 && $PROP_M_AUTOWARN } {
				if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
					ip_message_warning "The value of parameter atx_pll_f_max_lcnt_fpll_cascading cannot be automatically resolved. Valid value ranges are ${legal_values}."
				}
			}
		} else {
			auto_value_out_of_range_message auto atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_lcnt_fpll_cascading $legal_values { }
		}
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_bw_sel $atx_pll_dsm_mode $atx_pll_fb_select
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_bw_sel $atx_pll_dsm_mode $atx_pll_fb_select
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_dsm_mode $atx_pll_fb_select
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_dsm_mode $atx_pll_fb_select
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_bw_sel $atx_pll_dsm_mode $atx_pll_fb_select
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_dsm_mode $atx_pll_fb_select
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_bw_sel $atx_pll_dsm_mode $atx_pll_fb_select
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_pfd  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_pfd $atx_pll_bw_sel $atx_pll_dsm_mode $atx_pll_fb_select
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_ref { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_ref } {
   regsub -nocase -all {\D} $atx_pll_f_max_ref "" atx_pll_f_max_ref

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_ref.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_ref $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_ref $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_ref $atx_pll_f_max_ref $legal_values { }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_0
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_1
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode atx_pll_l_counter_enable } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode $atx_pll_l_counter_enable
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode $atx_pll_l_counter_enable
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_tank_2 $atx_pll_dsm_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode atx_pll_l_counter_enable } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode $atx_pll_l_counter_enable
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode $atx_pll_l_counter_enable
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_max_vco $atx_pll_dsm_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_max_x1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_x1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8700000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_x1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_x1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_x1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_x1 $atx_pll_f_max_x1 $legal_values { }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_min_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_pfd } {
   regsub -nocase -all {\D} $atx_pll_f_min_pfd "" atx_pll_f_min_pfd

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 61440000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_pfd $atx_pll_f_min_pfd $legal_values { }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_min_ref { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_ref } {
   regsub -nocase -all {\D} $atx_pll_f_min_ref "" atx_pll_f_min_ref

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 61440000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_ref.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_ref $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_ref $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_ref $atx_pll_f_min_ref $legal_values { }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_tank_0  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_0
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_tank_1  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_1
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_tank_2  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_tank_2
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_vco  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_f_min_vco
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_fb_select { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_dsm_mode atx_pll_prot_mode } {

   set legal_values [list "direct_fb" "iqtxrxclk_fb"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_dsm_mode!="dsm_mode_integer")) }] {
      set legal_values [intersect $legal_values [list "direct_fb"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_fb_select.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_fb_select $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_fb_select $atx_pll_fb_select $legal_values { atx_pll_dsm_mode atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_fpll_refclk_selection { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_vco_freq } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_fpll_refclk_selection  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_fpll_refclk_selection  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_fpll_refclk_selection  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_fpll_refclk_selection  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_fpll_refclk_selection  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_vco_freq
	} else {
		set legal_values [list "select_div_by_2" "select_vco_output"]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				ip_set "parameter.atx_pll_fpll_refclk_selection.value" [lindex $legal_values 0]
			}
			if { $len != 1 && $PROP_M_AUTOWARN} {
				if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
					ip_message warning "The value of parameter atx_pll_fpll_refclk_selection cannot be automatically resolved. Valid values are: ${legal_values}."
				}
			}
		} else {
			auto_invalid_value_message auto atx_pll_fpll_refclk_selection $atx_pll_fpll_refclk_selection $legal_values { }
		}
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_hclk_divide { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_hclk_divide atx_pll_prot_mode atx_pll_reference_clock_frequency } {
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "hclk_disable" "hclk_div40" "hclk_div50"]

   if [expr { (($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode!="pcie_gen1_tx")&&($atx_pll_prot_mode!="pcie_gen2_tx"))&&($atx_pll_prot_mode!="pcie_gen3_tx"))) }] {
      set legal_values [intersect $legal_values [list "hclk_disable"]]
   } else {
      if [expr { ($atx_pll_reference_clock_frequency==100000000) }] {
         set legal_values [intersect $legal_values [list "hclk_div50"]]
      } else {
         set legal_values [intersect $legal_values [list "hclk_div40"]]
      }
   }

   set legal_values [convert_b2a_atx_pll_hclk_divide $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_hclk_divide.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_hclk_divide $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_hclk_divide $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_hclk_divide $atx_pll_hclk_divide $legal_values { atx_pll_prot_mode atx_pll_reference_clock_frequency }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_iqclk_mux_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_iqclk_mux_sel atx_pll_prot_mode } {

   set legal_values [list "iqtxrxclk0" "iqtxrxclk1" "iqtxrxclk2" "iqtxrxclk3" "iqtxrxclk4" "iqtxrxclk5" "power_down"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "power_down"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_iqclk_mux_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_iqclk_mux_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_iqclk_mux_sel $atx_pll_iqclk_mux_sel $legal_values { atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_l_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter atx_pll_l_counter_scratch } {

   set legal_values [list "lcnt_div1" "lcnt_div16" "lcnt_div2" "lcnt_div4" "lcnt_div8"]

   if [expr { ($atx_pll_l_counter_scratch==1) }] {
      set legal_values [intersect $legal_values [list "lcnt_div1"]]   }
   if [expr { ($atx_pll_l_counter_scratch==2) }] {
      set legal_values [intersect $legal_values [list "lcnt_div2"]]   }
   if [expr { ($atx_pll_l_counter_scratch==4) }] {
      set legal_values [intersect $legal_values [list "lcnt_div4"]]   }
   if [expr { ($atx_pll_l_counter_scratch==8) }] {
      set legal_values [intersect $legal_values [list "lcnt_div8"]]   }
   if [expr { ($atx_pll_l_counter_scratch==16) }] {
      set legal_values [intersect $legal_values [list "lcnt_div16"]]   }

   set legal_values [convert_b2a_atx_pll_l_counter $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_l_counter.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_l_counter $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_l_counter $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_l_counter $atx_pll_l_counter $legal_values { atx_pll_l_counter_scratch }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_primary_use atx_pll_prot_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_l_counter_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_l_counter_enable $atx_pll_primary_use $atx_pll_prot_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_l_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode } {

   set legal_values [list 0:31]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 2]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8 16]]
   }

   return $legal_values
}

proc ::nf_atx_pll::parameters::validate_atx_pll_lc_atb { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_atb atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "atb_select0" "atb_select1" "atb_select10" "atb_select11" "atb_select12" "atb_select13" "atb_select14" "atb_select15" "atb_select16" "atb_select17" "atb_select18" "atb_select19" "atb_select2" "atb_select20" "atb_select21" "atb_select22" "atb_select23" "atb_select24" "atb_select25" "atb_select26" "atb_select27" "atb_select28" "atb_select29" "atb_select3" "atb_select30" "atb_select4" "atb_select5" "atb_select6" "atb_select7" "atb_select8" "atb_select9" "atb_selectdisable"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "atb_selectdisable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lc_atb.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lc_atb $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lc_atb $atx_pll_lc_atb $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_lc_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_mode atx_pll_prot_mode } {

   set legal_values [list "lccmu_normal" "lccmu_pd" "lccmu_reset"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lccmu_pd"]]
   } else {
      set legal_values [intersect $legal_values [list "lccmu_normal"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lc_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lc_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lc_mode $atx_pll_lc_mode $legal_values { atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_lc_to_fpll_l_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_to_fpll_l_counter atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lc_to_fpll_l_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter_scratch $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lc_to_fpll_l_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter_scratch $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lc_to_fpll_l_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter_scratch $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lc_to_fpll_l_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter_scratch $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lc_to_fpll_l_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter_scratch $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} else {
		set legal_values [list "lcounter_setting0" "lcounter_setting1" "lcounter_setting10" "lcounter_setting11" "lcounter_setting12" "lcounter_setting13" "lcounter_setting14" "lcounter_setting15" "lcounter_setting16" "lcounter_setting17" "lcounter_setting18" "lcounter_setting19" "lcounter_setting2" "lcounter_setting20" "lcounter_setting21" "lcounter_setting22" "lcounter_setting23" "lcounter_setting24" "lcounter_setting25" "lcounter_setting26" "lcounter_setting27" "lcounter_setting28" "lcounter_setting29" "lcounter_setting3" "lcounter_setting30" "lcounter_setting31" "lcounter_setting4" "lcounter_setting5" "lcounter_setting6" "lcounter_setting7" "lcounter_setting8" "lcounter_setting9"]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				ip_set "parameter.atx_pll_lc_to_fpll_l_counter.value" [lindex $legal_values 0]
			}
			if { $len != 1 && $PROP_M_AUTOWARN} {
				if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
					ip_message warning "The value of parameter atx_pll_lc_to_fpll_l_counter cannot be automatically resolved. Valid values are: ${legal_values}."
				}
			}
		} else {
			auto_invalid_value_message auto atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter $legal_values { }
		}
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_lc_to_fpll_l_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lc_to_fpll_l_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lc_to_fpll_l_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lc_to_fpll_l_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lc_to_fpll_l_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lc_to_fpll_l_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} else {
		set legal_values [list 0:31]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				set value_range [split_range [lindex $legal_values 0]]
				set min [lindex $value_range 0]
				set max [lindex $value_range 1]

				ip_set "parameter.atx_pll_lc_to_fpll_l_counter_scratch.value" $min
				if { $min != $max && $PROP_M_AUTOWARN } {
					if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
						ip_message warning "The value of parameter atx_pll_lc_to_fpll_l_counter_scratch cannot be automatically resolved. Valid value ranges are: ${legal_values}."
					}
				}
			}
			if { $len != 1 && $PROP_M_AUTOWARN } {
				if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
					ip_message_warning "The value of parameter atx_pll_lc_to_fpll_l_counter_scratch cannot be automatically resolved. Valid value ranges are ${legal_values}."
				}
			}
		} else {
			auto_value_out_of_range_message auto atx_pll_lc_to_fpll_l_counter_scratch $atx_pll_lc_to_fpll_l_counter_scratch $legal_values { }
		}
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lf_cbig_size  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_cbig_size $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lf_resistance  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_resistance $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_m_counter $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lf_ripplecap  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_lf_ripplecap $atx_pll_bw_sel $atx_pll_is_otn $atx_pll_is_sdi $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_reference_clock_frequency $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_primary_use atx_pll_prot_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_m_counter  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_cgb_div $atx_pll_dsm_mode $atx_pll_fb_select $atx_pll_l_counter_scratch $atx_pll_pma_width $atx_pll_primary_use $atx_pll_prot_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_max_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_max_fractional_percentage
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_min_fractional_percentage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_min_fractional_percentage
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_primary_use atx_pll_prot_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_n_counter_scratch  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_fb_select $atx_pll_primary_use $atx_pll_prot_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use atx_pll_l_counter_enable } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_x1 $atx_pll_primary_use
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_x1 $atx_pll_primary_use
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_x1 $atx_pll_l_counter_enable
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_x1 $atx_pll_l_counter_enable
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_x1 $atx_pll_primary_use
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_x1 $atx_pll_l_counter_enable
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_x1 $atx_pll_primary_use
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_output_clock_frequency  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_clock_frequency $atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_x1 $atx_pll_primary_use
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_output_regulator_supply  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_output_regulator_supply $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_overrange_voltage  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_overrange_voltage $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_pfd_delay_compensation { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_delay_compensation atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_pfd_delay_compensation  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_delay_compensation $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_pfd_delay_compensation  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_delay_compensation $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_pfd_delay_compensation  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_delay_compensation $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_pfd_delay_compensation  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_delay_compensation $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_pfd_delay_compensation  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_delay_compensation $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} else {
		set legal_values [list "fb_compensated_delay" "normal_delay" "ref_compensated_delay" "unused_delay"]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				ip_set "parameter.atx_pll_pfd_delay_compensation.value" [lindex $legal_values 0]
			}
			if { $len != 1 && $PROP_M_AUTOWARN} {
				if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
					ip_message warning "The value of parameter atx_pll_pfd_delay_compensation cannot be automatically resolved. Valid values are: ${legal_values}."
				}
			}
		} else {
			auto_invalid_value_message auto atx_pll_pfd_delay_compensation $atx_pll_pfd_delay_compensation $legal_values { }
		}
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_pfd_pulse_width { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_pulse_width atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_pfd_pulse_width  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_pulse_width $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_pfd_pulse_width  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_pulse_width $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_pfd_pulse_width  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_pulse_width $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_pfd_pulse_width  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_pulse_width $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_pfd_pulse_width  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_pfd_pulse_width $atx_pll_dsm_mode $atx_pll_prot_mode $atx_pll_sup_mode
	} else {
		set legal_values [list "pulse_width_setting0" "pulse_width_setting1" "pulse_width_setting2" "pulse_width_setting3"]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				ip_set "parameter.atx_pll_pfd_pulse_width.value" [lindex $legal_values 0]
			}
			if { $len != 1 && $PROP_M_AUTOWARN} {
				if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
					ip_message warning "The value of parameter atx_pll_pfd_pulse_width cannot be automatically resolved. Valid values are: ${legal_values}."
				}
			}
		} else {
			auto_invalid_value_message auto atx_pll_pfd_pulse_width $atx_pll_pfd_pulse_width $legal_values { }
		}
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_power_rail_et { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_power_rail_et atx_pll_power_mode } {

   set legal_values [list 0:4095]

   if [expr { ($atx_pll_power_mode=="low_power") }] {
      set legal_values [compare_eq $legal_values 950]
   } else {
      if [expr { ($atx_pll_power_mode=="mid_power") }] {
         set legal_values [compare_eq $legal_values 1030]
      } else {
         if [expr { ($atx_pll_power_mode=="high_perf") }] {
            set legal_values [compare_eq $legal_values 1120]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_power_rail_et.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_power_rail_et $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_power_rail_et $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_power_rail_et $atx_pll_power_rail_et $legal_values { atx_pll_power_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_prot_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_prot_mode $atx_pll_powerdown_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_ref_clk_div { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_ref_clk_div atx_pll_n_counter_scratch } {

   set legal_values [list "bypass" "divide2" "divide4" "divide8"]

   if [expr { ($atx_pll_n_counter_scratch==1) }] {
      set legal_values [intersect $legal_values [list "bypass"]]   }
   if [expr { ($atx_pll_n_counter_scratch==2) }] {
      set legal_values [intersect $legal_values [list "divide2"]]   }
   if [expr { ($atx_pll_n_counter_scratch==4) }] {
      set legal_values [intersect $legal_values [list "divide4"]]   }
   if [expr { ($atx_pll_n_counter_scratch==8) }] {
      set legal_values [intersect $legal_values [list "divide8"]]   }

   set legal_values [convert_b2a_atx_pll_ref_clk_div $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_ref_clk_div.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_ref_clk_div $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_ref_clk_div $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_ref_clk_div $atx_pll_ref_clk_div $legal_values { atx_pll_n_counter_scratch }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_reference_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_reference_clock_frequency atx_pll_f_max_pfd atx_pll_f_min_pfd atx_pll_fb_select atx_pll_n_counter_scratch atx_pll_prot_mode } {
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd
   regsub -nocase -all {\D} $atx_pll_f_min_pfd "" atx_pll_f_min_pfd

   set legal_values [list 0:68719476735]

   if [expr { !(((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb"))) }] {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_n_counter_scratch*($atx_pll_f_min_pfd-0)) }]]
      set legal_values [compare_le $legal_values [expr { ($atx_pll_n_counter_scratch*($atx_pll_f_max_pfd+0)) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_reference_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_reference_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_reference_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_reference_clock_frequency $atx_pll_reference_clock_frequency $legal_values { atx_pll_f_max_pfd atx_pll_f_min_pfd atx_pll_fb_select atx_pll_n_counter_scratch atx_pll_prot_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_regulator_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_regulator_bypass atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "reg_bypass" "reg_enable"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "reg_enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_regulator_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_regulator_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_regulator_bypass $atx_pll_regulator_bypass $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_tank_band  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_tank_band $atx_pll_initial_settings $atx_pll_prot_mode $atx_pll_sup_mode $atx_pll_vco_freq
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_tank_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_sel atx_pll_f_max_tank_0 atx_pll_f_max_tank_1 atx_pll_f_max_tank_2 atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lctank0" "lctank1" "lctank2"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lctank0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         if [expr { ($atx_pll_vco_freq<$atx_pll_f_max_tank_0) }] {
            set legal_values [intersect $legal_values [list "lctank0"]]         }
         if [expr { (($atx_pll_vco_freq>=$atx_pll_f_max_tank_0)&&($atx_pll_vco_freq<$atx_pll_f_max_tank_1)) }] {
            set legal_values [intersect $legal_values [list "lctank1"]]         }
         if [expr { (($atx_pll_vco_freq>=$atx_pll_f_max_tank_1)&&($atx_pll_vco_freq<=$atx_pll_f_max_tank_2)) }] {
            set legal_values [intersect $legal_values [list "lctank2"]]         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_sel $atx_pll_tank_sel $legal_values { atx_pll_f_max_tank_0 atx_pll_f_max_tank_1 atx_pll_f_max_tank_2 atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_tank_voltage_coarse { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_voltage_coarse atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg_setting_coarse0" "vreg_setting_coarse1" "vreg_setting_coarse2" "vreg_setting_coarse3" "vreg_setting_coarse4" "vreg_setting_coarse5" "vreg_setting_coarse6" "vreg_setting_coarse7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg_setting_coarse0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg_setting_coarse0"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_voltage_coarse.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_voltage_coarse $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_voltage_coarse $atx_pll_tank_voltage_coarse $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_tank_voltage_fine { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_voltage_fine atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg_setting0" "vreg_setting1" "vreg_setting2" "vreg_setting3" "vreg_setting4" "vreg_setting5" "vreg_setting6" "vreg_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "vreg_setting5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_voltage_fine.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_voltage_fine $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_voltage_fine $atx_pll_tank_voltage_fine $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_underrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_underrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "under_setting0" "under_setting1" "under_setting2" "under_setting3" "under_setting4" "under_setting5" "under_setting6" "under_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "under_setting4"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_underrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_underrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_underrange_voltage $atx_pll_underrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_vccdreg_clk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vccdreg_clk atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg_clk0" "vreg_clk1" "vreg_clk10" "vreg_clk11" "vreg_clk12" "vreg_clk13" "vreg_clk14" "vreg_clk15" "vreg_clk16" "vreg_clk17" "vreg_clk18" "vreg_clk19" "vreg_clk2" "vreg_clk20" "vreg_clk21" "vreg_clk22" "vreg_clk23" "vreg_clk24" "vreg_clk25" "vreg_clk26" "vreg_clk27" "vreg_clk28" "vreg_clk29" "vreg_clk3" "vreg_clk30" "vreg_clk31" "vreg_clk4" "vreg_clk5" "vreg_clk6" "vreg_clk7" "vreg_clk8" "vreg_clk9"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "vreg_clk5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vccdreg_clk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vccdreg_clk $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vccdreg_clk $atx_pll_vccdreg_clk $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_vccdreg_fb { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vccdreg_fb atx_pll_initial_settings atx_pll_power_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg_fb0" "vreg_fb1" "vreg_fb10" "vreg_fb11" "vreg_fb12" "vreg_fb13" "vreg_fb14" "vreg_fb15" "vreg_fb16" "vreg_fb17" "vreg_fb18" "vreg_fb19" "vreg_fb2" "vreg_fb20" "vreg_fb21" "vreg_fb22" "vreg_fb23" "vreg_fb24" "vreg_fb25" "vreg_fb26" "vreg_fb27" "vreg_fb28" "vreg_fb29" "vreg_fb3" "vreg_fb30" "vreg_fb31" "vreg_fb4" "vreg_fb5" "vreg_fb6" "vreg_fb7" "vreg_fb8" "vreg_fb9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg_fb0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         if [expr { ($atx_pll_power_mode=="low_power") }] {
            set legal_values [intersect $legal_values [list "vreg_fb8"]]
         } else {
            if [expr { ($atx_pll_power_mode=="mid_power") }] {
               set legal_values [intersect $legal_values [list "vreg_fb0"]]
            } else {
               set legal_values [intersect $legal_values [list "vreg_fb31"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vccdreg_fb.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vccdreg_fb $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vccdreg_fb $atx_pll_vccdreg_fb $legal_values { atx_pll_initial_settings atx_pll_power_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_vccdreg_fw { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vccdreg_fw atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg_fw0" "vreg_fw1" "vreg_fw10" "vreg_fw11" "vreg_fw12" "vreg_fw13" "vreg_fw14" "vreg_fw15" "vreg_fw16" "vreg_fw17" "vreg_fw18" "vreg_fw19" "vreg_fw2" "vreg_fw20" "vreg_fw21" "vreg_fw22" "vreg_fw23" "vreg_fw24" "vreg_fw25" "vreg_fw26" "vreg_fw27" "vreg_fw28" "vreg_fw29" "vreg_fw3" "vreg_fw30" "vreg_fw31" "vreg_fw4" "vreg_fw5" "vreg_fw6" "vreg_fw7" "vreg_fw8" "vreg_fw9"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "vreg_fw5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vccdreg_fw.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vccdreg_fw $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vccdreg_fw $atx_pll_vccdreg_fw $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}

proc ::nf_atx_pll::parameters::validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_vco_bypass_enable  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_bypass_enable $atx_pll_primary_use $atx_pll_prot_mode $atx_pll_sup_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode atx_pll_l_counter_enable } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_dsm_mode $atx_pll_f_max_pfd $atx_pll_f_max_vco $atx_pll_f_min_vco $atx_pll_l_counter_scratch $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_powerdown_mode $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_dsm_mode $atx_pll_f_max_pfd $atx_pll_f_max_vco $atx_pll_f_min_vco $atx_pll_l_counter_scratch $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_powerdown_mode $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_f_min_vco $atx_pll_l_counter_enable $atx_pll_l_counter_scratch $atx_pll_output_clock_frequency $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_f_min_vco $atx_pll_l_counter_enable $atx_pll_l_counter_scratch $atx_pll_output_clock_frequency $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_dsm_mode $atx_pll_f_max_pfd $atx_pll_f_max_vco $atx_pll_f_min_vco $atx_pll_l_counter_scratch $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_powerdown_mode $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_f_min_vco $atx_pll_l_counter_enable $atx_pll_l_counter_scratch $atx_pll_output_clock_frequency $atx_pll_powerdown_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_dsm_mode $atx_pll_f_max_pfd $atx_pll_f_max_vco $atx_pll_f_min_vco $atx_pll_l_counter_scratch $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_powerdown_mode $atx_pll_primary_use $atx_pll_prot_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_vco_freq  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_vco_freq $atx_pll_dsm_mode $atx_pll_f_max_pfd $atx_pll_f_max_vco $atx_pll_f_min_vco $atx_pll_l_counter_scratch $atx_pll_m_counter $atx_pll_output_clock_frequency $atx_pll_powerdown_mode $atx_pll_primary_use $atx_pll_prot_mode
	}
}

proc ::nf_atx_pll::parameters::validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_xcpvco_xchgpmplf_cp_current_boost atx_pll_prot_mode atx_pll_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_atx_pll::parameters::20nm4_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_atx_pll::parameters::20nm5_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_atx_pll::parameters::20nm2_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_atx_pll::parameters::20nm1_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_prot_mode $atx_pll_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_atx_pll::parameters::20nm3_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_prot_mode $atx_pll_sup_mode
	} else {
		set legal_values [list "boost_setting" "normal_setting"]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				ip_set "parameter.atx_pll_xcpvco_xchgpmplf_cp_current_boost.value" [lindex $legal_values 0]
			}
			if { $len != 1 && $PROP_M_AUTOWARN} {
				if { $device_revision!="20nm4es" && $device_revision!="20nm5es2" && $device_revision!="20nm5es" } {
					ip_message warning "The value of parameter atx_pll_xcpvco_xchgpmplf_cp_current_boost cannot be automatically resolved. Valid values are: ${legal_values}."
				}
			}
		} else {
			auto_invalid_value_message auto atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values { }
		}
	}
}

proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "cp_mode_enable"]]
      }
   }

   set legal_values [20nm1_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm1_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting19"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                  } else {
                     set legal_values [intersect $legal_values [list "cp_current_setting19"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "cp_current_setting19"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting26"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "cp_current_setting33"]]
               } else {
                  if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting20"]]
                  } else {
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting10"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting15"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting12"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting25"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
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
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm1_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               } else {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm1_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_order"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_lcnt_fpll_cascading { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_lcnt_fpll_cascading } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 1200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_lcnt_fpll_cascading.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_lcnt_fpll_cascading $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select } {
   set atx_pll_bw_sel [20nm1_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_bw_sel=="high_bw") }] {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
            set legal_values [compare_eq $legal_values 600000000]
         } else {
            set legal_values [compare_eq $legal_values 800000000]
         }
      } else {
         set legal_values [compare_eq $legal_values 400000000]
      }
   } else {
      if [expr { ($atx_pll_bw_sel=="mid_bw") }] {
         set legal_values [compare_eq $legal_values 350000000]
      } else {
         set legal_values [compare_eq $legal_values 160000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 6500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_fpll_refclk_selection { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_vco_freq } {

   set legal_values [list "select_div_by_2" "select_vco_output"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_primary_use!="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "select_vco_output"]]
   } else {
      if [expr { ($atx_pll_vco_freq>10440000000) }] {
         set legal_values [intersect $legal_values [list "select_div_by_2"]]
      } else {
         set legal_values [intersect $legal_values [list "select_vco_output"]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ((($atx_pll_prot_mode=="unused")||($atx_pll_primary_use=="hssi_hf"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   } else {
      set legal_values [intersect $legal_values [list "lcnt_on"]]
   }

   set legal_values [20nm1_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lc_to_fpll_l_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_to_fpll_l_counter atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcounter_setting0" "lcounter_setting1" "lcounter_setting10" "lcounter_setting11" "lcounter_setting12" "lcounter_setting13" "lcounter_setting14" "lcounter_setting15" "lcounter_setting16" "lcounter_setting17" "lcounter_setting18" "lcounter_setting19" "lcounter_setting2" "lcounter_setting20" "lcounter_setting21" "lcounter_setting22" "lcounter_setting23" "lcounter_setting24" "lcounter_setting25" "lcounter_setting26" "lcounter_setting27" "lcounter_setting28" "lcounter_setting29" "lcounter_setting3" "lcounter_setting30" "lcounter_setting31" "lcounter_setting4" "lcounter_setting5" "lcounter_setting6" "lcounter_setting7" "lcounter_setting8" "lcounter_setting9"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [intersect $legal_values [list "lcounter_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==0) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==1) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==2) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==3) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==4) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==5) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting5"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==6) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting6"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==7) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting7"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==8) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting8"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==9) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting9"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==10) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting10"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==11) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting11"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==12) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting12"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==13) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting13"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==14) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting14"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==15) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting15"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==16) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting16"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==17) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting17"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==18) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting18"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==19) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting19"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==20) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting20"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==21) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting21"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==22) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting22"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==23) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting23"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==24) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting24"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==25) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting25"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==26) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting26"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==27) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting27"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==28) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting28"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==29) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting29"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==30) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting30"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==31) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting31"]]         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lc_to_fpll_l_counter.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lc_to_fpll_l_counter $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter $legal_values { atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lc_to_fpll_l_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list 0:31]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [compare_inside $legal_values [list 4:31]]
      } else {
         set legal_values [compare_inside $legal_values [list 0:31]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm1_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm1_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_setting1"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                  set legal_values [intersect $legal_values [list "lf_setting2"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm1_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_1"]]
                  } else {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "lf_no_ripple"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 10:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 8:127]]
         }
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 11:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 11:123]]
         }
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 100]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 0]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { (((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use } {
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }
   if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_lcnt_fpll_cascading]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_pfd_delay_compensation { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_delay_compensation atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "fb_compensated_delay" "normal_delay" "ref_compensated_delay" "unused_delay"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "normal_delay"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "normal_delay"]]
         } else {
            set legal_values [intersect $legal_values [list "ref_compensated_delay"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_delay_compensation.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_delay_compensation $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_delay_compensation $atx_pll_pfd_delay_compensation $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_pfd_pulse_width { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_pulse_width atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pulse_width_setting0" "pulse_width_setting1" "pulse_width_setting2" "pulse_width_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
         } else {
            set legal_values [intersect $legal_values [list "pulse_width_setting2"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_pulse_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_pulse_width $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_pulse_width $atx_pll_pfd_pulse_width $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sas_tx" "sata_tx" "unused" "upi_tx"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=6500000000)&&($atx_pll_vco_freq<6700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6700000000)&&($atx_pll_vco_freq<6900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6900000000)&&($atx_pll_vco_freq<7100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=7100000000)&&($atx_pll_vco_freq<7400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7400000000)&&($atx_pll_vco_freq<7800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=7800000000)&&($atx_pll_vco_freq<8200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=8200000000)&&($atx_pll_vco_freq<8600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8600000000)&&($atx_pll_vco_freq<8800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=8800000000)&&($atx_pll_vco_freq<8900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=8900000000)&&($atx_pll_vco_freq<9100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=9100000000)&&($atx_pll_vco_freq<9350000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=9350000000)&&($atx_pll_vco_freq<9750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=9750000000)&&($atx_pll_vco_freq<10400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=10400000000)&&($atx_pll_vco_freq<10600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=10600000000)&&($atx_pll_vco_freq<11100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=11100000000)&&($atx_pll_vco_freq<11400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11400000000)&&($atx_pll_vco_freq<11550000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11550000000)&&($atx_pll_vco_freq<11900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11900000000)&&($atx_pll_vco_freq<12600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=12600000000)&&($atx_pll_vco_freq<13110000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=13110000000)&&($atx_pll_vco_freq<13150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=13150000000)&&($atx_pll_vco_freq<13650000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13650000000)&&($atx_pll_vco_freq<14200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=14200000000)&&($atx_pll_vco_freq<14500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lcnt_bypass"]]
         } else {
            set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
         }
      }
   }

   set legal_values [20nm1_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
      set legal_values [compare_le $legal_values [expr { ($atx_pll_f_max_vco+0) }]]
   }
   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_primary_use=="hssi_hf") }] {
         set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
            set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
         }
      }
   }
   if [expr { ($atx_pll_dsm_mode!="dsm_mode_integer") }] {
      set legal_values [compare_le $legal_values [expr { (($atx_pll_f_max_pfd*2)*($atx_pll_m_counter-3)) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm1_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_xcpvco_xchgpmplf_cp_current_boost atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "boost_setting" "normal_setting"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "normal_setting"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_xcpvco_xchgpmplf_cp_current_boost.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "cp_mode_enable"]]
      }
   }

   set legal_values [20nm2_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting19"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                  } else {
                     set legal_values [intersect $legal_values [list "cp_current_setting19"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "cp_current_setting19"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting26"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "cp_current_setting33"]]
               } else {
                  if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting20"]]
                  } else {
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting10"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting15"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting12"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting25"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
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
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               } else {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_order"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_lcnt_fpll_cascading { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_lcnt_fpll_cascading } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 1200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_lcnt_fpll_cascading.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_lcnt_fpll_cascading $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select } {
   set atx_pll_bw_sel [20nm2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_bw_sel=="high_bw") }] {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
            set legal_values [compare_eq $legal_values 600000000]
         } else {
            set legal_values [compare_eq $legal_values 800000000]
         }
      } else {
         set legal_values [compare_eq $legal_values 400000000]
      }
   } else {
      if [expr { ($atx_pll_bw_sel=="mid_bw") }] {
         set legal_values [compare_eq $legal_values 350000000]
      } else {
         set legal_values [compare_eq $legal_values 160000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 6500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_fpll_refclk_selection { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_vco_freq } {

   set legal_values [list "select_div_by_2" "select_vco_output"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_primary_use!="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "select_vco_output"]]
   } else {
      if [expr { ($atx_pll_vco_freq>10440000000) }] {
         set legal_values [intersect $legal_values [list "select_div_by_2"]]
      } else {
         set legal_values [intersect $legal_values [list "select_vco_output"]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ((($atx_pll_prot_mode=="unused")||($atx_pll_primary_use=="hssi_hf"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   } else {
      set legal_values [intersect $legal_values [list "lcnt_on"]]
   }

   set legal_values [20nm2_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lc_to_fpll_l_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_to_fpll_l_counter atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcounter_setting0" "lcounter_setting1" "lcounter_setting10" "lcounter_setting11" "lcounter_setting12" "lcounter_setting13" "lcounter_setting14" "lcounter_setting15" "lcounter_setting16" "lcounter_setting17" "lcounter_setting18" "lcounter_setting19" "lcounter_setting2" "lcounter_setting20" "lcounter_setting21" "lcounter_setting22" "lcounter_setting23" "lcounter_setting24" "lcounter_setting25" "lcounter_setting26" "lcounter_setting27" "lcounter_setting28" "lcounter_setting29" "lcounter_setting3" "lcounter_setting30" "lcounter_setting31" "lcounter_setting4" "lcounter_setting5" "lcounter_setting6" "lcounter_setting7" "lcounter_setting8" "lcounter_setting9"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [intersect $legal_values [list "lcounter_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==0) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==1) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==2) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==3) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==4) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==5) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting5"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==6) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting6"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==7) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting7"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==8) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting8"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==9) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting9"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==10) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting10"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==11) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting11"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==12) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting12"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==13) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting13"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==14) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting14"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==15) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting15"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==16) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting16"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==17) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting17"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==18) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting18"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==19) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting19"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==20) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting20"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==21) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting21"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==22) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting22"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==23) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting23"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==24) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting24"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==25) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting25"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==26) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting26"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==27) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting27"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==28) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting28"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==29) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting29"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==30) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting30"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==31) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting31"]]         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lc_to_fpll_l_counter.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lc_to_fpll_l_counter $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter $legal_values { atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lc_to_fpll_l_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list 0:31]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [compare_inside $legal_values [list 4:31]]
      } else {
         set legal_values [compare_inside $legal_values [list 0:31]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_setting1"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                  set legal_values [intersect $legal_values [list "lf_setting2"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_1"]]
                  } else {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "lf_no_ripple"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 10:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 8:127]]
         }
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 11:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 11:123]]
         }
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 100]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 0]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { (((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use } {
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }
   if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_lcnt_fpll_cascading]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_pfd_delay_compensation { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_delay_compensation atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "fb_compensated_delay" "normal_delay" "ref_compensated_delay" "unused_delay"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "normal_delay"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "normal_delay"]]
         } else {
            set legal_values [intersect $legal_values [list "ref_compensated_delay"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_delay_compensation.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_delay_compensation $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_delay_compensation $atx_pll_pfd_delay_compensation $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_pfd_pulse_width { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_pulse_width atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pulse_width_setting0" "pulse_width_setting1" "pulse_width_setting2" "pulse_width_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
         } else {
            set legal_values [intersect $legal_values [list "pulse_width_setting2"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_pulse_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_pulse_width $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_pulse_width $atx_pll_pfd_pulse_width $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sas_tx" "sata_tx" "unused" "upi_tx"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=6500000000)&&($atx_pll_vco_freq<6700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6700000000)&&($atx_pll_vco_freq<6900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6900000000)&&($atx_pll_vco_freq<7100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=7100000000)&&($atx_pll_vco_freq<7400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7400000000)&&($atx_pll_vco_freq<7800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=7800000000)&&($atx_pll_vco_freq<8200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=8200000000)&&($atx_pll_vco_freq<8600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8600000000)&&($atx_pll_vco_freq<8800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=8800000000)&&($atx_pll_vco_freq<8900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=8900000000)&&($atx_pll_vco_freq<9100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=9100000000)&&($atx_pll_vco_freq<9350000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=9350000000)&&($atx_pll_vco_freq<9750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=9750000000)&&($atx_pll_vco_freq<10400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=10400000000)&&($atx_pll_vco_freq<10600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=10600000000)&&($atx_pll_vco_freq<11100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=11100000000)&&($atx_pll_vco_freq<11400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11400000000)&&($atx_pll_vco_freq<11550000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11550000000)&&($atx_pll_vco_freq<11900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11900000000)&&($atx_pll_vco_freq<12600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=12600000000)&&($atx_pll_vco_freq<13110000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=13110000000)&&($atx_pll_vco_freq<13150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=13150000000)&&($atx_pll_vco_freq<13650000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13650000000)&&($atx_pll_vco_freq<14200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=14200000000)&&($atx_pll_vco_freq<14500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lcnt_bypass"]]
         } else {
            set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
         }
      }
   }

   set legal_values [20nm2_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
      set legal_values [compare_le $legal_values [expr { ($atx_pll_f_max_vco+0) }]]
   }
   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_primary_use=="hssi_hf") }] {
         set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
            set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
         }
      }
   }
   if [expr { ($atx_pll_dsm_mode!="dsm_mode_integer") }] {
      set legal_values [compare_le $legal_values [expr { (($atx_pll_f_max_pfd*2)*($atx_pll_m_counter-3)) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm2_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_xcpvco_xchgpmplf_cp_current_boost atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "boost_setting" "normal_setting"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "normal_setting"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_xcpvco_xchgpmplf_cp_current_boost.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "cp_mode_enable"]]
      }
   }

   set legal_values [20nm3_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm3_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting19"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                  } else {
                     set legal_values [intersect $legal_values [list "cp_current_setting19"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "cp_current_setting19"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting26"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "cp_current_setting33"]]
               } else {
                  if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting20"]]
                  } else {
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting10"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting15"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting12"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting25"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
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
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm3_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               } else {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm3_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_order"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_lcnt_fpll_cascading { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_lcnt_fpll_cascading } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 1200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_lcnt_fpll_cascading.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_lcnt_fpll_cascading $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select } {
   set atx_pll_bw_sel [20nm3_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_bw_sel=="high_bw") }] {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
            set legal_values [compare_eq $legal_values 600000000]
         } else {
            set legal_values [compare_eq $legal_values 800000000]
         }
      } else {
         set legal_values [compare_eq $legal_values 400000000]
      }
   } else {
      if [expr { ($atx_pll_bw_sel=="mid_bw") }] {
         set legal_values [compare_eq $legal_values 350000000]
      } else {
         set legal_values [compare_eq $legal_values 160000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 6500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_fpll_refclk_selection { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_vco_freq } {

   set legal_values [list "select_div_by_2" "select_vco_output"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_primary_use!="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "select_vco_output"]]
   } else {
      if [expr { ($atx_pll_vco_freq>10440000000) }] {
         set legal_values [intersect $legal_values [list "select_div_by_2"]]
      } else {
         set legal_values [intersect $legal_values [list "select_vco_output"]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ((($atx_pll_prot_mode=="unused")||($atx_pll_primary_use=="hssi_hf"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   } else {
      set legal_values [intersect $legal_values [list "lcnt_on"]]
   }

   set legal_values [20nm3_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lc_to_fpll_l_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_to_fpll_l_counter atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcounter_setting0" "lcounter_setting1" "lcounter_setting10" "lcounter_setting11" "lcounter_setting12" "lcounter_setting13" "lcounter_setting14" "lcounter_setting15" "lcounter_setting16" "lcounter_setting17" "lcounter_setting18" "lcounter_setting19" "lcounter_setting2" "lcounter_setting20" "lcounter_setting21" "lcounter_setting22" "lcounter_setting23" "lcounter_setting24" "lcounter_setting25" "lcounter_setting26" "lcounter_setting27" "lcounter_setting28" "lcounter_setting29" "lcounter_setting3" "lcounter_setting30" "lcounter_setting31" "lcounter_setting4" "lcounter_setting5" "lcounter_setting6" "lcounter_setting7" "lcounter_setting8" "lcounter_setting9"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [intersect $legal_values [list "lcounter_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==0) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==1) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==2) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==3) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==4) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==5) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting5"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==6) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting6"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==7) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting7"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==8) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting8"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==9) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting9"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==10) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting10"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==11) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting11"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==12) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting12"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==13) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting13"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==14) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting14"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==15) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting15"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==16) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting16"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==17) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting17"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==18) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting18"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==19) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting19"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==20) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting20"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==21) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting21"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==22) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting22"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==23) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting23"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==24) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting24"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==25) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting25"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==26) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting26"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==27) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting27"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==28) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting28"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==29) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting29"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==30) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting30"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==31) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting31"]]         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lc_to_fpll_l_counter.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lc_to_fpll_l_counter $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter $legal_values { atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lc_to_fpll_l_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list 0:31]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [compare_inside $legal_values [list 4:31]]
      } else {
         set legal_values [compare_inside $legal_values [list 0:31]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm3_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm3_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_setting1"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                  set legal_values [intersect $legal_values [list "lf_setting2"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm3_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_1"]]
                  } else {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "lf_no_ripple"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 10:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 8:127]]
         }
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 11:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 11:123]]
         }
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 100]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 0]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { (((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use } {
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }
   if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_lcnt_fpll_cascading]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_pfd_delay_compensation { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_delay_compensation atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "fb_compensated_delay" "normal_delay" "ref_compensated_delay" "unused_delay"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "normal_delay"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "normal_delay"]]
         } else {
            set legal_values [intersect $legal_values [list "ref_compensated_delay"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_delay_compensation.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_delay_compensation $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_delay_compensation $atx_pll_pfd_delay_compensation $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_pfd_pulse_width { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_pulse_width atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pulse_width_setting0" "pulse_width_setting1" "pulse_width_setting2" "pulse_width_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
         } else {
            set legal_values [intersect $legal_values [list "pulse_width_setting2"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_pulse_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_pulse_width $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_pulse_width $atx_pll_pfd_pulse_width $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sas_tx" "sata_tx" "unused" "upi_tx"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=6500000000)&&($atx_pll_vco_freq<6700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6700000000)&&($atx_pll_vco_freq<6900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6900000000)&&($atx_pll_vco_freq<7100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=7100000000)&&($atx_pll_vco_freq<7400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7400000000)&&($atx_pll_vco_freq<7800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=7800000000)&&($atx_pll_vco_freq<8200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=8200000000)&&($atx_pll_vco_freq<8600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8600000000)&&($atx_pll_vco_freq<8800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=8800000000)&&($atx_pll_vco_freq<8900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=8900000000)&&($atx_pll_vco_freq<9100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=9100000000)&&($atx_pll_vco_freq<9350000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=9350000000)&&($atx_pll_vco_freq<9750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=9750000000)&&($atx_pll_vco_freq<10400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=10400000000)&&($atx_pll_vco_freq<10600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=10600000000)&&($atx_pll_vco_freq<11100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=11100000000)&&($atx_pll_vco_freq<11400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11400000000)&&($atx_pll_vco_freq<11550000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11550000000)&&($atx_pll_vco_freq<11900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11900000000)&&($atx_pll_vco_freq<12600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=12600000000)&&($atx_pll_vco_freq<13110000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=13110000000)&&($atx_pll_vco_freq<13150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=13150000000)&&($atx_pll_vco_freq<13650000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13650000000)&&($atx_pll_vco_freq<14200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=14200000000)&&($atx_pll_vco_freq<14500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lcnt_bypass"]]
         } else {
            set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
         }
      }
   }

   set legal_values [20nm3_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
      set legal_values [compare_le $legal_values [expr { ($atx_pll_f_max_vco+0) }]]
   }
   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_primary_use=="hssi_hf") }] {
         set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
            set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
         }
      }
   }
   if [expr { ($atx_pll_dsm_mode!="dsm_mode_integer") }] {
      set legal_values [compare_le $legal_values [expr { (($atx_pll_f_max_pfd*2)*($atx_pll_m_counter-3)) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm3_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_xcpvco_xchgpmplf_cp_current_boost atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "boost_setting" "normal_setting"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "normal_setting"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_xcpvco_xchgpmplf_cp_current_boost.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "cp_mode_enable"]]
      }
   }

   set legal_values [20nm4_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting19"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                  } else {
                     set legal_values [intersect $legal_values [list "cp_current_setting19"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "cp_current_setting19"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting26"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "cp_current_setting33"]]
               } else {
                  if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting20"]]
                  } else {
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting10"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting15"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting12"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting25"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
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
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               } else {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_order"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_lcnt_fpll_cascading { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_lcnt_fpll_cascading } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 1200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_lcnt_fpll_cascading.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_lcnt_fpll_cascading $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select } {
   set atx_pll_bw_sel [20nm4_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_bw_sel=="high_bw") }] {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
            set legal_values [compare_eq $legal_values 600000000]
         } else {
            set legal_values [compare_eq $legal_values 800000000]
         }
      } else {
         set legal_values [compare_eq $legal_values 400000000]
      }
   } else {
      if [expr { ($atx_pll_bw_sel=="mid_bw") }] {
         set legal_values [compare_eq $legal_values 350000000]
      } else {
         set legal_values [compare_eq $legal_values 160000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 6500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_fpll_refclk_selection { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_vco_freq } {

   set legal_values [list "select_div_by_2" "select_vco_output"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_primary_use!="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "select_vco_output"]]
   } else {
      if [expr { ($atx_pll_vco_freq>10440000000) }] {
         set legal_values [intersect $legal_values [list "select_div_by_2"]]
      } else {
         set legal_values [intersect $legal_values [list "select_vco_output"]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ((($atx_pll_prot_mode=="unused")||($atx_pll_primary_use=="hssi_hf"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   } else {
      set legal_values [intersect $legal_values [list "lcnt_on"]]
   }

   set legal_values [20nm4_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lc_to_fpll_l_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_to_fpll_l_counter atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcounter_setting0" "lcounter_setting1" "lcounter_setting10" "lcounter_setting11" "lcounter_setting12" "lcounter_setting13" "lcounter_setting14" "lcounter_setting15" "lcounter_setting16" "lcounter_setting17" "lcounter_setting18" "lcounter_setting19" "lcounter_setting2" "lcounter_setting20" "lcounter_setting21" "lcounter_setting22" "lcounter_setting23" "lcounter_setting24" "lcounter_setting25" "lcounter_setting26" "lcounter_setting27" "lcounter_setting28" "lcounter_setting29" "lcounter_setting3" "lcounter_setting30" "lcounter_setting31" "lcounter_setting4" "lcounter_setting5" "lcounter_setting6" "lcounter_setting7" "lcounter_setting8" "lcounter_setting9"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [intersect $legal_values [list "lcounter_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==0) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==1) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==2) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==3) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==4) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==5) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting5"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==6) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting6"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==7) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting7"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==8) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting8"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==9) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting9"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==10) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting10"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==11) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting11"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==12) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting12"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==13) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting13"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==14) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting14"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==15) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting15"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==16) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting16"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==17) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting17"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==18) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting18"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==19) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting19"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==20) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting20"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==21) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting21"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==22) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting22"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==23) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting23"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==24) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting24"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==25) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting25"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==26) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting26"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==27) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting27"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==28) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting28"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==29) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting29"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==30) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting30"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==31) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting31"]]         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lc_to_fpll_l_counter.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lc_to_fpll_l_counter $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter $legal_values { atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lc_to_fpll_l_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list 0:31]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [compare_inside $legal_values [list 4:31]]
      } else {
         set legal_values [compare_inside $legal_values [list 0:31]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_setting1"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                  set legal_values [intersect $legal_values [list "lf_setting2"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_1"]]
                  } else {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "lf_no_ripple"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 10:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 8:127]]
         }
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 11:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 11:123]]
         }
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 100]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 0]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { (((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use } {
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }
   if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_lcnt_fpll_cascading]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_pfd_delay_compensation { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_delay_compensation atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "fb_compensated_delay" "normal_delay" "ref_compensated_delay" "unused_delay"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "normal_delay"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "normal_delay"]]
         } else {
            set legal_values [intersect $legal_values [list "ref_compensated_delay"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_delay_compensation.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_delay_compensation $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_delay_compensation $atx_pll_pfd_delay_compensation $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_pfd_pulse_width { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_pulse_width atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pulse_width_setting0" "pulse_width_setting1" "pulse_width_setting2" "pulse_width_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
         } else {
            set legal_values [intersect $legal_values [list "pulse_width_setting2"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_pulse_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_pulse_width $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_pulse_width $atx_pll_pfd_pulse_width $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sas_tx" "sata_tx" "unused" "upi_tx"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=6500000000)&&($atx_pll_vco_freq<6700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6700000000)&&($atx_pll_vco_freq<6900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6900000000)&&($atx_pll_vco_freq<7100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=7100000000)&&($atx_pll_vco_freq<7400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7400000000)&&($atx_pll_vco_freq<7800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=7800000000)&&($atx_pll_vco_freq<8200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=8200000000)&&($atx_pll_vco_freq<8600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8600000000)&&($atx_pll_vco_freq<8800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=8800000000)&&($atx_pll_vco_freq<8900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=8900000000)&&($atx_pll_vco_freq<9100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=9100000000)&&($atx_pll_vco_freq<9350000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=9350000000)&&($atx_pll_vco_freq<9750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=9750000000)&&($atx_pll_vco_freq<10400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=10400000000)&&($atx_pll_vco_freq<10600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=10600000000)&&($atx_pll_vco_freq<11100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=11100000000)&&($atx_pll_vco_freq<11400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11400000000)&&($atx_pll_vco_freq<11550000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11550000000)&&($atx_pll_vco_freq<11900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11900000000)&&($atx_pll_vco_freq<12600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=12600000000)&&($atx_pll_vco_freq<13110000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=13110000000)&&($atx_pll_vco_freq<13150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=13150000000)&&($atx_pll_vco_freq<13650000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13650000000)&&($atx_pll_vco_freq<14200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=14200000000)&&($atx_pll_vco_freq<14500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lcnt_bypass"]]
         } else {
            set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
         }
      }
   }

   set legal_values [20nm4_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
      set legal_values [compare_le $legal_values [expr { ($atx_pll_f_max_vco+0) }]]
   }
   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_primary_use=="hssi_hf") }] {
         set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
            set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
         }
      }
   }
   if [expr { ($atx_pll_dsm_mode!="dsm_mode_integer") }] {
      set legal_values [compare_le $legal_values [expr { (($atx_pll_f_max_pfd*2)*($atx_pll_m_counter-3)) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_xcpvco_xchgpmplf_cp_current_boost atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "boost_setting" "normal_setting"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "normal_setting"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_xcpvco_xchgpmplf_cp_current_boost.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   }

   set legal_values [20nm4es_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting10"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting15"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting12"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting25"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_dsm_mode atx_pll_fb_select } {
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [compare_eq $legal_values 600000000]
      } else {
         set legal_values [compare_eq $legal_values 800000000]
      }
   } else {
      set legal_values [compare_eq $legal_values 400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode atx_pll_l_counter_enable } {
   set atx_pll_l_counter_enable [20nm4es_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   } else {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode atx_pll_l_counter_enable }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode atx_pll_l_counter_enable } {
   set atx_pll_l_counter_enable [20nm4es_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   } else {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode atx_pll_l_counter_enable }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 6500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7300000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   }

   set legal_values [20nm4es_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm4es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         set legal_values [compare_inside $legal_values [list 8:127]]
      } else {
         set legal_values [compare_inside $legal_values [list 11:127]]
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 95]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 5]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_x1 atx_pll_l_counter_enable } {
   set atx_pll_l_counter_enable [20nm4es_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_l_counter_enable=="lcnt_on") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_x1 atx_pll_l_counter_enable }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting3"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting3"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sata_tx" "unused"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=6500000000)&&($atx_pll_vco_freq<6700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6700000000)&&($atx_pll_vco_freq<6900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=6900000000)&&($atx_pll_vco_freq<7100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7100000000)&&($atx_pll_vco_freq<7400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=7400000000)&&($atx_pll_vco_freq<7800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=7800000000)&&($atx_pll_vco_freq<8200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8200000000)&&($atx_pll_vco_freq<8600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=8600000000)&&($atx_pll_vco_freq<8800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
      if [expr { (($atx_pll_vco_freq>=8800000000)&&($atx_pll_vco_freq<8900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=8900000000)&&($atx_pll_vco_freq<9100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=9100000000)&&($atx_pll_vco_freq<9350000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=9350000000)&&($atx_pll_vco_freq<9750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=9750000000)&&($atx_pll_vco_freq<10200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=10200000000)&&($atx_pll_vco_freq<10600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=10600000000)&&($atx_pll_vco_freq<11100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11100000000)&&($atx_pll_vco_freq<11400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
      if [expr { (($atx_pll_vco_freq>=11400000000)&&($atx_pll_vco_freq<11550000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11550000000)&&($atx_pll_vco_freq<11900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=11900000000)&&($atx_pll_vco_freq<12300000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=12300000000)&&($atx_pll_vco_freq<12700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=12700000000)&&($atx_pll_vco_freq<13150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13150000000)&&($atx_pll_vco_freq<13650000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=13650000000)&&($atx_pll_vco_freq<14200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=14200000000)&&($atx_pll_vco_freq<14500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   }

   set legal_values [20nm4es_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm4es_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_f_min_vco atx_pll_l_counter_enable atx_pll_l_counter_scratch atx_pll_output_clock_frequency atx_pll_powerdown_mode } {
   set atx_pll_l_counter_enable [20nm4es_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
   }
   if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
      set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
   } else {
      set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_f_min_vco atx_pll_l_counter_enable atx_pll_l_counter_scratch atx_pll_output_clock_frequency atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "cp_mode_enable"]]
      }
   }

   set legal_values [20nm5_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting19"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                  } else {
                     set legal_values [intersect $legal_values [list "cp_current_setting19"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "cp_current_setting19"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "cp_current_setting26"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "cp_current_setting33"]]
               } else {
                  if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                     set legal_values [intersect $legal_values [list "cp_current_setting20"]]
                  } else {
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting10"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting15"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting12"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting25"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting22"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting26"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting33"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting23"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
                     }
                     if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                        set legal_values [intersect $legal_values [list "cp_current_setting34"]]
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
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               } else {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_3rd_order"]]
            } else {
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_3rd_order"]]
               }
               if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                  set legal_values [intersect $legal_values [list "lf_2nd_order"]]
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_lcnt_fpll_cascading { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_lcnt_fpll_cascading } {

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 1200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_lcnt_fpll_cascading.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_lcnt_fpll_cascading $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_lcnt_fpll_cascading $atx_pll_f_max_lcnt_fpll_cascading $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select } {
   set atx_pll_bw_sel [20nm5_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_bw_sel=="high_bw") }] {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
            set legal_values [compare_eq $legal_values 600000000]
         } else {
            set legal_values [compare_eq $legal_values 800000000]
         }
      } else {
         set legal_values [compare_eq $legal_values 400000000]
      }
   } else {
      if [expr { ($atx_pll_bw_sel=="mid_bw") }] {
         set legal_values [compare_eq $legal_values 350000000]
      } else {
         set legal_values [compare_eq $legal_values 160000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_bw_sel atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14400000000]
   } else {
      set legal_values [compare_eq $legal_values 14400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 6500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7200000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_fpll_refclk_selection { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_vco_freq } {

   set legal_values [list "select_div_by_2" "select_vco_output"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_primary_use!="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "select_vco_output"]]
   } else {
      if [expr { ($atx_pll_vco_freq>10440000000) }] {
         set legal_values [intersect $legal_values [list "select_div_by_2"]]
      } else {
         set legal_values [intersect $legal_values [list "select_vco_output"]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ((($atx_pll_prot_mode=="unused")||($atx_pll_primary_use=="hssi_hf"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   } else {
      set legal_values [intersect $legal_values [list "lcnt_on"]]
   }

   set legal_values [20nm5_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lc_to_fpll_l_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lc_to_fpll_l_counter atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcounter_setting0" "lcounter_setting1" "lcounter_setting10" "lcounter_setting11" "lcounter_setting12" "lcounter_setting13" "lcounter_setting14" "lcounter_setting15" "lcounter_setting16" "lcounter_setting17" "lcounter_setting18" "lcounter_setting19" "lcounter_setting2" "lcounter_setting20" "lcounter_setting21" "lcounter_setting22" "lcounter_setting23" "lcounter_setting24" "lcounter_setting25" "lcounter_setting26" "lcounter_setting27" "lcounter_setting28" "lcounter_setting29" "lcounter_setting3" "lcounter_setting30" "lcounter_setting31" "lcounter_setting4" "lcounter_setting5" "lcounter_setting6" "lcounter_setting7" "lcounter_setting8" "lcounter_setting9"]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [intersect $legal_values [list "lcounter_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==0) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==1) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==2) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==3) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==4) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting4"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==5) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting5"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==6) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting6"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==7) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting7"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==8) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting8"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==9) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting9"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==10) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting10"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==11) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting11"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==12) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting12"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==13) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting13"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==14) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting14"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==15) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting15"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==16) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting16"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==17) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting17"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==18) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting18"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==19) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting19"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==20) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting20"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==21) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting21"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==22) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting22"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==23) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting23"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==24) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting24"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==25) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting25"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==26) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting26"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==27) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting27"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==28) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting28"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==29) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting29"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==30) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting30"]]         }
         if [expr { ($atx_pll_lc_to_fpll_l_counter_scratch==31) }] {
            set legal_values [intersect $legal_values [list "lcounter_setting31"]]         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lc_to_fpll_l_counter.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lc_to_fpll_l_counter $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lc_to_fpll_l_counter $atx_pll_lc_to_fpll_l_counter $legal_values { atx_pll_lc_to_fpll_l_counter_scratch atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lc_to_fpll_l_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list 0:31]

   if [expr { (($atx_pll_prot_mode=="unused")||(($atx_pll_prot_mode!="unused")&&($atx_pll_primary_use!="hssi_cascade"))) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         set legal_values [compare_inside $legal_values [list 4:31]]
      } else {
         set legal_values [compare_inside $legal_values [list 0:31]]
      }
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_setting1"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="sas_tx")&&($atx_pll_output_clock_frequency==6000000000)) }] {
                  set legal_values [intersect $legal_values [list "lf_setting2"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting1"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting2"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_setting3"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_reference_clock_frequency "" atx_pll_reference_clock_frequency

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            if [expr { ($atx_pll_is_otn=="true") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { ($atx_pll_is_sdi=="true") }] {
                  if [expr { ($atx_pll_reference_clock_frequency<1500000000) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_1"]]
                  } else {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
               }
            }
         } else {
            if [expr { ($atx_pll_prot_mode=="pcie_gen3_tx") }] {
               set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
            } else {
               if [expr { (($atx_pll_prot_mode=="upi_tx")&&(($atx_pll_output_clock_frequency==4800000000)||($atx_pll_output_clock_frequency==5200000000))) }] {
                  set legal_values [intersect $legal_values [list "lf_no_ripple"]]
               } else {
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="low_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="mid_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
                  }
                  if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=127))&&($atx_pll_bw_sel=="high_bw")) }] {
                     set legal_values [intersect $legal_values [list "lf_no_ripple"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_is_otn atx_pll_is_sdi atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_primary_use atx_pll_prot_mode atx_pll_reference_clock_frequency atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 10:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 8:127]]
         }
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [compare_inside $legal_values [list 11:30]]
         } else {
            set legal_values [compare_inside $legal_values [list 11:123]]
         }
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 100]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 0]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_primary_use atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { (((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb"))||($atx_pll_primary_use=="hssi_cascade")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use } {
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }
   if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_lcnt_fpll_cascading]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_lcnt_fpll_cascading atx_pll_f_max_x1 atx_pll_primary_use }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting0"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting0"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_pfd_delay_compensation { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_delay_compensation atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "fb_compensated_delay" "normal_delay" "ref_compensated_delay" "unused_delay"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "normal_delay"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "normal_delay"]]
         } else {
            set legal_values [intersect $legal_values [list "ref_compensated_delay"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_delay_compensation.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_delay_compensation $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_delay_compensation $atx_pll_pfd_delay_compensation $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_pfd_pulse_width { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_pfd_pulse_width atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "pulse_width_setting0" "pulse_width_setting1" "pulse_width_setting2" "pulse_width_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
            set legal_values [intersect $legal_values [list "pulse_width_setting0"]]
         } else {
            set legal_values [intersect $legal_values [list "pulse_width_setting2"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_pfd_pulse_width.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_pfd_pulse_width $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_pfd_pulse_width $atx_pll_pfd_pulse_width $legal_values { atx_pll_dsm_mode atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sas_tx" "sata_tx" "unused" "upi_tx"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=6500000000)&&($atx_pll_vco_freq<6700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6700000000)&&($atx_pll_vco_freq<6900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6900000000)&&($atx_pll_vco_freq<7100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=7100000000)&&($atx_pll_vco_freq<7400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7400000000)&&($atx_pll_vco_freq<7800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=7800000000)&&($atx_pll_vco_freq<8200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=8200000000)&&($atx_pll_vco_freq<8600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8600000000)&&($atx_pll_vco_freq<8800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=8800000000)&&($atx_pll_vco_freq<8900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=8900000000)&&($atx_pll_vco_freq<9100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=9100000000)&&($atx_pll_vco_freq<9350000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=9350000000)&&($atx_pll_vco_freq<9750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=9750000000)&&($atx_pll_vco_freq<10400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=10400000000)&&($atx_pll_vco_freq<10600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=10600000000)&&($atx_pll_vco_freq<11100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=11100000000)&&($atx_pll_vco_freq<11400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11400000000)&&($atx_pll_vco_freq<11550000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11550000000)&&($atx_pll_vco_freq<11900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11900000000)&&($atx_pll_vco_freq<12600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=12600000000)&&($atx_pll_vco_freq<13110000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=13110000000)&&($atx_pll_vco_freq<13150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=13150000000)&&($atx_pll_vco_freq<13650000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13650000000)&&($atx_pll_vco_freq<14200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=14200000000)&&($atx_pll_vco_freq<14500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ($atx_pll_primary_use=="hssi_cascade") }] {
            set legal_values [intersect $legal_values [list "lcnt_bypass"]]
         } else {
            set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
         }
      }
   }

   set legal_values [20nm5_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_primary_use atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
      set legal_values [compare_le $legal_values [expr { ($atx_pll_f_max_vco+0) }]]
   }
   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($atx_pll_primary_use=="hssi_hf") }] {
         set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
      } else {
         if [expr { ($atx_pll_primary_use=="hssi_x1") }] {
            set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
         }
      }
   }
   if [expr { ($atx_pll_dsm_mode!="dsm_mode_integer") }] {
      set legal_values [compare_le $legal_values [expr { (($atx_pll_f_max_pfd*2)*($atx_pll_m_counter-3)) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_dsm_mode atx_pll_f_max_pfd atx_pll_f_max_vco atx_pll_f_min_vco atx_pll_l_counter_scratch atx_pll_m_counter atx_pll_output_clock_frequency atx_pll_powerdown_mode atx_pll_primary_use atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5_validate_atx_pll_xcpvco_xchgpmplf_cp_current_boost { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_xcpvco_xchgpmplf_cp_current_boost atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "boost_setting" "normal_setting"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "normal_setting"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_xcpvco_xchgpmplf_cp_current_boost.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_xcpvco_xchgpmplf_cp_current_boost $atx_pll_xcpvco_xchgpmplf_cp_current_boost $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   }

   set legal_values [20nm5es2_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting10"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting15"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting12"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting25"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_dsm_mode atx_pll_fb_select } {
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [compare_eq $legal_values 600000000]
      } else {
         set legal_values [compare_eq $legal_values 800000000]
      }
   } else {
      set legal_values [compare_eq $legal_values 400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode atx_pll_l_counter_enable } {
   set atx_pll_l_counter_enable [20nm5es2_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   } else {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode atx_pll_l_counter_enable }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode atx_pll_l_counter_enable } {
   set atx_pll_l_counter_enable [20nm5es2_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   } else {
      if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
         set legal_values [compare_eq $legal_values 14150000000]
      } else {
         set legal_values [compare_eq $legal_values 14600000000]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode atx_pll_l_counter_enable }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 6500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 8800000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 11400000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7300000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   }

   set legal_values [20nm5es2_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es2_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         set legal_values [compare_inside $legal_values [list 8:127]]
      } else {
         set legal_values [compare_inside $legal_values [list 11:127]]
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 95]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 5]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_x1 atx_pll_l_counter_enable } {
   set atx_pll_l_counter_enable [20nm5es2_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_l_counter_enable=="lcnt_on") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_x1 atx_pll_l_counter_enable }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting3"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting3"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sata_tx" "unused"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=6500000000)&&($atx_pll_vco_freq<6700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=6700000000)&&($atx_pll_vco_freq<6900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=6900000000)&&($atx_pll_vco_freq<7100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7100000000)&&($atx_pll_vco_freq<7400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=7400000000)&&($atx_pll_vco_freq<7800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=7800000000)&&($atx_pll_vco_freq<8200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8200000000)&&($atx_pll_vco_freq<8600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=8600000000)&&($atx_pll_vco_freq<8800000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
      if [expr { (($atx_pll_vco_freq>=8800000000)&&($atx_pll_vco_freq<8900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=8900000000)&&($atx_pll_vco_freq<9100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=9100000000)&&($atx_pll_vco_freq<9350000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=9350000000)&&($atx_pll_vco_freq<9750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=9750000000)&&($atx_pll_vco_freq<10200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=10200000000)&&($atx_pll_vco_freq<10600000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=10600000000)&&($atx_pll_vco_freq<11100000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11100000000)&&($atx_pll_vco_freq<11400000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
      if [expr { (($atx_pll_vco_freq>=11400000000)&&($atx_pll_vco_freq<11550000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=11550000000)&&($atx_pll_vco_freq<11900000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=11900000000)&&($atx_pll_vco_freq<12300000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=12300000000)&&($atx_pll_vco_freq<12700000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=12700000000)&&($atx_pll_vco_freq<13150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13150000000)&&($atx_pll_vco_freq<13650000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=13650000000)&&($atx_pll_vco_freq<14200000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=14200000000)&&($atx_pll_vco_freq<14500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   }

   set legal_values [20nm5es2_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es2_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_f_min_vco atx_pll_l_counter_enable atx_pll_l_counter_scratch atx_pll_output_clock_frequency atx_pll_powerdown_mode } {
   set atx_pll_l_counter_enable [20nm5es2_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
   }
   if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
      set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
   } else {
      set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_f_min_vco atx_pll_l_counter_enable atx_pll_l_counter_scratch atx_pll_output_clock_frequency atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_compensation_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_compensation_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "cp_mode_disable" "cp_mode_enable"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cp_mode_disable"]]
   }

   set legal_values [20nm5es_convert_b2a_atx_pll_cp_compensation_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_compensation_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_compensation_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_compensation_enable $atx_pll_cp_compensation_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_current_setting { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_current_setting atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "cp_current_setting0" "cp_current_setting1" "cp_current_setting10" "cp_current_setting11" "cp_current_setting12" "cp_current_setting13" "cp_current_setting14" "cp_current_setting15" "cp_current_setting16" "cp_current_setting17" "cp_current_setting18" "cp_current_setting19" "cp_current_setting2" "cp_current_setting20" "cp_current_setting21" "cp_current_setting22" "cp_current_setting23" "cp_current_setting24" "cp_current_setting25" "cp_current_setting26" "cp_current_setting27" "cp_current_setting28" "cp_current_setting29" "cp_current_setting3" "cp_current_setting30" "cp_current_setting31" "cp_current_setting32" "cp_current_setting33" "cp_current_setting34" "cp_current_setting35" "cp_current_setting36" "cp_current_setting37" "cp_current_setting38" "cp_current_setting39" "cp_current_setting4" "cp_current_setting40" "cp_current_setting41" "cp_current_setting5" "cp_current_setting6" "cp_current_setting7" "cp_current_setting8" "cp_current_setting9"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "cp_current_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting10"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting15"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting12"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting25"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting22"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting26"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting33"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting23"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "cp_current_setting34"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_current_setting.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_current_setting $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_current_setting $atx_pll_cp_current_setting $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_lf_3rd_pole_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_3rd_pole_freq atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_3rd_pole_setting0" "lf_3rd_pole_setting1" "lf_3rd_pole_setting2" "lf_3rd_pole_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_pole_setting0"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_3rd_pole_freq.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_3rd_pole_freq $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_3rd_pole_freq $atx_pll_cp_lf_3rd_pole_freq $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_cp_lf_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cp_lf_order atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_2nd_order" "lf_3rd_order"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_2nd_order"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_3rd_order"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_2nd_order"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_cp_lf_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_cp_lf_order $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_cp_lf_order $atx_pll_cp_lf_order $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_pfd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_pfd atx_pll_dsm_mode atx_pll_fb_select } {
   regsub -nocase -all {\D} $atx_pll_f_max_pfd "" atx_pll_f_max_pfd

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
         set legal_values [compare_eq $legal_values 600000000]
      } else {
         set legal_values [compare_eq $legal_values 800000000]
      }
   } else {
      set legal_values [compare_eq $legal_values 400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_pfd.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_pfd $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_pfd $atx_pll_f_max_pfd $legal_values { atx_pll_dsm_mode atx_pll_fb_select }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_0 "" atx_pll_f_max_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 9500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_0 $atx_pll_f_max_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_1 "" atx_pll_f_max_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 12000000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_1 $atx_pll_f_max_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_tank_2 atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_tank_2 "" atx_pll_f_max_tank_2

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14150000000]
   } else {
      set legal_values [compare_eq $legal_values 14150000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_tank_2 $atx_pll_f_max_tank_2 $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_max_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_max_vco atx_pll_dsm_mode } {
   regsub -nocase -all {\D} $atx_pll_f_max_vco "" atx_pll_f_max_vco

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
      set legal_values [compare_eq $legal_values 14150000000]
   } else {
      set legal_values [compare_eq $legal_values 14150000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_max_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_max_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_max_vco $atx_pll_f_max_vco $legal_values { atx_pll_dsm_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_tank_0 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_0 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_0 "" atx_pll_f_min_tank_0

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7000000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_0.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_0 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_0 $atx_pll_f_min_tank_0 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_tank_1 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_1 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_1 "" atx_pll_f_min_tank_1

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 9500000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_1.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_1 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_1 $atx_pll_f_min_tank_1 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_tank_2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_tank_2 } {
   regsub -nocase -all {\D} $atx_pll_f_min_tank_2 "" atx_pll_f_min_tank_2

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 12000000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_tank_2.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_tank_2 $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_tank_2 $atx_pll_f_min_tank_2 $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_f_min_vco { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_f_min_vco } {
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco

   set legal_values [list 0:68719476735]

   set legal_values [compare_eq $legal_values 7000000000]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_f_min_vco.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_f_min_vco $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_f_min_vco $atx_pll_f_min_vco $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_l_counter_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_l_counter_enable atx_pll_prot_mode } {

   set legal_values [list "lcnt_off" "lcnt_on"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lcnt_off"]]
   }

   set legal_values [20nm5es_convert_b2a_atx_pll_l_counter_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_l_counter_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_l_counter_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_l_counter_enable $atx_pll_l_counter_enable $legal_values { atx_pll_prot_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_lf_cbig_size { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_cbig_size atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_cbig_setting0" "lf_cbig_setting1" "lf_cbig_setting2" "lf_cbig_setting3" "lf_cbig_setting4"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_cbig_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_cbig_setting4"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_cbig_size.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_cbig_size $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_cbig_size $atx_pll_lf_cbig_size $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_lf_resistance { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_resistance atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_setting0" "lf_setting1" "lf_setting2" "lf_setting3"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_setting0"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting1"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting2"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_setting3"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_resistance.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_resistance $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_resistance $atx_pll_lf_resistance $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_lf_ripplecap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_lf_ripplecap atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode } {
   set atx_pll_bw_sel [20nm5es_convert_a2b_atx_pll_bw_sel $atx_pll_bw_sel]

   set legal_values [list "lf_no_ripple" "lf_ripple_cap_0" "lf_ripple_cap_1"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lf_no_ripple"]]
   } else {
      if [expr { ($atx_pll_sup_mode=="user_mode") }] {
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=8)&&($atx_pll_m_counter<=12))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=13)&&($atx_pll_m_counter<=20))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=21)&&($atx_pll_m_counter<=30))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=31)&&($atx_pll_m_counter<=40))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=41)&&($atx_pll_m_counter<=50))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=51)&&($atx_pll_m_counter<=60))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=61)&&($atx_pll_m_counter<=70))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=71)&&($atx_pll_m_counter<=80))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=81)&&($atx_pll_m_counter<=90))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=91)&&($atx_pll_m_counter<=100))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="low_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="mid_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_ripple_cap_0"]]
         }
         if [expr { ((($atx_pll_m_counter>=101)&&($atx_pll_m_counter<=120))&&($atx_pll_bw_sel=="high_bw")) }] {
            set legal_values [intersect $legal_values [list "lf_no_ripple"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_lf_ripplecap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_lf_ripplecap $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_lf_ripplecap $atx_pll_lf_ripplecap $legal_values { atx_pll_bw_sel atx_pll_m_counter atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_m_counter { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_cgb_div atx_pll_dsm_mode atx_pll_fb_select atx_pll_l_counter_scratch atx_pll_pma_width atx_pll_prot_mode } {

   set legal_values [list 0:255]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 10]
   } else {
      if [expr { ($atx_pll_dsm_mode=="dsm_mode_integer") }] {
         set legal_values [compare_inside $legal_values [list 8:127]]
      } else {
         set legal_values [compare_inside $legal_values [list 11:127]]
      }
   }
   if [expr { ($atx_pll_fb_select=="iqtxrxclk_fb") }] {
      set legal_values [compare_eq $legal_values [expr { ((($atx_pll_l_counter_scratch*$atx_pll_cgb_div)*$atx_pll_pma_width)/4) }]]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_max_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_max_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 95]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_max_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_max_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_max_fractional_percentage $atx_pll_max_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_min_fractional_percentage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_min_fractional_percentage } {

   set legal_values [list 0:127]

   set legal_values [compare_eq $legal_values 5]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_min_fractional_percentage.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_min_fractional_percentage $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_min_fractional_percentage $atx_pll_min_fractional_percentage $legal_values { }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_n_counter_scratch { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_fb_select atx_pll_prot_mode } {

   set legal_values [list 0:15]

   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      set legal_values [compare_inside $legal_values [list 1 2 4 8]]
   }
   if [expr { ((($atx_pll_prot_mode=="unused")||((($atx_pll_prot_mode=="pcie_gen1_tx")||($atx_pll_prot_mode=="pcie_gen2_tx"))||($atx_pll_prot_mode=="pcie_gen3_tx")))||($atx_pll_fb_select=="iqtxrxclk_fb")) }] {
      set legal_values [compare_eq $legal_values 1]
   }

   return $legal_values
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_output_clock_frequency { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_clock_frequency atx_pll_f_max_x1 atx_pll_l_counter_enable } {
   set atx_pll_l_counter_enable [20nm5es_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency
   regsub -nocase -all {\D} $atx_pll_f_max_x1 "" atx_pll_f_max_x1

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_l_counter_enable=="lcnt_on") }] {
      set legal_values [compare_le $legal_values $atx_pll_f_max_x1]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_output_clock_frequency.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_output_clock_frequency $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_output_clock_frequency $atx_pll_output_clock_frequency $legal_values { atx_pll_f_max_x1 atx_pll_l_counter_enable }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_output_regulator_supply { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_output_regulator_supply atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "vreg1v_setting0" "vreg1v_setting1" "vreg1v_setting2" "vreg1v_setting3" "vreg1v_setting4" "vreg1v_setting5" "vreg1v_setting6" "vreg1v_setting7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vreg1v_setting3"]]
   } else {
      if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
         set legal_values [intersect $legal_values [list "vreg1v_setting3"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_output_regulator_supply.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_output_regulator_supply $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_output_regulator_supply $atx_pll_output_regulator_supply $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_overrange_voltage { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_overrange_voltage atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "over_setting0" "over_setting1" "over_setting2" "over_setting3" "over_setting4" "over_setting5" "over_setting6" "over_setting7"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "over_setting5"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_overrange_voltage.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_overrange_voltage $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_overrange_voltage $atx_pll_overrange_voltage $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_prot_mode atx_pll_powerdown_mode } {

   set legal_values [list "basic_tx" "gpon_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "qpi_tx" "sata_tx" "unused"]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_prot_mode $atx_pll_prot_mode $legal_values { atx_pll_powerdown_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_tank_band { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_tank_band atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq } {
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq

   set legal_values [list "lc_band0" "lc_band1" "lc_band2" "lc_band3" "lc_band4" "lc_band5" "lc_band6" "lc_band7"]

   if [expr { ($atx_pll_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "lc_band0"]]
   }
   if [expr { (($atx_pll_sup_mode=="user_mode")&&($atx_pll_initial_settings=="true")) }] {
      if [expr { (($atx_pll_vco_freq>=7000000000)&&($atx_pll_vco_freq<7312500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=7312500000)&&($atx_pll_vco_freq<7625000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=7625000000)&&($atx_pll_vco_freq<7937500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=7937500000)&&($atx_pll_vco_freq<8250000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=8250000000)&&($atx_pll_vco_freq<8562500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=8562500000)&&($atx_pll_vco_freq<8875000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=8875000000)&&($atx_pll_vco_freq<9187500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=9187500000)&&($atx_pll_vco_freq<9500000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
      if [expr { (($atx_pll_vco_freq>=9500000000)&&($atx_pll_vco_freq<9812500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=9812500000)&&($atx_pll_vco_freq<10125000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=10125000000)&&($atx_pll_vco_freq<10437500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=10437500000)&&($atx_pll_vco_freq<10750000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=10750000000)&&($atx_pll_vco_freq<11062500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=11062500000)&&($atx_pll_vco_freq<11375000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=11375000000)&&($atx_pll_vco_freq<11687500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=11687500000)&&($atx_pll_vco_freq<12000000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
      if [expr { (($atx_pll_vco_freq>=12000000000)&&($atx_pll_vco_freq<12268750000)) }] {
         set legal_values [intersect $legal_values [list "lc_band7"]]      }
      if [expr { (($atx_pll_vco_freq>=12268750000)&&($atx_pll_vco_freq<12537500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band6"]]      }
      if [expr { (($atx_pll_vco_freq>=12537500000)&&($atx_pll_vco_freq<12806250000)) }] {
         set legal_values [intersect $legal_values [list "lc_band5"]]      }
      if [expr { (($atx_pll_vco_freq>=12806250000)&&($atx_pll_vco_freq<13075000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band4"]]      }
      if [expr { (($atx_pll_vco_freq>=13075000000)&&($atx_pll_vco_freq<13343750000)) }] {
         set legal_values [intersect $legal_values [list "lc_band3"]]      }
      if [expr { (($atx_pll_vco_freq>=13343750000)&&($atx_pll_vco_freq<13612500000)) }] {
         set legal_values [intersect $legal_values [list "lc_band2"]]      }
      if [expr { (($atx_pll_vco_freq>=13612500000)&&($atx_pll_vco_freq<13881250000)) }] {
         set legal_values [intersect $legal_values [list "lc_band1"]]      }
      if [expr { (($atx_pll_vco_freq>=13881250000)&&($atx_pll_vco_freq<14150000000)) }] {
         set legal_values [intersect $legal_values [list "lc_band0"]]      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_tank_band.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_tank_band $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_tank_band $atx_pll_tank_band $legal_values { atx_pll_initial_settings atx_pll_prot_mode atx_pll_sup_mode atx_pll_vco_freq }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_vco_bypass_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_bypass_enable atx_pll_prot_mode atx_pll_sup_mode } {

   set legal_values [list "lcnt_bypass" "lcnt_no_bypass"]

   if [expr { (($atx_pll_prot_mode=="unused")||($atx_pll_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "lcnt_no_bypass"]]
   }

   set legal_values [20nm5es_convert_b2a_atx_pll_vco_bypass_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.atx_pll_vco_bypass_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message atx_pll_vco_bypass_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto atx_pll_vco_bypass_enable $atx_pll_vco_bypass_enable $legal_values { atx_pll_prot_mode atx_pll_sup_mode }
   }
}


proc ::nf_atx_pll::parameters::20nm5es_validate_atx_pll_vco_freq { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision atx_pll_vco_freq atx_pll_f_min_vco atx_pll_l_counter_enable atx_pll_l_counter_scratch atx_pll_output_clock_frequency atx_pll_powerdown_mode } {
   set atx_pll_l_counter_enable [20nm5es_convert_a2b_atx_pll_l_counter_enable $atx_pll_l_counter_enable]
   regsub -nocase -all {\D} $atx_pll_vco_freq "" atx_pll_vco_freq
   regsub -nocase -all {\D} $atx_pll_f_min_vco "" atx_pll_f_min_vco
   regsub -nocase -all {\D} $atx_pll_output_clock_frequency "" atx_pll_output_clock_frequency

   set legal_values [list 0:68719476735]

   if [expr { ($atx_pll_powerdown_mode=="powerdown") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_ge $legal_values [expr { ($atx_pll_f_min_vco-0) }]]
   }
   if [expr { ($atx_pll_l_counter_enable=="lcnt_off") }] {
      set legal_values [compare_eq $legal_values $atx_pll_output_clock_frequency]
   } else {
      set legal_values [compare_eq $legal_values [expr { ($atx_pll_output_clock_frequency*$atx_pll_l_counter_scratch) }]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.atx_pll_vco_freq.value" "${min} Hz"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message atx_pll_vco_freq $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message atx_pll_vco_freq $legal_values
      }
   } else {
      auto_value_out_of_range_message auto atx_pll_vco_freq $atx_pll_vco_freq $legal_values { atx_pll_f_min_vco atx_pll_l_counter_enable atx_pll_l_counter_scratch atx_pll_output_clock_frequency atx_pll_powerdown_mode }
   }
}


