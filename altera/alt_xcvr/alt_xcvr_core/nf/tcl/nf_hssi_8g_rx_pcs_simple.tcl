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


proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_auto_error_replacement { device_revision hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

   set legal_values [list "dis_err_replace" "en_err_replace"]

   if [expr { (((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_eightb_tenb_decoder=="en_8b10b_ibm"))&&((($hssi_8g_rx_pcs_pma_dw=="ten_bit")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm"))||(($hssi_8g_rx_pcs_pma_dw=="twenty_bit")&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl")))) }] {
      set legal_values [intersect $legal_values [list "dis_err_replace" "en_err_replace"]]
   } else {
      if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_err_replace"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_err_replace"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_auto_speed_nego { device_revision hssi_8g_rx_pcs_ctrl_plane_bonding_consumption hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_asn" "en_asn_g2_freq_scal"]

   if [expr { (($hssi_8g_rx_pcs_prot_mode=="pipe_g3")&&(($hssi_8g_rx_pcs_ctrl_plane_bonding_consumption=="individual")||($hssi_8g_rx_pcs_ctrl_plane_bonding_consumption=="bundled_master"))) }] {
      set legal_values [intersect $legal_values [list "en_asn_g2_freq_scal"]]
   } else {
      if [expr { (($hssi_8g_rx_pcs_prot_mode=="pipe_g2")&&(($hssi_8g_rx_pcs_ctrl_plane_bonding_consumption=="individual")||($hssi_8g_rx_pcs_ctrl_plane_bonding_consumption=="bundled_master"))) }] {
         set legal_values [intersect $legal_values [list "en_asn_g2_freq_scal"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_asn"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_bit_reversal { device_revision hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_bit_reversal" "en_bit_reversal"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")) }] {
      set legal_values [intersect $legal_values [list "dis_bit_reversal" "en_bit_reversal"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_bit_reversal"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_bonding_dft_en { device_revision } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_bonding_dft_val { device_revision } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_bypass_pipeline_reg { device_revision } {

   set legal_values [list "dis_bypass_pipeline" "en_bypass_pipeline"]

   set legal_values [intersect $legal_values [list "dis_bypass_pipeline"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_byte_deserializer { device_revision hssi_8g_rx_pcs_pipe_if_enable hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_byte_serializer hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode } {

   set legal_values [list "dis_bds" "en_bds_by_2" "en_bds_by_2_det" "en_bds_by_4"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode=="tx_rx_pair_enabled") }] {
      if [expr { ($hssi_8g_tx_pcs_byte_serializer=="dis_bs") }] {
         set legal_values [intersect $legal_values [list "dis_bds"]]
      } else {
         if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_2") }] {
            set legal_values [intersect $legal_values [list "en_bds_by_2"]]
         } else {
            if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_4") }] {
               set legal_values [intersect $legal_values [list "en_bds_by_4"]]
            }
         }
      }
   }
   if [expr { ($hssi_8g_rx_pcs_pipe_if_enable=="en_pipe3_rx") }] {
      set legal_values [intersect $legal_values [list "en_bds_by_4"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
         set legal_values [intersect $legal_values [list "dis_bds" "en_bds_by_2"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
            set legal_values [intersect $legal_values [list "dis_bds"]]
         } else {
            if [expr { ($hssi_8g_rx_pcs_prot_mode=="pipe_g2") }] {
               set legal_values [intersect $legal_values [list "en_bds_by_2"]]
            } else {
               set legal_values [intersect $legal_values [list "dis_bds" "en_bds_by_2"]]
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_cdr_ctrl_rxvalid_mask { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_rxvalid_mask" "en_rxvalid_mask"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_rxvalid_mask"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_rxvalid_mask"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clkcmp_pattern_n { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list 0:1048575]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="dis_rm") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="gige_rm") }] {
         set legal_values [compare_eq $legal_values 702083]
      } else {
         if [expr { (($hssi_8g_rx_pcs_rate_match=="pipe_rm")||($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm")) }] {
            set legal_values [compare_eq $legal_values 192892]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clkcmp_pattern_p { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list 0:1048575]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="dis_rm") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="gige_rm") }] {
         set legal_values [compare_eq $legal_values 664956]
      } else {
         if [expr { (($hssi_8g_rx_pcs_rate_match=="pipe_rm")||($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm")) }] {
            set legal_values [compare_eq $legal_values 855683]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_bds_dec_asn { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_bds_dec_asn_clk_gating" "en_bds_dec_asn_clk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_bds_dec_asn_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_bds_dec_asn_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_cdr_eidle { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_cdr_eidle_clk_gating" "en_cdr_eidle_clk_gating"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode!="pipe_g1")&&($hssi_8g_rx_pcs_prot_mode!="pipe_g2"))&&($hssi_8g_rx_pcs_prot_mode!="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_cdr_eidle_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_cdr_eidle_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_dw_pc_wrclk { device_revision hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_phase_compensation_fifo hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_dw_pc_wrclk_gating" "en_dw_pc_wrclk_gating"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode")||($hssi_8g_rx_pcs_phase_compensation_fifo=="register_fifo"))||((($hssi_8g_rx_pcs_pma_dw=="ten_bit")||($hssi_8g_rx_pcs_pma_dw=="eight_bit"))&&($hssi_8g_rx_pcs_byte_deserializer!="en_bds_by_4"))) }] {
      set legal_values [intersect $legal_values [list "en_dw_pc_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_pc_wrclk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_dw_rm_rd { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_dw_rm_rdclk_gating" "en_dw_rm_rdclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match!="dw_basic_rm") }] {
      set legal_values [intersect $legal_values [list "en_dw_rm_rdclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_rm_rdclk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_dw_rm_wr { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_dw_rm_wrclk_gating" "en_dw_rm_wrclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match!="dw_basic_rm") }] {
      set legal_values [intersect $legal_values [list "en_dw_rm_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_rm_wrclk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_dw_wa { device_revision hssi_8g_rx_pcs_pma_dw } {

   set legal_values [list "dis_dw_wa_clk_gating" "en_dw_wa_clk_gating"]

   if [expr { (($hssi_8g_rx_pcs_pma_dw=="eight_bit")||($hssi_8g_rx_pcs_pma_dw=="ten_bit")) }] {
      set legal_values [intersect $legal_values [list "en_dw_wa_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_wa_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_pc_rdclk { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_pc_rdclk_gating" "en_pc_rdclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_pc_rdclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_pc_rdclk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_sw_pc_wrclk { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_sw_pc_wrclk_gating" "en_sw_pc_wrclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_sw_pc_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_pc_wrclk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_sw_rm_rd { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_sw_rm_rdclk_gating" "en_sw_rm_rdclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="dis_rm") }] {
      set legal_values [intersect $legal_values [list "en_sw_rm_rdclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_rm_rdclk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_sw_rm_wr { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_sw_rm_wrclk_gating" "en_sw_rm_wrclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="dis_rm") }] {
      set legal_values [intersect $legal_values [list "en_sw_rm_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_rm_wrclk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_gate_sw_wa { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_sw_wa_clk_gating" "en_sw_wa_clk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_sw_wa_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_wa_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_clock_observation_in_pld_core { device_revision } {

   set legal_values [list "internal_cdr_eidle_clk" "internal_clk_2_b" "internal_dw_rm_rd_clk" "internal_dw_rm_wr_clk" "internal_dw_rx_wr_clk" "internal_dw_wa_clk" "internal_rx_pma_clk_gen3" "internal_rx_rcvd_clk_gen3" "internal_rx_rd_clk" "internal_sm_rm_wr_clk" "internal_sw_rm_rd_clk" "internal_sw_rx_wr_clk" "internal_sw_wa_clk"]

   set legal_values [intersect $legal_values [list "internal_sw_wa_clk"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_ctrl_plane_bonding_compensation { device_revision hssi_8g_rx_pcs_byte_deserializer } {

   set legal_values [list "dis_compensation" "en_compensation"]

   if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_4") }] {
      set legal_values [intersect $legal_values [list "en_compensation"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_compensation"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_ctrl_plane_bonding_consumption { device_revision hssi_10g_rx_pcs_prot_mode hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx } {

   set legal_values [list "bundled_master" "bundled_slave_above" "bundled_slave_below" "individual"]

   if [expr { (($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode")&&($hssi_10g_rx_pcs_prot_mode=="disable_mode")) }] {
      set legal_values [intersect $legal_values [list "individual"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx=="individual_rx") }] {
      set legal_values [intersect $legal_values [list "individual"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx=="ctrl_master_rx") }] {
         set legal_values [intersect $legal_values [list "bundled_master"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx=="ctrl_slave_abv_rx") }] {
            set legal_values [intersect $legal_values [list "bundled_slave_above"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx=="ctrl_slave_blw_rx") }] {
               set legal_values [intersect $legal_values [list "bundled_slave_below"]]
            }
         }
      }
   }
   if [expr { (((((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))||($hssi_8g_rx_pcs_prot_mode=="cpri"))||($hssi_8g_rx_pcs_prot_mode=="cpri_rx_tx"))||(($hssi_8g_rx_pcs_prot_mode=="gige")||($hssi_8g_rx_pcs_prot_mode=="gige_1588")))||($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode")) }] {
      set legal_values [intersect $legal_values [list "individual"]]
   } else {
      set legal_values [intersect $legal_values [list "individual" "bundled_master" "bundled_slave_below" "bundled_slave_above"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_ctrl_plane_bonding_distribution { device_revision hssi_8g_rx_pcs_ctrl_plane_bonding_consumption } {

   set legal_values [list "master_chnl_distr" "not_master_chnl_distr"]

   if [expr { ($hssi_8g_rx_pcs_ctrl_plane_bonding_consumption=="bundled_master") }] {
      set legal_values [intersect $legal_values [list "master_chnl_distr"]]
   } else {
      set legal_values [intersect $legal_values [list "not_master_chnl_distr"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_eidle_entry_eios { device_revision hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_eidle_eios" "en_eidle_eios"]

   if [expr { ($hssi_8g_rx_pcs_hip_mode=="en_hip") }] {
      set legal_values [intersect $legal_values [list "dis_eidle_eios"]]
   } else {
      if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "dis_eidle_eios" "en_eidle_eios"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_eidle_eios"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_eidle_entry_iei { device_revision hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_eidle_iei" "en_eidle_iei"]

   if [expr { ($hssi_8g_rx_pcs_hip_mode=="en_hip") }] {
      set legal_values [intersect $legal_values [list "dis_eidle_iei"]]
   } else {
      if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "dis_eidle_iei" "en_eidle_iei"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_eidle_iei"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_eidle_entry_sd { device_revision hssi_8g_rx_pcs_eidle_entry_iei hssi_8g_rx_pcs_hip_mode } {

   set legal_values [list "dis_eidle_sd" "en_eidle_sd"]

   if [expr { ($hssi_8g_rx_pcs_hip_mode=="en_hip") }] {
      set legal_values [intersect $legal_values [list "en_eidle_sd"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_eidle_entry_iei=="en_eidle_iei") }] {
         set legal_values [intersect $legal_values [list "dis_eidle_sd" "en_eidle_sd"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_eidle_sd"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_eightb_tenb_decoder { device_revision hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_eightb_tenb_encoder hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode } {

   set legal_values [list "dis_8b10b" "en_8b10b_ibm" "en_8b10b_sgx"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode=="tx_rx_pair_enabled") }] {
      if [expr { ($hssi_8g_tx_pcs_eightb_tenb_encoder=="dis_8b10b") }] {
         set legal_values [intersect $legal_values [list "dis_8b10b"]]
      } else {
         if [expr { ($hssi_8g_tx_pcs_eightb_tenb_encoder=="en_8b10b_ibm") }] {
            set legal_values [intersect $legal_values [list "en_8b10b_ibm"]]
         } else {
            if [expr { ($hssi_8g_tx_pcs_eightb_tenb_encoder=="en_8b10b_sgx") }] {
               set legal_values [intersect $legal_values [list "en_8b10b_sgx"]]
            }
         }
      }
   }
   if [expr { ((($hssi_8g_rx_pcs_pma_dw=="eight_bit")||($hssi_8g_rx_pcs_pma_dw=="sixteen_bit"))||($hssi_8g_rx_pcs_pcs_bypass=="en_pcs_bypass")) }] {
      set legal_values [intersect $legal_values [list "dis_8b10b"]]
   } else {
      if [expr { (((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))||($hssi_8g_rx_pcs_prot_mode=="cpri"))||($hssi_8g_rx_pcs_prot_mode=="cpri_rx_tx")) }] {
         set legal_values [intersect $legal_values [list "dis_8b10b" "en_8b10b_ibm"]]
      } else {
         set legal_values [intersect $legal_values [list "en_8b10b_ibm"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_err_flags_sel { device_revision hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "err_flags_8b10b" "err_flags_wa"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_eightb_tenb_decoder=="en_8b10b_ibm")) }] {
      set legal_values [intersect $legal_values [list "err_flags_wa" "err_flags_8b10b"]]
   } else {
      set legal_values [intersect $legal_values [list "err_flags_wa"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_fixed_pat_det { device_revision hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode } {

   set legal_values [list "dis_fixed_patdet" "en_fixed_patdet"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      if [expr { ($hssi_8g_rx_pcs_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "dis_fixed_patdet" "en_fixed_patdet"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_fixed_patdet"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "dis_fixed_patdet"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_fixed_pat_num { device_revision hssi_8g_rx_pcs_fixed_pat_det } {

   set legal_values [list 0:15]

   if [expr { ($hssi_8g_rx_pcs_fixed_pat_det=="dis_fixed_patdet") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_force_signal_detect { device_revision } {

   set legal_values [list "dis_force_signal_detect" "en_force_signal_detect"]

   set legal_values [intersect $legal_values [list "en_force_signal_detect"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_gen3_clk_en { device_revision hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode } {

   set legal_values [list "disable_clk" "enable_clk"]

   if [expr { ($hssi_8g_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_8g_rx_pcs_prot_mode=="pipe_g3") }] {
         set legal_values [intersect $legal_values [list "enable_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "disable_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "enable_clk" "disable_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_gen3_rx_clk_sel { device_revision hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

   set legal_values [list "en_dig_clk1_8g" "rcvd_clk"]

   if [expr { ($hssi_8g_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { (($hssi_8g_rx_pcs_tx_rx_parallel_loopback=="en_plpbk")&&($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_dig_clk1_8g"]]
      } else {
         set legal_values [intersect $legal_values [list "rcvd_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "en_dig_clk1_8g" "rcvd_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_gen3_tx_clk_sel { device_revision hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

   set legal_values [list "en_dig_clk2_8g" "tx_pma_clk"]

   if [expr { ($hssi_8g_rx_pcs_sup_mode=="user_mode") }] {
      if [expr { (($hssi_8g_rx_pcs_tx_rx_parallel_loopback=="en_plpbk")&&($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_dig_clk2_8g"]]
      } else {
         set legal_values [intersect $legal_values [list "tx_pma_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "tx_pma_clk" "en_dig_clk2_8g"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_hip_mode { device_revision hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode } {

   set legal_values [list "dis_hip" "en_hip"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_hip_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_hip_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "en_hip"]]
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_hip_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_hip_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "en_hip"]]
      }
   }
   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "dis_hip" "en_hip"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_ibm_invalid_code { device_revision } {

   set legal_values [list "dis_ibm_invalid_code" "en_ibm_invalid_code"]

   set legal_values [intersect $legal_values [list "dis_ibm_invalid_code"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_invalid_code_flag_only { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_invalid_code_only" "en_invalid_code_only"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "dis_invalid_code_only" "en_invalid_code_only"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_invalid_code_only"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_pad_or_edb_error_replace { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "replace_edb" "replace_edb_dynamic" "replace_pad"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "replace_edb_dynamic"]]
   } else {
      set legal_values [intersect $legal_values [list "replace_edb"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_pcs_bypass { device_revision hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_pcs_bypass hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode } {

   set legal_values [list "dis_pcs_bypass" "en_pcs_bypass"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode=="tx_rx_pair_enabled") }] {
      if [expr { ($hssi_8g_tx_pcs_pcs_bypass=="dis_pcs_bypass") }] {
         set legal_values [intersect $legal_values [list "dis_pcs_bypass"]]
      } else {
         if [expr { ($hssi_8g_tx_pcs_pcs_bypass=="en_pcs_bypass") }] {
            set legal_values [intersect $legal_values [list "en_pcs_bypass"]]
         }
      }
   }
   if [expr { ($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable") }] {
      set legal_values [intersect $legal_values [list "dis_pcs_bypass" "en_pcs_bypass"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_pcs_bypass"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_phase_comp_rdptr { device_revision hssi_8g_rx_pcs_phase_compensation_fifo hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "disable_rdptr" "enable_rdptr"]

   if [expr { (($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode")||($hssi_8g_rx_pcs_phase_compensation_fifo=="register_fifo")) }] {
      set legal_values [intersect $legal_values [list "disable_rdptr"]]
   } else {
      set legal_values [intersect $legal_values [list "enable_rdptr"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_phase_compensation_fifo { device_revision hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx } {

   set legal_values [list "low_latency" "normal_latency" "pld_ctrl_low_latency" "pld_ctrl_normal_latency" "register_fifo"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx=="fifo_rx") }] {
      set legal_values [intersect $legal_values [list "low_latency"]]
   } else {
      set legal_values [intersect $legal_values [list "register_fifo"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx=="fifo_rx") }] {
      set legal_values [intersect $legal_values [list "low_latency"]]
   } else {
      set legal_values [intersect $legal_values [list "register_fifo"]]
   }
   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="cpri")||($hssi_8g_rx_pcs_prot_mode=="cpri_rx_tx"))||($hssi_8g_rx_pcs_hip_mode=="en_hip")) }] {
      set legal_values [intersect $legal_values [list "register_fifo"]]
   } else {
      if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))||($hssi_8g_rx_pcs_prot_mode=="gige_1588")) }] {
         set legal_values [intersect $legal_values [list "low_latency" "register_fifo"]]
      } else {
         set legal_values [intersect $legal_values [list "low_latency"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_pipe_if_enable { device_revision hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_pipe_rx" "en_pipe3_rx" "en_pipe_rx"]

   if [expr { (($hssi_8g_rx_pcs_prot_mode=="pipe_g3")||($hssi_8g_rx_pcs_hip_mode=="en_hip")) }] {
      set legal_values [intersect $legal_values [list "en_pipe3_rx"]]
   } else {
      if [expr { (($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2")) }] {
         set legal_values [intersect $legal_values [list "en_pipe_rx"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_pipe_rx"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_pma_dw { device_revision hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx } {

   set legal_values [list "eight_bit" "sixteen_bit" "ten_bit" "twenty_bit"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_8b_rx") }] {
      set legal_values [intersect $legal_values [list "eight_bit"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_10b_rx") }] {
         set legal_values [intersect $legal_values [list "ten_bit"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_16b_rx") }] {
            set legal_values [intersect $legal_values [list "sixteen_bit"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_20b_rx") }] {
               set legal_values [intersect $legal_values [list "twenty_bit"]]
            } else {
               set legal_values [intersect $legal_values [list "ten_bit"]]
            }
         }
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_8b_rx") }] {
      set legal_values [intersect $legal_values [list "eight_bit"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_10b_rx") }] {
         set legal_values [intersect $legal_values [list "ten_bit"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_16b_rx") }] {
            set legal_values [intersect $legal_values [list "sixteen_bit"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx=="pma_20b_rx") }] {
               set legal_values [intersect $legal_values [list "twenty_bit"]]
            } else {
               set legal_values [intersect $legal_values [list "ten_bit"]]
            }
         }
      }
   }
   if [expr { ($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable") }] {
      set legal_values [intersect $legal_values [list "eight_bit" "ten_bit" "sixteen_bit" "twenty_bit"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable") }] {
         set legal_values [intersect $legal_values [list "ten_bit" "twenty_bit"]]
      } else {
         if [expr { (($hssi_8g_rx_pcs_prot_mode=="cpri")||($hssi_8g_rx_pcs_prot_mode=="cpri_rx_tx")) }] {
            set legal_values [intersect $legal_values [list "ten_bit" "twenty_bit"]]
         } else {
            set legal_values [intersect $legal_values [list "ten_bit"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_polinv_8b10b_dec { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_polinv_8b10b_dec" "en_polinv_8b10b_dec"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_polinv_8b10b_dec"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_polinv_8b10b_dec"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_prot_mode { device_revision hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx } {

   set legal_values [list "basic_rm_disable" "basic_rm_enable" "cpri" "cpri_rx_tx" "disabled_prot_mode" "gige" "gige_1588" "pipe_g1" "pipe_g2" "pipe_g3"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g1_rx") }] {
      set legal_values [intersect $legal_values [list "pipe_g1"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g2_rx") }] {
         set legal_values [intersect $legal_values [list "pipe_g2"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g3_rx") }] {
            set legal_values [intersect $legal_values [list "pipe_g3"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx") }] {
               set legal_values [intersect $legal_values [list "cpri"]]
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx_tx_rx") }] {
                  set legal_values [intersect $legal_values [list "cpri_rx_tx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="gige_rx") }] {
                     set legal_values [intersect $legal_values [list "gige"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="gige_1588_rx") }] {
                        set legal_values [intersect $legal_values [list "gige_1588"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_disable_rx") }] {
                           set legal_values [intersect $legal_values [list "basic_rm_disable"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_enable_rx") }] {
                              set legal_values [intersect $legal_values [list "basic_rm_enable"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="disabled_prot_mode_rx") }] {
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
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g1_rx") }] {
      set legal_values [intersect $legal_values [list "pipe_g1"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g2_rx") }] {
         set legal_values [intersect $legal_values [list "pipe_g2"]]
      } else {
         if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="pipe_g3_rx") }] {
            set legal_values [intersect $legal_values [list "pipe_g3"]]
         } else {
            if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx") }] {
               set legal_values [intersect $legal_values [list "cpri"]]
            } else {
               if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="cpri_rx_tx_rx") }] {
                  set legal_values [intersect $legal_values [list "cpri_rx_tx"]]
               } else {
                  if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="gige_rx") }] {
                     set legal_values [intersect $legal_values [list "gige"]]
                  } else {
                     if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="gige_1588_rx") }] {
                        set legal_values [intersect $legal_values [list "gige_1588"]]
                     } else {
                        if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_disable_rx") }] {
                           set legal_values [intersect $legal_values [list "basic_rm_disable"]]
                        } else {
                           if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="basic_rm_enable_rx") }] {
                              set legal_values [intersect $legal_values [list "basic_rm_enable"]]
                           } else {
                              if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx=="disabled_prot_mode_rx") }] {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rate_match { device_revision hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

   set legal_values [list "dis_rm" "dw_basic_rm" "gige_rm" "pipe_rm" "pipe_rm_0ppm" "sw_basic_rm"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="gige") }] {
      set legal_values [intersect $legal_values [list "gige_rm"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_prot_mode=="gige_1588") }] {
         set legal_values [intersect $legal_values [list "dis_rm"]]
      } else {
         if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
            set legal_values [intersect $legal_values [list "pipe_rm" "pipe_rm_0ppm"]]
         } else {
            if [expr { (((($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable")&&($hssi_8g_rx_pcs_pma_dw=="ten_bit"))&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm"))&&($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")) }] {
               set legal_values [intersect $legal_values [list "sw_basic_rm"]]
            } else {
               if [expr { (((($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable")&&($hssi_8g_rx_pcs_pma_dw=="twenty_bit"))&&($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="auto_align_pld_ctrl"))&&($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")) }] {
                  set legal_values [intersect $legal_values [list "dw_basic_rm"]]
               } else {
                  set legal_values [intersect $legal_values [list "dis_rm"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rate_match_del_thres { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_rm_del_thres" "dw_basic_rm_del_thres" "gige_rm_del_thres" "pipe_rm_0ppm_del_thres" "pipe_rm_del_thres" "sw_basic_rm_del_thres"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="gige_rm") }] {
      set legal_values [intersect $legal_values [list "gige_rm_del_thres"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm") }] {
         set legal_values [intersect $legal_values [list "pipe_rm_del_thres"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm") }] {
            set legal_values [intersect $legal_values [list "pipe_rm_0ppm_del_thres"]]
         } else {
            if [expr { ($hssi_8g_rx_pcs_rate_match=="sw_basic_rm") }] {
               set legal_values [intersect $legal_values [list "sw_basic_rm_del_thres"]]
            } else {
               if [expr { ($hssi_8g_rx_pcs_rate_match=="dw_basic_rm") }] {
                  set legal_values [intersect $legal_values [list "dw_basic_rm_del_thres"]]
               } else {
                  set legal_values [intersect $legal_values [list "dis_rm_del_thres"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rate_match_empty_thres { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_rm_empty_thres" "dw_basic_rm_empty_thres" "gige_rm_empty_thres" "pipe_rm_0ppm_empty_thres" "pipe_rm_empty_thres" "sw_basic_rm_empty_thres"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="gige_rm") }] {
      set legal_values [intersect $legal_values [list "gige_rm_empty_thres"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm") }] {
         set legal_values [intersect $legal_values [list "pipe_rm_empty_thres"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm") }] {
            set legal_values [intersect $legal_values [list "pipe_rm_0ppm_empty_thres"]]
         } else {
            if [expr { ($hssi_8g_rx_pcs_rate_match=="sw_basic_rm") }] {
               set legal_values [intersect $legal_values [list "sw_basic_rm_empty_thres"]]
            } else {
               if [expr { ($hssi_8g_rx_pcs_rate_match=="dw_basic_rm") }] {
                  set legal_values [intersect $legal_values [list "dw_basic_rm_empty_thres"]]
               } else {
                  set legal_values [intersect $legal_values [list "dis_rm_empty_thres"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rate_match_full_thres { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_rm_full_thres" "dw_basic_rm_full_thres" "gige_rm_full_thres" "pipe_rm_0ppm_full_thres" "pipe_rm_full_thres" "sw_basic_rm_full_thres"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="gige_rm") }] {
      set legal_values [intersect $legal_values [list "gige_rm_full_thres"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm") }] {
         set legal_values [intersect $legal_values [list "pipe_rm_full_thres"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm") }] {
            set legal_values [intersect $legal_values [list "pipe_rm_0ppm_full_thres"]]
         } else {
            if [expr { ($hssi_8g_rx_pcs_rate_match=="sw_basic_rm") }] {
               set legal_values [intersect $legal_values [list "sw_basic_rm_full_thres"]]
            } else {
               if [expr { ($hssi_8g_rx_pcs_rate_match=="dw_basic_rm") }] {
                  set legal_values [intersect $legal_values [list "dw_basic_rm_full_thres"]]
               } else {
                  set legal_values [intersect $legal_values [list "dis_rm_full_thres"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rate_match_ins_thres { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_rm_ins_thres" "dw_basic_rm_ins_thres" "gige_rm_ins_thres" "pipe_rm_0ppm_ins_thres" "pipe_rm_ins_thres" "sw_basic_rm_ins_thres"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="gige_rm") }] {
      set legal_values [intersect $legal_values [list "gige_rm_ins_thres"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm") }] {
         set legal_values [intersect $legal_values [list "pipe_rm_ins_thres"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm") }] {
            set legal_values [intersect $legal_values [list "pipe_rm_0ppm_ins_thres"]]
         } else {
            if [expr { ($hssi_8g_rx_pcs_rate_match=="sw_basic_rm") }] {
               set legal_values [intersect $legal_values [list "sw_basic_rm_ins_thres"]]
            } else {
               if [expr { ($hssi_8g_rx_pcs_rate_match=="dw_basic_rm") }] {
                  set legal_values [intersect $legal_values [list "dw_basic_rm_ins_thres"]]
               } else {
                  set legal_values [intersect $legal_values [list "dis_rm_ins_thres"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rate_match_start_thres { device_revision hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_rm_start_thres" "dw_basic_rm_start_thres" "gige_rm_start_thres" "pipe_rm_0ppm_start_thres" "pipe_rm_start_thres" "sw_basic_rm_start_thres"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="gige_rm") }] {
      set legal_values [intersect $legal_values [list "gige_rm_start_thres"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm") }] {
         set legal_values [intersect $legal_values [list "pipe_rm_start_thres"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_rate_match=="pipe_rm_0ppm") }] {
            set legal_values [intersect $legal_values [list "pipe_rm_0ppm_start_thres"]]
         } else {
            if [expr { ($hssi_8g_rx_pcs_rate_match=="sw_basic_rm") }] {
               set legal_values [intersect $legal_values [list "sw_basic_rm_start_thres"]]
            } else {
               if [expr { ($hssi_8g_rx_pcs_rate_match=="dw_basic_rm") }] {
                  set legal_values [intersect $legal_values [list "dw_basic_rm_start_thres"]]
               } else {
                  set legal_values [intersect $legal_values [list "dis_rm_start_thres"]]
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rx_clk2 { device_revision hssi_8g_rx_pcs_rate_match hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

   set legal_values [list "rcvd_clk_clk2" "refclk_dig2_clk2" "tx_pma_clock_clk2"]

   if [expr { (($hssi_8g_rx_pcs_sup_mode=="engineering_mode")&&($hssi_8g_rx_pcs_rate_match=="dis_rm")) }] {
      set legal_values [intersect $legal_values [list "rcvd_clk_clk2"]]
   } else {
      if [expr { (($hssi_8g_rx_pcs_sup_mode=="engineering_mode")&&($hssi_8g_rx_pcs_rate_match!="dis_rm")) }] {
         set legal_values [intersect $legal_values [list "tx_pma_clock_clk2" "refclk_dig2_clk2"]]
      } else {
         if [expr { (($hssi_8g_rx_pcs_tx_rx_parallel_loopback=="en_plpbk")||($hssi_8g_rx_pcs_rate_match!="dis_rm")) }] {
            set legal_values [intersect $legal_values [list "tx_pma_clock_clk2"]]
         } else {
            set legal_values [intersect $legal_values [list "rcvd_clk_clk2"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rx_clk_free_running { device_revision } {

   set legal_values [list "dis_rx_clk_free_run" "en_rx_clk_free_run"]

   set legal_values [intersect $legal_values [list "en_rx_clk_free_run"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rx_pcs_urst { device_revision } {

   set legal_values [list "dis_rx_pcs_urst" "en_rx_pcs_urst"]

   set legal_values [intersect $legal_values [list "en_rx_pcs_urst"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rx_rcvd_clk { device_revision hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

   set legal_values [list "rcvd_clk_rcvd_clk" "tx_pma_clock_rcvd_clk"]

   if [expr { ($hssi_8g_rx_pcs_tx_rx_parallel_loopback=="en_plpbk") }] {
      set legal_values [intersect $legal_values [list "tx_pma_clock_rcvd_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "rcvd_clk_rcvd_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rx_rd_clk { device_revision hssi_8g_rx_pcs_phase_compensation_fifo } {

   set legal_values [list "pld_rx_clk" "rx_clk"]

   if [expr { ($hssi_8g_rx_pcs_phase_compensation_fifo=="register_fifo") }] {
      set legal_values [intersect $legal_values [list "rx_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "pld_rx_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rx_refclk { device_revision hssi_8g_rx_pcs_sup_mode } {

   set legal_values [list "dis_refclk_sel" "en_refclk_sel"]

   if [expr { ($hssi_8g_rx_pcs_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "dis_refclk_sel" "en_refclk_sel"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_refclk_sel"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_rx_wr_clk { device_revision hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "rx_clk2_div_1_2_4" "txfifo_rd_clk"]

   if [expr { (($hssi_8g_rx_pcs_hip_mode=="en_hip")||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "txfifo_rd_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "rx_clk2_div_1_2_4"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_sup_mode { device_revision hssi_rx_pld_pcs_interface_hd_8g_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "engineering_mode"]]
      }
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   } else {
      if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "engineering_mode"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_symbol_swap { device_revision hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_symbol_swap" "en_symbol_swap"]

   if [expr { (((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&(($hssi_8g_rx_pcs_pma_dw=="sixteen_bit")||($hssi_8g_rx_pcs_pma_dw=="twenty_bit")))&&($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")) }] {
      set legal_values [intersect $legal_values [list "dis_symbol_swap" "en_symbol_swap"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_symbol_swap"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_sync_sm_idle_eios { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_syncsm_idle" "en_syncsm_idle"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_syncsm_idle"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_syncsm_idle"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_test_bus_sel { device_revision hssi_8g_rx_pcs_sup_mode } {

   set legal_values [list "pcie_ctrl_testbus" "rm_testbus" "rx_ctrl_plane_testbus" "rx_ctrl_testbus" "tx_ctrl_plane_testbus" "tx_testbus" "wa_testbus"]

   if [expr { ($hssi_8g_rx_pcs_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "tx_testbus"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_tx_rx_parallel_loopback { device_revision hssi_rx_pld_pcs_interface_hd_8g_lpbk_en } {

   set legal_values [list "dis_plpbk" "en_plpbk"]

   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "en_plpbk"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_plpbk"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_8g_lpbk_en=="enable") }] {
      set legal_values [intersect $legal_values [list "en_plpbk"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_plpbk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_boundary_lock_ctrl { device_revision hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "auto_align_pld_ctrl" "bit_slip" "deterministic_latency" "sync_sm"]

   if [expr { ((($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")&&(($hssi_8g_rx_pcs_pma_dw=="eight_bit")||($hssi_8g_rx_pcs_pma_dw=="sixteen_bit")))&&($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")) }] {
      set legal_values [intersect $legal_values [list "bit_slip" "auto_align_pld_ctrl"]]
   } else {
      if [expr { (($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")&&($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")) }] {
         set legal_values [intersect $legal_values [list "bit_slip" "sync_sm" "auto_align_pld_ctrl"]]
      } else {
         if [expr { (($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")&&(($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable")&&($hssi_8g_rx_pcs_pma_dw=="ten_bit"))) }] {
            set legal_values [intersect $legal_values [list "sync_sm"]]
         } else {
            if [expr { (($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")&&(($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable")&&($hssi_8g_rx_pcs_pma_dw=="twenty_bit"))) }] {
               set legal_values [intersect $legal_values [list "auto_align_pld_ctrl"]]
            } else {
               if [expr { ($hssi_8g_rx_pcs_pcs_bypass=="en_pcs_bypass") }] {
                  set legal_values [intersect $legal_values [list "bit_slip"]]
               } else {
                  if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
                     set legal_values [intersect $legal_values [list "deterministic_latency"]]
                  } else {
                     if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri_rx_tx") }] {
                        set legal_values [intersect $legal_values [list "auto_align_pld_ctrl"]]
                     } else {
                        set legal_values [intersect $legal_values [list "sync_sm"]]
                     }
                  }
               }
            }
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_clk_slip_spacing { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list 0:1023]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
      set legal_values [compare_ge $legal_values 16]
   } else {
      set legal_values [compare_eq $legal_values 16]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_det_latency_sync_status_beh { device_revision hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "assert_sync_status_imm" "assert_sync_status_non_imm" "dont_care_assert_sync"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
      set legal_values [intersect $legal_values [list "assert_sync_status_imm" "assert_sync_status_non_imm"]]
   } else {
      set legal_values [intersect $legal_values [list "dont_care_assert_sync"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_disp_err_flag { device_revision hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_pd hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list "dis_disp_err_flag" "en_disp_err_flag"]

   if [expr { (($hssi_8g_rx_pcs_wa_pd=="wa_pd_20")&&($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="dw_basic_sync_sm")) }] {
      set legal_values [intersect $legal_values [list "en_disp_err_flag"]]
   } else {
      if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_eightb_tenb_decoder=="en_8b10b_ibm")) }] {
         set legal_values [intersect $legal_values [list "dis_disp_err_flag" "en_disp_err_flag"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_eightb_tenb_decoder=="dis_8b10b") }] {
            set legal_values [intersect $legal_values [list "dis_disp_err_flag"]]
         } else {
            set legal_values [intersect $legal_values [list "en_disp_err_flag"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_kchar { device_revision } {

   set legal_values [list "dis_kchar" "en_kchar"]

   set legal_values [intersect $legal_values [list "dis_kchar"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_pd { device_revision hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

   set legal_values [list "wa_pd_10" "wa_pd_16_dw" "wa_pd_16_sw" "wa_pd_20" "wa_pd_32" "wa_pd_40" "wa_pd_7" "wa_pd_8_dw" "wa_pd_8_sw"]

   if [expr { ($hssi_8g_rx_pcs_wa_boundary_lock_ctrl!="bit_slip") }] {
      if [expr { (($hssi_8g_rx_pcs_prot_mode=="gige")||($hssi_8g_rx_pcs_prot_mode=="gige_1588")) }] {
         set legal_values [intersect $legal_values [list "wa_pd_7" "wa_pd_10"]]
      } else {
         if [expr { (($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable")) }] {
            if [expr { ($hssi_8g_rx_pcs_pma_dw=="eight_bit") }] {
               set legal_values [intersect $legal_values [list "wa_pd_8_sw" "wa_pd_16_sw"]]
            } else {
               if [expr { ($hssi_8g_rx_pcs_pma_dw=="ten_bit") }] {
                  set legal_values [intersect $legal_values [list "wa_pd_7" "wa_pd_10"]]
               } else {
                  if [expr { ($hssi_8g_rx_pcs_pma_dw=="sixteen_bit") }] {
                     set legal_values [intersect $legal_values [list "wa_pd_8_dw" "wa_pd_16_dw" "wa_pd_32"]]
                  } else {
                     if [expr { ($hssi_8g_rx_pcs_wa_boundary_lock_ctrl!="sync_sm") }] {
                        set legal_values [intersect $legal_values [list "wa_pd_7" "wa_pd_10" "wa_pd_20" "wa_pd_40"]]
                     } else {
                        set legal_values [intersect $legal_values [list "wa_pd_7" "wa_pd_10" "wa_pd_20"]]
                     }
                  }
               }
            }
         } else {
            set legal_values [intersect $legal_values [list "wa_pd_10"]]
         }
      }
   } else {
      if [expr { ($hssi_8g_rx_pcs_pma_dw=="sixteen_bit") }] {
         set legal_values [intersect $legal_values [list "wa_pd_16_sw"]]
      } else {
         if [expr { ($hssi_8g_rx_pcs_pma_dw=="eight_bit") }] {
            set legal_values [intersect $legal_values [list "wa_pd_8_sw"]]
         } else {
            set legal_values [intersect $legal_values [list "wa_pd_7"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_pd_data { device_revision hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_8g_rx_pcs_wa_pd } {

   set legal_values [list 0:1099511627775]

   if [expr { (($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode")||($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="bit_slip")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_pd=="wa_pd_7") }] {
         if [expr { (($hssi_8g_rx_pcs_prot_mode=="gige")||($hssi_8g_rx_pcs_prot_mode=="gige_1588")) }] {
            set legal_values [compare_eq $legal_values 124]
         } else {
            set legal_values [compare_lt $legal_values 128]
         }
      } else {
         if [expr { ($hssi_8g_rx_pcs_wa_pd=="wa_pd_10") }] {
            if [expr { (($hssi_8g_rx_pcs_prot_mode=="gige")||($hssi_8g_rx_pcs_prot_mode=="gige_1588")) }] {
               set legal_values [compare_eq $legal_values 380]
            } else {
               if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
                  set legal_values [compare_eq $legal_values 380]
               } else {
                  if [expr { (($hssi_8g_rx_pcs_prot_mode=="cpri")||($hssi_8g_rx_pcs_prot_mode=="cpri_rx_tx")) }] {
                     set legal_values [compare_eq $legal_values 380]
                  } else {
                     set legal_values [compare_lt $legal_values 1024]
                  }
               }
            }
         } else {
            if [expr { ($hssi_8g_rx_pcs_wa_pd=="wa_pd_20") }] {
               set legal_values [compare_lt $legal_values 1048576]
            } else {
               if [expr { ($hssi_8g_rx_pcs_wa_pd=="wa_pd_40") }] {
                  set legal_values [compare_le $legal_values 1099511627775]
               } else {
                  if [expr { (($hssi_8g_rx_pcs_wa_pd=="wa_pd_8_sw")||($hssi_8g_rx_pcs_wa_pd=="wa_pd_8_dw")) }] {
                     set legal_values [compare_lt $legal_values 256]
                  } else {
                     if [expr { (($hssi_8g_rx_pcs_wa_pd=="wa_pd_16_sw")||($hssi_8g_rx_pcs_wa_pd=="wa_pd_16_dw")) }] {
                        set legal_values [compare_lt $legal_values 65536]
                     } else {
                        if [expr { ($hssi_8g_rx_pcs_wa_pd=="wa_pd_32") }] {
                           set legal_values [compare_lt $legal_values 4294967296]
                        } else {
                           set legal_values [compare_eq $legal_values 0]
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

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_pd_polarity { device_revision hssi_8g_rx_pcs_pma_dw } {

   set legal_values [list "dis_pd_both_pol" "dont_care_both_pol" "en_pd_both_pol"]

   if [expr { (($hssi_8g_rx_pcs_pma_dw=="eight_bit")||($hssi_8g_rx_pcs_pma_dw=="ten_bit")) }] {
      set legal_values [intersect $legal_values [list "dont_care_both_pol"]]
   } else {
      if [expr { ($hssi_8g_rx_pcs_pma_dw=="sixteen_bit") }] {
         set legal_values [intersect $legal_values [list "dis_pd_both_pol"]]
      } else {
         set legal_values [intersect $legal_values [list "en_pd_both_pol"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_pld_controlled { device_revision hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

   set legal_values [list "dis_pld_ctrl" "level_sensitive_dw" "pld_ctrl_sw" "rising_edge_sensitive_dw"]

   if [expr { ($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm") }] {
      set legal_values [intersect $legal_values [list "dis_pld_ctrl"]]
   } else {
      if [expr { ((($hssi_8g_rx_pcs_pma_dw=="eight_bit")||($hssi_8g_rx_pcs_pma_dw=="ten_bit"))||($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="deterministic_latency")) }] {
         set legal_values [intersect $legal_values [list "pld_ctrl_sw"]]
      } else {
         set legal_values [intersect $legal_values [list "rising_edge_sensitive_dw"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_renumber_data { device_revision hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:63]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 3]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 16]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_rgnumber_data { device_revision hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:255]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 3]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_rknumber_data { device_revision hssi_8g_rx_pcs_wa_rosnumber_data hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:255]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 3]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 3]
      }
   }
   if [expr { ($hssi_8g_rx_pcs_wa_rosnumber_data!=0) }] {
      set legal_values [compare_gt $legal_values 0]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_rosnumber_data { device_revision hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:3]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_rvnumber_data { device_revision hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:8191]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 0]
      } else {
         if [expr { (($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="sw_basic_sync_sm")||($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="fibre_channel_sync_sm")) }] {
            set legal_values [compare_eq $legal_values 0]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wa_sync_sm_ctrl { device_revision hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

   set legal_values [list "dw_basic_sync_sm" "fibre_channel_sync_sm" "gige_sync_sm" "pipe_sync_sm" "sw_basic_sync_sm"]

   if [expr { ($hssi_8g_rx_pcs_wa_boundary_lock_ctrl=="sync_sm") }] {
      if [expr { (($hssi_8g_rx_pcs_prot_mode=="gige")||($hssi_8g_rx_pcs_prot_mode=="gige_1588")) }] {
         set legal_values [intersect $legal_values [list "gige_sync_sm"]]
      } else {
         if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
            set legal_values [intersect $legal_values [list "pipe_sync_sm"]]
         } else {
            if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_pma_dw=="ten_bit")) }] {
               set legal_values [intersect $legal_values [list "sw_basic_sync_sm"]]
            } else {
               if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_pma_dw=="twenty_bit")) }] {
                  set legal_values [intersect $legal_values [list "dw_basic_sync_sm"]]
               } else {
                  set legal_values [intersect $legal_values [list "gige_sync_sm"]]
               }
            }
         }
      }
   } else {
      set legal_values [intersect $legal_values [list "gige_sync_sm"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_rx_pcs_wait_cnt { device_revision hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list 0:4095]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode!="pipe_g1")&&($hssi_8g_rx_pcs_prot_mode!="pipe_g2"))&&($hssi_8g_rx_pcs_prot_mode!="pipe_g3")) }] {
      set legal_values [compare_eq $legal_values 0]
   } else {
      if [expr { ($hssi_8g_rx_pcs_hip_mode=="en_hip") }] {
         set legal_values [compare_eq $legal_values 0]
      } else {
         set legal_values [compare_eq $legal_values 2500]
      }
   }

   return $legal_values
}

