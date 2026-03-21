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


proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_block_sel { device_revision hssi_rx_pcs_pma_interface_pma_dw_rx hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "direct_pld" "eight_g_pcs" "ten_g_pcs"]

   if [expr { ((($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_krfec_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_basic_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_sfis_sdi_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "ten_g_pcs"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="pcs_direct_mode_rx") }] {
         if [expr { (((($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_8b_rx")||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_20b_rx")) }] {
            set legal_values [intersect $legal_values [list "direct_pld"]]
         } else {
            set legal_values [intersect $legal_values [list "direct_pld"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "eight_g_pcs"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_channel_operation_mode { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_clkslip_sel { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx } {

   set legal_values [list "pld" "slip_eight_g_pcs"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx") }] {
      set legal_values [intersect $legal_values [list "slip_eight_g_pcs"]]
   } else {
      set legal_values [intersect $legal_values [list "pld"]]
   }
   if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "slip_eight_g_pcs" "pld"]]
   } else {
      set legal_values [intersect $legal_values [list "pld"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_lpbk_en { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_master_clk_sel { device_revision hssi_rx_pcs_pma_interface_rx_lpbk_en hssi_rx_pcs_pma_interface_sup_mode } {

   set legal_values [list "master_refclk_dig" "master_rx_pma_clk" "master_tx_pma_clk"]

   if [expr { ($hssi_rx_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_rx_pcs_pma_interface_rx_lpbk_en=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "master_tx_pma_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "master_rx_pma_clk"]]
      }
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_rx_lpbk_en=="lpbk_en") }] {
         set legal_values [intersect $legal_values [list "master_tx_pma_clk" "master_refclk_dig"]]
      } else {
         set legal_values [intersect $legal_values [list "master_rx_pma_clk" "master_refclk_dig"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_pldif_datawidth_mode { device_revision hssi_rx_pcs_pma_interface_pma_dw_rx hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "pldif_data_10bit" "pldif_data_8bit"]

   if [expr { ((($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_krfec_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_basic_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="teng_sfis_sdi_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="pcs_direct_mode_rx") }] {
         if [expr { (((($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_8b_rx")||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pcs_pma_interface_pma_dw_rx=="pma_20b_rx")) }] {
            set legal_values [intersect $legal_values [list "pldif_data_8bit"]]
         } else {
            set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
         }
      } else {
         set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_pma_dw_rx { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_8b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_8b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_10b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_10b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_16b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_16b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_20b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_20b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_32b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_32b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_40b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_40b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pma_64b_rx") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx=="pcie_g3_dyn_dw_rx") }] {
      set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_pma_if_dft_en { device_revision } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_pma_if_dft_val { device_revision } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_prbs9_dwidth { device_revision hssi_rx_pcs_pma_interface_prbs_ver } {

   set legal_values [list "prbs9_10b" "prbs9_64b"]

   if [expr { ($hssi_rx_pcs_pma_interface_prbs_ver=="prbs_9") }] {
      set legal_values [intersect $legal_values [list "prbs9_64b" "prbs9_10b"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs9_64b"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_prbs_clken { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "prbs_clk_dis" "prbs_clk_en"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbs_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_clk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_prbs_ver { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "prbs_15" "prbs_23" "prbs_31" "prbs_7" "prbs_9" "prbs_off"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbs_31" "prbs_15" "prbs_23" "prbs_9" "prbs_7"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_off"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_prot_mode_rx { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx } {

   set legal_values [list "disabled_prot_mode_rx" "eightg_basic_mode_rx" "eightg_g3_pcie_g3_hip_mode_rx" "eightg_g3_pcie_g3_pld_mode_rx" "eightg_only_pld_mode_rx" "eightg_pcie_g12_hip_mode_rx" "eightg_pcie_g12_pld_mode_rx" "pcs_direct_mode_rx" "prbs_mode_rx" "teng_basic_mode_rx" "teng_krfec_mode_rx" "teng_sfis_sdi_mode_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="pcs_direct_mode_rx") }] {
      set legal_values [intersect $legal_values [list "pcs_direct_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_only_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_only_pld_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_pld_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_hip_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "eightg_basic_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_basic_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_sfis_sdi_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_rx"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbs_mode_rx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_lpbk_en { device_revision hssi_rx_pcs_pma_interface_lpbk_en hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "lpbk_dis" "lpbk_en"]

   if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "lpbk_en"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "lpbk_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "lpbk_dis"]]
      }
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_prbs_force_signal_ok { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "force_sig_ok" "unforce_sig_ok"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "unforce_sig_ok" "force_sig_ok"]]
   } else {
      set legal_values [intersect $legal_values [list "force_sig_ok"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_prbs_mask { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "prbsmask1024" "prbsmask128" "prbsmask256" "prbsmask512"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "prbsmask128" "prbsmask256" "prbsmask512" "prbsmask1024"]]
   } else {
      set legal_values [intersect $legal_values [list "prbsmask128"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_prbs_mode { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx } {

   set legal_values [list "eightg_mode" "teng_mode"]

   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_mode" "eightg_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "teng_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_signalok_signaldet_sel { device_revision hssi_rx_pcs_pma_interface_sup_mode } {

   set legal_values [list "sel_sig_det" "sel_sig_ok"]

   if [expr { ($hssi_rx_pcs_pma_interface_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "sel_sig_det"]]
   } else {
      set legal_values [intersect $legal_values [list "sel_sig_det" "sel_sig_ok"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion  $device_revision $hssi_rx_pcs_pma_interface_prot_mode_rx $hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_rx_uhsif_lpbk_en { device_revision hssi_rx_pcs_pma_interface_lpbk_en } {

   set legal_values [list "uhsif_lpbk_dis" "uhsif_lpbk_en"]

   if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "uhsif_lpbk_en" "uhsif_lpbk_dis"]]
   } else {
      if [expr { ($hssi_rx_pcs_pma_interface_lpbk_en=="disable") }] {
         set legal_values [intersect $legal_values [list "uhsif_lpbk_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "uhsif_lpbk_dis"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_rx_pcs_pma_interface_sup_mode { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
               if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis" "rx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "rx_dyn_polinv_dis"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_rx_pcs_pma_interface_rx_static_polarity_inversion { device_revision hssi_rx_pcs_pma_interface_prot_mode_rx hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   }
   if [expr { ($hssi_rx_pcs_pma_interface_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
   } else {
      if [expr { (((($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx"))||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pcs_pma_interface_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            if [expr { ($hssi_rx_pcs_pma_interface_rx_dyn_polarity_inversion=="rx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "rx_stat_polinv_dis" "rx_stat_polinv_en"]]
         }
      }
   }

   return $legal_values
}


