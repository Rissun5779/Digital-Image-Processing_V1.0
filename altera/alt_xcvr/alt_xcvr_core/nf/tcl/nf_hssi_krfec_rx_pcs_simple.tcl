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


proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_blksync_cor_en { device_revision hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "correct" "detect"]

   if [expr { (((($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode")) }] {
      set legal_values [intersect $legal_values [list "detect"]]
   } else {
      if [expr { (($hssi_krfec_rx_pcs_prot_mode=="basic_mode")&&($hssi_krfec_rx_pcs_sup_mode=="engineering_mode")) }] {
         set legal_values [intersect $legal_values [list "detect" "correct"]]
      } else {
         set legal_values [intersect $legal_values [list "detect"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_bypass_gb { device_revision hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "bypass_dis" "bypass_en"]

   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="basic_mode")&&($hssi_krfec_rx_pcs_sup_mode=="engineering_mode")) }] {
      set legal_values [intersect $legal_values [list "bypass_dis" "bypass_en"]]
   } else {
      set legal_values [intersect $legal_values [list "bypass_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_clr_ctrl { device_revision hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "both_enabled" "corr_cnt_only" "uncorr_cnt_only"]

   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "both_enabled"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_ctrl_bit_reverse { device_revision } {

   set legal_values [list "ctrl_bit_reverse_dis" "ctrl_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_data_bit_reverse { device_revision } {

   set legal_values [list "data_bit_reverse_dis" "data_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_dv_start { device_revision hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list "with_blklock" "with_blksync"]

   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_sup_mode=="user_mode")) }] {
      set legal_values [intersect $legal_values [list "with_blklock"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_err_mark_type { device_revision hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode } {

   set legal_values [list "err_mark_10g" "err_mark_40g"]

   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode") }] {
      set legal_values [intersect $legal_values [list "err_mark_10g"]]
   } else {
      if [expr { ($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode") }] {
         set legal_values [intersect $legal_values [list "err_mark_40g"]]
      } else {
         if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode") }] {
            set legal_values [intersect $legal_values [list "err_mark_10g"]]
         } else {
            if [expr { ($hssi_krfec_rx_pcs_prot_mode=="basic_mode") }] {
               if [expr { ($hssi_krfec_rx_pcs_error_marking_en=="err_mark_en") }] {
                  set legal_values [intersect $legal_values [list "err_mark_10g" "err_mark_40g"]]
               } else {
                  set legal_values [intersect $legal_values [list "err_mark_10g"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "err_mark_10g"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_error_marking_en { device_revision hssi_krfec_rx_pcs_prot_mode } {

   set legal_values [list "err_mark_dis" "err_mark_en"]

   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode") }] {
      set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
   } else {
      if [expr { ($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode") }] {
         set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
      } else {
         if [expr { ($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode") }] {
            set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
         } else {
            if [expr { ($hssi_krfec_rx_pcs_prot_mode=="basic_mode") }] {
               set legal_values [intersect $legal_values [list "err_mark_dis" "err_mark_en"]]
            } else {
               set legal_values [intersect $legal_values [list "err_mark_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_low_latency_en { device_revision hssi_krfec_rx_pcs_error_marking_en hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { (($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_error_marking_en=="err_mark_en")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { ((($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode")||($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode")) }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_lpbk_mode { device_revision hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en } {

   set legal_values [list "lpbk_dis" "lpbk_en"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en=="disable") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "lpbk_en"]]
   }
   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "lpbk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_parity_invalid_enum { device_revision hssi_krfec_rx_pcs_prot_mode hssi_krfec_rx_pcs_sup_mode } {

   set legal_values [list 0:255]

   if [expr { (((($hssi_krfec_rx_pcs_prot_mode=="disable_mode")||($hssi_krfec_rx_pcs_prot_mode=="teng_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="fortyg_basekr_mode"))||($hssi_krfec_rx_pcs_prot_mode=="teng_1588_basekr_mode")) }] {
      set legal_values [compare_eq $legal_values 8]
   } else {
      if [expr { (($hssi_krfec_rx_pcs_prot_mode=="basic_mode")&&($hssi_krfec_rx_pcs_sup_mode=="engineering_mode")) }] {
         set legal_values [compare_inside $legal_values [list 0 8 255]]
      } else {
         set legal_values [compare_eq $legal_values 8]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_parity_valid_num { device_revision } {

   set legal_values [list 0:15]

   set legal_values [compare_eq $legal_values 4]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_blksync { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_descrm { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_errcorrect { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_errtrap_ind { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_errtrap_lfsr { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_errtrap_loc { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_errtrap_pat { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_gearbox { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_syndrm { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_pipeln_trans_dec { device_revision hssi_krfec_rx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_rx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_prot_mode { device_revision hssi_krfec_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx } {

   set legal_values [list "basic_mode" "disable_mode" "fortyg_basekr_mode" "teng_1588_basekr_mode" "teng_basekr_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="teng_basekr_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_basekr_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="fortyg_basekr_mode_rx") }] {
      set legal_values [intersect $legal_values [list "fortyg_basekr_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="basic_mode_rx") }] {
      set legal_values [intersect $legal_values [list "basic_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="teng_1588_basekr_mode_rx") }] {
      set legal_values [intersect $legal_values [list "teng_1588_basekr_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable_mode"]]
   }
   if [expr { ($hssi_krfec_rx_pcs_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "disable_mode" "teng_basekr_mode" "fortyg_basekr_mode" "teng_1588_basekr_mode" "basic_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "disable_mode" "teng_basekr_mode" "fortyg_basekr_mode" "basic_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_receive_order { device_revision } {

   set legal_values [list "receive_lsb" "receive_msb"]

   set legal_values [intersect $legal_values [list "receive_lsb"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_rx_testbus_sel { device_revision hssi_krfec_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode } {

   set legal_values [list "blksync" "blksync_cntrs" "decoder_master_sm" "decoder_master_sm_cntrs" "decoder_rd_sm" "errtrap_ind1" "errtrap_ind2" "errtrap_ind3" "errtrap_ind4" "errtrap_ind5" "errtrap_loc" "errtrap_pat1" "errtrap_pat2" "errtrap_pat3" "errtrap_pat4" "errtrap_sm" "fast_search" "fast_search_cntrs" "gb_and_trans" "overall" "syndrm1" "syndrm2" "syndrm_sm"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode=="tx") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }
   if [expr { ($hssi_krfec_rx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_signal_ok_en { device_revision hssi_krfec_rx_pcs_lpbk_mode } {

   set legal_values [list "sig_ok_dis" "sig_ok_en"]

   if [expr { ($hssi_krfec_rx_pcs_lpbk_mode=="lpbk_en") }] {
      set legal_values [intersect $legal_values [list "sig_ok_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "sig_ok_en"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_rx_pcs_sup_mode { device_revision hssi_rx_pld_pcs_interface_hd_krfec_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

