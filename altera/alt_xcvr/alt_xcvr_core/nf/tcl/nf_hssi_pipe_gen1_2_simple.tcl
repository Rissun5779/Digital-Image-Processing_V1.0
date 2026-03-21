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


proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_elec_idle_delay_val { device_revision hssi_pipe_gen1_2_prot_mode } {

   set legal_values [list 0:7]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_eq $legal_values 3]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_error_replace_pad { device_revision } {

   set legal_values [list "replace_edb" "replace_pad"]

   set legal_values [intersect $legal_values [list "replace_edb"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_hip_mode { device_revision hssi_pipe_gen1_2_prot_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_ind_error_reporting { device_revision hssi_pipe_gen1_2_rx_pipe_enable } {

   set legal_values [list "dis_ind_error_reporting" "en_ind_error_reporting"]

   if [expr { ($hssi_pipe_gen1_2_rx_pipe_enable=="en_pipe_rx") }] {
      set legal_values [intersect $legal_values [list "en_ind_error_reporting" "dis_ind_error_reporting"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_ind_error_reporting"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_phystatus_delay_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:7]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_phystatus_rst_toggle { device_revision } {

   set legal_values [list "dis_phystatus_rst_toggle" "en_phystatus_rst_toggle"]

   set legal_values [intersect $legal_values [list "dis_phystatus_rst_toggle"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_pipe_byte_de_serializer_en { device_revision hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_pipe_if_enable hssi_pipe_gen1_2_rx_pipe_enable } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_prot_mode { device_revision hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rpre_emph_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rpre_emph_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rpre_emph_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rpre_emph_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rpre_emph_e_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 6]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_a_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_b_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_c_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_d_val  $device_revision $hssi_pipe_gen1_2_prot_mode $hssi_pipe_gen1_2_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rvod_sel_e_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rx_pipe_enable { device_revision hssi_pipe_gen1_2_hip_mode hssi_pipe_gen1_2_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_rxdetect_bypass { device_revision hssi_pipe_gen1_2_rx_pipe_enable hssi_pipe_gen1_2_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_sup_mode { device_revision hssi_rx_pld_pcs_interface_hd_8g_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "engineering_mode"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_tx_pipe_enable { device_revision hssi_pipe_gen1_2_hip_mode hssi_pipe_gen1_2_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_pipe_gen1_2_txswing { device_revision hssi_pipe_gen1_2_rx_pipe_enable } {

   set legal_values [list "dis_txswing" "en_txswing"]

   if [expr { ($hssi_pipe_gen1_2_rx_pipe_enable=="en_pipe_rx") }] {
      set legal_values [intersect $legal_values [list "en_txswing" "dis_txswing"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_txswing"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 60]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 45]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 12]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 24]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 60]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 45]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 50]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rpre_emph_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rpre_emph_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rpre_emph_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 10]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_a_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_b_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_c_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_pipe_gen1_2_rvod_sel_d_val { device_revision hssi_pipe_gen1_2_prot_mode hssi_pipe_gen1_2_sup_mode } {

   set legal_values [list 0:63]

   if [expr { ((($hssi_pipe_gen1_2_prot_mode!="pipe_g1")&&($hssi_pipe_gen1_2_prot_mode!="pipe_g2"))&&($hssi_pipe_gen1_2_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_pipe_gen1_2_sup_mode=="user_mode") }] {
         set legal_values [compare_eq $legal_values 31]
      }
   }

   return $legal_values
}


