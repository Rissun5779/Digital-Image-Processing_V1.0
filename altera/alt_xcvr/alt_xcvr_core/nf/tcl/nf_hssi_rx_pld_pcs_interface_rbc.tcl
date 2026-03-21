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


proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx } {

   set legal_values [list "disable" "enable"]

   set legal_values [intersect $legal_values [list "disable"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx $hssi_rx_pld_pcs_interface_hd_10g_advanced_user_mode_rx $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode $hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_rx hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx } {

   set legal_values [list "ctrl_master_rx" "ctrl_slave_abv_rx" "ctrl_slave_blw_rx" "individual_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx!="disabled_prot_mode_rx") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="individual_rx") }] {
         set legal_values [intersect $legal_values [list "individual_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="ctrl_master_rx") }] {
         set legal_values [intersect $legal_values [list "ctrl_master_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="ctrl_slave_abv_rx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_abv_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="ctrl_slave_blw_rx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_blw_rx"]]
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode=="tx_rx_pair_enabled") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="individual_tx") }] {
         set legal_values [intersect $legal_values [list "individual_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_master_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_abv_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_blw_rx"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "individual_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_rx $hssi_rx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_rx $legal_values { hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx } {

   set legal_values [list "fifo_rx" "reg_rx"]

   if [expr { (((((((($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="disabled_prot_mode_rx")||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="interlaken_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="sfis_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_sdi_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="test_prp_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_krfec_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="test_prp_krfec_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "fifo_rx"]]
   } else {
      if [expr { (($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_1588_mode_rx")||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_1588_krfec_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "reg_rx"]]
      } else {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_mode_rx")||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_krfec_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "fifo_rx" "reg_rx"]]
         } else {
            set legal_values [intersect $legal_values [list "fifo_rx"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx")) }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   } else {
      if [expr { !(($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx")) }] {
         if [expr { ((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx")) }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
               set legal_values [intersect $legal_values [list "enable"]]
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         }
      }
   }
   if [expr { ((((($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_mode_rx")||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="interlaken_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_krfec_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_krfec_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_10g_low_latency_en_rx $legal_values { hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_lpbk_en hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx!="disabled_prot_mode_rx") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx!="disabled_prot_mode_rx") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_lpbk_en $hssi_rx_pld_pcs_interface_hd_10g_lpbk_en $legal_values { hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx } {

   set legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { (((((($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_mode_rx")||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="interlaken_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="sfis_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_1588_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="test_prp_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_sdi_mode_rx") }] {
            set legal_values [intersect $legal_values [list "pma_40b_rx"]]
         } else {
            if [expr { (((($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_baser_krfec_mode_rx")||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="teng_1588_krfec_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_krfec_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="test_prp_krfec_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "pma_64b_rx"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_10g_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "basic_krfec_mode_rx" "basic_mode_rx" "disabled_prot_mode_rx" "interlaken_mode_rx" "sfis_mode_rx" "teng_1588_krfec_mode_rx" "teng_1588_mode_rx" "teng_baser_krfec_mode_rx" "teng_baser_mode_rx" "teng_sdi_mode_rx" "test_prp_krfec_mode_rx" "test_prp_mode_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
            set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
               set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                  set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
                     set legal_values [intersect $legal_values [list "teng_baser_mode_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
                        set legal_values [intersect $legal_values [list "teng_baser_krfec_mode_rx"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
                           set legal_values [intersect $legal_values [list "basic_krfec_mode_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
                              set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
                                 set legal_values [intersect $legal_values [list "interlaken_mode_rx"]]
                              } else {
                                 if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
                                    set legal_values [intersect $legal_values [list "sfis_mode_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                                       set legal_values [intersect $legal_values [list "teng_sdi_mode_rx"]]
                                    } else {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
                                          set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                       } else {
                                          if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                             set legal_values [intersect $legal_values [list "teng_1588_mode_rx"]]
                                          } else {
                                             if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
                                                set legal_values [intersect $legal_values [list "teng_1588_krfec_mode_rx"]]
                                             } else {
                                                if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                                                   set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                } else {
                                                   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
                                                      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                   } else {
                                                      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
                                                         set legal_values [intersect $legal_values [list "basic_mode_rx"]]
                                                      } else {
                                                         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
                                                            set legal_values [intersect $legal_values [list "basic_krfec_mode_rx"]]
                                                         } else {
                                                            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_1588_mode_rx"]]
                                                               } else {
                                                                  set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                               }
                                                            } else {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
                                                                  set legal_values [intersect $legal_values [list "test_prp_mode_rx"]]
                                                               } else {
                                                                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
                                                                     set legal_values [intersect $legal_values [list "test_prp_krfec_mode_rx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
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
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx" "teng_baser_mode_rx" "interlaken_mode_rx" "sfis_mode_rx" "teng_sdi_mode_rx" "basic_mode_rx" "test_prp_mode_rx" "test_prp_krfec_mode_rx" "teng_1588_mode_rx" "teng_baser_krfec_mode_rx" "teng_1588_krfec_mode_rx" "basic_krfec_mode_rx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_baser_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_1588_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="interlaken_mode_tx") }] {
         set legal_values [intersect $legal_values [list "interlaken_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="sfis_mode_tx") }] {
         set legal_values [intersect $legal_values [list "sfis_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_sdi_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_sdi_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_mode_tx") }] {
         set legal_values [intersect $legal_values [list "basic_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_mode_tx") }] {
         set legal_values [intersect $legal_values [list "test_prp_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_krfec_mode_tx") }] {
         set legal_values [intersect $legal_values [list "test_prp_krfec_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_krfec_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_baser_krfec_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_krfec_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_1588_krfec_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_krfec_mode_tx") }] {
         set legal_values [intersect $legal_values [list "basic_krfec_mode_rx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_10g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx } {

   set legal_values [list "double_rx" "single_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx!="disabled_prot_mode_rx") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx=="single_rx") }] {
         set legal_values [intersect $legal_values [list "single_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx=="double_rx") }] {
         set legal_values [intersect $legal_values [list "double_rx"]]
      }
   }
   if [expr { ((($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_mode_rx")||($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="basic_krfec_mode_rx"))&&($hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx=="fifo_rx")) }] {
      set legal_values [intersect $legal_values [list "single_rx" "double_rx"]]
   } else {
      set legal_values [intersect $legal_values [list "single_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx $hssi_rx_pld_pcs_interface_hd_10g_shared_fifo_width_rx $legal_values { hssi_rx_pld_pcs_interface_hd_10g_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_sup_mode $hssi_rx_pld_pcs_interface_hd_10g_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "rx" "tx"]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx")&&($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="disabled_prot_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "rx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx") }] {
         set legal_values [intersect $legal_values [list "rx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode $hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode $legal_values { hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode $hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx } {

   set legal_values [list "ctrl_master_rx" "ctrl_slave_abv_rx" "ctrl_slave_blw_rx" "individual_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx!="disabled_prot_mode_rx") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="individual_rx") }] {
         set legal_values [intersect $legal_values [list "individual_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="ctrl_master_rx") }] {
         set legal_values [intersect $legal_values [list "ctrl_master_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="ctrl_slave_abv_rx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_abv_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx=="ctrl_slave_blw_rx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_blw_rx"]]
      }
   }
   if [expr { ((($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g1_tx")||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g2_tx"))||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g3_tx")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="individual_tx") }] {
         set legal_values [intersect $legal_values [list "individual_rx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
            set legal_values [intersect $legal_values [list "ctrl_master_rx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
               set legal_values [intersect $legal_values [list "ctrl_slave_abv_rx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
                  set legal_values [intersect $legal_values [list "ctrl_slave_blw_rx"]]
               }
            }
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "individual_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx $hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx $legal_values { hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx } {

   set legal_values [list "fifo_rx" "reg_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "fifo_rx"]]
   } else {
      if [expr { ((($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g1_rx")||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g2_rx"))||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g3_rx")) }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_hip_mode=="enable") }] {
            set legal_values [intersect $legal_values [list "reg_rx"]]
         } else {
            set legal_values [intersect $legal_values [list "fifo_rx"]]
         }
      } else {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx")||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx_tx_rx")) }] {
            set legal_values [intersect $legal_values [list "reg_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="gige_rx") }] {
               set legal_values [intersect $legal_values [list "fifo_rx"]]
            } else {
               if [expr { ((($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_enable_rx")||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_disable_rx"))||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="gige_1588_rx")) }] {
                  set legal_values [intersect $legal_values [list "fifo_rx" "reg_rx"]]
               } else {
                  set legal_values [intersect $legal_values [list "fifo_rx"]]
               }
            }
         }
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode=="tx_rx_pair_enabled") }] {
      if [expr { ((($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_enable_rx")||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_disable_rx"))||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="gige_1588_rx")) }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fifo_tx") }] {
            set legal_values [intersect $legal_values [list "fifo_rx"]]
         } else {
            set legal_values [intersect $legal_values [list "reg_rx"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_hip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_hip_mode hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx!="disabled_prot_mode_tx") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="disable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }
   if [expr { ((($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g1_tx")||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g2_tx"))||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g3_tx")) }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_hip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_hip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_hip_mode $hssi_rx_pld_pcs_interface_hd_8g_hip_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_lpbk_en hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx!="disabled_prot_mode_rx") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx!="disabled_prot_mode_rx") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_lpbk_en $hssi_rx_pld_pcs_interface_hd_8g_lpbk_en $legal_values { hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx } {

   set legal_values [list "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_8b_rx"]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_enable_rx")||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_disable_rx")) }] {
      set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
   } else {
      if [expr { (($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx")||($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx_tx_rx")) }] {
         set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
      } else {
         set legal_values [intersect $legal_values [list "pma_10b_rx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx } {

   set legal_values [list "basic_rm_disable_rx" "basic_rm_enable_rx" "cpri_rx" "cpri_rx_tx_rx" "disabled_prot_mode_rx" "gige_1588_rx" "gige_rx" "pipe_g1_rx" "pipe_g2_rx" "pipe_g3_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [intersect $legal_values [list "pipe_g1_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
            set legal_values [intersect $legal_values [list "pipe_g2_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
               set legal_values [intersect $legal_values [list "pipe_g3_rx"]]
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                  set legal_values [intersect $legal_values [list "gige_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
                     set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
                        set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
                           set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
                              set legal_values [intersect $legal_values [list "cpri_rx" "cpri_rx_tx_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
                                 set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                              } else {
                                 if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
                                    set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                                       set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                    } else {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
                                          set legal_values [intersect $legal_values [list "gige_1588_rx"]]
                                       } else {
                                          if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                             set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                          } else {
                                             if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
                                                set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                             } else {
                                                if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                                                   set legal_values [intersect $legal_values [list "basic_rm_enable_rx"]]
                                                } else {
                                                   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
                                                      set legal_values [intersect $legal_values [list "basic_rm_disable_rx"]]
                                                   } else {
                                                      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
                                                         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                      } else {
                                                         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
                                                            set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                         } else {
                                                            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                                               set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                            } else {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
                                                                  set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                               } else {
                                                                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
                                                                     set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
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
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_8g_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_8g_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_8g_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_8g_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_8g_sup_mode $hssi_rx_pld_pcs_interface_hd_8g_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_le $legal_values 400000000]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx } {

   set legal_values [list "ctrl_master_rx" "ctrl_slave_abv_rx" "ctrl_slave_blw_rx" "individual_rx"]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable")||($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode!="tx_rx_pair_enabled")) }] {
      set legal_values [intersect $legal_values [list "individual_rx"]]
   } else {
      if [expr { ((((((((((((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx")) }] {
         set legal_values [intersect $legal_values [list "individual_rx"]]
      } else {
         if [expr { ((((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx")) }] {
            set legal_values [intersect $legal_values [list "individual_rx" "ctrl_master_rx" "ctrl_slave_abv_rx" "ctrl_slave_blw_rx"]]
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="individual_tx") }] {
               set legal_values [intersect $legal_values [list "individual_rx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
                  set legal_values [intersect $legal_values [list "ctrl_master_rx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
                     set legal_values [intersect $legal_values [list "ctrl_slave_abv_rx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
                        set legal_values [intersect $legal_values [list "ctrl_slave_blw_rx"]]
                     }
                  }
               }
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
               set legal_values [intersect $legal_values [list "ctrl_master_rx" "ctrl_slave_abv_rx" "ctrl_slave_blw_rx"]]
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
                  set legal_values [intersect $legal_values [list "ctrl_master_rx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
                     set legal_values [intersect $legal_values [list "ctrl_slave_abv_rx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
                        set legal_values [intersect $legal_values [list "ctrl_slave_blw_rx"]]
                     }
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx $hssi_rx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_fref_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_fref_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_le $legal_values 400000000]
      set legal_values [compare_eq $legal_values $hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_fref_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_fref_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_fref_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_fref_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_fref_clk_hz $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_clklow_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_hclk_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_hclk_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
         set legal_values [compare_le $legal_values 500000000]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
            set legal_values [compare_le $legal_values 250000000]
         } else {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_hclk_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_hclk_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_hclk_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_hclk_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_hclk_clk_hz $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_hip_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="enable")&&((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx"))) }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_hip_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_hip_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en $hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_hip_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { (((((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx"))||(($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx")) }] {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ((($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable")||($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable"))||(($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode")&&(((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx")))) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en $hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pcs_rx_pwr_scaling_clk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pcs_rx_pwr_scaling_clk } {

   set legal_values [list "pma_rx_clk"]

   set legal_values [intersect $legal_values [list "pma_rx_clk"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pcs_rx_pwr_scaling_clk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pcs_rx_pwr_scaling_clk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pcs_rx_pwr_scaling_clk $hssi_rx_pld_pcs_interface_hd_chnl_pcs_rx_pwr_scaling_clk $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz } {

   set legal_values [list 0:1073741823]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable")||($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode")) }] {
      set legal_values [compare_eq $legal_values 0]
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_le $legal_values $hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz]
      set legal_values [compare_le $legal_values $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx } {

   set legal_values [list "fifo_rx" "reg_rx"]

   if [expr { ((((((((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
      set legal_values [intersect $legal_values [list "fifo_rx"]]
   } else {
      if [expr { ((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx")) }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "reg_rx"]]
         } else {
            set legal_values [intersect $legal_values [list "fifo_rx"]]
         }
      } else {
         if [expr { (((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx")) }] {
            set legal_values [intersect $legal_values [list "reg_rx"]]
         } else {
            if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx")) }] {
               set legal_values [intersect $legal_values [list "fifo_rx" "reg_rx"]]
            } else {
               set legal_values [intersect $legal_values [list "fifo_rx"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz } {

   set legal_values [list 0:1073741823]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable")||($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode")) }] {
      set legal_values [compare_eq $legal_values 0]
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_le $legal_values $hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz]
      set legal_values [compare_le $legal_values $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_hip_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_func_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

	if [expr { $device_revision=="20nm4" }] {
		 ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5" }] {
		 ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm4es" }] {
		 ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm2" }] {
		 ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm5es" }] {
		 ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm1" }] {
		 ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	} elseif [expr { $device_revision=="20nm3" }] {
		 ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz  $PROP_M_AUTOSET $PROP_M_AUTOWARN $device_revision $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx
	}
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "basic_10gpcs_krfec_rx" "basic_10gpcs_rx" "basic_8gpcs_rm_disable_rx" "basic_8gpcs_rm_enable_rx" "cpri_8b10b_rx" "disabled_prot_mode_rx" "fortyg_basekr_krfec_rx" "gige_1588_rx" "gige_rx" "interlaken_rx" "pcie_g1_capable_rx" "pcie_g2_capable_rx" "pcie_g3_capable_rx" "pcs_direct_rx" "prbs_rx" "prp_krfec_rx" "prp_rx" "sfis_rx" "teng_1588_basekr_krfec_rx" "teng_1588_baser_rx" "teng_basekr_krfec_rx" "teng_baser_rx" "teng_sdi_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
            set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
               set legal_values [intersect $legal_values [list "pcie_g1_capable_rx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g2_capable_rx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_capable_rx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                        set legal_values [intersect $legal_values [list "gige_rx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                           set legal_values [intersect $legal_values [list "teng_baser_rx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                              set legal_values [intersect $legal_values [list "teng_basekr_krfec_rx"]]
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                                 set legal_values [intersect $legal_values [list "fortyg_basekr_krfec_rx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                                    set legal_values [intersect $legal_values [list "cpri_8b10b_rx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                       set legal_values [intersect $legal_values [list "interlaken_rx"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                          set legal_values [intersect $legal_values [list "sfis_rx"]]
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                             set legal_values [intersect $legal_values [list "teng_sdi_rx"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                                set legal_values [intersect $legal_values [list "gige_1588_rx"]]
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                                   set legal_values [intersect $legal_values [list "teng_1588_baser_rx"]]
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                      set legal_values [intersect $legal_values [list "teng_1588_basekr_krfec_rx"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                         set legal_values [intersect $legal_values [list "basic_8gpcs_rm_enable_rx" "basic_8gpcs_rm_disable_rx"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                            set legal_values [intersect $legal_values [list "basic_10gpcs_rx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                               set legal_values [intersect $legal_values [list "basic_10gpcs_krfec_rx"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "pcs_direct_rx"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "pcs_direct_rx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "prp_rx"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "prp_krfec_rx"]]
                                                                        } else {
                                                                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                              set legal_values [intersect $legal_values [list "prbs_rx"]]
                                                                           } else {
                                                                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                                 set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
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
            }
         }
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
            set legal_values [exclude $legal_values [list "teng_1588_basekr_krfec_rx"]]
            set legal_values [exclude $legal_values [list "teng_sdi_rx"]]
            set legal_values [exclude $legal_values [list "sfis_rx"]]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx } {

   set legal_values [list "double_rx" "single_rx"]

   if [expr { (((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))&&($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx"))&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx!="pma_32b_rx")) }] {
      set legal_values [intersect $legal_values [list "single_rx" "double_rx"]]
   } else {
      set legal_values [intersect $legal_values [list "single_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx $hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_speed_grade { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "e2" "e3" "e4" "i2" "i3" "i4"]

   if [expr { !(($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         set legal_values [exclude $legal_values [list "e4"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_speed_grade.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $hssi_rx_pld_pcs_interface_hd_chnl_speed_grade $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   set legal_values [intersect $legal_values [list "user_mode"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_sup_mode $hssi_rx_pld_pcs_interface_hd_chnl_sup_mode $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx $hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }
   set legal_values [intersect $legal_values [list "tx_rx_pair_enabled" "tx_rx_independent"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode $hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx } {

   set legal_values [list "non_teng_mode_rx" "teng_mode_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
            set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
               set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                  set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
                     set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
                        set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
                           set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
                              set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
                                 set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                              } else {
                                 if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
                                    set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                                       set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                    } else {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
                                          set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
                                       } else {
                                          if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                             set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                          } else {
                                             if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
                                                set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                             } else {
                                                if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                                                   set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
                                                } else {
                                                   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
                                                      set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
                                                   } else {
                                                      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
                                                         set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                                      } else {
                                                         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
                                                            set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                                         } else {
                                                            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                                               } else {
                                                                  set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
                                                               }
                                                            } else {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                                               } else {
                                                                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_mode_rx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
                                                                        set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
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
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "teng_mode_rx" "non_teng_mode_rx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx=="teng_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx=="non_teng_mode_tx") }] {
         set legal_values [intersect $legal_values [list "non_teng_mode_rx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx hssi_rx_pld_pcs_interface_hd_fifo_channel_operation_mode hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_fifo_shared_fifo_width_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_fifo_shared_fifo_width_rx hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx } {

   set legal_values [list "double_rx" "single_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx!="disabled_prot_mode_rx") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx=="single_rx") }] {
         set legal_values [intersect $legal_values [list "single_rx"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx=="double_rx") }] {
         set legal_values [intersect $legal_values [list "double_rx"]]
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx!="teng_mode_rx") }] {
      set legal_values [intersect $legal_values [list "single_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_fifo_shared_fifo_width_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_fifo_shared_fifo_width_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_fifo_shared_fifo_width_rx $hssi_rx_pld_pcs_interface_hd_fifo_shared_fifo_width_rx $legal_values { hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_shared_fifo_width_rx hssi_rx_pld_pcs_interface_hd_fifo_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_fifo_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_fifo_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_fifo_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_fifo_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_fifo_sup_mode $hssi_rx_pld_pcs_interface_hd_fifo_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_g3_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_g3_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disabled_prot_mode" "pipe_g1" "pipe_g2" "pipe_g3"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "pipe_g1"]]
         } else {
            set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
         }
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
               set legal_values [intersect $legal_values [list "pipe_g2"]]
            } else {
               set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
                  set legal_values [intersect $legal_values [list "pipe_g3"]]
               } else {
                  set legal_values [intersect $legal_values [list "pipe_g3"]]
               }
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                  set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                     set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                        set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                           set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                              set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                 set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                    set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                       set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                          set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                             set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                   set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                      set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                         set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                            set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                               set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_g3_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_g3_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_g3_prot_mode $hssi_rx_pld_pcs_interface_hd_g3_prot_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_g3_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_g3_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_g3_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_g3_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_g3_sup_mode $hssi_rx_pld_pcs_interface_hd_g3_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode $hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx")) }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            set legal_values [intersect $legal_values [list "enable"]]
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            set legal_values [intersect $legal_values [list "disable"]]
         }
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx $hssi_rx_pld_pcs_interface_hd_krfec_low_latency_en_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx!="disabled_prot_mode_rx") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx!="disabled_prot_mode_rx") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en $hssi_rx_pld_pcs_interface_hd_krfec_lpbk_en $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx } {

   set legal_values [list "basic_mode_rx" "disabled_prot_mode_rx" "fortyg_basekr_mode_rx" "teng_1588_basekr_mode_rx" "teng_basekr_mode_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
            set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
               set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                  set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
                     set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
                        set legal_values [intersect $legal_values [list "teng_basekr_mode_rx"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
                           set legal_values [intersect $legal_values [list "fortyg_basekr_mode_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
                              set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
                                 set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                              } else {
                                 if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
                                    set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                                       set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                    } else {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
                                          set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                       } else {
                                          if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                             set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                          } else {
                                             if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
                                                set legal_values [intersect $legal_values [list "teng_1588_basekr_mode_rx"]]
                                             } else {
                                                if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                                                   set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                } else {
                                                   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
                                                      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                   } else {
                                                      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
                                                         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                      } else {
                                                         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
                                                            set legal_values [intersect $legal_values [list "basic_mode_rx"]]
                                                         } else {
                                                            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                                               set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                            } else {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
                                                                  set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
                                                               } else {
                                                                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_basekr_mode_rx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
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
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode=="tx_rx_pair_enabled") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="disabled_prot_mode_tx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="teng_basekr_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_basekr_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="fortyg_basekr_mode_tx") }] {
         set legal_values [intersect $legal_values [list "fortyg_basekr_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="teng_1588_basekr_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_1588_basekr_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="basic_mode_tx") }] {
         set legal_values [intersect $legal_values [list "basic_mode_rx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_krfec_channel_operation_mode hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_krfec_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_krfec_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_krfec_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_krfec_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_krfec_sup_mode $hssi_rx_pld_pcs_interface_hd_krfec_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx } {

   set legal_values [list "rx" "tx"]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="disabled_prot_mode_tx")&&($hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx=="disabled_prot_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "tx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode $hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode $legal_values { hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_hip_tx") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en $hssi_rx_pld_pcs_interface_hd_pldif_hrdrstctl_en $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_hrdrstctl_en hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "disabled_prot_mode_rx" "eightg_and_g3_pld_fifo_mode_rx" "eightg_and_g3_reg_mode_hip_rx" "eightg_and_g3_reg_mode_rx" "pcs_direct_reg_mode_rx" "teng_and_krfec_pld_fifo_mode_rx" "teng_and_krfec_reg_mode_rx" "teng_pld_fifo_mode_rx" "teng_reg_mode_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_rx"]]
         } else {
            set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_rx"]]
         }
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
               set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_rx"]]
            } else {
               set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_rx"]]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
                  set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_rx"]]
               } else {
                  set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_rx"]]
               }
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                  set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
                     set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
                        set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_rx"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
                           set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
                              set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
                                 set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_rx"]]
                              } else {
                                 if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
                                    set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                                       set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_rx"]]
                                    } else {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
                                          if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="reg_rx") }] {
                                             set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_rx"]]
                                          } else {
                                             set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_rx"]]
                                          }
                                       } else {
                                          if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                             set legal_values [intersect $legal_values [list "teng_reg_mode_rx"]]
                                             set legal_values [intersect $legal_values [list "teng_reg_mode_rx"]]
                                          } else {
                                             if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
                                                set legal_values [intersect $legal_values [list "teng_and_krfec_reg_mode_rx"]]
                                             } else {
                                                if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                                                   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="reg_rx") }] {
                                                      set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_rx"]]
                                                   } else {
                                                      set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_rx"]]
                                                   }
                                                } else {
                                                   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
                                                      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="reg_rx") }] {
                                                         set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_rx"]]
                                                      } else {
                                                         set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_rx"]]
                                                      }
                                                   } else {
                                                      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
                                                         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="reg_rx") }] {
                                                            set legal_values [intersect $legal_values [list "teng_reg_mode_rx"]]
                                                         } else {
                                                            set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_rx"]]
                                                         }
                                                      } else {
                                                         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
                                                            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="reg_rx") }] {
                                                               set legal_values [intersect $legal_values [list "teng_and_krfec_reg_mode_rx"]]
                                                            } else {
                                                               set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_rx"]]
                                                            }
                                                         } else {
                                                            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                                               set legal_values [intersect $legal_values [list "pcs_direct_reg_mode_rx"]]
                                                            } else {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_rx"]]
                                                               } else {
                                                                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_rx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
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
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_hip_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_rx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [exclude $legal_values [list "eightg_and_g3_reg_mode_hip_rx"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_hip_tx") }] {
      set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_rx"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pldif_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pldif_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pldif_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pldif_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pldif_sup_mode $hssi_rx_pld_pcs_interface_hd_pldif_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode $hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en $hssi_rx_pld_pcs_interface_hd_pmaif_lpbk_en $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="disabled_prot_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="prbs_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="pcs_direct_mode_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
      } else {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_only_pld_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_basic_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_pld_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_pcie_g12_hip_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_pld_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="eightg_g3_pcie_g3_hip_mode_rx")) }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
               } else {
                  if [expr { ((($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_krfec_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_basic_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx=="teng_sfis_sdi_mode_rx")) }] {
                     set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                  }
               }
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_pmaif_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "disabled_prot_mode_rx" "eightg_basic_mode_rx" "eightg_g3_pcie_g3_hip_mode_rx" "eightg_g3_pcie_g3_pld_mode_rx" "eightg_only_pld_mode_rx" "eightg_pcie_g12_hip_mode_rx" "eightg_pcie_g12_pld_mode_rx" "pcs_direct_mode_rx" "prbs_mode_rx" "teng_basic_mode_rx" "teng_krfec_mode_rx" "teng_sfis_sdi_mode_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_rx"]]
         } else {
            set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_rx"]]
         }
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
               set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_rx"]]
            } else {
               set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_rx"]]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
                  set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_hip_mode_rx"]]
               } else {
                  set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_pld_mode_rx"]]
               }
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                  set legal_values [intersect $legal_values [list "eightg_only_pld_mode_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
                     set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
                        set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
                           set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
                              set legal_values [intersect $legal_values [list "eightg_only_pld_mode_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
                                 set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                              } else {
                                 if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
                                    set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                                       set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_rx"]]
                                    } else {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
                                          set legal_values [intersect $legal_values [list "eightg_only_pld_mode_rx"]]
                                       } else {
                                          if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                             set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                                          } else {
                                             if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
                                                set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                                             } else {
                                                if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                                                   set legal_values [intersect $legal_values [list "eightg_basic_mode_rx"]]
                                                } else {
                                                   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
                                                      set legal_values [intersect $legal_values [list "eightg_basic_mode_rx"]]
                                                   } else {
                                                      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
                                                         set legal_values [intersect $legal_values [list "teng_basic_mode_rx"]]
                                                      } else {
                                                         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
                                                            set legal_values [intersect $legal_values [list "teng_basic_mode_rx"]]
                                                         } else {
                                                            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                                               set legal_values [intersect $legal_values [list "pcs_direct_mode_rx"]]
                                                            } else {
                                                               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                                                               } else {
                                                                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
                                                                        set legal_values [intersect $legal_values [list "prbs_mode_rx"]]
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
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode=="tx_rx_pair_enabled") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="pcs_direct_mode_tx") }] {
         set legal_values [intersect $legal_values [list "pcs_direct_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_reg_mode_tx") }] {
         set legal_values [intersect $legal_values [list "pcs_direct_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_direct_mode_tx") }] {
         set legal_values [intersect $legal_values [list "pcs_direct_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_only_pld_mode_tx") }] {
         set legal_values [intersect $legal_values [list "eightg_only_pld_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx") }] {
         set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx") }] {
         set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_pld_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx") }] {
         set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx") }] {
         set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_hip_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_krfec_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_krfec_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_basic_mode_tx") }] {
         set legal_values [intersect $legal_values [list "eightg_basic_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_basic_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_basic_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_sfis_sdi_mode_tx") }] {
         set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="prbs_mode_tx") }] {
         set legal_values [intersect $legal_values [list "prbs_mode_rx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="sqwave_mode_tx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_rx"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx $hssi_rx_pld_pcs_interface_hd_pmaif_prot_mode_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_pmaif_channel_operation_mode hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode $hssi_rx_pld_pcs_interface_hd_pmaif_sim_mode $legal_values { hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode hssi_rx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode $hssi_rx_pld_pcs_interface_hd_pmaif_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_pcs_rx_block_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_pcs_rx_block_sel hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx } {

   set legal_values [list "eightg" "pcs_direct" "teng"]

   if [expr { ((($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_pld_fifo_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_reg_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_reg_mode_hip_rx")) }] {
      set legal_values [intersect $legal_values [list "eightg"]]
   } else {
      if [expr { (((($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_and_krfec_pld_fifo_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_and_krfec_reg_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_pld_fifo_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_reg_mode_rx")) }] {
         set legal_values [intersect $legal_values [list "teng"]]
      } else {
         set legal_values [intersect $legal_values [list "pcs_direct"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_pcs_rx_block_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_pcs_rx_block_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_pcs_rx_block_sel $hssi_rx_pld_pcs_interface_pcs_rx_block_sel $legal_values { hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_pcs_rx_clk_out_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_pcs_rx_clk_out_sel hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx } {

   set legal_values [list "eightg_clk_out" "pma_rx_clk" "pma_rx_clk_user" "teng_clk_out"]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_reg_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_reg_mode_hip_rx")) }] {
      set legal_values [intersect $legal_values [list "eightg_clk_out"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_pld_fifo_mode_rx") }] {
         set legal_values [intersect $legal_values [list "eightg_clk_out"]]
      } else {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_and_krfec_pld_fifo_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_pld_fifo_mode_rx")) }] {
            set legal_values [intersect $legal_values [list "teng_clk_out" "pma_rx_clk_user"]]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_and_krfec_reg_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_reg_mode_rx")) }] {
               set legal_values [intersect $legal_values [list "teng_clk_out"]]
            } else {
               set legal_values [intersect $legal_values [list "pma_rx_clk"]]
            }
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_pcs_rx_clk_out_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_pcs_rx_clk_out_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_pcs_rx_clk_out_sel $hssi_rx_pld_pcs_interface_pcs_rx_clk_out_sel $legal_values { hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_pcs_rx_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_pcs_rx_clk_sel hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx } {

   set legal_values [list "pcs_rx_clk" "pld_rx_clk"]

   if [expr { ((($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_pld_fifo_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_and_krfec_pld_fifo_mode_rx"))||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_pld_fifo_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "pld_rx_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "pcs_rx_clk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_pcs_rx_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_pcs_rx_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_pcs_rx_clk_sel $hssi_rx_pld_pcs_interface_pcs_rx_clk_sel $legal_values { hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_pcs_rx_hip_clk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_pcs_rx_hip_clk_en hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx } {

   set legal_values [list "hip_rx_disable" "hip_rx_enable"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="disabled_prot_mode_rx") }] {
      set legal_values [intersect $legal_values [list "hip_rx_disable"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="eightg_and_g3_reg_mode_hip_rx") }] {
         set legal_values [intersect $legal_values [list "hip_rx_enable"]]
      } else {
         set legal_values [intersect $legal_values [list "hip_rx_disable"]]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_pcs_rx_hip_clk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_pcs_rx_hip_clk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_pcs_rx_hip_clk_en $hssi_rx_pld_pcs_interface_pcs_rx_hip_clk_en $legal_values { hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_rx_pld_pcs_interface_pcs_rx_output_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_pcs_rx_output_sel hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx } {

   set legal_values [list "krfec_output" "teng_output"]

   if [expr { (($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_and_krfec_pld_fifo_mode_rx")||($hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx=="teng_and_krfec_reg_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "krfec_output"]]
   } else {
      set legal_values [intersect $legal_values [list "teng_output"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_pcs_rx_output_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_pcs_rx_output_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_pcs_rx_output_sel $hssi_rx_pld_pcs_interface_pcs_rx_output_sel $legal_values { hssi_rx_pld_pcs_interface_hd_pldif_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm1_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm3_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm4_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm4es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 385000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es2_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 385000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 300000000]
                     } else {
                        set legal_values [compare_le $legal_values 270336000]
                     }
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 250000000]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                        set legal_values [compare_le $legal_values 245760000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 223420000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 266200000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 242000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 220000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pld_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_hip_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list "pcie_g3_dyn_dw_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx" "pma_8b_rx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_rx"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
               set legal_values [intersect $legal_values [list "pma_10b_rx" "pma_20b_rx"]]
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_rx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_rx"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
                        set legal_values [intersect $legal_values [list "pma_10b_rx"]]
                     } else {
                        if [expr { ((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx")) }] {
                           set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
                              set legal_values [intersect $legal_values [list "pma_40b_rx"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
                                 set legal_values [intersect $legal_values [list "pma_32b_rx" "pma_40b_rx"]]
                              } else {
                                 if [expr { (((((($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx"))||($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx")) }] {
                                    set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                 } else {
                                    if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
                                       if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
                                          set legal_values [intersect $legal_values [list "pma_64b_rx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_rx" "pma_10b_rx" "pma_16b_rx" "pma_20b_rx" "pma_32b_rx" "pma_40b_rx" "pma_64b_rx"]]
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
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx $legal_values { hssi_rx_pld_pcs_interface_hd_chnl_func_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


proc ::nf_xcvr_native::parameters::20nm5es_validate_hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g1_capable_rx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g2_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcie_g3_capable_rx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="fortyg_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="cpri_8b10b_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx") }] {
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="interlaken_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="sfis_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_sdi_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="gige_1588_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_baser_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="teng_1588_basekr_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_disable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")) }] {
                        set legal_values [compare_le $legal_values 600000000]
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  } else {
                     set legal_values [compare_le $legal_values 540672000]
                  }
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm")) }] {
                     set legal_values [compare_le $legal_values 500000000]
                  } else {
                     set legal_values [compare_le $legal_values 491520000]
                  }
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 446840000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_10b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_8b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_16b_rx")||($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_20b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 532400000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 484000000]
               }
            }
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="dis_bds") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_2") }] {
                  set legal_values [compare_le $legal_values 440000000]
               }
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx=="fifo_rx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable")&&($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx")) }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_10gpcs_krfec_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="enable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx=="disable") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="pcs_direct_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx=="enable") }] {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 195312500]
               }
            } else {
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 500000000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 406250000]
               }
               if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 221875000]
               }
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 385000000]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_rx") }] {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_64b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_32b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx=="pma_40b_rx") }] {
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prp_krfec_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="prbs_rx") }] {
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_rx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_rx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_rx_pld_pcs_interface_hd_chnl_low_latency_en_rx hssi_rx_pld_pcs_interface_hd_chnl_pld_fifo_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_pma_dw_rx hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_rx_pld_pcs_interface_hd_chnl_speed_grade hssi_rx_pld_pcs_interface_hd_chnl_transparent_pcs_rx }
   }
}


