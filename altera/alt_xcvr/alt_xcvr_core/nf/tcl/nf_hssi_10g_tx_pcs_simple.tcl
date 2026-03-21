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


proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_advanced_user_mode { device_revision hssi_10g_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_10g_advanced_user_mode_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_advanced_user_mode_tx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_bitslip_en { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "bitslip_dis" "bitslip_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   } else {
      if [expr { ((($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_mode"))||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
         set legal_values [intersect $legal_values [list "bitslip_dis" "bitslip_en"]]
      } else {
         set legal_values [intersect $legal_values [list "bitslip_dis"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_bonding_dft_en { device_revision } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_bonding_dft_val { device_revision } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_comp_cnt { device_revision hssi_10g_tx_pcs_ctrl_plane_bonding } {

   set legal_values [list 0:255]

   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="individual") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_compin_sel { device_revision hssi_10g_tx_pcs_ctrl_plane_bonding } {

   set legal_values [list "compin_default" "compin_master" "compin_slave_bot" "compin_slave_top"]

   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "compin_master"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "compin_master"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "compin_slave_bot"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "compin_slave_top"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_crcgen_bypass { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "crcgen_bypass_dis" "crcgen_bypass_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "crcgen_bypass_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "crcgen_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "crcgen_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "crcgen_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "crcgen_bypass_en"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_crcgen_clken { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "crcgen_clk_dis" "crcgen_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "crcgen_clk_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "crcgen_clk_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "crcgen_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "crcgen_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "crcgen_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_crcgen_err { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "crcgen_err_dis" "crcgen_err_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "crcgen_err_dis" "crcgen_err_en"]]
   } else {
      set legal_values [intersect $legal_values [list "crcgen_err_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_crcgen_inv { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "crcgen_inv_dis" "crcgen_inv_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "crcgen_inv_en"]]
   } else {
      set legal_values [intersect $legal_values [list "crcgen_inv_en"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_ctrl_bit_reverse { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "ctrl_bit_reverse_dis" "ctrl_bit_reverse_en"]

   if [expr { ((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode")) }] {
      set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]
      } else {
         set legal_values [intersect $legal_values [list "ctrl_bit_reverse_dis"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_ctrl_plane_bonding { device_revision hssi_10g_tx_pcs_prot_mode hssi_8g_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx } {

   set legal_values [list "ctrl_master" "ctrl_slave_abv" "ctrl_slave_blw" "individual"]

   if [expr { (($hssi_10g_tx_pcs_prot_mode=="disable_mode")&&($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode")) }] {
      set legal_values [intersect $legal_values [list "individual"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="individual_tx") }] {
      set legal_values [intersect $legal_values [list "individual"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
      set legal_values [intersect $legal_values [list "ctrl_master"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
      set legal_values [intersect $legal_values [list "ctrl_slave_blw"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
      set legal_values [intersect $legal_values [list "ctrl_slave_abv"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_data_bit_reverse { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "data_bit_reverse_dis" "data_bit_reverse_en"]

   if [expr { ((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode")) }] {
      set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "data_bit_reverse_en"]]
      } else {
         set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_dft_clk_out_sel { device_revision } {

   set legal_values [list "tx_64b66benc_txsm_clk" "tx_crcgen_clk" "tx_dispgen_clk" "tx_fec_clk" "tx_frmgen_clk" "tx_gbred_clk" "tx_master_clk" "tx_rdfifo_clk" "tx_scrm_clk" "tx_wrfifo_clk"]

   set legal_values [intersect $legal_values [list "tx_master_clk"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_dispgen_bypass { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "dispgen_bypass_dis" "dispgen_bypass_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "dispgen_bypass_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "dispgen_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "dispgen_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { (($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67")) }] {
                  set legal_values [intersect $legal_values [list "dispgen_bypass_dis"]]
               } else {
                  set legal_values [intersect $legal_values [list "dispgen_bypass_en"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "dispgen_bypass_en"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_dispgen_clken { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "dispgen_clk_dis" "dispgen_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "dispgen_clk_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "dispgen_clk_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "dispgen_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { (($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67")) }] {
                  set legal_values [intersect $legal_values [list "dispgen_clk_en"]]
               } else {
                  set legal_values [intersect $legal_values [list "dispgen_clk_dis"]]
               }
            } else {
               set legal_values [intersect $legal_values [list "dispgen_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_dispgen_err { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "dispgen_err_dis" "dispgen_err_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dispgen_err_dis" "dispgen_err_en"]]
      } else {
         set legal_values [intersect $legal_values [list "dispgen_err_dis"]]
      }
   } else {
      if [expr { ((($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67"))&&($hssi_10g_tx_pcs_prot_mode=="basic_mode")) }] {
         set legal_values [intersect $legal_values [list "dispgen_err_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "dispgen_err_dis"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_dispgen_pipeln { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "dispgen_pipeln_dis" "dispgen_pipeln_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dispgen_pipeln_en" "dispgen_pipeln_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "dispgen_pipeln_dis"]]
      }
   } else {
      if [expr { ((($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67"))&&($hssi_10g_tx_pcs_prot_mode=="basic_mode")) }] {
         set legal_values [intersect $legal_values [list "dispgen_pipeln_en"]]
      } else {
         set legal_values [intersect $legal_values [list "dispgen_pipeln_dis"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_distdwn_bypass_pipeln { device_revision } {

   set legal_values [list "distdwn_bypass_pipeln_dis" "distdwn_bypass_pipeln_en"]

   set legal_values [intersect $legal_values [list "distdwn_bypass_pipeln_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_distdwn_master { device_revision hssi_10g_tx_pcs_ctrl_plane_bonding } {

   set legal_values [list "distdwn_master_dis" "distdwn_master_en"]

   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "distdwn_master_en"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "distdwn_master_en"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "distdwn_master_dis"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "distdwn_master_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_distup_bypass_pipeln { device_revision } {

   set legal_values [list "distup_bypass_pipeln_dis" "distup_bypass_pipeln_en"]

   set legal_values [intersect $legal_values [list "distup_bypass_pipeln_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_distup_master { device_revision hssi_10g_tx_pcs_ctrl_plane_bonding } {

   set legal_values [list "distup_master_dis" "distup_master_en"]

   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "distup_master_en"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "distup_master_en"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "distup_master_dis"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "distup_master_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_dv_bond { device_revision hssi_10g_tx_pcs_indv } {

   set legal_values [list "dv_bond_dis" "dv_bond_en"]

   if [expr { ($hssi_10g_tx_pcs_indv=="indv_dis") }] {
      set legal_values [intersect $legal_values [list "dv_bond_en"]]
   } else {
      set legal_values [intersect $legal_values [list "dv_bond_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_empty_flag_type { device_revision } {

   set legal_values [list "empty_rd_side" "empty_wr_side"]

   set legal_values [intersect $legal_values [list "empty_rd_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_enc64b66b_txsm_clken { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "enc64b66b_txsm_clk_dis" "enc64b66b_txsm_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "enc64b66b_txsm_clk_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "enc64b66b_txsm_clk_dis"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "enc64b66b_txsm_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "enc64b66b_txsm_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "enc64b66b_txsm_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_enc_64b66b_txsm_bypass { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "enc_64b66b_txsm_bypass_dis" "enc_64b66b_txsm_bypass_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "enc_64b66b_txsm_bypass_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "enc_64b66b_txsm_bypass_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "enc_64b66b_txsm_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "enc_64b66b_txsm_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "enc_64b66b_txsm_bypass_en"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_fastpath { device_revision hssi_10g_tx_pcs_crcgen_bypass hssi_10g_tx_pcs_dispgen_bypass hssi_10g_tx_pcs_enc_64b66b_txsm_bypass hssi_10g_tx_pcs_frmgen_bypass hssi_10g_tx_pcs_scrm_bypass } {

   set legal_values [list "fastpath_dis" "fastpath_en"]

   if [expr { ((((($hssi_10g_tx_pcs_frmgen_bypass=="frmgen_bypass_en")&&($hssi_10g_tx_pcs_crcgen_bypass=="crcgen_bypass_en"))&&($hssi_10g_tx_pcs_enc_64b66b_txsm_bypass=="enc_64b66b_txsm_bypass_en"))&&($hssi_10g_tx_pcs_scrm_bypass=="scrm_bypass_en"))&&($hssi_10g_tx_pcs_dispgen_bypass=="dispgen_bypass_en")) }] {
      set legal_values [intersect $legal_values [list "fastpath_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fastpath_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_fec_clken { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "fec_clk_dis" "fec_clk_en"]

   if [expr { (((($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "fec_clk_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fec_clk_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_fec_enable { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "fec_dis" "fec_en"]

   if [expr { (((($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "fec_en"]]
   } else {
      set legal_values [intersect $legal_values [list "fec_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_fifo_double_write { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_txfifo_mode hssi_tx_pld_pcs_interface_hd_10g_shared_fifo_width_tx } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "fifo_double_write_dis" "fifo_double_write_en"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_shared_fifo_width_tx=="single_tx") }] {
      set legal_values [intersect $legal_values [list "fifo_double_write_dis"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_shared_fifo_width_tx=="double_tx") }] {
      set legal_values [intersect $legal_values [list "fifo_double_write_en"]]
   }
   if [expr { (((($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode"))&&($hssi_10g_tx_pcs_txfifo_mode=="phase_comp"))&&(((($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_40"))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64")))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_66")))) }] {
      set legal_values [intersect $legal_values [list "fifo_double_write_en" "fifo_double_write_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "fifo_double_write_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_fifo_reg_fast { device_revision hssi_10g_tx_pcs_pld_if_type } {

   set legal_values [list "fifo_reg_fast_dis" "fifo_reg_fast_en"]

   if [expr { ($hssi_10g_tx_pcs_pld_if_type=="reg") }] {
      set legal_values [intersect $legal_values [list "fifo_reg_fast_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_pld_if_type=="fastreg") }] {
         set legal_values [intersect $legal_values [list "fifo_reg_fast_en"]]
      } else {
         set legal_values [intersect $legal_values [list "fifo_reg_fast_dis"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_fifo_stop_rd { device_revision hssi_10g_tx_pcs_ctrl_plane_bonding hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_txfifo_mode } {

   set legal_values [list "n_rd_empty" "rd_empty"]

   if [expr { (($hssi_10g_tx_pcs_prot_mode=="interlaken_mode")&&($hssi_10g_tx_pcs_ctrl_plane_bonding!="individual")) }] {
      set legal_values [intersect $legal_values [list "rd_empty"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_txfifo_mode=="phase_comp") }] {
         set legal_values [intersect $legal_values [list "rd_empty"]]
      } else {
         set legal_values [intersect $legal_values [list "n_rd_empty"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_fifo_stop_wr { device_revision } {

   set legal_values [list "n_wr_full" "wr_full"]

   set legal_values [intersect $legal_values [list "n_wr_full"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_frmgen_burst { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "frmgen_burst_dis" "frmgen_burst_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "frmgen_burst_en" "frmgen_burst_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "frmgen_burst_en" "frmgen_burst_dis"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "frmgen_burst_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_frmgen_bypass { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "frmgen_bypass_dis" "frmgen_bypass_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "frmgen_bypass_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "frmgen_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "frmgen_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "frmgen_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "frmgen_bypass_en"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_frmgen_clken { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "frmgen_clk_dis" "frmgen_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "frmgen_clk_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "frmgen_clk_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "frmgen_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "frmgen_clk_dis"]]
            } else {
               set legal_values [intersect $legal_values [list "frmgen_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_frmgen_mfrm_length { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list 0:65535]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [compare_ge $legal_values 5]
      set legal_values [compare_le $legal_values 65535]
   } else {
      set legal_values [compare_eq $legal_values 2048]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_frmgen_pipeln { device_revision hssi_10g_tx_pcs_low_latency_en hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "frmgen_pipeln_dis" "frmgen_pipeln_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "frmgen_pipeln_en" "frmgen_pipeln_dis"]]
      } else {
         if [expr { ($hssi_10g_tx_pcs_low_latency_en=="enable") }] {
            set legal_values [intersect $legal_values [list "frmgen_pipeln_dis"]]
         } else {
            set legal_values [intersect $legal_values [list "frmgen_pipeln_en"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "frmgen_pipeln_en"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_frmgen_pyld_ins { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "frmgen_pyld_ins_dis" "frmgen_pyld_ins_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "frmgen_pyld_ins_en" "frmgen_pyld_ins_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "frmgen_pyld_ins_dis"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "frmgen_pyld_ins_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_frmgen_wordslip { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "frmgen_wordslip_dis" "frmgen_wordslip_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "frmgen_wordslip_en" "frmgen_wordslip_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "frmgen_wordslip_dis"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "frmgen_wordslip_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_full_flag_type { device_revision } {

   set legal_values [list "full_rd_side" "full_wr_side"]

   set legal_values [intersect $legal_values [list "full_wr_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_gb_pipeln_bypass { device_revision hssi_10g_tx_pcs_bitslip_en hssi_10g_tx_pcs_low_latency_en hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_10g_tx_pcs_bitslip_en=="bitslip_en")||($hssi_10g_tx_pcs_prot_mode=="disable_mode")) }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      if [expr { (($hssi_10g_tx_pcs_low_latency_en=="enable")&&($hssi_10g_tx_pcs_prot_mode!="teng_baser_mode")) }] {
         set legal_values [intersect $legal_values [list "disable" "enable"]]
      } else {
         set legal_values [intersect $legal_values [list "disable"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_gb_tx_idwidth { device_revision hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "idwidth_32" "idwidth_40" "idwidth_50" "idwidth_64" "idwidth_66" "idwidth_67"]

   if [expr { ((((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "idwidth_66"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "idwidth_67"]]
      } else {
         if [expr { ($hssi_10g_tx_pcs_prot_mode=="sfis_mode") }] {
            if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32") }] {
               set legal_values [intersect $legal_values [list "idwidth_32" "idwidth_64"]]
            } else {
               if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40") }] {
                  if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
                     set legal_values [intersect $legal_values [list "idwidth_40" "idwidth_64"]]
                  } else {
                     set legal_values [intersect $legal_values [list "idwidth_40"]]
                  }
               } else {
                  set legal_values [intersect $legal_values [list "idwidth_64"]]
               }
            }
         } else {
            if [expr { ($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode") }] {
               if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
                  set legal_values [intersect $legal_values [list "idwidth_40" "idwidth_50"]]
               } else {
                  set legal_values [intersect $legal_values [list "idwidth_50"]]
               }
            } else {
               if [expr { ($hssi_10g_tx_pcs_prot_mode=="basic_mode") }] {
                  if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32") }] {
                     if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
                        set legal_values [intersect $legal_values [list "idwidth_32" "idwidth_64" "idwidth_66" "idwidth_67"]]
                     } else {
                        set legal_values [intersect $legal_values [list "idwidth_32" "idwidth_64" "idwidth_66"]]
                     }
                  } else {
                     if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40") }] {
                        if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
                           set legal_values [intersect $legal_values [list "idwidth_40" "idwidth_64" "idwidth_66" "idwidth_67"]]
                        } else {
                           set legal_values [intersect $legal_values [list "idwidth_40" "idwidth_66"]]
                        }
                     } else {
                        set legal_values [intersect $legal_values [list "idwidth_64" "idwidth_66" "idwidth_67"]]
                     }
                  }
               } else {
                  if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32") }] {
                     set legal_values [intersect $legal_values [list "idwidth_32"]]
                  } else {
                     if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40") }] {
                        set legal_values [intersect $legal_values [list "idwidth_40"]]
                     } else {
                        set legal_values [intersect $legal_values [list "idwidth_64"]]
                     }
                  }
               }
            }
         }
      }
   }

   set legal_values [convert_b2a_hssi_10g_tx_pcs_gb_tx_idwidth $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_gb_tx_odwidth { device_revision hssi_tx_pld_pcs_interface_hd_10g_pma_dw_tx } {

   set legal_values [list "odwidth_32" "odwidth_40" "odwidth_64"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_pma_dw_tx=="pma_64b_tx") }] {
      set legal_values [intersect $legal_values [list "odwidth_64"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_pma_dw_tx=="pma_40b_tx") }] {
         set legal_values [intersect $legal_values [list "odwidth_40"]]
      } else {
         set legal_values [intersect $legal_values [list "odwidth_32"]]
      }
   }

   set legal_values [convert_b2a_hssi_10g_tx_pcs_gb_tx_odwidth $legal_values]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_gbred_clken { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "gbred_clk_dis" "gbred_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "gbred_clk_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "gbred_clk_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "gbred_clk_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "gbred_clk_en"]]
            } else {
               set legal_values [intersect $legal_values [list "gbred_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_indv { device_revision hssi_10g_tx_pcs_ctrl_plane_bonding } {

   set legal_values [list "indv_dis" "indv_en"]

   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="individual") }] {
      set legal_values [intersect $legal_values [list "indv_en"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_master") }] {
      set legal_values [intersect $legal_values [list "indv_dis"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_blw") }] {
      set legal_values [intersect $legal_values [list "indv_dis"]]
   }
   if [expr { ($hssi_10g_tx_pcs_ctrl_plane_bonding=="ctrl_slave_abv") }] {
      set legal_values [intersect $legal_values [list "indv_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_low_latency_en { device_revision hssi_tx_pld_pcs_interface_hd_10g_low_latency_en_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_low_latency_en_tx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_master_clk_sel { device_revision hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "master_refclk_dig" "master_tx_pma_clk"]

   if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "master_tx_pma_clk" "master_refclk_dig"]]
   } else {
      set legal_values [intersect $legal_values [list "master_tx_pma_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_pempty_flag_type { device_revision } {

   set legal_values [list "pempty_rd_side" "pempty_wr_side"]

   set legal_values [intersect $legal_values [list "pempty_rd_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_pfull_flag_type { device_revision } {

   set legal_values [list "pfull_rd_side" "pfull_wr_side"]

   set legal_values [intersect $legal_values [list "pfull_wr_side"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_phcomp_rd_del { device_revision hssi_10g_tx_pcs_fifo_double_write hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_low_latency_en hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode hssi_10g_tx_pcs_txfifo_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "phcomp_rd_del2" "phcomp_rd_del3" "phcomp_rd_del4" "phcomp_rd_del5" "phcomp_rd_del6"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "phcomp_rd_del2"]]
   } else {
      if [expr { (($hssi_10g_tx_pcs_txfifo_mode=="phase_comp")&&($hssi_10g_tx_pcs_fifo_double_write=="fifo_double_write_dis")) }] {
         if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
            set legal_values [intersect $legal_values [list "phcomp_rd_del4" "phcomp_rd_del3" "phcomp_rd_del2"]]
         } else {
            if [expr { ($hssi_10g_tx_pcs_low_latency_en=="disable") }] {
               set legal_values [intersect $legal_values [list "phcomp_rd_del4"]]
            } else {
               if [expr { (((($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_32"))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_40")))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64"))) }] {
                  set legal_values [intersect $legal_values [list "phcomp_rd_del2"]]
               } else {
                  if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32") }] {
                     if [expr { ($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64") }] {
                        set legal_values [intersect $legal_values [list "phcomp_rd_del3"]]
                     } else {
                        set legal_values [intersect $legal_values [list "phcomp_rd_del4"]]
                     }
                  } else {
                     if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40") }] {
                        if [expr { ($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_50") }] {
                           set legal_values [intersect $legal_values [list "phcomp_rd_del3"]]
                        } else {
                           set legal_values [intersect $legal_values [list "phcomp_rd_del4"]]
                        }
                     } else {
                        set legal_values [intersect $legal_values [list "phcomp_rd_del3"]]
                     }
                  }
               }
            }
         }
      } else {
         if [expr { (($hssi_10g_tx_pcs_txfifo_mode=="phase_comp")&&($hssi_10g_tx_pcs_fifo_double_write=="fifo_double_write_en")) }] {
            if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
               set legal_values [intersect $legal_values [list "phcomp_rd_del4" "phcomp_rd_del3"]]
            } else {
               if [expr { ($hssi_10g_tx_pcs_low_latency_en=="disable") }] {
                  set legal_values [intersect $legal_values [list "phcomp_rd_del4"]]
               } else {
                  if [expr { (((($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_32"))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_40")))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64"))) }] {
                     set legal_values [intersect $legal_values [list "phcomp_rd_del3"]]
                  } else {
                     set legal_values [intersect $legal_values [list "phcomp_rd_del4"]]
                  }
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "phcomp_rd_del2"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_pld_if_type { device_revision hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx } {

   set legal_values [list "fastreg" "fifo" "reg"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx=="reg_tx") }] {
      set legal_values [intersect $legal_values [list "reg"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_fifo_mode_tx=="fastreg_tx") }] {
         set legal_values [intersect $legal_values [list "fastreg"]]
      } else {
         set legal_values [intersect $legal_values [list "fifo"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_prot_mode { device_revision hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "basic_krfec_mode" "basic_mode" "disable_mode" "interlaken_mode" "sfis_mode" "teng_1588_krfec_mode" "teng_1588_mode" "teng_baser_krfec_mode" "teng_baser_mode" "teng_sdi_mode" "test_prp_krfec_mode" "test_prp_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_baser_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_1588_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="interlaken_mode_tx") }] {
      set legal_values [intersect $legal_values [list "interlaken_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="sfis_mode_tx") }] {
      set legal_values [intersect $legal_values [list "sfis_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_sdi_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_sdi_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_mode_tx") }] {
      set legal_values [intersect $legal_values [list "basic_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_mode_tx") }] {
      set legal_values [intersect $legal_values [list "test_prp_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="test_prp_krfec_mode_tx") }] {
      set legal_values [intersect $legal_values [list "test_prp_krfec_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disable_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_baser_krfec_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_baser_krfec_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="teng_1588_krfec_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_1588_krfec_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="basic_krfec_mode_tx") }] {
      set legal_values [intersect $legal_values [list "basic_krfec_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_pseudo_random { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_test_mode } {

   set legal_values [list "all_0" "two_lf"]

   if [expr { ($hssi_10g_tx_pcs_test_mode=="pseudo_random") }] {
      set legal_values [intersect $legal_values [list "all_0" "two_lf"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "all_0"]]
      } else {
         set legal_values [intersect $legal_values [list "all_0"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_pseudo_seed_a { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_test_mode } {

   set legal_values [list 0:288230376151711743]

   if [expr { !(($hssi_10g_tx_pcs_test_mode=="pseudo_random")) }] {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [compare_gt $legal_values 0]
      } else {
         set legal_values [compare_eq $legal_values 288230376151711743]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_pseudo_seed_b { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_test_mode } {

   set legal_values [list 0:288230376151711743]

   if [expr { !(($hssi_10g_tx_pcs_test_mode=="pseudo_random")) }] {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [compare_eq $legal_values 288230376151711743]
      } else {
         set legal_values [compare_eq $legal_values 288230376151711743]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_random_disp { device_revision hssi_10g_tx_pcs_low_latency_en hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { (($hssi_10g_tx_pcs_low_latency_en=="enable")&&($hssi_10g_tx_pcs_prot_mode=="interlaken_mode")) }] {
      set legal_values [intersect $legal_values [list "disable" "enable"]]
   } else {
      set legal_values [intersect $legal_values [list "disable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_rdfifo_clken { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "rdfifo_clk_dis" "rdfifo_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "rdfifo_clk_en"]]
            } else {
               set legal_values [intersect $legal_values [list "rdfifo_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_scrm_bypass { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "scrm_bypass_dis" "scrm_bypass_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "scrm_bypass_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "scrm_bypass_dis"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "scrm_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { (($hssi_10g_tx_pcs_sup_mode=="engineering_mode")&&((($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64")||($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_66"))||($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67"))) }] {
                  set legal_values [intersect $legal_values [list "scrm_bypass_dis" "scrm_bypass_en"]]
               } else {
                  if [expr { ((($hssi_10g_tx_pcs_sup_mode=="user_mode")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_66"))&&($hssi_10g_tx_pcs_prot_mode=="basic_mode")) }] {
                     if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32") }] {
                        set legal_values [intersect $legal_values [list "scrm_bypass_dis"]]
                     } else {
                        set legal_values [intersect $legal_values [list "scrm_bypass_dis" "scrm_bypass_en"]]
                     }
                  } else {
                     set legal_values [intersect $legal_values [list "scrm_bypass_en"]]
                  }
               }
            } else {
               set legal_values [intersect $legal_values [list "scrm_bypass_en"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_scrm_clken { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_scrm_bypass hssi_10g_tx_pcs_sup_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]

   set legal_values [list "scrm_clk_dis" "scrm_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "scrm_clk_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "scrm_clk_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "scrm_clk_dis"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               if [expr { (($hssi_10g_tx_pcs_sup_mode=="engineering_mode")&&((($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64")||($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_66"))||($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67"))) }] {
                  set legal_values [intersect $legal_values [list "scrm_clk_en"]]
               } else {
                  if [expr { ((($hssi_10g_tx_pcs_sup_mode=="user_mode")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_66"))&&($hssi_10g_tx_pcs_prot_mode=="basic_mode")) }] {
                     if [expr { ($hssi_10g_tx_pcs_scrm_bypass=="scrm_bypass_dis") }] {
                        set legal_values [intersect $legal_values [list "scrm_clk_en"]]
                     } else {
                        set legal_values [intersect $legal_values [list "scrm_clk_dis"]]
                     }
                  } else {
                     set legal_values [intersect $legal_values [list "scrm_clk_dis"]]
                  }
               }
            } else {
               set legal_values [intersect $legal_values [list "scrm_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_scrm_mode { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "async" "sync"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      set legal_values [intersect $legal_values [list "sync"]]
   } else {
      set legal_values [intersect $legal_values [list "async"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_scrm_pipeln { device_revision hssi_10g_tx_pcs_low_latency_en hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_low_latency_en=="enable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      } else {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   } else {
      if [expr { ($hssi_10g_tx_pcs_low_latency_en=="enable") }] {
         set legal_values [intersect $legal_values [list "disable"]]
      } else {
         set legal_values [intersect $legal_values [list "enable"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_sh_err { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "sh_err_dis" "sh_err_en"]

   if [expr { ((((($hssi_10g_tx_pcs_prot_mode=="interlaken_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "sh_err_en" "sh_err_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "sh_err_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_sop_mark { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "sop_mark_dis" "sop_mark_en"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode") }] {
      set legal_values [intersect $legal_values [list "sop_mark_en" "sop_mark_dis"]]
   } else {
      set legal_values [intersect $legal_values [list "sop_mark_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_stretch_num_stages { device_revision hssi_10g_tx_pcs_fifo_double_write hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "one_stage" "three_stage" "two_stage" "zero_stage"]

   if [expr { ($hssi_10g_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "zero_stage"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "zero_stage" "one_stage" "two_stage" "three_stage"]]
      } else {
         if [expr { ($hssi_10g_tx_pcs_fifo_double_write=="fifo_double_write_dis") }] {
            if [expr { (((($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_32"))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_40")))||(($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64"))) }] {
               set legal_values [intersect $legal_values [list "one_stage"]]
            } else {
               if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_40") }] {
                  set legal_values [intersect $legal_values [list "one_stage"]]
               } else {
                  if [expr { ($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_32") }] {
                     if [expr { ($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_64") }] {
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
            if [expr { (($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_66")) }] {
               set legal_values [intersect $legal_values [list "two_stage"]]
            } else {
               set legal_values [intersect $legal_values [list "two_stage"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_10g_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_test_mode { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "pseudo_random" "test_off"]

   if [expr { (($hssi_10g_tx_pcs_prot_mode=="test_prp_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "pseudo_random"]]
   } else {
      set legal_values [intersect $legal_values [list "test_off"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_tx_scrm_err { device_revision hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_scrm_bypass hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "scrm_err_dis" "scrm_err_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="interlaken_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode"))||(($hssi_10g_tx_pcs_prot_mode=="basic_mode")&&($hssi_10g_tx_pcs_scrm_bypass=="scrm_bypass_dis"))) }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "scrm_err_en" "scrm_err_dis"]]
      } else {
         set legal_values [intersect $legal_values [list "scrm_err_dis"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "scrm_err_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_tx_scrm_width { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "bit64" "bit66" "bit67"]

   if [expr { ((((($hssi_10g_tx_pcs_prot_mode=="interlaken_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "bit64"]]
   } else {
      set legal_values [intersect $legal_values [list "bit64"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_tx_sh_location { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "lsb" "msb"]

   if [expr { ((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode")) }] {
      set legal_values [intersect $legal_values [list "lsb"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "lsb"]]
      } else {
         set legal_values [intersect $legal_values [list "msb"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_tx_sm_bypass { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "tx_sm_bypass_dis" "tx_sm_bypass_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "tx_sm_bypass_dis"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "tx_sm_bypass_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "tx_sm_bypass_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "tx_sm_bypass_en"]]
            } else {
               set legal_values [intersect $legal_values [list "tx_sm_bypass_en"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_tx_sm_pipeln { device_revision hssi_10g_tx_pcs_low_latency_en hssi_10g_tx_pcs_prot_mode hssi_10g_tx_pcs_sup_mode } {

   set legal_values [list "tx_sm_pipeln_dis" "tx_sm_pipeln_en"]

   if [expr { (((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "tx_sm_pipeln_en" "tx_sm_pipeln_dis"]]
      } else {
         if [expr { ($hssi_10g_tx_pcs_low_latency_en=="enable") }] {
            set legal_values [intersect $legal_values [list "tx_sm_pipeln_dis"]]
         } else {
            set legal_values [intersect $legal_values [list "tx_sm_pipeln_en"]]
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "tx_sm_pipeln_en"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_tx_testbus_sel { device_revision hssi_10g_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx } {

   set legal_values [list "blank_testbus" "crc32_gen_testbus1" "crc32_gen_testbus2" "disp_gen_testbus1" "disp_gen_testbus2" "enc64b66b_testbus" "frame_gen_testbus1" "frame_gen_testbus2" "gearbox_red_testbus" "scramble_testbus" "txsm_testbus" "tx_cp_bond_testbus" "tx_fifo_testbus1" "tx_fifo_testbus2"]

   if [expr { (($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx")&&($hssi_rx_pld_pcs_interface_hd_10g_prot_mode_rx=="disabled_prot_mode_rx")) }] {
      set legal_values [intersect $legal_values [list "tx_fifo_testbus1"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_10g_prot_mode_tx=="disabled_prot_mode_tx") }] {
         set legal_values [intersect $legal_values [list "tx_fifo_testbus1"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_10g_test_bus_mode=="rx") }] {
            set legal_values [intersect $legal_values [list "tx_fifo_testbus1"]]
         }
      }
   }
   if [expr { ($hssi_10g_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "tx_fifo_testbus1"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_txfifo_mode { device_revision hssi_10g_tx_pcs_gb_tx_idwidth hssi_10g_tx_pcs_gb_tx_odwidth hssi_10g_tx_pcs_pld_if_type hssi_10g_tx_pcs_prot_mode } {
   set hssi_10g_tx_pcs_gb_tx_idwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_idwidth $hssi_10g_tx_pcs_gb_tx_idwidth]
   set hssi_10g_tx_pcs_gb_tx_odwidth [convert_a2b_hssi_10g_tx_pcs_gb_tx_odwidth $hssi_10g_tx_pcs_gb_tx_odwidth]

   set legal_values [list "basic_generic" "interlaken_generic" "phase_comp" "register_mode"]

   if [expr { ($hssi_10g_tx_pcs_pld_if_type=="reg") }] {
      set legal_values [intersect $legal_values [list "register_mode"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_pld_if_type=="fastreg") }] {
         set legal_values [intersect $legal_values [list "register_mode"]]
      } else {
         if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
            set legal_values [intersect $legal_values [list "interlaken_generic"]]
         } else {
            if [expr { ($hssi_10g_tx_pcs_prot_mode=="basic_mode") }] {
               if [expr { (($hssi_10g_tx_pcs_gb_tx_odwidth=="odwidth_64")&&($hssi_10g_tx_pcs_gb_tx_idwidth=="idwidth_67")) }] {
                  set legal_values [intersect $legal_values [list "basic_generic"]]
               } else {
                  set legal_values [intersect $legal_values [list "basic_generic" "phase_comp"]]
               }
            } else {
               if [expr { (($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode")) }] {
                  set legal_values [intersect $legal_values [list "phase_comp"]]
               } else {
                  if [expr { ($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode") }] {
                     set legal_values [intersect $legal_values [list "basic_generic" "phase_comp"]]
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

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_txfifo_pempty { device_revision hssi_10g_tx_pcs_advanced_user_mode hssi_10g_tx_pcs_sup_mode hssi_10g_tx_pcs_txfifo_mode } {

   set legal_values [list 0:15]

   if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
      if [expr { (($hssi_10g_tx_pcs_txfifo_mode=="interlaken_generic")||($hssi_10g_tx_pcs_txfifo_mode=="basic_generic")) }] {
         set legal_values [compare_ge $legal_values 1]
         set legal_values [compare_le $legal_values 5]
      } else {
         set legal_values [compare_eq $legal_values 2]
      }
   } else {
      if [expr { ($hssi_10g_tx_pcs_advanced_user_mode=="enable") }] {
         set legal_values [compare_ge $legal_values 1]
         set legal_values [compare_le $legal_values 8]
      } else {
         if [expr { (($hssi_10g_tx_pcs_txfifo_mode=="interlaken_generic")||($hssi_10g_tx_pcs_txfifo_mode=="basic_generic")) }] {
            set legal_values [compare_ge $legal_values 2]
            set legal_values [compare_le $legal_values 5]
         } else {
            set legal_values [compare_eq $legal_values 2]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_txfifo_pfull { device_revision hssi_10g_tx_pcs_advanced_user_mode hssi_10g_tx_pcs_sup_mode hssi_10g_tx_pcs_txfifo_mode hssi_10g_tx_pcs_txfifo_pempty } {

   set legal_values [list 0:15]

   if [expr { ($hssi_10g_tx_pcs_sup_mode=="engineering_mode") }] {
      if [expr { (($hssi_10g_tx_pcs_txfifo_mode=="interlaken_generic")||($hssi_10g_tx_pcs_txfifo_mode=="basic_generic")) }] {
         set legal_values [compare_ge $legal_values 6]
         set legal_values [compare_le $legal_values 14]
      } else {
         set legal_values [compare_eq $legal_values 11]
      }
   } else {
      if [expr { ($hssi_10g_tx_pcs_advanced_user_mode=="enable") }] {
         set legal_values [compare_ge $legal_values $hssi_10g_tx_pcs_txfifo_pempty]
      } else {
         if [expr { (($hssi_10g_tx_pcs_txfifo_mode=="interlaken_generic")||($hssi_10g_tx_pcs_txfifo_mode=="basic_generic")) }] {
            set legal_values [compare_ge $legal_values [expr { ($hssi_10g_tx_pcs_txfifo_pempty+8) }]]
            set legal_values [compare_le $legal_values 13]
         } else {
            set legal_values [compare_eq $legal_values 11]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_wr_clk_sel { device_revision hssi_10g_tx_pcs_master_clk_sel hssi_10g_tx_pcs_txfifo_mode } {

   set legal_values [list "wr_refclk_dig" "wr_tx_pld_clk" "wr_tx_pma_clk"]

   if [expr { ($hssi_10g_tx_pcs_txfifo_mode=="register_mode") }] {
      if [expr { ($hssi_10g_tx_pcs_master_clk_sel=="master_refclk_dig") }] {
         set legal_values [intersect $legal_values [list "wr_refclk_dig"]]
      } else {
         set legal_values [intersect $legal_values [list "wr_tx_pma_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "wr_tx_pld_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_10g_tx_pcs_wrfifo_clken { device_revision hssi_10g_tx_pcs_prot_mode } {

   set legal_values [list "wrfifo_clk_dis" "wrfifo_clk_en"]

   if [expr { (((((($hssi_10g_tx_pcs_prot_mode=="teng_baser_mode")||($hssi_10g_tx_pcs_prot_mode=="test_prp_mode"))||($hssi_10g_tx_pcs_prot_mode=="test_prp_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_baser_krfec_mode"))||($hssi_10g_tx_pcs_prot_mode=="teng_1588_krfec_mode")) }] {
      set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
   } else {
      if [expr { ($hssi_10g_tx_pcs_prot_mode=="interlaken_mode") }] {
         set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
      } else {
         if [expr { (($hssi_10g_tx_pcs_prot_mode=="sfis_mode")||($hssi_10g_tx_pcs_prot_mode=="teng_sdi_mode")) }] {
            set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
         } else {
            if [expr { (($hssi_10g_tx_pcs_prot_mode=="basic_mode")||($hssi_10g_tx_pcs_prot_mode=="basic_krfec_mode")) }] {
               set legal_values [intersect $legal_values [list "wrfifo_clk_en"]]
            } else {
               set legal_values [intersect $legal_values [list "wrfifo_clk_dis"]]
            }
         }
      }
   }

   return $legal_values
}

