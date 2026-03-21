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


proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_bitslip_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_bitslip_bypass pma_rx_deser_prot_mode } {

   set legal_values [list "bs_bypass_no" "bs_bypass_yes"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "bs_bypass_yes"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_bitslip_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_bitslip_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_bitslip_bypass $pma_rx_deser_bitslip_bypass $legal_values { pma_rx_deser_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_clkdiv_source { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_clkdiv_source pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "clklow_to_clkdivrx" "fref_to_clkdivrx" "vco_bypass_normal"]

   if [expr { (($pma_rx_deser_prot_mode=="unused")||($pma_rx_deser_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vco_bypass_normal"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_clkdiv_source.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_clkdiv_source $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_clkdiv_source $pma_rx_deser_clkdiv_source $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_clkdivrx_user_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_clkdivrx_user_mode pma_rx_deser_deser_factor pma_rx_deser_prot_mode } {
   set pma_rx_deser_deser_factor [convert_a2b_pma_rx_deser_deser_factor $pma_rx_deser_deser_factor]

   set legal_values [list "clkdivrx_user_clkdiv" "clkdivrx_user_clkdiv_div2" "clkdivrx_user_disabled" "clkdivrx_user_div33" "clkdivrx_user_div40" "clkdivrx_user_div66"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "clkdivrx_user_disabled"]]
   } else {
      if [expr { ($pma_rx_deser_deser_factor!="deser_64b") }] {
         set legal_values [intersect $legal_values [list "clkdivrx_user_disabled" "clkdivrx_user_clkdiv" "clkdivrx_user_clkdiv_div2" "clkdivrx_user_div33" "clkdivrx_user_div66"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_clkdivrx_user_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_clkdivrx_user_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_clkdivrx_user_mode $pma_rx_deser_clkdivrx_user_mode $legal_values { pma_rx_deser_deser_factor pma_rx_deser_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_datarate { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_datarate cdr_pll_tx_pll_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_deser_datarate "" pma_rx_deser_datarate
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($cdr_pll_tx_pll_prot_mode=="txpll_unused") }] {
      set legal_values [compare_eq $legal_values $pma_rx_buf_xrx_path_datarate]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.pma_rx_deser_datarate.value" "${min} bps"
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message pma_rx_deser_datarate $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message pma_rx_deser_datarate $legal_values
      }
   } else {
      auto_value_out_of_range_message auto pma_rx_deser_datarate $pma_rx_deser_datarate $legal_values { cdr_pll_tx_pll_prot_mode pma_rx_buf_xrx_path_datarate }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_deser_factor { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_deser_factor pma_rx_buf_xrx_path_datawidth } {

   set legal_values [list "deser_10b" "deser_16b" "deser_20b" "deser_32b" "deser_40b" "deser_64b" "deser_8b"]

   if [expr { ($pma_rx_buf_xrx_path_datawidth==8) }] {
      set legal_values [intersect $legal_values [list "deser_8b"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_datawidth==10) }] {
      set legal_values [intersect $legal_values [list "deser_10b"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_datawidth==16) }] {
      set legal_values [intersect $legal_values [list "deser_16b"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_datawidth==20) }] {
      set legal_values [intersect $legal_values [list "deser_20b"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_datawidth==32) }] {
      set legal_values [intersect $legal_values [list "deser_32b"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_datawidth==40) }] {
      set legal_values [intersect $legal_values [list "deser_40b"]]
   }
   if [expr { ($pma_rx_buf_xrx_path_datawidth==64) }] {
      set legal_values [intersect $legal_values [list "deser_64b"]]
   }

   set legal_values [convert_b2a_pma_rx_deser_deser_factor $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.pma_rx_deser_deser_factor.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message pma_rx_deser_deser_factor $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message pma_rx_deser_deser_factor $legal_values
      }
   } else {
      auto_value_out_of_range_message auto pma_rx_deser_deser_factor $pma_rx_deser_deser_factor $legal_values { pma_rx_buf_xrx_path_datawidth }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_deser_powerdown { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_deser_powerdown pma_rx_deser_prot_mode } {

   set legal_values [list "deser_power_down" "deser_power_up"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "deser_power_down"]]
   } else {
      set legal_values [intersect $legal_values [list "deser_power_up"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_deser_powerdown.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_deser_powerdown $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_deser_powerdown $pma_rx_deser_deser_powerdown $legal_values { pma_rx_deser_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_force_adaptation_outputs { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_force_adaptation_outputs pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "forced_0101" "forced_1010" "forced_all_ones" "forced_all_zeros" "normal_outputs"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "forced_all_zeros"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "normal_outputs"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_force_adaptation_outputs.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_force_adaptation_outputs $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_force_adaptation_outputs $pma_rx_deser_force_adaptation_outputs $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_force_clkdiv_for_testing { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_force_clkdiv_for_testing pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "forced_0" "forced_1" "normal_clkdiv"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "forced_0"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "normal_clkdiv"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_force_clkdiv_for_testing.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_force_clkdiv_for_testing $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_force_clkdiv_for_testing $pma_rx_deser_force_clkdiv_for_testing $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_pcie_gen_bitwidth { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_pcie_gen_bitwidth } {

   set legal_values [list "pcie_gen3_16b" "pcie_gen3_32b"]

   set legal_values [intersect $legal_values [list "pcie_gen3_32b"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_pcie_gen_bitwidth.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_pcie_gen_bitwidth $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_pcie_gen_bitwidth $pma_rx_deser_pcie_gen_bitwidth $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_prot_mode pma_rx_buf_xrx_path_prot_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_prot_mode $pma_rx_deser_prot_mode $legal_values { pma_rx_buf_xrx_path_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_rst_n_adapt_odi { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_rst_n_adapt_odi pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "no_rst_adapt_odi" "yes_rst_adapt_odi"]

   if [expr { (($pma_rx_deser_prot_mode=="unused")||($pma_rx_deser_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "no_rst_adapt_odi"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_rst_n_adapt_odi.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_rst_n_adapt_odi $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_rst_n_adapt_odi $pma_rx_deser_rst_n_adapt_odi $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_sdclk_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_sdclk_enable pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "sd_clk_disabled" "sd_clk_enabled"]

   if [expr { ((((($pma_rx_deser_prot_mode=="pcie_gen1_rx")||($pma_rx_deser_prot_mode=="pcie_gen2_rx"))||($pma_rx_deser_prot_mode=="pcie_gen3_rx"))||($pma_rx_deser_prot_mode=="pcie_gen4_rx"))||($pma_rx_deser_prot_mode=="sata_rx")) }] {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "sd_clk_enabled"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "sd_clk_disabled"]]
   }

   set legal_values [convert_b2a_pma_rx_deser_sdclk_enable $legal_values]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_sdclk_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_sdclk_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_sdclk_enable $pma_rx_deser_sdclk_enable $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_pma_rx_deser_tdr_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_rx_deser_tdr_mode $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_pma_rx_deser_tdr_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_rx_deser_tdr_mode $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_pma_rx_deser_tdr_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_rx_deser_tdr_mode $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_pma_rx_deser_tdr_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_rx_deser_tdr_mode $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_pma_rx_deser_tdr_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_rx_deser_tdr_mode $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_pma_rx_deser_tdr_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_rx_deser_tdr_mode $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_pma_rx_deser_tdr_mode  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $pma_rx_deser_tdr_mode $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode
	} else {
		set legal_values [list "select_bbpd_data" "select_odi_data"]

		if { $PROP_M_AUTOSET } {
			set len [llength $legal_values]
			if { $len > 0 } {
				ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
			}
			if { $len != 1 && $PROP_M_AUTOWARN} {
				if { $device_revision!="20nm5es" } {
					ip_message warning "The value of parameter pma_rx_deser_tdr_mode cannot be automatically resolved. Valid values are: ${legal_values}."
				}
			}
		} else {
			auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { }
		}
	}
}

proc ::nf_xcvr_native::parameters::20nm1_validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_tdr_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_tdr_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_tdr_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_tdr_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_tdr_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_tdr_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_pma_rx_deser_tdr_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision pma_rx_deser_tdr_mode pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.pma_rx_deser_tdr_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message pma_rx_deser_tdr_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto pma_rx_deser_tdr_mode $pma_rx_deser_tdr_mode $legal_values { pma_rx_deser_prot_mode pma_rx_deser_sup_mode }
   }
}


