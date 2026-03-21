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


proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_atb_select { device_revision pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list "atb_disable" "atb_sel0" "atb_sel1" "atb_sel10" "atb_sel11" "atb_sel12" "atb_sel13" "atb_sel14" "atb_sel15" "atb_sel16" "atb_sel17" "atb_sel18" "atb_sel19" "atb_sel2" "atb_sel20" "atb_sel21" "atb_sel22" "atb_sel23" "atb_sel24" "atb_sel25" "atb_sel26" "atb_sel27" "atb_sel28" "atb_sel29" "atb_sel3" "atb_sel30" "atb_sel4" "atb_sel5" "atb_sel6" "atb_sel7" "atb_sel8" "atb_sel9"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "atb_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_datarate { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_dfe_datarate "" pma_rx_dfe_datarate
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($cdr_pll_tx_pll_prot_mode=="txpll_unused") }] {
      set legal_values [compare_eq $legal_values $pma_rx_buf_xrx_path_datarate]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_dft_en { device_revision pma_adapt_adapt_mode pma_rx_buf_xrx_path_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "dft_disable" "dft_enalbe"]

   if [expr { ($pma_rx_buf_xrx_path_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "dft_disable"]]
   } else {
      if [expr { (($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")&&((($pma_adapt_adapt_mode=="ctle")||($pma_adapt_adapt_mode=="ctle_vga"))||($pma_adapt_adapt_mode=="manual"))) }] {
         set legal_values [intersect $legal_values [list "dft_enalbe"]]
      } else {
         set legal_values [intersect $legal_values [list "dft_disable"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_initial_settings { device_revision pma_rx_buf_xrx_path_initial_settings } {

   set legal_values [list "false" "true"]

   if [expr { ($pma_rx_buf_xrx_path_initial_settings=="true") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_initial_settings=="false") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_adp1 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_adp2 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_c270 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_c90 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_d0c0 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_d0c180 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_d1c0 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_oc_sa_d1c180 { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_pdb { device_revision cdr_pll_enable_idle_rx_channel_support pma_rx_buf_prot_mode cdr_pll_prot_mode pma_adapt_adapt_mode pma_rx_dfe_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb  $device_revision $cdr_pll_enable_idle_rx_channel_support $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb  $device_revision $cdr_pll_enable_idle_rx_channel_support $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb  $device_revision $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb  $device_revision $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb  $device_revision $cdr_pll_enable_idle_rx_channel_support $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb  $device_revision $cdr_pll_prot_mode $pma_adapt_adapt_mode $pma_rx_dfe_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb  $device_revision $cdr_pll_enable_idle_rx_channel_support $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb  $device_revision $cdr_pll_enable_idle_rx_channel_support $pma_rx_buf_prot_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_buf_xrx_path_datarate pma_rx_dfe_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_buf_xrx_path_datarate]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_buf_xrx_path_datarate]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_buf_xrx_path_datarate]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_dfe_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_buf_xrx_path_datarate]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb_fixedtap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_buf_xrx_path_datarate]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap pma_rx_buf_xrx_path_datarate pma_rx_dfe_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_rx_buf_xrx_path_datarate $pma_rx_dfe_pdb_fixedtap $pma_rx_dfe_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb_floattap  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap pma_rx_dfe_prot_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_rx_dfe_pdb_fixedtap $pma_rx_dfe_prot_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb_fxtap4t7  $device_revision $pma_adapt_adapt_mode $pma_rx_buf_prot_mode $pma_rx_dfe_pdb_fixedtap]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_power_mode { device_revision pma_rx_buf_power_mode } {

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

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_prot_mode { device_revision pma_rx_buf_xrx_path_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_sel_fltapstep_dec { device_revision pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list "fltap_step_dec" "fltap_step_no_dec"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "fltap_step_no_dec"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_sel_fltapstep_inc { device_revision pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list "fltap_step_inc" "fltap_step_no_inc"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "fltap_step_no_inc"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_sel_fxtapstep_dec { device_revision pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list "fxtap234567_step_dec" "fxtap2345_step_dec" "fxtap2367_step_dec" "fxtap23_step_dec" "fxtap4567_step_dec" "fxtap45_step_dec" "fxtap67_step_dec" "fxtap_step_no_dec"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "fxtap_step_no_dec"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_sel_fxtapstep_inc { device_revision pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list "fxtap234567_step_inc" "fxtap2345_step_inc" "fxtap2367_step_inc" "fxtap23_step_inc" "fxtap4567_step_inc" "fxtap45_step_inc" "fxtap67_step_inc" "fxtap_step_no_inc"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "fxtap_step_no_inc"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_sel_oc_en { device_revision pma_rx_dfe_initial_settings pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list "off_canc_disable" "off_canc_enable"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||(($pma_rx_dfe_sup_mode=="user_mode")&&($pma_rx_dfe_initial_settings=="true"))) }] {
      set legal_values [intersect $legal_values [list "off_canc_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_sel_probe_tstmx { device_revision pma_rx_dfe_prot_mode pma_rx_dfe_sup_mode } {

   set legal_values [list "probe_fltap1_coeff" "probe_fltap2_coeff" "probe_fltap3_coeff" "probe_fltap4_coeff" "probe_fxtap10_coeff" "probe_fxtap1_coeff" "probe_fxtap2_coeff" "probe_fxtap3_coeff" "probe_fxtap4_coeff" "probe_fxtap5_coeff" "probe_fxtap6_coeff" "probe_fxtap7_coeff" "probe_fxtap8_coeff" "probe_fxtap9_coeff" "probe_none" "probe_tstmx_none"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "probe_tstmx_none"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_dfe_uc_rx_dfe_cal { device_revision cdr_pll_prot_mode pma_rx_dfe_pdb } {

   set legal_values [list "uc_rx_dfe_cal_off" "uc_rx_dfe_cal_on"]

   if [expr { (($pma_rx_dfe_pdb=="dfe_powerdown")&&($cdr_pll_prot_mode=="unused")) }] {
      set legal_values [intersect $legal_values [list "uc_rx_dfe_cal_off"]]
   } else {
      set legal_values [intersect $legal_values [list "uc_rx_dfe_cal_on"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb { device_revision cdr_pll_enable_idle_rx_channel_support pma_rx_buf_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($cdr_pll_enable_idle_rx_channel_support=="true") }] {
      set legal_values [intersect $legal_values [list "dfe_enable"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
         set legal_values [intersect $legal_values [list "dfe_powerdown"]]
      } else {
         set legal_values [intersect $legal_values [list "dfe_enable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { ((($pma_rx_buf_xrx_path_datarate<=4500000000)&&($pma_adapt_adapt_mode!="ctle"))&&($pma_adapt_adapt_mode!="ctle_vga")) }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
      } else {
         if [expr { ($pma_adapt_adapt_mode=="manual") }] {
            set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown" "fixtap_dfe_enable"]]
         } else {
            if [expr { ($pma_adapt_adapt_mode=="ctle") }] {
               set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
            } else {
               if [expr { ($pma_adapt_adapt_mode=="ctle_vga") }] {
                  set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
               } else {
                  if [expr { ($pma_adapt_adapt_mode=="dfe_vga") }] {
                     set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                  } else {
                     if [expr { ($pma_adapt_adapt_mode=="ctle_vga_dfe") }] {
                        set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb { device_revision cdr_pll_enable_idle_rx_channel_support pma_rx_buf_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($cdr_pll_enable_idle_rx_channel_support=="true") }] {
      set legal_values [intersect $legal_values [list "dfe_enable"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
         set legal_values [intersect $legal_values [list "dfe_powerdown"]]
      } else {
         set legal_values [intersect $legal_values [list "dfe_enable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { ((($pma_rx_buf_xrx_path_datarate<=4500000000)&&($pma_adapt_adapt_mode!="ctle"))&&($pma_adapt_adapt_mode!="ctle_vga")) }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
      } else {
         if [expr { ($pma_adapt_adapt_mode=="manual") }] {
            set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown" "fixtap_dfe_enable"]]
         } else {
            if [expr { ($pma_adapt_adapt_mode=="ctle") }] {
               set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
            } else {
               if [expr { ($pma_adapt_adapt_mode=="ctle_vga") }] {
                  set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
               } else {
                  if [expr { ($pma_adapt_adapt_mode=="dfe_vga") }] {
                     set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                  } else {
                     if [expr { ($pma_adapt_adapt_mode=="ctle_vga_dfe") }] {
                        set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb { device_revision cdr_pll_enable_idle_rx_channel_support pma_rx_buf_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($cdr_pll_enable_idle_rx_channel_support=="true") }] {
      set legal_values [intersect $legal_values [list "dfe_enable"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
         set legal_values [intersect $legal_values [list "dfe_powerdown"]]
      } else {
         set legal_values [intersect $legal_values [list "dfe_enable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { ((($pma_rx_buf_xrx_path_datarate<=4500000000)&&($pma_adapt_adapt_mode!="ctle"))&&($pma_adapt_adapt_mode!="ctle_vga")) }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
      } else {
         if [expr { ($pma_adapt_adapt_mode=="manual") }] {
            set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown" "fixtap_dfe_enable"]]
         } else {
            if [expr { ($pma_adapt_adapt_mode=="ctle") }] {
               set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
            } else {
               if [expr { ($pma_adapt_adapt_mode=="ctle_vga") }] {
                  set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
               } else {
                  if [expr { ($pma_adapt_adapt_mode=="dfe_vga") }] {
                     set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                  } else {
                     if [expr { ($pma_adapt_adapt_mode=="ctle_vga_dfe") }] {
                        set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb { device_revision cdr_pll_enable_idle_rx_channel_support pma_rx_buf_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($cdr_pll_enable_idle_rx_channel_support=="true") }] {
      set legal_values [intersect $legal_values [list "dfe_enable"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
         set legal_values [intersect $legal_values [list "dfe_powerdown"]]
      } else {
         set legal_values [intersect $legal_values [list "dfe_enable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { ((($pma_rx_buf_xrx_path_datarate<=4500000000)&&($pma_adapt_adapt_mode!="ctle"))&&($pma_adapt_adapt_mode!="ctle_vga")) }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
      } else {
         if [expr { ($pma_adapt_adapt_mode=="manual") }] {
            set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown" "fixtap_dfe_enable"]]
         } else {
            if [expr { ($pma_adapt_adapt_mode=="ctle") }] {
               set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
            } else {
               if [expr { ($pma_adapt_adapt_mode=="ctle_vga") }] {
                  set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
               } else {
                  if [expr { ($pma_adapt_adapt_mode=="dfe_vga") }] {
                     set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                  } else {
                     if [expr { ($pma_adapt_adapt_mode=="ctle_vga_dfe") }] {
                        set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb { device_revision pma_rx_buf_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "dfe_powerdown"]]
   } else {
      set legal_values [intersect $legal_values [list "dfe_enable"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode } {

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { ($pma_adapt_adapt_mode=="manual") }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown" "fixtap_dfe_enable"]]
      } else {
         if [expr { ($pma_adapt_adapt_mode=="ctle") }] {
            set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
         } else {
            if [expr { ($pma_adapt_adapt_mode=="ctle_vga") }] {
               set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
            } else {
               if [expr { ($pma_adapt_adapt_mode=="dfe_vga") }] {
                  set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
               } else {
                  if [expr { ($pma_adapt_adapt_mode=="ctle_vga_dfe") }] {
                     set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb { device_revision cdr_pll_enable_idle_rx_channel_support pma_rx_buf_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($cdr_pll_enable_idle_rx_channel_support=="true") }] {
      set legal_values [intersect $legal_values [list "dfe_enable"]]
   } else {
      if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
         set legal_values [intersect $legal_values [list "dfe_powerdown"]]
      } else {
         set legal_values [intersect $legal_values [list "dfe_enable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { ((($pma_rx_buf_xrx_path_datarate<=4500000000)&&($pma_adapt_adapt_mode!="ctle"))&&($pma_adapt_adapt_mode!="ctle_vga")) }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
      } else {
         if [expr { ($pma_adapt_adapt_mode=="manual") }] {
            set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown" "fixtap_dfe_enable"]]
         } else {
            if [expr { ($pma_adapt_adapt_mode=="ctle") }] {
               set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
            } else {
               if [expr { ($pma_adapt_adapt_mode=="ctle_vga") }] {
                  set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
               } else {
                  if [expr { ($pma_adapt_adapt_mode=="dfe_vga") }] {
                     set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                  } else {
                     if [expr { ($pma_adapt_adapt_mode=="ctle_vga_dfe") }] {
                        set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }
   if [expr { ($pma_rx_buf_xrx_path_datarate>17400000000) }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "floattap_dfe_powerdown" "floattap_dfe_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
               } else {
                  if [expr { (($pma_adapt_adapt_mode=="dfe_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                     set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                  } else {
                     if [expr { (($pma_adapt_adapt_mode=="ctle_vga_dfe")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                        set legal_values [intersect $legal_values [list "fxtap4t7_powerdown" "fxtap4t7_enable"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb { device_revision pma_rx_buf_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "dfe_powerdown"]]
   } else {
      set legal_values [intersect $legal_values [list "dfe_enable"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode } {

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { ($pma_adapt_adapt_mode=="manual") }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown" "fixtap_dfe_enable"]]
      } else {
         if [expr { ($pma_adapt_adapt_mode=="ctle") }] {
            set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
         } else {
            if [expr { ($pma_adapt_adapt_mode=="ctle_vga") }] {
               set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
            } else {
               if [expr { ($pma_adapt_adapt_mode=="dfe_vga") }] {
                  set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
               } else {
                  if [expr { ($pma_adapt_adapt_mode=="ctle_vga_dfe") }] {
                     set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
                  }
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
         } else {
            if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
               set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
            } else {
               if [expr { (($pma_adapt_adapt_mode=="ctle_vga")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
                  set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
               }
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_adapt_adapt_mode pma_rx_buf_prot_mode pma_rx_dfe_pdb_fixedtap } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { ($pma_rx_buf_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="manual")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
         set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
      } else {
         if [expr { (($pma_adapt_adapt_mode=="ctle")&&($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_enable")) }] {
            set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb { device_revision cdr_pll_prot_mode pma_adapt_adapt_mode pma_rx_dfe_prot_mode } {

   set legal_values [list "dfe_enable" "dfe_powerdown" "dfe_reset"]

   if [expr { ($pma_rx_dfe_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "dfe_powerdown"]]
   } else {
      if [expr { ((($pma_adapt_adapt_mode=="dfe_vga")||($pma_adapt_adapt_mode=="ctle_vga_dfe"))||($cdr_pll_prot_mode!="unused")) }] {
         set legal_values [intersect $legal_values [list "dfe_enable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb_fixedtap { device_revision pma_adapt_adapt_mode pma_rx_dfe_prot_mode } {

   set legal_values [list "fixtap_dfe_enable" "fixtap_dfe_powerdown"]

   if [expr { ($pma_rx_dfe_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "fixtap_dfe_powerdown"]]
   } else {
      if [expr { (($pma_adapt_adapt_mode=="dfe_vga")||($pma_adapt_adapt_mode=="ctle_vga_dfe")) }] {
         set legal_values [intersect $legal_values [list "fixtap_dfe_enable"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb_floattap { device_revision pma_rx_buf_xrx_path_datarate pma_rx_dfe_pdb_fixedtap pma_rx_dfe_prot_mode } {
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list "floattap_dfe_enable" "floattap_dfe_powerdown"]

   if [expr { ((($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown"))||($pma_rx_buf_xrx_path_datarate>17400000000)) }] {
      set legal_values [intersect $legal_values [list "floattap_dfe_powerdown"]]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_pma_rx_dfe_pdb_fxtap4t7 { device_revision pma_rx_dfe_pdb_fixedtap pma_rx_dfe_prot_mode } {

   set legal_values [list "fxtap4t7_enable" "fxtap4t7_powerdown"]

   if [expr { (($pma_rx_dfe_prot_mode=="unused")||($pma_rx_dfe_pdb_fixedtap=="fixtap_dfe_powerdown")) }] {
      set legal_values [intersect $legal_values [list "fxtap4t7_powerdown"]]
   }

   return $legal_values
}


