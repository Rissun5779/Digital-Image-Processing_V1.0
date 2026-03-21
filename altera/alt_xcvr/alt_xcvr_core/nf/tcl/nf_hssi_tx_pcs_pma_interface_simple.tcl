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


proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_bypass_pma_txelecidle { device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="other_prot_mode")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_channel_operation_mode { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_lpbk_en { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_master_clk_sel { device_revision hssi_tx_pcs_pma_interface_sup_mode } {

   set legal_values [list "master_refclk_dig" "master_tx_pma_clk"]

   if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "master_tx_pma_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "master_tx_pma_clk" "master_refclk_dig"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "other_prot_mode" "pipe_g12" "pipe_g3"]

   if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "pipe_g12"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "pipe_g3"]]
      } else {
         set legal_values [intersect $legal_values [list "other_prot_mode"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_pldif_datawidth_mode { device_revision hssi_tx_pcs_pma_interface_pma_dw_tx hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "pldif_data_10bit" "pldif_data_8bit"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="pcs_direct_mode_tx") }] {
      if [expr { (((($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_8b_tx")||($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pcs_pma_interface_pma_dw_tx=="pma_20b_tx")) }] {
         set legal_values [intersect $legal_values [list "pldif_data_8bit"]]
      } else {
         set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "pldif_data_10bit"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_8b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_8b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_10b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_10b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_16b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_16b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_20b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_20b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_32b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_32b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_40b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_40b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pma_64b_tx") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx=="pcie_g3_dyn_dw_tx") }] {
      set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_pma_if_dft_en { device_revision } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_pmagate_en { device_revision hssi_tx_pcs_pma_interface_lpbk_en hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "pmagate_dis" "pmagate_en"]

   if [expr { (($hssi_tx_pcs_pma_interface_lpbk_en=="enable")&&((($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_krfec_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_basic_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_sfis_sdi_mode_tx"))) }] {
      set legal_values [intersect $legal_values [list "pmagate_dis" "pmagate_en"]]
   } else {
      set legal_values [intersect $legal_values [list "pmagate_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_prbs9_dwidth { device_revision hssi_tx_pcs_pma_interface_prbs_gen_pat } {

   set legal_values [list "prbs9_10b" "prbs9_64b"]

   if [expr { ($hssi_tx_pcs_pma_interface_prbs_gen_pat=="prbs_9") }] {
      set legal_values [intersect $legal_values [list "prbs9_64b" "prbs9_10b"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs9_64b"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_prbs_clken { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "prbs_clk_dis" "prbs_clk_en"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="prbs_mode_tx") }] {
      set legal_values [intersect $legal_values [list "prbs_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_clk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_prbs_gen_pat { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "prbs_15" "prbs_23" "prbs_31" "prbs_7" "prbs_9" "prbs_gen_dis"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="prbs_mode_tx") }] {
      set legal_values [intersect $legal_values [list "prbs_31" "prbs_23" "prbs_15" "prbs_9" "prbs_7"]]
   } else {
      set legal_values [intersect $legal_values [list "prbs_gen_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "disabled_prot_mode_tx" "eightg_basic_mode_tx" "eightg_g3_pcie_g3_hip_mode_tx" "eightg_g3_pcie_g3_pld_mode_tx" "eightg_only_pld_mode_tx" "eightg_pcie_g12_hip_mode_tx" "eightg_pcie_g12_pld_mode_tx" "pcs_direct_mode_tx" "prbs_mode_tx" "sqwave_mode_tx" "teng_basic_mode_tx" "teng_krfec_mode_tx" "teng_sfis_sdi_mode_tx" "uhsif_direct_mode_tx" "uhsif_reg_mode_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="pcs_direct_mode_tx") }] {
      set legal_values [intersect $legal_values [list "pcs_direct_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_reg_mode_tx") }] {
      set legal_values [intersect $legal_values [list "uhsif_reg_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_direct_mode_tx") }] {
      set legal_values [intersect $legal_values [list "uhsif_direct_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_only_pld_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_only_pld_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_pld_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_hip_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_krfec_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_basic_mode_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_basic_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_basic_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_basic_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_sfis_sdi_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="prbs_mode_tx") }] {
      set legal_values [intersect $legal_values [list "prbs_mode_tx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="sqwave_mode_tx") }] {
      set legal_values [intersect $legal_values [list "sqwave_mode_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_sq_wave_num { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "sq_wave_1" "sq_wave_4" "sq_wave_6" "sq_wave_8" "sq_wave_default"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="sqwave_mode_tx") }] {
      set legal_values [intersect $legal_values [list "sq_wave_1" "sq_wave_4" "sq_wave_6" "sq_wave_8"]]
   } else {
      set legal_values [intersect $legal_values [list "sq_wave_default"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_sqwgen_clken { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "sqwgen_clk_dis" "sqwgen_clk_en"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="sqwave_mode_tx") }] {
      set legal_values [intersect $legal_values [list "sqwgen_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "sqwgen_clk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_tx_pma_data_sel { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "block_sel_default" "directed_uhsif_dat" "eight_g_pcs" "pcie_gen3" "pld_dir" "prbs_pat" "registered_uhsif_dat" "sq_wave_pat" "ten_g_pcs"]

   if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="pcs_direct_mode_tx") }] {
      set legal_values [intersect $legal_values [list "pld_dir"]]
   } else {
      if [expr { (((($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "eight_g_pcs"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "pcie_gen3"]]
         } else {
            if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_krfec_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_basic_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="teng_sfis_sdi_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "ten_g_pcs"]]
            } else {
               if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="prbs_mode_tx") }] {
                  set legal_values [intersect $legal_values [list "prbs_pat"]]
               } else {
                  if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="sqwave_mode_tx") }] {
                     set legal_values [intersect $legal_values [list "sq_wave_pat"]]
                  } else {
                     if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx") }] {
                        set legal_values [intersect $legal_values [list "registered_uhsif_dat"]]
                     } else {
                        if [expr { ($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx") }] {
                           set legal_values [intersect $legal_values [list "directed_uhsif_dat"]]
                        } else {
                           set legal_values [intersect $legal_values [list "pld_dir"]]
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

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion  $device_revision $hssi_tx_pcs_pma_interface_prot_mode_tx $hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion $hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_cnt_step_filt_before_lock { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_filt_stepsz_b4lock_2" "uhsif_filt_stepsz_b4lock_4" "uhsif_filt_stepsz_b4lock_6" "uhsif_filt_stepsz_b4lock_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_filt_stepsz_b4lock_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_filt_stepsz_b4lock_2" "uhsif_filt_stepsz_b4lock_4" "uhsif_filt_stepsz_b4lock_6" "uhsif_filt_stepsz_b4lock_8"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_filt_stepsz_b4lock_2"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_after_lock_value { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 11]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_cnt_thresh_filt_before_lock { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_filt_cntthr_b4lock_16" "uhsif_filt_cntthr_b4lock_24" "uhsif_filt_cntthr_b4lock_32" "uhsif_filt_cntthr_b4lock_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_filt_cntthr_b4lock_16"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_filt_cntthr_b4lock_8" "uhsif_filt_cntthr_b4lock_16" "uhsif_filt_cntthr_b4lock_24" "uhsif_filt_cntthr_b4lock_32"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_filt_cntthr_b4lock_8"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dcn_test_update_period { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dcn_test_period_12" "uhsif_dcn_test_period_16" "uhsif_dcn_test_period_4" "uhsif_dcn_test_period_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dcn_test_period_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dcn_test_period_4" "uhsif_dcn_test_period_8" "uhsif_dcn_test_period_12" "uhsif_dcn_test_period_16"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dcn_test_period_4"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dcn_testmode_enable { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dcn_test_mode_disable" "uhsif_dcn_test_mode_enable"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dcn_test_mode_disable"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dcn_test_mode_enable" "uhsif_dcn_test_mode_disable"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dcn_test_mode_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dead_zone_count_thresh { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_cnt_thr_2" "uhsif_dzt_cnt_thr_4" "uhsif_dzt_cnt_thr_6" "uhsif_dzt_cnt_thr_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_cnt_thr_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_cnt_thr_2" "uhsif_dzt_cnt_thr_4" "uhsif_dzt_cnt_thr_6" "uhsif_dzt_cnt_thr_8"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_cnt_thr_2"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dead_zone_detection_enable { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_disable" "uhsif_dzt_enable"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_enable"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_enable" "uhsif_dzt_disable"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dead_zone_obser_window { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_obr_win_16" "uhsif_dzt_obr_win_32" "uhsif_dzt_obr_win_48" "uhsif_dzt_obr_win_64"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_obr_win_32"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_obr_win_16" "uhsif_dzt_obr_win_32" "uhsif_dzt_obr_win_48" "uhsif_dzt_obr_win_64"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_obr_win_16"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dead_zone_skip_size { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dzt_skipsz_12" "uhsif_dzt_skipsz_16" "uhsif_dzt_skipsz_4" "uhsif_dzt_skipsz_8"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dzt_skipsz_8"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dzt_skipsz_4" "uhsif_dzt_skipsz_8" "uhsif_dzt_skipsz_12" "uhsif_dzt_skipsz_16"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dzt_skipsz_4"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_delay_cell_index_sel { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_index_cram" "uhsif_index_internal"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_index_internal"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_index_internal" "uhsif_index_cram"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_index_cram"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_delay_cell_margin { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dcn_margin_2" "uhsif_dcn_margin_3" "uhsif_dcn_margin_4" "uhsif_dcn_margin_5"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dcn_margin_4"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dcn_margin_2" "uhsif_dcn_margin_3" "uhsif_dcn_margin_4" "uhsif_dcn_margin_5"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dcn_margin_2"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_delay_cell_static_index_value { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:255]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 128]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dft_dead_zone_control { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dft_dz_det_val_0" "uhsif_dft_dz_det_val_1"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dft_dz_det_val_0"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dft_dz_det_val_0" "uhsif_dft_dz_det_val_1"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dft_dz_det_val_0"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_dft_up_filt_control { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_dft_up_val_0" "uhsif_dft_up_val_1"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_dft_up_val_0"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_dft_up_val_0" "uhsif_dft_up_val_1"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_dft_up_val_0"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_enable { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx } {

   set legal_values [list "uhsif_disable" "uhsif_enable"]

   if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "uhsif_enable"]]
   } else {
      set legal_values [intersect $legal_values [list "uhsif_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_after_lock { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_lkd_segsz_aflock_1024" "uhsif_lkd_segsz_aflock_2048" "uhsif_lkd_segsz_aflock_4096" "uhsif_lkd_segsz_aflock_512"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_aflock_2048"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_aflock_512" "uhsif_lkd_segsz_aflock_1024" "uhsif_lkd_segsz_aflock_2048" "uhsif_lkd_segsz_aflock_4096"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_aflock_512"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_lock_det_segsz_before_lock { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list "uhsif_lkd_segsz_b4lock_128" "uhsif_lkd_segsz_b4lock_16" "uhsif_lkd_segsz_b4lock_32" "uhsif_lkd_segsz_b4lock_64"]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_b4lock_32"]]
      } else {
         if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_b4lock_16" "uhsif_lkd_segsz_b4lock_32" "uhsif_lkd_segsz_b4lock_64" "uhsif_lkd_segsz_b4lock_128"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "uhsif_lkd_segsz_b4lock_16"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_after_lock_value { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_cnt_before_lock_value { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_after_lock_value { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 3]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pcs_pma_interface_uhsif_lock_det_thresh_diff_before_lock_value { device_revision hssi_tx_pcs_pma_interface_sup_mode hssi_tx_pcs_pma_interface_uhsif_enable } {

   set legal_values [list 0:15]

   if [expr { ($hssi_tx_pcs_pma_interface_uhsif_enable=="uhsif_enable") }] {
      if [expr { ($hssi_tx_pcs_pma_interface_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 3]
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis" "tx_dyn_polinv_en"]]
         } else {
            set legal_values [intersect $legal_values [list "tx_dyn_polinv_dis"]]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pcs_pma_interface_tx_static_polarity_inversion { device_revision hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx hssi_tx_pcs_pma_interface_prot_mode_tx hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en } {

   set legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   }
   if [expr { ((($hssi_tx_pcs_pma_interface_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_reg_mode_tx"))||($hssi_tx_pcs_pma_interface_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
   } else {
      if [expr { (($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g12")||($hssi_tx_pcs_pma_interface_pcie_sub_prot_mode_tx=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
      } else {
         if [expr { (($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pcs_pma_interface_prot_mode_tx=="eightg_basic_mode_tx")) }] {
            if [expr { ($hssi_tx_pcs_pma_interface_tx_dyn_polarity_inversion=="tx_dyn_polinv_en") }] {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
            }
         } else {
            set legal_values [intersect $legal_values [list "tx_stat_polinv_dis" "tx_stat_polinv_en"]]
         }
      }
   }

   return $legal_values
}


