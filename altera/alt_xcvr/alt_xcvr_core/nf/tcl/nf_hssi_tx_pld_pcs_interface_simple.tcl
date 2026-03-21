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


proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_advanced_user_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="interlaken_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_channel_operation_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx } {

   set legal_values [list "ctrl_master_tx" "ctrl_slave_abv_tx" "ctrl_slave_blw_tx" "individual_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx!="disabled_prot_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="individual_tx") }] {
         set legal_values [intersect $legal_values [list "individual_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_master_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_abv_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_blw_tx"]]
      }
   }
   if [expr { (((($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx!="sfis_mode_tx")&&($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx!="basic_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx!="interlaken_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx!="basic_krfec_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "individual_tx"]]
   } else {
      set legal_values [intersect $legal_values [list "individual_tx" "ctrl_master_tx" "ctrl_slave_blw_tx" "ctrl_slave_abv_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "fastreg_tx" "fifo_tx" "reg_tx"]

   if [expr { (((((((($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="interlaken_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="sfis_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_sdi_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_krfec_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_krfec_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "fifo_tx"]]
   } else {
      if [expr { (($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_mode_tx")||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_krfec_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "reg_tx" "fastreg_tx"]]
      } else {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_mode_tx")||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_krfec_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "fifo_tx" "reg_tx" "fastreg_tx"]]
         } else {
            set legal_values [intersect $legal_values [list "fifo_tx"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_low_latency_en_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   } else {
      if [expr { !(($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx")) }] {
         if [expr { ((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx")) }] {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
               set legal_values [intersect $legal_values [list "enable"]]
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
               set legal_values [intersect $legal_values [list "disable"]]
            }
         }
      }
   }
   if [expr { ((((($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_mode_tx")||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="interlaken_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_krfec_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_krfec_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_lpbk_en { device_revision hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { (((((($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_mode_tx")||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="interlaken_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="sfis_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_sdi_mode_tx") }] {
            set legal_values [intersect $legal_values [list "pma_40b_tx"]]
         } else {
            if [expr { (((($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_krfec_mode_tx")||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_krfec_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_krfec_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_krfec_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_64b_tx"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_channel_operation_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "basic_krfec_mode_tx" "basic_mode_tx" "disabled_prot_mode_tx" "interlaken_mode_tx" "sfis_mode_tx" "teng_1588_krfec_mode_tx" "teng_1588_mode_tx" "teng_baser_krfec_mode_tx" "teng_baser_mode_tx" "teng_sdi_mode_tx" "test_prp_krfec_mode_tx" "test_prp_mode_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                  set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                     set legal_values [intersect $legal_values [list "teng_baser_mode_tx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                        set legal_values [intersect $legal_values [list "teng_baser_krfec_mode_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                           set legal_values [intersect $legal_values [list "basic_krfec_mode_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                              set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                 set legal_values [intersect $legal_values [list "interlaken_mode_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                    set legal_values [intersect $legal_values [list "sfis_mode_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                       set legal_values [intersect $legal_values [list "teng_sdi_mode_tx"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                          set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                             set legal_values [intersect $legal_values [list "teng_1588_mode_tx"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                set legal_values [intersect $legal_values [list "teng_1588_krfec_mode_tx"]]
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                   set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                      set legal_values [intersect $legal_values [list "basic_mode_tx"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                         set legal_values [intersect $legal_values [list "basic_krfec_mode_tx"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                            set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                               set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "test_prp_mode_tx"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "test_prp_krfec_mode_tx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
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
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx" "teng_baser_mode_tx" "interlaken_mode_tx" "sfis_mode_tx" "teng_sdi_mode_tx" "basic_mode_tx" "test_prp_mode_tx" "test_prp_krfec_mode_tx" "teng_1588_mode_tx" "teng_baser_krfec_mode_tx" "teng_1588_krfec_mode_tx" "basic_krfec_mode_tx"]]
   } else {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx" "teng_baser_mode_tx" "interlaken_mode_tx" "sfis_mode_tx" "teng_sdi_mode_tx" "basic_mode_tx" "test_prp_mode_tx" "test_prp_krfec_mode_tx" "teng_1588_mode_tx" "teng_baser_krfec_mode_tx" "teng_1588_krfec_mode_tx" "basic_krfec_mode_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_shared_fifo_width_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx } {

   set legal_values [list "double_tx" "single_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx!="disabled_prot_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx=="single_tx") }] {
         set legal_values [intersect $legal_values [list "single_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx=="double_tx") }] {
         set legal_values [intersect $legal_values [list "double_tx"]]
      }
   }
   if [expr { ((($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_mode_tx")||($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_krfec_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx=="fifo_tx")) }] {
      set legal_values [intersect $legal_values [list "single_tx" "double_tx"]]
   } else {
      set legal_values [intersect $legal_values [list "single_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_10g_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_channel_operation_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx { device_revision hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx } {

   set legal_values [list "ctrl_master_tx" "ctrl_slave_abv_tx" "ctrl_slave_blw_tx" "individual_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx!="disabled_prot_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="individual_tx") }] {
         set legal_values [intersect $legal_values [list "individual_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_master_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_abv_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_blw_tx"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_8g_hip_mode hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx } {

   set legal_values [list "fastreg_tx" "fifo_tx" "reg_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "fifo_tx"]]
   } else {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g1_tx")||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g2_tx"))||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g3_tx")) }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_hip_mode=="enable") }] {
            set legal_values [intersect $legal_values [list "reg_tx"]]
         } else {
            set legal_values [intersect $legal_values [list "fifo_tx"]]
         }
      } else {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_tx")||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_rx_tx_tx")) }] {
            set legal_values [intersect $legal_values [list "reg_tx" "fastreg_tx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="gige_tx") }] {
               set legal_values [intersect $legal_values [list "fifo_tx"]]
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="basic_tx")||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="gige_1588_tx")) }] {
                  set legal_values [intersect $legal_values [list "fifo_tx" "reg_tx" "fastreg_tx"]]
               } else {
                  set legal_values [intersect $legal_values [list "fifo_tx"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_hip_mode { device_revision hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_hip_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx!="disabled_prot_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="disable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }
   if [expr { ((($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g1_tx")||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g2_tx"))||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g3_tx")) }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_lpbk_en { device_revision hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx } {

   set legal_values [list "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="basic_tx") }] {
      set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
   } else {
      if [expr { (($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_tx")||($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_rx_tx_tx")) }] {
         set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
      } else {
         set legal_values [intersect $legal_values [list "pma_10b_tx"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "basic_tx" "cpri_rx_tx_tx" "cpri_tx" "disabled_prot_mode_tx" "gige_1588_tx" "gige_tx" "pipe_g1_tx" "pipe_g2_tx" "pipe_g3_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [intersect $legal_values [list "pipe_g1_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            set legal_values [intersect $legal_values [list "pipe_g2_tx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               set legal_values [intersect $legal_values [list "pipe_g3_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                  set legal_values [intersect $legal_values [list "gige_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                     set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                        set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                           set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                              set legal_values [intersect $legal_values [list "cpri_tx" "cpri_rx_tx_tx"]]
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                 set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                    set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                       set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                          set legal_values [intersect $legal_values [list "gige_1588_tx"]]
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                             set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                   set legal_values [intersect $legal_values [list "basic_tx"]]
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                         set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                            set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                               set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_8g_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "ctrl_master_tx" "ctrl_slave_abv_tx" "ctrl_slave_blw_tx" "individual_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "individual_tx"]]
   } else {
      if [expr { (((((((((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
         set legal_values [intersect $legal_values [list "individual_tx"]]
      } else {
         if [expr { ((((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx")) }] {
            set legal_values [intersect $legal_values [list "individual_tx" "ctrl_master_tx" "ctrl_slave_abv_tx" "ctrl_slave_blw_tx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
               set legal_values [intersect $legal_values [list "ctrl_master_tx" "ctrl_slave_abv_tx" "ctrl_slave_blw_tx"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_hclk_clk_hz { device_revision hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_hip_en { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="enable")&&((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx"))) }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_hrdrstctl_en { device_revision hssi_tx_pld_pcs_interface_hd_chnl_hip_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { (((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx"))||(($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx")) }] {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ((($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable")||($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable"))||(($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode")&&(((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx")))) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pcs_tx_pwr_scaling_clk { device_revision } {

   set legal_values [list "pma_tx_clk"]

   set legal_values [intersect $legal_values [list "pma_tx_clk"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_8g_refclk_dig_nonatpg_mode_clk_hz { device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list 0:1073741823]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable")||($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode")) }] {
      set legal_values [compare_eq $legal_values 0]
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_le $legal_values $hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz]
      set legal_values [compare_le $legal_values $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "fastreg_tx" "fifo_tx" "reg_tx"]

   if [expr { ((((((((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
      set legal_values [intersect $legal_values [list "fifo_tx"]]
   } else {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx")) }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "reg_tx"]]
         } else {
            set legal_values [intersect $legal_values [list "fifo_tx"]]
         }
      } else {
         if [expr { ((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx")) }] {
            set legal_values [intersect $legal_values [list "reg_tx" "fastreg_tx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
               set legal_values [intersect $legal_values [list "fastreg_tx"]]
            } else {
               if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx")) }] {
                  set legal_values [intersect $legal_values [list "fifo_tx" "reg_tx" "fastreg_tx"]]
               } else {
                  set legal_values [intersect $legal_values [list "fifo_tx"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_pcs_refclk_dig_nonatpg_mode_clk_hz { device_revision hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list 0:1073741823]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable")||($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode")) }] {
      set legal_values [compare_eq $legal_values 0]
      set legal_values [compare_eq $legal_values 0]
   } else {
      set legal_values [compare_le $legal_values $hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz]
      set legal_values [compare_le $legal_values $hssi_rx_pld_pcs_interface_hd_chnl_pma_rx_clk_hz]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_hip_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_uhsif_tx_clk_hz { device_revision hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
      set legal_values [compare_eq $legal_values $hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz]
   } else {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx  $device_revision $hssi_tx_pld_pcs_interface_hd_chnl_func_mode $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_sup_mode]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

	set legal_values {}

	if [expr { $device_revision=="20nm4" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm5" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm4es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm5es2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm2" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm5es" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm1" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	} elseif [expr { $device_revision=="20nm3" }] {
		 set legal_values [::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz  $device_revision $hssi_8g_tx_pcs_byte_serializer $hssi_8g_tx_pcs_prot_mode $hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx $hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en $hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx $hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx $hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx $hssi_tx_pld_pcs_interface_hd_chnl_speed_grade]
	}
	return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "basic_10gpcs_krfec_tx" "basic_10gpcs_tx" "basic_8gpcs_tx" "cpri_8b10b_tx" "disabled_prot_mode_tx" "fortyg_basekr_krfec_tx" "gige_1588_tx" "gige_tx" "interlaken_tx" "pcie_g1_capable_tx" "pcie_g2_capable_tx" "pcie_g3_capable_tx" "pcs_direct_tx" "prbs_tx" "prp_krfec_tx" "prp_tx" "sfis_tx" "sqwave_tx" "teng_1588_basekr_krfec_tx" "teng_1588_baser_tx" "teng_basekr_krfec_tx" "teng_baser_tx" "teng_sdi_tx" "uhsif_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
         set legal_values [exclude $legal_values [list "teng_1588_basekr_krfec_tx"]]
         set legal_values [exclude $legal_values [list "uhsif_tx"]]
         set legal_values [exclude $legal_values [list "teng_sdi_tx"]]
         set legal_values [exclude $legal_values [list "sfis_tx"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "double_tx" "single_tx"]

   if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))&&($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx"))&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx!="pma_32b_tx")) }] {
      set legal_values [intersect $legal_values [list "single_tx" "double_tx"]]
   } else {
      set legal_values [intersect $legal_values [list "single_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_speed_grade { device_revision hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "e2" "e3" "e4" "i2" "i3" "i4"]

   if [expr { !(($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         set legal_values [exclude $legal_values [list "e4"]]
         set legal_values [exclude $legal_values [list "i4"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_chnl_sup_mode { device_revision } {

   set legal_values [list "engineering_mode" "user_mode"]

   set legal_values [intersect $legal_values [list "user_mode"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_fifo_channel_operation_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }
   set legal_values [intersect $legal_values [list "tx_rx_pair_enabled" "tx_rx_independent"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_fifo_channel_operation_mode } {

   set legal_values [list "non_teng_mode_tx" "teng_mode_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                  set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                     set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                        set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                           set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                              set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                 set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                    set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                       set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                          set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                             set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                   set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                      set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                         set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                            set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                               set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_mode_tx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "non_teng_mode_tx"]]
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
   if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "teng_mode_tx" "non_teng_mode_tx"]]
   } else {
      set legal_values [intersect $legal_values [list "teng_mode_tx" "non_teng_mode_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_fifo_shared_fifo_width_tx { device_revision hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx } {

   set legal_values [list "double_tx" "single_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx!="disabled_prot_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx=="single_tx") }] {
         set legal_values [intersect $legal_values [list "single_tx"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_shared_fifo_width_tx=="double_tx") }] {
         set legal_values [intersect $legal_values [list "double_tx"]]
      }
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_fifo_prot_mode_tx!="teng_mode_tx") }] {
      set legal_values [intersect $legal_values [list "single_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_fifo_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_g3_prot_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disabled_prot_mode" "pipe_g1" "pipe_g2" "pipe_g3"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "pipe_g1"]]
         } else {
            set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
         }
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
               set legal_values [intersect $legal_values [list "pipe_g2"]]
            } else {
               set legal_values [intersect $legal_values [list "disabled_prot_mode"]]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_g3_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_krfec_channel_operation_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_krfec_low_latency_en_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
         set legal_values [intersect $legal_values [list "enable"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            set legal_values [intersect $legal_values [list "enable"]]
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            set legal_values [intersect $legal_values [list "disable"]]
         }
      }
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_krfec_lpbk_en { device_revision hssi_rx_pld_pcs_interface_hd_krfec_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_krfec_sup_mode } {

   set legal_values [list "basic_mode_tx" "disabled_prot_mode_tx" "fortyg_basekr_mode_tx" "teng_1588_basekr_mode_tx" "teng_basekr_mode_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                  set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                     set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                        set legal_values [intersect $legal_values [list "teng_basekr_mode_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                           set legal_values [intersect $legal_values [list "fortyg_basekr_mode_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                              set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                 set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                    set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                       set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                          set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                             set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                set legal_values [intersect $legal_values [list "teng_1588_basekr_mode_tx"]]
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                   set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                         set legal_values [intersect $legal_values [list "basic_mode_tx"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                            set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                               set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_basekr_mode_tx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
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
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx" "teng_basekr_mode_tx" "fortyg_basekr_mode_tx" "teng_1588_basekr_mode_tx" "basic_mode_tx"]]
   } else {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx" "teng_basekr_mode_tx" "fortyg_basekr_mode_tx" "basic_mode_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_krfec_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pldif_hrdrstctl_en { device_revision hssi_tx_pld_pcs_interface_hd_chnl_hrdrstctl_en hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hrdrstctl_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hrdrstctl_en=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_hip_tx") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx } {

   set legal_values [list "disabled_prot_mode_tx" "eightg_and_g3_fastreg_mode_tx" "eightg_and_g3_pld_fifo_mode_tx" "eightg_and_g3_reg_mode_hip_tx" "eightg_and_g3_reg_mode_tx" "pcs_direct_fastreg_mode_tx" "teng_and_krfec_fastreg_mode_tx" "teng_and_krfec_pld_fifo_mode_tx" "teng_and_krfec_reg_mode_tx" "teng_fastreg_mode_tx" "teng_pld_fifo_mode_tx" "teng_reg_mode_tx" "uhsif_mode_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_tx"]]
         } else {
            set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_tx"]]
         }
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
               set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_tx"]]
            } else {
               set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_tx"]]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
                  set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_hip_tx"]]
               } else {
                  set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_tx"]]
               }
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                  set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                     set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_tx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                        set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                           set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fastreg_tx") }] {
                                 set legal_values [intersect $legal_values [list "eightg_and_g3_fastreg_mode_tx"]]
                              } else {
                                 set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_tx"]]
                              }
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                 set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                    set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                       set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_tx"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fastreg_tx") }] {
                                             set legal_values [intersect $legal_values [list "eightg_and_g3_fastreg_mode_tx"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="reg_tx") }] {
                                                set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_tx"]]
                                             } else {
                                                set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_tx"]]
                                             }
                                          }
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fastreg_tx") }] {
                                                set legal_values [intersect $legal_values [list "teng_fastreg_mode_tx"]]
                                             } else {
                                                set legal_values [intersect $legal_values [list "teng_reg_mode_tx"]]
                                             }
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fastreg_tx") }] {
                                                   set legal_values [intersect $legal_values [list "teng_and_krfec_fastreg_mode_tx"]]
                                                } else {
                                                   set legal_values [intersect $legal_values [list "teng_and_krfec_reg_mode_tx"]]
                                                }
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fastreg_tx") }] {
                                                      set legal_values [intersect $legal_values [list "eightg_and_g3_fastreg_mode_tx"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="reg_tx") }] {
                                                         set legal_values [intersect $legal_values [list "eightg_and_g3_reg_mode_tx"]]
                                                      } else {
                                                         set legal_values [intersect $legal_values [list "eightg_and_g3_pld_fifo_mode_tx"]]
                                                      }
                                                   }
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fastreg_tx") }] {
                                                         set legal_values [intersect $legal_values [list "teng_fastreg_mode_tx"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="reg_tx") }] {
                                                            set legal_values [intersect $legal_values [list "teng_reg_mode_tx"]]
                                                         } else {
                                                            set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_tx"]]
                                                         }
                                                      }
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fastreg_tx") }] {
                                                            set legal_values [intersect $legal_values [list "teng_and_krfec_fastreg_mode_tx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="reg_tx") }] {
                                                               set legal_values [intersect $legal_values [list "teng_and_krfec_reg_mode_tx"]]
                                                            } else {
                                                               set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_tx"]]
                                                            }
                                                         }
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                            set legal_values [intersect $legal_values [list "pcs_direct_fastreg_mode_tx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                               set legal_values [intersect $legal_values [list "uhsif_mode_tx"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_pld_fifo_mode_tx"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_and_krfec_pld_fifo_mode_tx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pldif_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pmaif_channel_operation_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode } {

   set legal_values [list "tx_rx_independent" "tx_rx_pair_enabled"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_pair_enabled") }] {
      set legal_values [intersect $legal_values [list "tx_rx_pair_enabled"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_channel_operation_mode=="tx_rx_independent") }] {
      set legal_values [intersect $legal_values [list "tx_rx_independent"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pmaif_ctrl_plane_bonding { device_revision hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx } {

   set legal_values [list "ctrl_master" "ctrl_slave_abv" "ctrl_slave_blw" "individual"]

   if [expr { ((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="individual_tx") }] {
         set legal_values [intersect $legal_values [list "individual"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_master"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_abv"]]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
         set legal_values [intersect $legal_values [list "ctrl_slave_blw"]]
      }
   }
   if [expr { (((($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "individual" "ctrl_master" "ctrl_slave_abv" "ctrl_slave_blw"]]
   } else {
      set legal_values [intersect $legal_values [list "individual"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pmaif_lpbk_en { device_revision hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pmaif_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ((($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="disabled_prot_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="prbs_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="sqwave_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="pcs_direct_mode_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
      } else {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_reg_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="uhsif_direct_mode_tx")) }] {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
               set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
            } else {
               set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
            }
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_only_pld_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_basic_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_pld_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_pcie_g12_hip_mode_tx")) }] {
                  set legal_values [intersect $legal_values [list "pma_10b_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_pld_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="eightg_g3_pcie_g3_hip_mode_tx")) }] {
                     set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
                  } else {
                     if [expr { ((($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_krfec_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_basic_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx=="teng_sfis_sdi_mode_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pmaif_prot_mode_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "disabled_prot_mode_tx" "eightg_basic_mode_tx" "eightg_g3_pcie_g3_hip_mode_tx" "eightg_g3_pcie_g3_pld_mode_tx" "eightg_only_pld_mode_tx" "eightg_pcie_g12_hip_mode_tx" "eightg_pcie_g12_pld_mode_tx" "pcs_direct_mode_tx" "prbs_mode_tx" "sqwave_mode_tx" "teng_basic_mode_tx" "teng_krfec_mode_tx" "teng_sfis_sdi_mode_tx" "uhsif_direct_mode_tx" "uhsif_reg_mode_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disabled_prot_mode_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_tx"]]
         } else {
            set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_tx"]]
         }
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
               set legal_values [intersect $legal_values [list "eightg_pcie_g12_hip_mode_tx"]]
            } else {
               set legal_values [intersect $legal_values [list "eightg_pcie_g12_pld_mode_tx"]]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
                  set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_hip_mode_tx"]]
               } else {
                  set legal_values [intersect $legal_values [list "eightg_g3_pcie_g3_pld_mode_tx"]]
               }
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
                  set legal_values [intersect $legal_values [list "eightg_only_pld_mode_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
                     set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
                        set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
                           set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
                              set legal_values [intersect $legal_values [list "eightg_only_pld_mode_tx"]]
                           } else {
                              if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
                                 set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
                                    set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                                       set legal_values [intersect $legal_values [list "teng_sfis_sdi_mode_tx"]]
                                    } else {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
                                          set legal_values [intersect $legal_values [list "eightg_only_pld_mode_tx"]]
                                       } else {
                                          if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                                             set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                                          } else {
                                             if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
                                                set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                                             } else {
                                                if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
                                                   set legal_values [intersect $legal_values [list "eightg_basic_mode_tx"]]
                                                } else {
                                                   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
                                                      set legal_values [intersect $legal_values [list "teng_basic_mode_tx"]]
                                                   } else {
                                                      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
                                                         set legal_values [intersect $legal_values [list "teng_basic_mode_tx"]]
                                                      } else {
                                                         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                                            set legal_values [intersect $legal_values [list "pcs_direct_mode_tx"]]
                                                         } else {
                                                            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                                               set legal_values [intersect $legal_values [list "uhsif_reg_mode_tx" "uhsif_direct_mode_tx"]]
                                                            } else {
                                                               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
                                                                  set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                                                               } else {
                                                                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
                                                                     set legal_values [intersect $legal_values [list "teng_krfec_mode_tx"]]
                                                                  } else {
                                                                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
                                                                        set legal_values [intersect $legal_values [list "prbs_mode_tx"]]
                                                                     } else {
                                                                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
                                                                           set legal_values [intersect $legal_values [list "sqwave_mode_tx"]]
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
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [exclude $legal_values [list "uhsif_reg_mode_tx"]]
      set legal_values [exclude $legal_values [list "uhsif_direct_mode_tx"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pmaif_sim_mode { device_revision hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "enable" "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_hd_pmaif_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_clk_out_sel { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "eightg_clk_out" "pma_tx_clk" "pma_tx_clk_user" "teng_clk_out"]

   if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_hip_tx"))||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_fastreg_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "eightg_clk_out"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_pld_fifo_mode_tx") }] {
         set legal_values [intersect $legal_values [list "eightg_clk_out"]]
      } else {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="uhsif_mode_tx")) }] {
            set legal_values [intersect $legal_values [list "pma_tx_clk"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="teng_pld_fifo_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="teng_and_krfec_pld_fifo_mode_tx")) }] {
               set legal_values [intersect $legal_values [list "teng_clk_out" "pma_tx_clk_user"]]
            } else {
               set legal_values [intersect $legal_values [list "teng_clk_out"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_clk_source { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "eightg" "pma_clk" "teng"]

   if [expr { (((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_pld_fifo_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_hip_tx"))||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_fastreg_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "eightg"]]
   } else {
      if [expr { (($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="uhsif_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "pma_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "teng"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_data_source { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "hip_disable" "hip_enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="eightg_and_g3_reg_mode_hip_tx") }] {
      set legal_values [intersect $legal_values [list "hip_enable"]]
   } else {
      set legal_values [intersect $legal_values [list "hip_disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_delay1_clk_en { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel } {

   set legal_values [list "delay1_clk_disable" "delay1_clk_enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel=="one_ff_delay") }] {
         set legal_values [intersect $legal_values [list "delay1_clk_disable"]]
      } else {
         set legal_values [intersect $legal_values [list "delay1_clk_enable"]]
      }
   } else {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="eightg_and_g3_fastreg_mode_tx")&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_and_krfec_fastreg_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_fastreg_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "delay1_clk_disable"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel=="one_ff_delay") }] {
            set legal_values [intersect $legal_values [list "delay1_clk_disable"]]
         } else {
            set legal_values [intersect $legal_values [list "delay1_clk_enable"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_delay1_clk_sel { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel } {

   set legal_values [list "pcs_tx_clk" "pld_tx_clk"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel=="one_ff_delay") }] {
         set legal_values [intersect $legal_values [list "pcs_tx_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "pcs_tx_clk"]]
      }
   } else {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="eightg_and_g3_fastreg_mode_tx")&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_and_krfec_fastreg_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_fastreg_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "pcs_tx_clk"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel=="one_ff_delay") }] {
            set legal_values [intersect $legal_values [list "pcs_tx_clk"]]
         } else {
            set legal_values [intersect $legal_values [list "pcs_tx_clk"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_delay1_ctrl { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel } {

   set legal_values [list "delay1_path0" "delay1_path1" "delay1_path2" "delay1_path3" "delay1_path4"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx") }] {
      if [expr { ($hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel=="one_ff_delay") }] {
         set legal_values [intersect $legal_values [list "delay1_path0"]]
      } else {
         set legal_values [intersect $legal_values [list "delay1_path3" "delay1_path1"]]
      }
   } else {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="eightg_and_g3_fastreg_mode_tx")&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_and_krfec_fastreg_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_fastreg_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "delay1_path0"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel=="one_ff_delay") }] {
            set legal_values [intersect $legal_values [list "delay1_path0"]]
         } else {
            set legal_values [intersect $legal_values [list "delay1_path3" "delay1_path1"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_delay1_data_sel { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "one_ff_delay" "two_ff_delay"]

   if [expr { !(($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx")) }] {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="eightg_and_g3_fastreg_mode_tx")&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_and_krfec_fastreg_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_fastreg_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "one_ff_delay"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_delay2_clk_en { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "delay2_clk_disable" "delay2_clk_enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx") }] {
      set legal_values [intersect $legal_values [list "delay2_clk_enable"]]
   } else {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="eightg_and_g3_fastreg_mode_tx")&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_and_krfec_fastreg_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_fastreg_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "delay2_clk_disable"]]
      } else {
         set legal_values [intersect $legal_values [list "delay2_clk_enable"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_delay2_ctrl { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "delay2_path0" "delay2_path1" "delay2_path2" "delay2_path3" "delay2_path4"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="pcs_direct_fastreg_mode_tx") }] {
      set legal_values [intersect $legal_values [list "delay2_path3" "delay2_path0"]]
   } else {
      if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="eightg_and_g3_fastreg_mode_tx")&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_and_krfec_fastreg_mode_tx"))&&($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx!="teng_fastreg_mode_tx")) }] {
         set legal_values [intersect $legal_values [list "delay2_path0"]]
      } else {
         set legal_values [intersect $legal_values [list "delay2_path3"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_tx_pld_pcs_interface_pcs_tx_output_sel { device_revision hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx } {

   set legal_values [list "krfec_output" "teng_output"]

   if [expr { ((($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="teng_and_krfec_pld_fifo_mode_tx")||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="teng_and_krfec_reg_mode_tx"))||($hssi_tx_pld_pcs_interface_hd_pldif_prot_mode_tx=="teng_and_krfec_fastreg_mode_tx")) }] {
      set legal_values [intersect $legal_values [list "krfec_output"]]
   } else {
      set legal_values [intersect $legal_values [list "teng_output"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm1_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm3_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm4es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 385000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 379000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es2_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 312500000]
               }
            } else {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 355000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 322265625]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 385000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pld_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_hip_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 250000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 125000000]
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_hip_en=="enable") }] {
            set legal_values [compare_eq $legal_values 0]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               set legal_values [compare_le $legal_values 250000000]
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               set legal_values [compare_le $legal_values 125000000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 172121212]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 215151515]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  set legal_values [compare_eq $legal_values 0]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_eq $legal_values 0]
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_eq $legal_values 0]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 290400000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 264000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 240000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 400000000]
                  } else {
                     set legal_values [compare_eq $legal_values 0]
                  }
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 266200000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 300000000]
                        } else {
                           set legal_values [compare_le $legal_values 270336000]
                        }
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 242000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 250000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 220000000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        set legal_values [compare_le $legal_values 223420000]
                     } else {
                        set legal_values [compare_eq $legal_values 0]
                     }
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 484848485]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 393939394]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 215151515]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_eq $legal_values 0]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 236742425]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 189400000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 156250000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 236742425]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 189400000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx { device_revision hssi_tx_pld_pcs_interface_hd_chnl_func_mode hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_sup_mode } {

   set legal_values [list "pcie_g3_dyn_dw_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx" "pma_8b_tx"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_func_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "pma_64b_tx"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
            set legal_values [intersect $legal_values [list "pma_10b_tx" "pma_20b_tx"]]
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx")) }] {
               set legal_values [intersect $legal_values [list "pma_10b_tx"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
                  set legal_values [intersect $legal_values [list "pcie_g3_dyn_dw_tx"]]
               } else {
                  if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx")) }] {
                     set legal_values [intersect $legal_values [list "pma_10b_tx"]]
                  } else {
                     if [expr { ((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx")) }] {
                        set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
                           set legal_values [intersect $legal_values [list "pma_40b_tx"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
                              set legal_values [intersect $legal_values [list "pma_32b_tx" "pma_40b_tx"]]
                           } else {
                              if [expr { ((((((($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx"))||($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx")) }] {
                                 set legal_values [intersect $legal_values [list "pma_64b_tx"]]
                              } else {
                                 if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
                                    set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
                                 } else {
                                    if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
                                       if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_sup_mode=="user_mode") }] {
                                          set legal_values [intersect $legal_values [list "pma_16b_tx" "pma_20b_tx"]]
                                       } else {
                                          set legal_values [intersect $legal_values [list "pma_8b_tx" "pma_10b_tx" "pma_16b_tx" "pma_20b_tx" "pma_32b_tx" "pma_40b_tx" "pma_64b_tx"]]
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

   return $legal_values
}


proc ::nf_xcvr_native::parameters::20nm5es_getValue_hssi_tx_pld_pcs_interface_hd_chnl_pma_tx_clk_hz { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx hssi_tx_pld_pcs_interface_hd_chnl_speed_grade } {

   set legal_values [list 0:1073741823]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_frequency_rules_en=="disable") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g1_capable_tx") }] {
         set legal_values [compare_le $legal_values 250000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g2_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcie_g3_capable_tx") }] {
         set legal_values [compare_le $legal_values 500000000]
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 312500000]
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="fortyg_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="cpri_8b10b_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 307200000]
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               set legal_values [compare_le $legal_values 307200000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  set legal_values [compare_le $legal_values 307200000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 491520000]
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri") }] {
                     set legal_values [compare_le $legal_values 491520000]
                  } else {
                     set legal_values [compare_le $legal_values 307200000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="interlaken_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 439062500]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 403125000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 271875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 443750000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 328125000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sfis_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_sdi_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 267500000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="gige_1588_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 250000000]
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
            set legal_values [compare_le $legal_values 250000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_baser_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         } else {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 355000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="teng_1588_basekr_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_8gpcs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_10b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_8b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 580800000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 528000000]
               }
            }
            if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
                  set legal_values [compare_le $legal_values 480000000]
               }
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_16b_tx")||($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx")) }] {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                     set legal_values [compare_le $legal_values 515625000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  set legal_values [compare_le $legal_values 400000000]
               }
            }
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 532400000]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_20b_tx") }] {
                           set legal_values [compare_le $legal_values 600000000]
                        } else {
                           set legal_values [compare_le $legal_values 540672000]
                        }
                     } else {
                        set legal_values [compare_le $legal_values 540672000]
                     }
                  }
               }
               if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 484000000]
                  } else {
                     set legal_values [compare_le $legal_values 500000000]
                  }
               }
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4") }] {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_chnl_prot_mode_rx=="basic_8gpcs_rm_enable_rx") }] {
                     set legal_values [compare_le $legal_values 440000000]
                  } else {
                     set legal_values [compare_le $legal_values 446840000]
                  }
               }
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pld_fifo_mode_tx=="fifo_tx") }] {
                  set legal_values [compare_le $legal_values 439062500]
               } else {
                  set legal_values [compare_le $legal_values 406250000]
               }
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable")&&($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx")) }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="basic_10gpcs_krfec_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="enable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_low_latency_en_tx=="disable") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="pcs_direct_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 221875000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 385000000]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 500000000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 406250000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 352500000]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="uhsif_tx") }] {
         if [expr { (((($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3"))||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 644531250]
            set legal_values [compare_ge $legal_values 400000000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_tx") }] {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_64b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 244140625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 195312500]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_32b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 322265625]
            }
         }
         if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_pma_dw_tx=="pma_40b_tx") }] {
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
               set legal_values [compare_le $legal_values 390625000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
               set legal_values [compare_le $legal_values 312500000]
            }
            if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
               set legal_values [compare_le $legal_values 258037500]
            }
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prp_krfec_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 322265625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 244140625]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 195312500]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="prbs_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 390625000]
         }
      }
      if [expr { ($hssi_tx_pld_pcs_interface_hd_chnl_prot_mode_tx=="sqwave_tx") }] {
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e2")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i2")) }] {
            set legal_values [compare_le $legal_values 500000000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e3")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i3")) }] {
            set legal_values [compare_le $legal_values 406250000]
         }
         if [expr { (($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="e4")||($hssi_tx_pld_pcs_interface_hd_chnl_speed_grade=="i4")) }] {
            set legal_values [compare_le $legal_values 221875000]
         }
      }
   }

   return $legal_values
}


