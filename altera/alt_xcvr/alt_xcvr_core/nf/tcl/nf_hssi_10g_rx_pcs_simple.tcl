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


proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_advanced_user_mode { device_revision hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   set legal_values [intersect $legal_values [list "disable"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_align_del { device_revision hssi_10g_rx_pcs_control_del hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_ber_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_ber_xus_timer_window { device_revision hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list 0:2097151]

   if [expr { ($hssi_10g_rx_pcs_sup_mode=="user_mode") }] {
      set legal_values [compare_eq $legal_values 19530]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_10g_rx_pcs_bitslip_mode  $device_revision $hssi_10g_rx_pcs_blksync_bypass $hssi_10g_rx_pcs_gb_rx_idwidth $hssi_10g_rx_pcs_gb_rx_odwidth $hssi_10g_rx_pcs_prot_mode $hssi_10g_rx_pcs_rxfifo_mode $hssi_10g_rx_pcs_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_bitslip_type { device_revision hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_bitslip_wait_cnt { device_revision hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_bitslip_wait_type { device_revision hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_bypass { device_revision hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_clken { device_revision hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_enum_invalid_sh_cnt { device_revision } {

   set legal_values [list "enum_invalid_sh_cnt_10g"]

   set legal_values [intersect $legal_values [list "enum_invalid_sh_cnt_10g"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_knum_sh_cnt_postlock { device_revision } {

   set legal_values [list "knum_sh_cnt_postlock_10g"]

   set legal_values [intersect $legal_values [list "knum_sh_cnt_postlock_10g"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_knum_sh_cnt_prelock { device_revision } {

   set legal_values [list "knum_sh_cnt_prelock_10g"]

   set legal_values [intersect $legal_values [list "knum_sh_cnt_prelock_10g"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_blksync_pipeln { device_revision hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_clr_errblk_cnt_en { device_revision hssi_10g_rx_pcs_dec64b66b_clken } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_10g_rx_pcs_dec64b66b_clken=="dec64b66b_clk_en") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_control_del { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "control_del_all" "control_del_none"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "control_del_all" "control_del_none"]]
   } else {
      set legal_values [intersect $legal_values [list "control_del_none"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_crcchk_bypass { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_crcchk_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_crcchk_inv { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "crcchk_inv_dis" "crcchk_inv_en"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "crcchk_inv_en"]]
   } else {
      set legal_values [intersect $legal_values [list "crcchk_inv_en"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_crcchk_pipeln { device_revision hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_crcflag_pipeln { device_revision hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_ctrl_bit_reverse { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_data_bit_reverse { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_dec64b66b_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_descrm_bypass { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_descrm_clken { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_descrm_bypass hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_descrm_mode { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "async" "sync"]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "sync"]]
   } else {
      set legal_values [intersect $legal_values [list "async"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_descrm_pipeln { device_revision hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_dft_clk_out_sel { device_revision } {

   set legal_values [list "rx_64b66bdec_clk" "rx_ber_clk" "rx_blksync_clk" "rx_crcchk_clk" "rx_descrm_clk" "rx_fec_clk" "rx_frmsync_clk" "rx_gbexp_clk" "rx_master_clk" "rx_rand_clk" "rx_rdfifo_clk" "rx_wrfifo_clk"]

   set legal_values [intersect $legal_values [list "rx_master_clk"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_dis_signal_ok { device_revision hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_dispchk_bypass { device_revision hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_empty_flag_type { device_revision } {

   set legal_values [list "empty_rd_side" "empty_wr_side"]

   set legal_values [intersect $legal_values [list "empty_rd_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_fast_path { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_crcchk_bypass hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass hssi_10g_rx_pcs_descrm_bypass hssi_10g_rx_pcs_dispchk_bypass hssi_10g_rx_pcs_fec_enable hssi_10g_rx_pcs_frmsync_bypass } {

   set legal_values [list "fast_path_dis" "fast_path_en"]

   if [expr { ((((((($hssi_10g_rx_pcs_descrm_bypass=="descrm_bypass_en")&&($hssi_10g_rx_pcs_frmsync_bypass=="frmsync_bypass_en"))&&($hssi_10g_rx_pcs_crcchk_bypass=="crcchk_bypass_en"))&&($hssi_10g_rx_pcs_dec_64b66b_rxsm_bypass=="dec_64b66b_rxsm_bypass_en"))&&($hssi_10g_rx_pcs_dispchk_bypass=="dispchk_bypass_en"))&&($hssi_10g_rx_pcs_blksync_bypass=="blksync_bypass_en"))&&($hssi_10g_rx_pcs_fec_enable=="fec_dis")) }] {
      set legal_values [intersect $legal_values [list "fast_path_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fast_path_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_fec_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "fec_clk_dis" "fec_clk_en"]

   if [expr { (((($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "fec_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fec_clk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_fec_enable { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "fec_dis" "fec_en"]

   if [expr { (((($hssi_10g_rx_pcs_prot_mode=="teng_baser_krfec_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="basic_krfec_mode"))||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "fec_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fec_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_fifo_double_read { device_revision hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_fifo_stop_rd { device_revision hssi_10g_rx_pcs_fifo_double_read hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_fifo_stop_wr { device_revision } {

   set legal_values [list "n_wr_full" "wr_full"]

   set legal_values [intersect $legal_values [list "n_wr_full"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_force_align { device_revision hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

   set legal_values [list "force_align_dis" "force_align_en"]

   if [expr { (($hssi_10g_rx_pcs_prot_mode=="interlaken_mode")&&($hssi_10g_rx_pcs_sup_mode=="engineering_mode")) }] {
      set legal_values [intersect $legal_values [list "force_align_en" "force_align_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "force_align_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_frmsync_bypass { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_frmsync_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_frmsync_flag_type { device_revision } {

   set legal_values [list "all_framing_words" "location_only"]

   set legal_values [intersect $legal_values [list "location_only"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_frmsync_mfrm_length { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_10g_rx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [compare_ge $legal_values 5]
      set legal_values [compare_le $legal_values 65535]
   } else {
      set legal_values [compare_eq $legal_values 2048]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_frmsync_pipeln { device_revision hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_full_flag_type { device_revision } {

   set legal_values [list "full_rd_side" "full_wr_side"]

   set legal_values [intersect $legal_values [list "full_wr_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_gb_rx_idwidth { device_revision hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_gb_rx_odwidth { device_revision hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_gbexp_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_low_latency_en { device_revision hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_lpbk_mode { device_revision hssi_rx_pld_pcs_interface_hd_10g_lpbk_en } {

   set legal_values [list "lpbk_dis" "lpbk_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "lpbk_en"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_master_clk_sel { device_revision hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_pempty_flag_type { device_revision } {

   set legal_values [list "pempty_rd_side" "pempty_wr_side"]

   set legal_values [intersect $legal_values [list "pempty_rd_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_pfull_flag_type { device_revision } {

   set legal_values [list "pfull_rd_side" "pfull_wr_side"]

   set legal_values [intersect $legal_values [list "pfull_wr_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_phcomp_rd_del { device_revision hssi_10g_rx_pcs_fifo_stop_rd hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_pld_if_type { device_revision hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx } {

   set legal_values [list "fifo" "reg"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx=="reg_rx") }] {
      set legal_values [intersect $legal_values [list "reg"]]
   } else {
      set legal_values [intersect $legal_values [list "fifo"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_prot_mode { device_revision hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rand_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rd_clk_sel { device_revision hssi_10g_rx_pcs_master_clk_sel hssi_10g_rx_pcs_rxfifo_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rdfifo_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_fifo_write_ctrl { device_revision } {

   set legal_values [list "blklock_ignore" "blklock_stops"]

   set legal_values [intersect $legal_values [list "blklock_stops"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_scrm_width { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "bit64" "bit66" "bit67"]

   if [expr { ((($hssi_10g_rx_pcs_prot_mode=="interlaken_mode")||($hssi_10g_rx_pcs_prot_mode=="teng_baser_mode"))||($hssi_10g_rx_pcs_prot_mode=="teng_1588_mode")) }] {
      set legal_values [intersect $legal_values [list "bit64"]]
   } else {
      set legal_values [intersect $legal_values [list "bit64"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_sh_location { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_signal_ok_sel { device_revision hssi_10g_rx_pcs_lpbk_mode hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_sm_bypass { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_sm_hiber { device_revision hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_sm_pipeln { device_revision hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_testbus_sel { device_revision hssi_10g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rx_true_b2b { device_revision hssi_10g_rx_pcs_rxfifo_mode } {

   set legal_values [list "b2b" "single"]

   if [expr { ($hssi_10g_rx_pcs_rxfifo_mode=="clk_comp_10g") }] {
      set legal_values [intersect $legal_values [list "b2b" "single"]]
   } else {
      set legal_values [intersect $legal_values [list "b2b"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rxfifo_mode { device_revision hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_pld_if_type hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rxfifo_pempty { device_revision hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_rxfifo_pfull { device_revision hssi_10g_rx_pcs_low_latency_en hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_rxfifo_pempty hssi_10g_rx_pcs_sup_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_stretch_num_stages { device_revision hssi_10g_rx_pcs_fifo_double_read hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_sup_mode { device_revision hssi_rx_pld_pcs_interface_hd_10g_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_test_mode { device_revision hssi_10g_rx_pcs_prot_mode } {

   set legal_values [list "pseudo_random" "test_off"]

   if [expr { (($hssi_10g_rx_pcs_prot_mode=="test_prp_mode")||($hssi_10g_rx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "pseudo_random"]]
   } else {
      set legal_values [intersect $legal_values [list "test_off"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_rx_pcs_wrfifo_clken { device_revision hssi_10g_rx_pcs_prot_mode } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_rxfifo_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_10g_rx_pcs_bitslip_mode { device_revision hssi_10g_rx_pcs_blksync_bypass hssi_10g_rx_pcs_gb_rx_idwidth hssi_10g_rx_pcs_gb_rx_odwidth hssi_10g_rx_pcs_prot_mode hssi_10g_rx_pcs_sup_mode } {
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

   return $legal_values
}


