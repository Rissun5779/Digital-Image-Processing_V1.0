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


proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_act_isource_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "isrc_dis" "isrc_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "isrc_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_bodybias_enable { device_revision pma_rx_buf_initial_settings pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "bodybias_dis" "bodybias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||(($pma_rx_buf_sup_mode=="user_mode")&&($pma_rx_buf_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "bodybias_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_bodybias_select { device_revision pma_rx_buf_initial_settings pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "bodybias_sel1" "bodybias_sel2"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||(($pma_rx_buf_sup_mode=="user_mode")&&($pma_rx_buf_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "bodybias_sel1"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_bypass_eqz_stages_234 { device_revision } {

   set legal_values [list "bypass_off" "byypass_stages_234"]

   set legal_values [intersect $legal_values [list "bypass_off"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_cdrclk_to_cgb { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cdrclk_2cgb_dis" "cdrclk_2cgb_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cdrclk_2cgb_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_cgm_bias_disable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_datarate { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($cdr_pll_tx_pll_prot_mode=="txpll_unused") }] {
      set legal_values [compare_eq $legal_values $pma_rx_buf_xrx_path_datarate]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_diag_lp_en { device_revision pma_rx_buf_loopback_modes pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {

   set legal_values [list "dlp_off" "dlp_on"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "dlp_off"]]
   } else {
      if [expr { (($pma_rx_buf_refclk_en=="enable")||($pma_rx_buf_loopback_modes=="pre_cdr")) }] {
         set legal_values [intersect $legal_values [list "dlp_on"]]
      } else {
         if [expr { ((($pma_rx_buf_loopback_modes=="lpbk_disable")||($pma_rx_buf_loopback_modes=="post_cdr"))||($pma_rx_buf_prot_mode=="unused")) }] {
            set legal_values [intersect $legal_values [list "dlp_off"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_eq_bw_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_optimal pma_rx_buf_optimal } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_optimal]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_optimal]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_optimal]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_optimal]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_eq_dc_gain_trim  $device_revision $pma_rx_buf_link_rx $pma_rx_buf_one_stage_enable $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_optimal]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_initial_settings { device_revision pma_rx_buf_xrx_path_initial_settings } {

   set legal_values [list "false" "true"]

   if [expr { ($pma_rx_buf_xrx_path_initial_settings=="true") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_initial_settings=="false") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_input_vcm_sel { device_revision pma_rx_buf_prot_mode } {

   set legal_values [list "high_vcm" "low_vcm"]

   if [expr { ($pma_rx_buf_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "low_vcm"]]
   } else {
      set legal_values [intersect $legal_values [list "high_vcm"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_lfeq_enable { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "lfeq_mode" "non_lfeq_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_datarate>12500000000)) }] {
      set legal_values [intersect $legal_values [list "non_lfeq_mode"]]
   } else {
      if [expr { ($pma_rx_buf_optimal=="true") }] {
         set legal_values [intersect $legal_values [list "non_lfeq_mode"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_lfeq_zero_control { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "lfeq_setting_0" "lfeq_setting_1" "lfeq_setting_2" "lfeq_setting_3"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "lfeq_setting_2"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_link { device_revision pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "lr" "mr" "sr"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "sr"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_link_rx { device_revision pma_rx_buf_link } {

   set legal_values [list "lr" "mr" "sr"]

   if [expr { ($pma_rx_buf_link=="sr") }] {
      set legal_values [intersect $legal_values [list "sr"]]
   }
   if [expr { ($pma_rx_buf_link=="mr") }] {
      set legal_values [intersect $legal_values [list "mr"]]
   }
   if [expr { ($pma_rx_buf_link=="lr") }] {
      set legal_values [intersect $legal_values [list "lr"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_offset_cal_pd { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "eqz1_en" "eqz1_pd"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "eqz1_pd"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "eqz1_en"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_offset_cancellation_coarse { device_revision pma_rx_buf_initial_settings pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "coarse_setting_00" "coarse_setting_01" "coarse_setting_02" "coarse_setting_03" "coarse_setting_04" "coarse_setting_05" "coarse_setting_06" "coarse_setting_07" "coarse_setting_08" "coarse_setting_09" "coarse_setting_10" "coarse_setting_11" "coarse_setting_12" "coarse_setting_13" "coarse_setting_14" "coarse_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||(($pma_rx_buf_sup_mode=="user_mode")&&($pma_rx_buf_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "coarse_setting_00"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_offset_cancellation_ctrl { device_revision } {

   set legal_values [list "minus_delta1" "minus_delta10" "minus_delta11" "minus_delta12" "minus_delta13" "minus_delta14" "minus_delta15" "minus_delta2" "minus_delta3" "minus_delta4" "minus_delta5" "minus_delta6" "minus_delta7" "minus_delta8" "minus_delta9" "plus_delta1" "plus_delta10" "plus_delta11" "plus_delta12" "plus_delta13" "plus_delta14" "plus_delta15" "plus_delta2" "plus_delta3" "plus_delta4" "plus_delta5" "plus_delta6" "plus_delta7" "plus_delta8" "plus_delta9" "volt_0mv"]

   set legal_values [intersect $legal_values [list "volt_0mv"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_offset_cancellation_fine { device_revision pma_rx_buf_initial_settings pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "fine_setting_00" "fine_setting_01" "fine_setting_02" "fine_setting_03" "fine_setting_04" "fine_setting_05" "fine_setting_06" "fine_setting_07"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||(($pma_rx_buf_sup_mode=="user_mode")&&($pma_rx_buf_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "fine_setting_00"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_offset_pd { device_revision pma_rx_buf_initial_settings pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "oc_en" "oc_pd"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||(($pma_rx_buf_sup_mode=="user_mode")&&($pma_rx_buf_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "oc_pd"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_link_rx } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_link_rx $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_link_rx $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_link_rx $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_one_stage_enable  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_pdb_rx { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {

   set legal_values [list "normal_rx_on" "power_down_rx"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "power_down_rx"]]
   } else {
      set legal_values [intersect $legal_values [list "normal_rx_on"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_pm_speed_grade  $device_revision $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision pma_rx_buf_pm_tx_rx_pcie_gen pma_rx_buf_xrx_path_prot_mode pma_tx_buf_xtx_path_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision $pma_rx_buf_pm_tx_rx_pcie_gen $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_xtx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision $pma_rx_buf_pm_tx_rx_pcie_gen $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_xtx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision $pma_rx_buf_pm_tx_rx_pcie_gen $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_xtx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision $pma_rx_buf_pm_tx_rx_pcie_gen $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_xtx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_pm_tx_rx_cvp_mode  $device_revision $pma_rx_buf_pm_tx_rx_pcie_gen $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_xtx_path_prot_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_pm_tx_rx_pcie_gen_bitwidth { device_revision } {

   set legal_values [list "pcie_gen3_16b" "pcie_gen3_32b"]

   set legal_values [intersect $legal_values [list "pcie_gen3_32b"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_power_mode  $device_revision $pma_rx_buf_xrx_path_prot_mode $pma_tx_buf_power_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_power_mode_rx { device_revision pma_rx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
      set legal_values [intersect $legal_values [list "high_perf"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
            set legal_values [intersect $legal_values [list "low_power"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_power_rail_er { device_revision pma_rx_buf_power_mode } {

   set legal_values [list 0:4095]

   if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
      set legal_values [compare_eq $legal_values 1120]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
         set legal_values [compare_eq $legal_values 1030]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
            set legal_values [compare_eq $legal_values 950]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_prot_mode { device_revision pma_rx_buf_refclk_en pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "basic_rx" "gpon_rx" "pcie_gen1_rx" "pcie_gen2_rx" "pcie_gen3_rx" "pcie_gen4_rx" "qpi_rx" "sata_rx" "unused"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="basic_rx") }] {
      set legal_values [intersect $legal_values [list "basic_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen1_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen1_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen2_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen2_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen3_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen3_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="pcie_gen4_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_gen4_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "qpi_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="gpon_rx") }] {
      set legal_values [intersect $legal_values [list "gpon_rx"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="sata_rx") }] {
      set legal_values [intersect $legal_values [list "sata_rx"]]
   }
   if [expr { ($pma_rx_buf_refclk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_qpi_enable { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "non_qpi_mode" "qpi_mode"]

   if [expr { ($pma_rx_buf_prot_mode!="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "non_qpi_mode"]]
   } else {
      if [expr { (($pma_rx_buf_prot_mode=="qpi_rx")&&($pma_rx_buf_sup_mode=="user_mode")) }] {
         set legal_values [intersect $legal_values [list "qpi_mode"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_refclk_en { device_revision cdr_pll_primary_use } {

   set legal_values [list "disable" "enable"]

   if [expr { ($cdr_pll_primary_use=="cdr") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_rx_atb_select { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "atb_disable"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "atb_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_rx_refclk_divider { device_revision pma_rx_buf_refclk_en } {

   set legal_values [list "bypass_divider" "divide_by_2"]

   if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "bypass_divider"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_rx_sel_bias_source  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode $pma_rx_buf_vcm_sel]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_rx_vga_oc_en { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_rx_vga_oc_en  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_rx_vga_oc_en  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_rx_vga_oc_en  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_rx_vga_oc_en  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_rx_vga_oc_en  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_rx_vga_oc_en  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_sup_mode]
	} else {
		set legal_values [list "vga_cal_off" "vga_cal_on"]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_term_sel  $device_revision $pma_rx_buf_datarate $pma_rx_buf_optimal $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_term_tri_enable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_term_tri_enable  $device_revision]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_term_tri_enable  $device_revision]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_term_tri_enable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_term_tri_enable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_term_tri_enable  $device_revision]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_term_tri_enable  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_term_tri_enable  $device_revision]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_term_tri_enable  $device_revision]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_vccela_supply_voltage { device_revision pma_rx_buf_power_mode_rx } {

   set legal_values [list "vccela_0p9v" "vccela_1p1v"]

   if [expr { (($pma_rx_buf_power_mode_rx=="high_perf")||($pma_rx_buf_power_mode_rx=="mid_power")) }] {
      set legal_values [intersect $legal_values [list "vccela_1p1v"]]
   }
   if [expr { ($pma_rx_buf_power_mode_rx=="low_power") }] {
      set legal_values [intersect $legal_values [list "vccela_0p9v"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_vcm_current_add  $device_revision $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap pma_rx_buf_power_mode_rx pma_rx_buf_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_power_mode $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_xrx_path_sup_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_power_mode $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_xrx_path_sup_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_power_mode $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_xrx_path_sup_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_power_mode $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_xrx_path_sup_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_power_mode $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_xrx_path_sup_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_rx_buf_power_mode_rx $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_power_mode $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_xrx_path_sup_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_vcm_sel  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_power_mode $pma_rx_buf_prot_mode $pma_rx_buf_refclk_en $pma_rx_buf_xrx_path_sup_mode $pma_rx_dfe_pdb_fixedtap]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_vga_bandwidth_select { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "vga_bw_1" "vga_bw_2" "vga_bw_3" "vga_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "vga_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "vga_bw_4"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_xrx_path_datarate  $device_revision $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_prot_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_datawidth { device_revision pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list 0:255]

   set legal_values [compare_inside $legal_values [list 8 10 16 20 32 40 64]]
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 8]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_xrx_path_gt_enabled  $device_revision $cdr_pll_tx_pll_prot_mode $pma_rx_buf_link $pma_rx_buf_pm_speed_grade $pma_rx_buf_power_mode $pma_rx_buf_xrx_path_datarate $pma_rx_buf_xrx_path_prot_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_jtag_hys { device_revision pma_rx_buf_xrx_path_prot_mode pma_rx_buf_xrx_path_sup_mode } {

   set legal_values [list "hys_increase_disable" "hys_increase_enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")||($pma_rx_buf_xrx_path_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "hys_increase_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_jtag_lp { device_revision pma_rx_buf_xrx_path_prot_mode pma_rx_buf_xrx_path_sup_mode pma_tx_buf_jtag_lp } {

   set legal_values [list "lp_off" "lp_on"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")||($pma_rx_buf_xrx_path_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "lp_off"]]
   }
   if [expr { ($pma_tx_buf_jtag_lp=="lp_off") }] {
      set legal_values [intersect $legal_values [list "lp_off"]]
   } else {
      if [expr { ($pma_tx_buf_jtag_lp=="lp_on") }] {
         set legal_values [intersect $legal_values [list "lp_on"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_optimal { device_revision pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_pma_rx_divclk_hz { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list 0:4294967295]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 50000000]
         set legal_values [compare_le $legal_values 600000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 50000000]
            set legal_values [compare_le $legal_values 600000000]
         } else {
            set legal_values [compare_ge $legal_values 30000000]
            set legal_values [compare_le $legal_values 600000000]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_prot_mode { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_refclk_en } {

   set legal_values [list "basic_rx" "gpon_rx" "pcie_gen1_rx" "pcie_gen2_rx" "pcie_gen3_rx" "pcie_gen4_rx" "qpi_rx" "sata_rx" "unused"]

   if [expr { (($cdr_pll_tx_pll_prot_mode!="txpll_unused")||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "unused"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_uc_cal_enable { device_revision pma_rx_buf_xrx_path_initial_settings pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "rx_cal_off" "rx_cal_on"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")||($pma_rx_buf_xrx_path_initial_settings=="true")) }] {
      set legal_values [intersect $legal_values [list "rx_cal_off"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_uc_cru_rstb { device_revision pma_rx_buf_xrx_path_prot_mode pma_rx_buf_xrx_path_sup_mode } {

   set legal_values [list "cdr_lf_reset_off" "cdr_lf_reset_on"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")||($pma_rx_buf_xrx_path_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cdr_lf_reset_off"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_uc_pcie_sw { device_revision pma_rx_buf_xrx_path_prot_mode pma_rx_buf_xrx_path_sup_mode } {

   set legal_values [list "not_allowed" "uc_pcie_gen1" "uc_pcie_gen2" "uc_pcie_gen3"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")||($pma_rx_buf_xrx_path_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "uc_pcie_gen1"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_buf_xrx_path_uc_rx_rstb { device_revision pma_rx_buf_xrx_path_initial_settings pma_rx_buf_xrx_path_prot_mode pma_rx_buf_xrx_path_sup_mode } {

   set legal_values [list "rx_reset_off" "rx_reset_on"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")||(($pma_rx_buf_xrx_path_initial_settings=="true")&&($pma_rx_buf_xrx_path_sup_mode=="user_mode"))) }] {
      set legal_values [intersect $legal_values [list "rx_reset_on"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_dis"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="pcie_gen3_rx") }] {
         set legal_values [intersect $legal_values [list "eq_bw_1"]]
      } else {
         if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
            if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_2"]]
               } else {
                  if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                     set legal_values [intersect $legal_values [list "eq_bw_3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "eq_bw_4"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_optimal } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
            if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "no_dc_gain"]]
            }
         } else {
            if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
               if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "no_dc_gain"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="sr") }] {
                  if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg2_gain7"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link_rx=="mr") }] {
                     if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                        set legal_values [intersect $legal_values [list "stg1_gain7"]]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                        if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "no_dc_gain"]]
                           }
                        } else {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "stg1_gain7"]]
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "non_s1_mode"]]
         }
      } else {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision pma_rx_buf_pm_tx_rx_pcie_gen pma_rx_buf_xrx_path_prot_mode pma_tx_buf_xtx_path_prot_mode } {

   set legal_values [list "cvp_off" "cvp_on"]

   if [expr { (($pma_tx_buf_xtx_path_prot_mode=="unused")&&($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      set legal_values [intersect $legal_values [list "cvp_off"]]
   } else {
      if [expr { (((((($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_100mhzref")||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_125mhzref")) }] {
         set legal_values [intersect $legal_values [list "cvp_on" "cvp_off"]]
      } else {
         set legal_values [intersect $legal_values [list "cvp_off"]]
      }
   }
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_prot_mode=="qpi_rx"))||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_rx_vga_oc_en { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "vga_cal_off" "vga_cal_on"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vga_cal_off"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="qpi_rx") }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_datarate>17400000000) }] {
            set legal_values [intersect $legal_values [list "r_r1" "r_r2"]]
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_term_tri_enable { device_revision } {

   set legal_values [list "disable_tri" "enable_tri"]

   set legal_values [intersect $legal_values [list "disable_tri"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         set legal_values [intersect $legal_values [list "vcm_current_3"]]
      } else {
         if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "vcm_current_1"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
               set legal_values [intersect $legal_values [list "vcm_setting_02"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_02"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
               if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_03"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                              }
                           }
                        }
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                              } else {
                                 if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                    set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 25800000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 25800000000]
               } else {
                  set legal_values [compare_le $legal_values 15000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 25800000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 20000000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 1000000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 1000000000]
         } else {
            set legal_values [compare_ge $legal_values 1000000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                     if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                        set legal_values [intersect $legal_values [list "enable"]]
                     } else {
                        set legal_values [intersect $legal_values [list "disable"]]
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_dis"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="pcie_gen3_rx") }] {
         set legal_values [intersect $legal_values [list "eq_bw_1"]]
      } else {
         if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
            if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_2"]]
               } else {
                  if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                     set legal_values [intersect $legal_values [list "eq_bw_3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "eq_bw_4"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_optimal } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
            if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "no_dc_gain"]]
            }
         } else {
            if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
               if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "no_dc_gain"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="sr") }] {
                  if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg2_gain7"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link_rx=="mr") }] {
                     if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                        set legal_values [intersect $legal_values [list "stg1_gain7"]]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                        if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "no_dc_gain"]]
                           }
                        } else {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "stg1_gain7"]]
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "non_s1_mode"]]
         }
      } else {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision pma_rx_buf_pm_tx_rx_pcie_gen pma_rx_buf_xrx_path_prot_mode pma_tx_buf_xtx_path_prot_mode } {

   set legal_values [list "cvp_off" "cvp_on"]

   if [expr { (($pma_tx_buf_xtx_path_prot_mode=="unused")&&($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      set legal_values [intersect $legal_values [list "cvp_off"]]
   } else {
      if [expr { (((((($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_100mhzref")||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_125mhzref")) }] {
         set legal_values [intersect $legal_values [list "cvp_on" "cvp_off"]]
      } else {
         set legal_values [intersect $legal_values [list "cvp_off"]]
      }
   }
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_prot_mode=="qpi_rx"))||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_rx_vga_oc_en { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "vga_cal_off" "vga_cal_on"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vga_cal_off"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="qpi_rx") }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_datarate>17400000000) }] {
            set legal_values [intersect $legal_values [list "r_r1" "r_r2"]]
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_term_tri_enable { device_revision } {

   set legal_values [list "disable_tri" "enable_tri"]

   set legal_values [intersect $legal_values [list "disable_tri"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         set legal_values [intersect $legal_values [list "vcm_current_3"]]
      } else {
         if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "vcm_current_1"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
               set legal_values [intersect $legal_values [list "vcm_setting_02"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_02"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
               if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_03"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                              }
                           }
                        }
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                              } else {
                                 if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                    set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 25800000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 25800000000]
               } else {
                  set legal_values [compare_le $legal_values 15000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 25800000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 20000000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 1000000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 1000000000]
         } else {
            set legal_values [compare_ge $legal_values 1000000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                     if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                        set legal_values [intersect $legal_values [list "enable"]]
                     } else {
                        set legal_values [intersect $legal_values [list "disable"]]
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_dis"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="pcie_gen3_rx") }] {
         set legal_values [intersect $legal_values [list "eq_bw_1"]]
      } else {
         if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
            if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_2"]]
               } else {
                  if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                     set legal_values [intersect $legal_values [list "eq_bw_3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "eq_bw_4"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_optimal } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
            if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "no_dc_gain"]]
            }
         } else {
            if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
               if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "no_dc_gain"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="sr") }] {
                  if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg2_gain7"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link_rx=="mr") }] {
                     if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                        set legal_values [intersect $legal_values [list "stg1_gain7"]]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                        if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "no_dc_gain"]]
                           }
                        } else {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "stg1_gain7"]]
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "non_s1_mode"]]
         }
      } else {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision pma_rx_buf_pm_tx_rx_pcie_gen pma_rx_buf_xrx_path_prot_mode pma_tx_buf_xtx_path_prot_mode } {

   set legal_values [list "cvp_off" "cvp_on"]

   if [expr { (($pma_tx_buf_xtx_path_prot_mode=="unused")&&($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      set legal_values [intersect $legal_values [list "cvp_off"]]
   } else {
      if [expr { (((((($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_100mhzref")||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_125mhzref")) }] {
         set legal_values [intersect $legal_values [list "cvp_on" "cvp_off"]]
      } else {
         set legal_values [intersect $legal_values [list "cvp_off"]]
      }
   }
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_prot_mode=="qpi_rx"))||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_rx_vga_oc_en { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "vga_cal_off" "vga_cal_on"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vga_cal_off"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="qpi_rx") }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_datarate>17400000000) }] {
            set legal_values [intersect $legal_values [list "r_r1" "r_r2"]]
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_term_tri_enable { device_revision } {

   set legal_values [list "disable_tri" "enable_tri"]

   set legal_values [intersect $legal_values [list "disable_tri"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         set legal_values [intersect $legal_values [list "vcm_current_3"]]
      } else {
         if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "vcm_current_1"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
               set legal_values [intersect $legal_values [list "vcm_setting_02"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_02"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
               if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_03"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                              }
                           }
                        }
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                              } else {
                                 if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                    set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 25800000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 25800000000]
               } else {
                  set legal_values [compare_le $legal_values 15000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 25800000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 20000000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 1000000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 1000000000]
         } else {
            set legal_values [compare_ge $legal_values 1000000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                     if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                        set legal_values [intersect $legal_values [list "enable"]]
                     } else {
                        set legal_values [intersect $legal_values [list "disable"]]
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_dis"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="pcie_gen3_rx") }] {
         set legal_values [intersect $legal_values [list "eq_bw_1"]]
      } else {
         if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
            if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_2"]]
               } else {
                  if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                     set legal_values [intersect $legal_values [list "eq_bw_3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "eq_bw_4"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_optimal } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
            if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "no_dc_gain"]]
            }
         } else {
            if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
               if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "no_dc_gain"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="sr") }] {
                  if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg2_gain7"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link_rx=="mr") }] {
                     if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                        set legal_values [intersect $legal_values [list "stg1_gain7"]]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                        if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "no_dc_gain"]]
                           }
                        } else {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "stg1_gain7"]]
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "non_s1_mode"]]
         }
      } else {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision pma_rx_buf_pm_tx_rx_pcie_gen pma_rx_buf_xrx_path_prot_mode pma_tx_buf_xtx_path_prot_mode } {

   set legal_values [list "cvp_off" "cvp_on"]

   if [expr { (($pma_tx_buf_xtx_path_prot_mode=="unused")&&($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      set legal_values [intersect $legal_values [list "cvp_off"]]
   } else {
      if [expr { (((((($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_100mhzref")||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_125mhzref")) }] {
         set legal_values [intersect $legal_values [list "cvp_on" "cvp_off"]]
      } else {
         set legal_values [intersect $legal_values [list "cvp_off"]]
      }
   }
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_prot_mode=="qpi_rx"))||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_rx_vga_oc_en { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "vga_cal_off" "vga_cal_on"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vga_cal_off"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="qpi_rx") }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_datarate>17400000000) }] {
            set legal_values [intersect $legal_values [list "r_r1" "r_r2"]]
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_term_tri_enable { device_revision } {

   set legal_values [list "disable_tri" "enable_tri"]

   set legal_values [intersect $legal_values [list "disable_tri"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         set legal_values [intersect $legal_values [list "vcm_current_3"]]
      } else {
         if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "vcm_current_1"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
               set legal_values [intersect $legal_values [list "vcm_setting_02"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_02"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
               if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_03"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                              }
                           }
                        }
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                              } else {
                                 if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                    set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 25800000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 25800000000]
               } else {
                  set legal_values [compare_le $legal_values 15000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 25800000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 20000000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 1000000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 1000000000]
         } else {
            set legal_values [compare_ge $legal_values 1000000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                     if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                        set legal_values [intersect $legal_values [list "enable"]]
                     } else {
                        set legal_values [intersect $legal_values [list "disable"]]
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_dis"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="pcie_gen3_rx") }] {
         set legal_values [intersect $legal_values [list "eq_bw_2"]]
      } else {
         if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
            if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_2"]]
               } else {
                  if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                     set legal_values [intersect $legal_values [list "eq_bw_3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "eq_bw_4"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ($pma_rx_buf_link_rx=="sr") }] {
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "stg2_gain7"]]
            }
         } else {
            if [expr { ($pma_rx_buf_link_rx=="mr") }] {
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "stg1_gain7"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                  if [expr { ($pma_rx_buf_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg1_gain7"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_link_rx pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ($pma_rx_buf_link_rx=="sr") }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "e1"]]
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision } {

   set legal_values [list "cvp_off" "cvp_on"]

   set legal_values [intersect $legal_values [list "cvp_off"]]
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_prot_mode=="qpi_rx"))||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_rx_vga_oc_en { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "vga_cal_off" "vga_cal_on"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vga_cal_off"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_datarate>=25000000000) }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_prot_mode!="basic_rx") }] {
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r1"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r2"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_term_tri_enable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {

   set legal_values [list "disable_tri" "enable_tri"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "disable_tri"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
               set legal_values [intersect $legal_values [list "vcm_setting_02"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_02"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
               if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_03"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                              }
                           }
                        }
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                              } else {
                                 if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                    set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 28300000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 26000000000]
               } else {
                  set legal_values [compare_le $legal_values 14200000000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 20000000000]
               } else {
                  set legal_values [compare_le $legal_values 14200000000]
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 611000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 611000000]
         } else {
            set legal_values [compare_ge $legal_values 611000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=28300000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=26000000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_dis"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="pcie_gen3_rx") }] {
         set legal_values [intersect $legal_values [list "eq_bw_1"]]
      } else {
         if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
            if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_2"]]
               } else {
                  if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                     set legal_values [intersect $legal_values [list "eq_bw_3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "eq_bw_4"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_optimal } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
            if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "no_dc_gain"]]
            }
         } else {
            if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
               if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "no_dc_gain"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="sr") }] {
                  if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg2_gain7"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link_rx=="mr") }] {
                     if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                        set legal_values [intersect $legal_values [list "stg1_gain7"]]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                        if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "no_dc_gain"]]
                           }
                        } else {
                           if [expr { ($pma_rx_buf_xrx_path_optimal=="true") }] {
                              set legal_values [intersect $legal_values [list "stg1_gain7"]]
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "non_s1_mode"]]
         }
      } else {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision pma_rx_buf_pm_tx_rx_pcie_gen pma_rx_buf_xrx_path_prot_mode pma_tx_buf_xtx_path_prot_mode } {

   set legal_values [list "cvp_off" "cvp_on"]

   if [expr { (($pma_tx_buf_xtx_path_prot_mode=="unused")&&($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      set legal_values [intersect $legal_values [list "cvp_off"]]
   } else {
      if [expr { (((((($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_100mhzref")||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen1_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen2_125mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_100mhzref"))||($pma_rx_buf_pm_tx_rx_pcie_gen=="pcie_gen3_125mhzref")) }] {
         set legal_values [intersect $legal_values [list "cvp_on" "cvp_off"]]
      } else {
         set legal_values [intersect $legal_values [list "cvp_off"]]
      }
   }
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_prot_mode=="qpi_rx"))||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_rx_vga_oc_en { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "vga_cal_off" "vga_cal_on"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vga_cal_off"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="qpi_rx") }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_datarate>17400000000) }] {
            set legal_values [intersect $legal_values [list "r_r1" "r_r2"]]
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "r_r1" "r_r2" "r_ext0"]]
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r1"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_term_tri_enable { device_revision } {

   set legal_values [list "disable_tri" "enable_tri"]

   set legal_values [intersect $legal_values [list "disable_tri"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   } else {
      if [expr { ((($pma_rx_buf_prot_mode=="pcie_gen1_rx")||($pma_rx_buf_prot_mode=="pcie_gen2_rx"))||($pma_rx_buf_prot_mode=="pcie_gen3_rx")) }] {
         set legal_values [intersect $legal_values [list "vcm_current_3"]]
      } else {
         if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
            set legal_values [intersect $legal_values [list "vcm_current_1"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
               set legal_values [intersect $legal_values [list "vcm_setting_02"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_02"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
               if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_03"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                              }
                           }
                        }
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                              } else {
                                 if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                    set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 25800000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 25800000000]
               } else {
                  set legal_values [compare_le $legal_values 15000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 25800000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 20000000000]
                  } else {
                     set legal_values [compare_le $legal_values 14200000000]
                  }
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 1000000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 1000000000]
         } else {
            set legal_values [compare_ge $legal_values 1000000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=25800000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                     if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                        set legal_values [intersect $legal_values [list "enable"]]
                     } else {
                        set legal_values [intersect $legal_values [list "disable"]]
                     }
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_dis"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="pcie_gen3_rx") }] {
         set legal_values [intersect $legal_values [list "eq_bw_2"]]
      } else {
         if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
            if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            }
         } else {
            if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_1"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_2"]]
               } else {
                  if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                     set legal_values [intersect $legal_values [list "eq_bw_3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "eq_bw_4"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ($pma_rx_buf_link_rx=="sr") }] {
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "stg2_gain7"]]
            }
         } else {
            if [expr { ($pma_rx_buf_link_rx=="mr") }] {
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "stg1_gain7"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                  if [expr { ($pma_rx_buf_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg1_gain7"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_link_rx pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ($pma_rx_buf_link_rx=="sr") }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "e1"]]
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision } {

   set legal_values [list "cvp_off" "cvp_on"]

   set legal_values [intersect $legal_values [list "cvp_off"]]
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_prot_mode=="qpi_rx"))||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_datarate>=25000000000) }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_prot_mode!="basic_rx") }] {
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r1"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r2"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_term_tri_enable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {

   set legal_values [list "disable_tri" "enable_tri"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "disable_tri"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_vcm_sel { device_revision pma_adapt_adapt_mode pma_rx_buf_power_mode pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_xrx_path_sup_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_xrx_path_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
               set legal_values [intersect $legal_values [list "vcm_setting_02"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_02"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_02"]]
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
               if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                  set legal_values [intersect $legal_values [list "vcm_setting_03"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_03"]]
                              }
                           }
                        }
                     }
                  }
               }
            } else {
               if [expr { ($pma_rx_buf_power_mode=="low_power") }] {
                  if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
                     set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                     } else {
                        if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                           set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                        } else {
                           if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                              set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                           } else {
                              if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                 set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                              } else {
                                 if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                                    set legal_values [intersect $legal_values [list "vcm_setting_04"]]
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 28300000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 26000000000]
               } else {
                  set legal_values [compare_le $legal_values 14200000000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 20000000000]
               } else {
                  set legal_values [compare_le $legal_values 14200000000]
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 611000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 611000000]
         } else {
            set legal_values [compare_ge $legal_values 611000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=28300000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=26000000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_cgm_bias_disable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "cgmbias_dis" "cgmbias_en"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "cgmbias_en"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_eq_bw_sel { device_revision pma_rx_buf_datarate pma_rx_buf_one_stage_enable pma_rx_buf_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "eq_bw_1" "eq_bw_2" "eq_bw_3" "eq_bw_4"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "eq_bw_1"]]
   } else {
      if [expr { ($pma_rx_buf_one_stage_enable=="non_s1_mode") }] {
         if [expr { ($pma_rx_buf_datarate<=6000000000) }] {
            set legal_values [intersect $legal_values [list "eq_bw_1"]]
         } else {
            set legal_values [intersect $legal_values [list "eq_bw_2"]]
         }
      } else {
         if [expr { ($pma_rx_buf_datarate<=5000000000) }] {
            set legal_values [intersect $legal_values [list "eq_bw_1"]]
         } else {
            if [expr { ($pma_rx_buf_datarate<=10000000000) }] {
               set legal_values [intersect $legal_values [list "eq_bw_2"]]
            } else {
               if [expr { ($pma_rx_buf_datarate<=20000000000) }] {
                  set legal_values [intersect $legal_values [list "eq_bw_3"]]
               } else {
                  set legal_values [intersect $legal_values [list "eq_bw_4"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_eq_dc_gain_trim { device_revision pma_rx_buf_link_rx pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_sup_mode } {

   set legal_values [list "no_dc_gain" "stg1_gain1" "stg1_gain2" "stg1_gain3" "stg1_gain4" "stg1_gain5" "stg1_gain6" "stg1_gain7" "stg2_gain1" "stg2_gain2" "stg2_gain3" "stg2_gain4" "stg2_gain5" "stg2_gain6" "stg2_gain7" "stg3_gain1" "stg3_gain2" "stg3_gain3" "stg3_gain4" "stg3_gain5" "stg3_gain6" "stg3_gain7" "stg4_gain1" "stg4_gain2" "stg4_gain3" "stg4_gain4" "stg4_gain5" "stg4_gain6" "stg4_gain7"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "no_dc_gain"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "no_dc_gain" "stg1_gain7" "stg2_gain7" "stg3_gain7" "stg4_gain7"]]
         if [expr { ($pma_rx_buf_link_rx=="sr") }] {
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "stg2_gain7"]]
            }
         } else {
            if [expr { ($pma_rx_buf_link_rx=="mr") }] {
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "stg1_gain7"]]
               }
            } else {
               if [expr { ($pma_rx_buf_link_rx=="lr") }] {
                  if [expr { ($pma_rx_buf_optimal=="true") }] {
                     set legal_values [intersect $legal_values [list "stg1_gain7"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_one_stage_enable { device_revision pma_rx_buf_datarate pma_rx_buf_link_rx pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "non_s1_mode" "s1_mode"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_datarate>17400000000))||($pma_rx_buf_refclk_en=="enable")) }] {
      set legal_values [intersect $legal_values [list "s1_mode"]]
   } else {
      if [expr { ($pma_rx_buf_link_rx=="sr") }] {
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "s1_mode"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_pm_speed_grade { device_revision pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {

   set legal_values [list "e1" "e2" "e3" "e4" "e5" "i1" "i2" "i3" "i4" "i5" "m3" "m4"]

   if [expr { !(($pma_rx_buf_xrx_path_prot_mode=="unused")) }] {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [exclude $legal_values [list "e1"]]
         set legal_values [exclude $legal_values [list "i1"]]
         set legal_values [exclude $legal_values [list "i2"]]
         set legal_values [exclude $legal_values [list "i3"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_pm_tx_rx_cvp_mode { device_revision } {

   set legal_values [list "cvp_off" "cvp_on"]

   set legal_values [intersect $legal_values [list "cvp_off"]]
   set legal_values [intersect $legal_values [list "cvp_off"]]

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_power_mode { device_revision pma_rx_buf_xrx_path_prot_mode pma_tx_buf_power_mode } {

   set legal_values [list "high_perf" "low_power" "mid_power"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode!="unused") }] {
      set legal_values [exclude $legal_values [list "low_power"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="qpi_rx") }] {
      set legal_values [intersect $legal_values [list "high_perf" "mid_power"]]
   }
   if [expr { ($pma_tx_buf_power_mode=="low_power") }] {
      set legal_values [intersect $legal_values [list "low_power"]]
   } else {
      if [expr { ($pma_tx_buf_power_mode=="mid_power") }] {
         set legal_values [intersect $legal_values [list "mid_power"]]
      } else {
         if [expr { ($pma_tx_buf_power_mode=="high_perf") }] {
            set legal_values [intersect $legal_values [list "high_perf"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_rx_sel_bias_source { device_revision pma_rx_buf_prot_mode pma_rx_buf_sup_mode pma_rx_buf_vcm_sel } {

   set legal_values [list "bias_int" "bias_vcmdrv"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")||($pma_rx_buf_vcm_sel=="vcm_setting_00")) }] {
      set legal_values [intersect $legal_values [list "bias_int"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "bias_vcmdrv"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_term_sel { device_revision pma_rx_buf_datarate pma_rx_buf_optimal pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {
   regsub -nocase -all {\D} $pma_rx_buf_datarate "" pma_rx_buf_datarate

   set legal_values [list "r_ext0" "r_ext1" "r_r1" "r_r2"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      if [expr { ($pma_rx_buf_refclk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "r_ext0"]]
      } else {
         set legal_values [intersect $legal_values [list "r_ext0" "r_r1"]]
         if [expr { ($pma_rx_buf_optimal=="true") }] {
            set legal_values [intersect $legal_values [list "r_r1"]]
         }
      }
   } else {
      if [expr { ($pma_rx_buf_datarate>=25000000000) }] {
         set legal_values [intersect $legal_values [list "r_r2"]]
      } else {
         if [expr { ($pma_rx_buf_prot_mode!="basic_rx") }] {
            if [expr { ($pma_rx_buf_optimal=="true") }] {
               set legal_values [intersect $legal_values [list "r_r1"]]
            }
         } else {
            if [expr { ($pma_rx_buf_prot_mode=="basic_rx") }] {
               if [expr { ($pma_rx_buf_optimal=="true") }] {
                  set legal_values [intersect $legal_values [list "r_r2"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_term_tri_enable { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en } {

   set legal_values [list "disable_tri" "enable_tri"]

   if [expr { (($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable")) }] {
      set legal_values [intersect $legal_values [list "disable_tri"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_vcm_current_add { device_revision pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_current_1" "vcm_current_2" "vcm_current_3" "vcm_current_default"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vcm_current_1"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_vcm_sel { device_revision pma_rx_buf_power_mode_rx pma_rx_buf_prot_mode pma_rx_buf_refclk_en pma_rx_buf_sup_mode } {

   set legal_values [list "vcm_setting_00" "vcm_setting_01" "vcm_setting_02" "vcm_setting_03" "vcm_setting_04" "vcm_setting_05" "vcm_setting_06" "vcm_setting_07" "vcm_setting_08" "vcm_setting_09" "vcm_setting_10" "vcm_setting_11" "vcm_setting_12" "vcm_setting_13" "vcm_setting_14" "vcm_setting_15"]

   if [expr { ((($pma_rx_buf_prot_mode=="unused")&&($pma_rx_buf_refclk_en=="disable"))||($pma_rx_buf_prot_mode=="qpi_rx")) }] {
      set legal_values [intersect $legal_values [list "vcm_setting_14"]]
   } else {
      if [expr { ($pma_rx_buf_sup_mode=="user_mode") }] {
         if [expr { ($pma_rx_buf_power_mode_rx=="high_perf") }] {
            set legal_values [intersect $legal_values [list "vcm_setting_02"]]
         }
         if [expr { ($pma_rx_buf_power_mode_rx=="mid_power") }] {
            set legal_values [intersect $legal_values [list "vcm_setting_02"]]
         }
         if [expr { ($pma_rx_buf_power_mode_rx=="low_power") }] {
            set legal_values [intersect $legal_values [list "vcm_setting_04"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_xrx_path_datarate { device_revision pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
            if [expr { ($pma_rx_buf_link=="sr") }] {
               set legal_values [compare_le $legal_values 28300000000]
            } else {
               set legal_values [compare_le $legal_values 17400000000]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 26000000000]
               } else {
                  set legal_values [compare_le $legal_values 14200000000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 20000000000]
               } else {
                  set legal_values [compare_le $legal_values 14200000000]
               }
            }
         }
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e1") }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 17400000000]
               } else {
                  set legal_values [compare_le $legal_values 16000000000]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="i1") }] {
                  if [expr { ($pma_rx_buf_link=="sr") }] {
                     set legal_values [compare_le $legal_values 17400000000]
                  } else {
                     set legal_values [compare_le $legal_values 16000000000]
                  }
               } else {
                  if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
                     if [expr { ($pma_rx_buf_link=="sr") }] {
                        set legal_values [compare_le $legal_values 15000000000]
                     } else {
                        set legal_values [compare_le $legal_values 14200000000]
                     }
                  } else {
                     if [expr { ($pma_rx_buf_pm_speed_grade=="i2") }] {
                        if [expr { ($pma_rx_buf_link=="sr") }] {
                           set legal_values [compare_le $legal_values 15000000000]
                        } else {
                           set legal_values [compare_le $legal_values 14200000000]
                        }
                     } else {
                        if [expr { (($pma_rx_buf_pm_speed_grade=="e3")||($pma_rx_buf_pm_speed_grade=="i3")) }] {
                           if [expr { ($pma_rx_buf_link=="sr") }] {
                              set legal_values [compare_le $legal_values 14200000000]
                           } else {
                              set legal_values [compare_le $legal_values 12500000000]
                           }
                        } else {
                           if [expr { (($pma_rx_buf_pm_speed_grade=="e4")||($pma_rx_buf_pm_speed_grade=="i4")) }] {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 12500000000]
                              } else {
                                 set legal_values [compare_le $legal_values 10312500000]
                              }
                           } else {
                              if [expr { ($pma_rx_buf_link=="sr") }] {
                                 set legal_values [compare_le $legal_values 8000000000]
                              } else {
                                 set legal_values [compare_le $legal_values 6553600000]
                              }
                           }
                        }
                     }
                  }
               }
            }
         } else {
            if [expr { (((((((($pma_rx_buf_pm_speed_grade=="e1")||($pma_rx_buf_pm_speed_grade=="i1"))||($pma_rx_buf_pm_speed_grade=="e2"))||($pma_rx_buf_pm_speed_grade=="i2"))||($pma_rx_buf_pm_speed_grade=="e3"))||($pma_rx_buf_pm_speed_grade=="i3"))||($pma_rx_buf_pm_speed_grade=="e4"))||($pma_rx_buf_pm_speed_grade=="i4")) }] {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 11300000000]
               } else {
                  set legal_values [compare_le $legal_values 10312500000]
               }
            } else {
               if [expr { ($pma_rx_buf_link=="sr") }] {
                  set legal_values [compare_le $legal_values 8000000000]
               } else {
                  set legal_values [compare_le $legal_values 6553600000]
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         set legal_values [compare_ge $legal_values 611000000]
      } else {
         if [expr { ($pma_rx_buf_power_mode=="mid_power") }] {
            set legal_values [compare_ge $legal_values 611000000]
         } else {
            set legal_values [compare_ge $legal_values 611000000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_buf_xrx_path_gt_enabled { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_link pma_rx_buf_pm_speed_grade pma_rx_buf_power_mode pma_rx_buf_xrx_path_datarate pma_rx_buf_xrx_path_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "disable" "enable"]

   if [expr { (($pma_rx_buf_xrx_path_prot_mode=="unused")&&($cdr_pll_tx_pll_prot_mode=="txpll_unused")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ($pma_rx_buf_power_mode=="high_perf") }] {
         if [expr { ($pma_rx_buf_pm_speed_grade=="e2") }] {
            if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>17400000000))&&($pma_rx_buf_xrx_path_datarate<=28300000000)) }] {
               set legal_values [intersect $legal_values [list "enable"]]
            } else {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         } else {
            if [expr { ($pma_rx_buf_pm_speed_grade=="e3") }] {
               if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=26000000000)) }] {
                  set legal_values [intersect $legal_values [list "enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "disable"]]
               }
            } else {
               if [expr { ($pma_rx_buf_pm_speed_grade=="e4") }] {
                  if [expr { ((($pma_rx_buf_link=="sr")&&($pma_rx_buf_xrx_path_datarate>15000000000))&&($pma_rx_buf_xrx_path_datarate<=20000000000)) }] {
                     set legal_values [intersect $legal_values [list "enable"]]
                  } else {
                     set legal_values [intersect $legal_values [list "disable"]]
                  }
               }
            }
         }
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}


