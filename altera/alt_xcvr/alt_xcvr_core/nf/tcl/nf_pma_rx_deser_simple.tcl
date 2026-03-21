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


proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_bitslip_bypass { device_revision pma_rx_deser_prot_mode } {

   set legal_values [list "bs_bypass_no" "bs_bypass_yes"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "bs_bypass_yes"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_clkdiv_source { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "clklow_to_clkdivrx" "fref_to_clkdivrx" "vco_bypass_normal"]

   if [expr { (($pma_rx_deser_prot_mode=="unused")||($pma_rx_deser_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "vco_bypass_normal"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_clkdivrx_user_mode { device_revision pma_rx_deser_deser_factor pma_rx_deser_prot_mode } {
   set pma_rx_deser_deser_factor [convert_a2b_pma_rx_deser_deser_factor $pma_rx_deser_deser_factor]

   set legal_values [list "clkdivrx_user_clkdiv" "clkdivrx_user_clkdiv_div2" "clkdivrx_user_disabled" "clkdivrx_user_div33" "clkdivrx_user_div40" "clkdivrx_user_div66"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "clkdivrx_user_disabled"]]
   } else {
      if [expr { ($pma_rx_deser_deser_factor!="deser_64b") }] {
         set legal_values [intersect $legal_values [list "clkdivrx_user_disabled" "clkdivrx_user_clkdiv" "clkdivrx_user_clkdiv_div2" "clkdivrx_user_div33" "clkdivrx_user_div66"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_datarate { device_revision cdr_pll_tx_pll_prot_mode pma_rx_buf_xrx_path_datarate } {
   regsub -nocase -all {\D} $pma_rx_deser_datarate "" pma_rx_deser_datarate
   regsub -nocase -all {\D} $pma_rx_buf_xrx_path_datarate "" pma_rx_buf_xrx_path_datarate

   set legal_values [list 0:68719476735]

   if [expr { ($cdr_pll_tx_pll_prot_mode=="txpll_unused") }] {
      set legal_values [compare_eq $legal_values $pma_rx_buf_xrx_path_datarate]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_deser_factor { device_revision pma_rx_buf_xrx_path_datawidth } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_deser_powerdown { device_revision pma_rx_deser_prot_mode } {

   set legal_values [list "deser_power_down" "deser_power_up"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "deser_power_down"]]
   } else {
      set legal_values [intersect $legal_values [list "deser_power_up"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_force_adaptation_outputs { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "forced_0101" "forced_1010" "forced_all_ones" "forced_all_zeros" "normal_outputs"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "forced_all_zeros"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "normal_outputs"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_force_clkdiv_for_testing { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "forced_0" "forced_1" "normal_clkdiv"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "forced_0"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "normal_clkdiv"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_pcie_gen_bitwidth { device_revision } {

   set legal_values [list "pcie_gen3_16b" "pcie_gen3_32b"]

   set legal_values [intersect $legal_values [list "pcie_gen3_32b"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_prot_mode { device_revision pma_rx_buf_xrx_path_prot_mode } {

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

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_rst_n_adapt_odi { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "no_rst_adapt_odi" "yes_rst_adapt_odi"]

   if [expr { (($pma_rx_deser_prot_mode=="unused")||($pma_rx_deser_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "no_rst_adapt_odi"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_sdclk_enable { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "sd_clk_disabled" "sd_clk_enabled"]

   if [expr { ((((($pma_rx_deser_prot_mode=="pcie_gen1_rx")||($pma_rx_deser_prot_mode=="pcie_gen2_rx"))||($pma_rx_deser_prot_mode=="pcie_gen3_rx"))||($pma_rx_deser_prot_mode=="pcie_gen4_rx"))||($pma_rx_deser_prot_mode=="sata_rx")) }] {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "sd_clk_enabled"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "sd_clk_disabled"]]
   }

   set legal_values [convert_b2a_pma_rx_deser_sdclk_enable $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_deser_tdr_mode  $device_revision $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_deser_tdr_mode  $device_revision $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_deser_tdr_mode  $device_revision $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_deser_tdr_mode  $device_revision $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_deser_tdr_mode  $device_revision $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_deser_tdr_mode  $device_revision $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_deser_tdr_mode  $device_revision $pma_rx_deser_prot_mode $pma_rx_deser_sup_mode]
	} else {
		set legal_values [list "select_bbpd_data" "select_odi_data"]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_pma_rx_deser_tdr_mode { device_revision pma_rx_deser_prot_mode pma_rx_deser_sup_mode } {

   set legal_values [list "select_bbpd_data" "select_odi_data"]

   if [expr { ($pma_rx_deser_prot_mode=="unused") }] {
      set legal_values [intersect $legal_values [list "select_bbpd_data"]]
   } else {
      if [expr { ($pma_rx_deser_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "select_bbpd_data"]]
      }
   }

   return $legal_values
}


