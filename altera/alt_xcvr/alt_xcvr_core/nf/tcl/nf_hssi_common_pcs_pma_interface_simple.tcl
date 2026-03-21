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


proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_asn_clk_enable { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_asn_enable { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "dis_asn" "en_asn"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_asn"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "dis_asn"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "en_asn" "dis_asn"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_block_sel { device_revision hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "eight_g_pcs" "pcie_gen3"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "pcie_gen3"]]
   } else {
      set legal_values [intersect $legal_values [list "eight_g_pcs"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_bypass_early_eios { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_bypass_pcie_switch { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_bypass_pma_ltr { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_bypass_pma_sw_done { device_revision hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { (($hssi_common_pcs_pma_interface_sup_mode=="user_mode")||($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode")) }] {
      set legal_values [intersect $legal_values [list "true" "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_bypass_ppm_lock { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3"))||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_bypass_send_syncp_fbkp { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3") }] {
            set legal_values [intersect $legal_values [list "true"]]
         } else {
            if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
               set legal_values [intersect $legal_values [list "true"]]
            }
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_bypass_txdetectrx { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_cdr_control { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "dis_cdr_ctrl" "en_cdr_ctrl"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_cdr_ctrl"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_cdr_ctrl"]]
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_cdr_ctrl" "en_cdr_ctrl"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_cid_enable { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "dis_cid_mode" "en_cid_mode"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
         set legal_values [intersect $legal_values [list "en_cid_mode"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="dis_cdr_ctrl") }] {
            set legal_values [intersect $legal_values [list "dis_cid_mode"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_cid_mode" "en_cid_mode"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_cp_cons_sel { device_revision hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "cp_cons_default" "cp_cons_master" "cp_cons_slave_abv" "cp_cons_slave_blw"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "cp_cons_master"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "cp_cons_master"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "cp_cons_master"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "cp_cons_slave_blw"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "cp_cons_slave_abv"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_cp_dwn_mstr { device_revision hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_cp_up_mstr { device_revision hssi_common_pcs_pma_interface_ctrl_plane_bonding hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "true"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }
   if [expr { ($hssi_common_pcs_pma_interface_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ctrl_plane_bonding { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding } {

   set legal_values [list "ctrl_master" "ctrl_slave_abv" "ctrl_slave_blw" "individual"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "individual"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "ctrl_master"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "ctrl_slave_abv"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "ctrl_slave_blw"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode hssi_common_pcs_pma_interface_data_mask_count_multi } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_data_mask_count_multi $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_common_pcs_pma_interface_data_mask_count  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi  $device_revision $hssi_common_pcs_pma_interface_cdr_control $hssi_common_pcs_pma_interface_pcie_hip_mode $hssi_common_pcs_pma_interface_sim_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_dft_observation_clock_selection { device_revision } {

   set legal_values [list "dft_clk_obsrv_asn0" "dft_clk_obsrv_asn1" "dft_clk_obsrv_clklow" "dft_clk_obsrv_fref" "dft_clk_obsrv_hclk" "dft_clk_obsrv_rx" "dft_clk_obsrv_tx0" "dft_clk_obsrv_tx1" "dft_clk_obsrv_tx2" "dft_clk_obsrv_tx3" "dft_clk_obsrv_tx4"]

   set legal_values [intersect $legal_values [list "dft_clk_obsrv_tx0"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_early_eios_counter { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:255]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 50]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 50]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_force_freqdet { device_revision hssi_common_pcs_pma_interface_ppm_det_buckets } {

   set legal_values [list "force0_freqdet_en" "force1_freqdet_en" "force_freqdet_dis"]

   if [expr { ($hssi_common_pcs_pma_interface_ppm_det_buckets=="disable_prot") }] {
      set legal_values [intersect $legal_values [list "force1_freqdet_en"]]
   } else {
      set legal_values [intersect $legal_values [list "force_freqdet_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_free_run_clk_enable { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode")||($hssi_common_pcs_pma_interface_prot_mode=="other_protocols")) }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "true" "false"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ignore_sigdet_g23 { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "false"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [intersect $legal_values [list "false"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_pc_en_counter { device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:127]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 55]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 55]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_pc_rst_counter { device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 23]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 23]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_pcie_hip_mode { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "hip_disable" "hip_enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "hip_disable"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx") }] {
         set legal_values [intersect $legal_values [list "hip_disable"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx") }] {
            set legal_values [intersect $legal_values [list "hip_enable"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx") }] {
               set legal_values [intersect $legal_values [list "hip_disable"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx") }] {
                  set legal_values [intersect $legal_values [list "hip_enable"]]
               } else {
                  set legal_values [intersect $legal_values [list "hip_disable"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ph_fifo_reg_mode { device_revision hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "phfifo_reg_mode_dis" "phfifo_reg_mode_en"]

   if [expr { ((($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3"))&&($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable")) }] {
      set legal_values [intersect $legal_values [list "phfifo_reg_mode_en"]]
   } else {
      set legal_values [intersect $legal_values [list "phfifo_reg_mode_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_phfifo_flush_wait { device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:63]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 36]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 36]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_pipe_if_g3pcs { device_revision hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "pipe_if_8gpcs" "pipe_if_g3pcs"]

   if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")||($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable")) }] {
      set legal_values [intersect $legal_values [list "pipe_if_g3pcs"]]
   } else {
      set legal_values [intersect $legal_values [list "pipe_if_8gpcs"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_pma_done_counter { device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:262143]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 200]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 175000]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_pma_if_dft_en { device_revision } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_pma_if_dft_val { device_revision } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ppm_cnt_rst { device_revision } {

   set legal_values [list "ppm_cnt_rst_dis" "ppm_cnt_rst_en"]

   set legal_values [intersect $legal_values [list "ppm_cnt_rst_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ppm_deassert_early { device_revision hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "deassert_early_dis" "deassert_early_en"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "deassert_early_en"]]
   } else {
      set legal_values [intersect $legal_values [list "deassert_early_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ppm_det_buckets { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx } {

   set legal_values [list "disable_prot" "ppm_100_bucket" "ppm_300_100_bucket" "ppm_300_bucket"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable_prot"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="pcs_direct_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_only_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_krfec_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_sfis_sdi_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="prbs_mode_rx") }] {
      set legal_values [intersect $legal_values [list "ppm_300_100_bucket"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ppm_gen1_2_cnt { device_revision hssi_common_pcs_pma_interface_prot_mode hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "cnt_32k" "cnt_64k"]

   if [expr { (($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode")&&($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")) }] {
      set legal_values [intersect $legal_values [list "cnt_32k" "cnt_64k"]]
   } else {
      set legal_values [intersect $legal_values [list "cnt_32k"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ppm_post_eidle_delay { device_revision hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "cnt_200_cycles" "cnt_400_cycles"]

   if [expr { (($hssi_common_pcs_pma_interface_prot_mode=="pipe_g12")||($hssi_common_pcs_pma_interface_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "cnt_200_cycles" "cnt_400_cycles"]]
   } else {
      set legal_values [intersect $legal_values [list "cnt_200_cycles"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_ppmsel { device_revision hssi_common_pcs_pma_interface_ppm_det_buckets hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "ppmsel_100" "ppmsel_1000" "ppmsel_125" "ppmsel_200" "ppmsel_250" "ppmsel_2500" "ppmsel_300" "ppmsel_500" "ppmsel_5000" "ppmsel_62p5" "ppmsel_disable" "ppm_other"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_ppm_det_buckets=="disable_prot") }] {
         set legal_values [intersect $legal_values [list "ppm_other"]]
      } else {
         set legal_values [intersect $legal_values [list "ppmsel_100" "ppmsel_300" "ppmsel_500" "ppmsel_1000" "ppmsel_5000"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "ppm_other" "ppmsel_62p5" "ppmsel_100" "ppmsel_125" "ppmsel_200" "ppmsel_250" "ppmsel_300" "ppmsel_500" "ppmsel_1000" "ppmsel_2500" "ppmsel_5000"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_prot_mode { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "disable_prot_mode" "other_protocols" "pipe_g12" "pipe_g3"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disable_prot_mode"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx") }] {
         set legal_values [intersect $legal_values [list "pipe_g12"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx") }] {
            set legal_values [intersect $legal_values [list "pipe_g12"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx") }] {
               set legal_values [intersect $legal_values [list "pipe_g3"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx") }] {
                  set legal_values [intersect $legal_values [list "pipe_g3"]]
               } else {
                  set legal_values [intersect $legal_values [list "other_protocols"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_rxvalid_mask { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sup_mode } {

   set legal_values [list "rxvalid_mask_dis" "rxvalid_mask_en"]

   if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="user_mode") }] {
      if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
         set legal_values [intersect $legal_values [list "rxvalid_mask_en"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="dis_cdr_ctrl") }] {
            set legal_values [intersect $legal_values [list "rxvalid_mask_dis"]]
         }
      }
   } else {
      if [expr { ($hssi_common_pcs_pma_interface_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "rxvalid_mask_dis" "rxvalid_mask_en"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_sigdet_wait_counter { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:4095]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 200]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_sigdet_wait_counter_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_sim_mode { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_spd_chg_rst_wait_cnt_en { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list "false" "true"]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "true"]]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [intersect $legal_values [list "true"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "false"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_sup_mode { device_revision hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_testout_sel { device_revision hssi_common_pcs_pma_interface_prot_mode } {

   set legal_values [list "asn_test" "pma_pll_test" "ppm_det_test" "prbs_gen_test" "prbs_ver_test" "rxpmaif_test" "uhsif_1_test" "uhsif_2_test" "uhsif_3_test"]

   if [expr { ($hssi_common_pcs_pma_interface_prot_mode=="disable_prot_mode") }] {
      set legal_values [intersect $legal_values [list "ppm_det_test"]]
   } else {
      set legal_values [intersect $legal_values [list "ppm_det_test" "asn_test" "pma_pll_test" "rxpmaif_test" "prbs_gen_test" "prbs_ver_test" "uhsif_1_test" "uhsif_2_test" "uhsif_3_test"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_wait_clk_on_off_timer { device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:15]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 0]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_wait_pipe_synchronizing { device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:31]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 23]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 23]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_common_pcs_pma_interface_wait_send_syncp_fbkp { device_revision hssi_common_pcs_pma_interface_asn_enable hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:2047]

   if [expr { ($hssi_common_pcs_pma_interface_asn_enable=="en_asn") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 125]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 250]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               set legal_values [compare_eq $legal_values 58334]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_pcie_hip_mode hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            if [expr { ($hssi_common_pcs_pma_interface_pcie_hip_mode=="hip_enable") }] {
               set legal_values [compare_eq $legal_values 1]
            } else {
               set legal_values [compare_eq $legal_values 3]
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_data_mask_count_multi hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_inside $legal_values [list 2500 58334]]
            if [expr { ($hssi_common_pcs_pma_interface_data_mask_count_multi==1) }] {
               set legal_values [compare_eq $legal_values 2500]
            } else {
               if [expr { ($hssi_common_pcs_pma_interface_data_mask_count_multi==3) }] {
                  set legal_values [compare_eq $legal_values 58334]
               }
            }
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_inside $legal_values [list 1 3]]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_common_pcs_pma_interface_data_mask_count { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 100]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 2500]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_common_pcs_pma_interface_data_mask_count_multi { device_revision hssi_common_pcs_pma_interface_cdr_control hssi_common_pcs_pma_interface_sim_mode } {

   set legal_values [list 0:7]

   if [expr { ($hssi_common_pcs_pma_interface_cdr_control=="en_cdr_ctrl") }] {
      if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="enable") }] {
         set legal_values [compare_eq $legal_values 1]
      } else {
         if [expr { ($hssi_common_pcs_pma_interface_sim_mode=="disable") }] {
            set legal_values [compare_eq $legal_values 1]
         }
      }
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}


