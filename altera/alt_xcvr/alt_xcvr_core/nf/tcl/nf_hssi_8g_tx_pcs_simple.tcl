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


proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_auto_speed_nego_gen2 { device_revision hssi_8g_tx_pcs_ctrl_plane_bonding_consumption hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_asn_g2" "en_asn_g2_freq_scal"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="pipe_g2")&&(($hssi_8g_tx_pcs_ctrl_plane_bonding_consumption=="individual")||($hssi_8g_tx_pcs_ctrl_plane_bonding_consumption=="bundled_master"))) }] {
      set legal_values [intersect $legal_values [list "en_asn_g2_freq_scal"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_asn_g2"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_bit_reversal { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_bit_reversal" "en_bit_reversal"]

   if [expr { ((((((($hssi_8g_tx_pcs_prot_mode=="pipe_g1")||($hssi_8g_tx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_tx_pcs_prot_mode=="pipe_g3"))||($hssi_8g_tx_pcs_prot_mode=="cpri"))||($hssi_8g_tx_pcs_prot_mode=="cpri_rx_tx"))||($hssi_8g_tx_pcs_prot_mode=="gige"))||($hssi_8g_tx_pcs_prot_mode=="gige_1588")) }] {
      set legal_values [intersect $legal_values [list "dis_bit_reversal"]]
   } else {
      if [expr { ($hssi_8g_tx_pcs_prot_mode=="basic") }] {
         set legal_values [intersect $legal_values [list "dis_bit_reversal" "en_bit_reversal"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_bit_reversal"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_bonding_dft_en { device_revision } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_bonding_dft_val { device_revision } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_bypass_pipeline_reg { device_revision } {

   set legal_values [list "dis_bypass_pipeline" "en_bypass_pipeline"]

   set legal_values [intersect $legal_values [list "dis_bypass_pipeline"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_byte_serializer { device_revision hssi_8g_tx_pcs_hip_mode hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_bs" "en_bs_by_2" "en_bs_by_4"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="pipe_g3")||($hssi_8g_tx_pcs_hip_mode=="en_hip")) }] {
      set legal_values [intersect $legal_values [list "en_bs_by_4"]]
   } else {
      if [expr { ($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode") }] {
         set legal_values [intersect $legal_values [list "dis_bs"]]
      } else {
         if [expr { ($hssi_8g_tx_pcs_prot_mode=="pipe_g2") }] {
            set legal_values [intersect $legal_values [list "en_bs_by_2"]]
         } else {
            set legal_values [intersect $legal_values [list "dis_bs" "en_bs_by_2"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_clock_gate_bs_enc { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_bs_enc_clk_gating" "en_bs_enc_clk_gating"]

   if [expr { ($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_bs_enc_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_bs_enc_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_clock_gate_dw_fifowr { device_revision hssi_8g_tx_pcs_byte_serializer hssi_8g_tx_pcs_phase_compensation_fifo hssi_8g_tx_pcs_pma_dw hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_dw_fifowr_clk_gating" "en_dw_fifowr_clk_gating"]

   if [expr { ((($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode")||($hssi_8g_tx_pcs_phase_compensation_fifo=="register_fifo"))||((($hssi_8g_tx_pcs_pma_dw=="ten_bit")||($hssi_8g_tx_pcs_pma_dw=="eight_bit"))&&($hssi_8g_tx_pcs_byte_serializer!="en_bs_by_4"))) }] {
      set legal_values [intersect $legal_values [list "en_dw_fifowr_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_fifowr_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_clock_gate_fiford { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_fiford_clk_gating" "en_fiford_clk_gating"]

   if [expr { ($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_fiford_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_fiford_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_clock_gate_sw_fifowr { device_revision hssi_8g_tx_pcs_hip_mode hssi_8g_tx_pcs_phase_compensation_fifo hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_sw_fifowr_clk_gating" "en_sw_fifowr_clk_gating"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode")||(($hssi_8g_tx_pcs_phase_compensation_fifo=="register_fifo")&&($hssi_8g_tx_pcs_hip_mode=="dis_hip"))) }] {
      set legal_values [intersect $legal_values [list "en_sw_fifowr_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_fifowr_clk_gating"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_clock_observation_in_pld_core { device_revision } {

   set legal_values [list "internal_dw_fifo_wr_clk" "internal_fifo_rd_clk" "internal_pipe_tx_clk_out_gen3" "internal_refclk_b" "internal_sw_fifo_wr_clk" "internal_tx_clk_out_gen3"]

   set legal_values [intersect $legal_values [list "internal_refclk_b"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_ctrl_plane_bonding_compensation { device_revision hssi_8g_tx_pcs_byte_serializer } {

   set legal_values [list "dis_compensation" "en_compensation"]

   if [expr { ($hssi_8g_tx_pcs_byte_serializer=="en_bs_by_4") }] {
      set legal_values [intersect $legal_values [list "en_compensation"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_compensation"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_ctrl_plane_bonding_consumption { device_revision hssi_10g_tx_pcs_prot_mode hssi_8g_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx } {

   set legal_values [list "bundled_master" "bundled_slave_above" "bundled_slave_below" "individual"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode")&&($hssi_10g_tx_pcs_prot_mode=="disable_mode")) }] {
      set legal_values [intersect $legal_values [list "individual"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="individual_tx") }] {
      set legal_values [intersect $legal_values [list "individual"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="ctrl_master_tx") }] {
         set legal_values [intersect $legal_values [list "bundled_master"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="ctrl_slave_abv_tx") }] {
            set legal_values [intersect $legal_values [list "bundled_slave_above"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_tx=="ctrl_slave_blw_tx") }] {
               set legal_values [intersect $legal_values [list "bundled_slave_below"]]
            }
         }
      }
   }
   if [expr { ((($hssi_8g_tx_pcs_prot_mode=="gige")||($hssi_8g_tx_pcs_prot_mode=="gige_1588"))||($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode")) }] {
      set legal_values [intersect $legal_values [list "individual"]]
   } else {
      set legal_values [intersect $legal_values [list "individual" "bundled_master" "bundled_slave_below" "bundled_slave_above"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_ctrl_plane_bonding_distribution { device_revision hssi_8g_tx_pcs_ctrl_plane_bonding_consumption } {

   set legal_values [list "master_chnl_distr" "not_master_chnl_distr"]

   if [expr { ($hssi_8g_tx_pcs_ctrl_plane_bonding_consumption=="bundled_master") }] {
      set legal_values [intersect $legal_values [list "master_chnl_distr"]]
   } else {
      set legal_values [intersect $legal_values [list "not_master_chnl_distr"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_data_selection_8b10b_encoder_input { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "gige_idle_conversion" "normal_data_path"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="gige")||($hssi_8g_tx_pcs_prot_mode=="gige_1588")) }] {
      set legal_values [intersect $legal_values [list "gige_idle_conversion"]]
   } else {
      set legal_values [intersect $legal_values [list "normal_data_path"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_dynamic_clk_switch { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_dyn_clk_switch" "en_dyn_clk_switch"]

   if [expr { ($hssi_8g_tx_pcs_prot_mode=="pipe_g3") }] {
      set legal_values [intersect $legal_values [list "en_dyn_clk_switch"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dyn_clk_switch"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_eightb_tenb_disp_ctrl { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_disp_ctrl" "en_disp_ctrl" "en_ib_disp_ctrl"]

   if [expr { ($hssi_8g_tx_pcs_prot_mode=="basic") }] {
      set legal_values [intersect $legal_values [list "dis_disp_ctrl" "en_disp_ctrl"]]
   } else {
      if [expr { ((($hssi_8g_tx_pcs_prot_mode=="pipe_g1")||($hssi_8g_tx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_tx_pcs_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "en_disp_ctrl"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_disp_ctrl"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_eightb_tenb_encoder { device_revision hssi_8g_tx_pcs_pcs_bypass hssi_8g_tx_pcs_pma_dw hssi_8g_tx_pcs_prot_mode hssi_8g_tx_pcs_sup_mode } {

   set legal_values [list "dis_8b10b" "en_8b10b_ibm" "en_8b10b_sgx"]

   if [expr { ((($hssi_8g_tx_pcs_pma_dw=="eight_bit")||($hssi_8g_tx_pcs_pma_dw=="sixteen_bit"))||($hssi_8g_tx_pcs_pcs_bypass=="en_pcs_bypass")) }] {
      set legal_values [intersect $legal_values [list "dis_8b10b"]]
   } else {
      if [expr { ((((($hssi_8g_tx_pcs_prot_mode=="basic")&&($hssi_8g_tx_pcs_pcs_bypass=="dis_pcs_bypass"))&&($hssi_8g_tx_pcs_sup_mode=="user_mode"))||($hssi_8g_tx_pcs_prot_mode=="cpri"))||($hssi_8g_tx_pcs_prot_mode=="cpri_rx_tx")) }] {
         set legal_values [intersect $legal_values [list "dis_8b10b" "en_8b10b_ibm"]]
      } else {
         if [expr { ((($hssi_8g_tx_pcs_prot_mode=="basic")&&($hssi_8g_tx_pcs_pcs_bypass=="dis_pcs_bypass"))&&($hssi_8g_tx_pcs_sup_mode=="engineering_mode")) }] {
            set legal_values [intersect $legal_values [list "dis_8b10b" "en_8b10b_ibm" "en_8b10b_sgx"]]
         } else {
            set legal_values [intersect $legal_values [list "en_8b10b_ibm"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_force_echar { device_revision } {

   set legal_values [list "dis_force_echar" "en_force_echar"]

   set legal_values [intersect $legal_values [list "dis_force_echar"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_force_kchar { device_revision } {

   set legal_values [list "dis_force_kchar" "en_force_kchar"]

   set legal_values [intersect $legal_values [list "dis_force_kchar"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_gen3_tx_clk_sel { device_revision hssi_8g_tx_pcs_prot_mode hssi_8g_tx_pcs_sup_mode } {

   set legal_values [list "dis_tx_clk" "tx_pma_clk"]

   if [expr { ($hssi_8g_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ($hssi_8g_tx_pcs_prot_mode=="pipe_g3") }] {
         set legal_values [intersect $legal_values [list "tx_pma_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_tx_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "dis_tx_clk" "tx_pma_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_gen3_tx_pipe_clk_sel { device_revision hssi_8g_tx_pcs_prot_mode hssi_8g_tx_pcs_sup_mode } {

   set legal_values [list "dis_tx_pipe_clk" "func_clk"]

   if [expr { ($hssi_8g_tx_pcs_sup_mode=="user_mode") }] {
      if [expr { ((($hssi_8g_tx_pcs_prot_mode=="pipe_g1")||($hssi_8g_tx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_tx_pcs_prot_mode=="pipe_g3")) }] {
         set legal_values [intersect $legal_values [list "func_clk"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_tx_pipe_clk"]]
      }
   } else {
      set legal_values [intersect $legal_values [list "dis_tx_pipe_clk" "func_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_hip_mode { device_revision hssi_8g_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_8g_hip_mode } {

   set legal_values [list "dis_hip" "en_hip"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_hip_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_hip_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "en_hip"]]
      }
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_hip_mode=="disable") }] {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_hip_mode=="enable") }] {
         set legal_values [intersect $legal_values [list "en_hip"]]
      }
   }
   if [expr { ((($hssi_8g_tx_pcs_prot_mode=="pipe_g1")||($hssi_8g_tx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_tx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "dis_hip" "en_hip"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_hip"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_pcs_bypass { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_pcs_bypass" "en_pcs_bypass"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="basic")||($hssi_8g_tx_pcs_prot_mode=="cpri_rx_tx")) }] {
      set legal_values [intersect $legal_values [list "dis_pcs_bypass" "en_pcs_bypass"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_pcs_bypass"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_phase_comp_rdptr { device_revision hssi_8g_tx_pcs_phase_compensation_fifo hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "disable_rdptr" "enable_rdptr"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="disabled_prot_mode")||($hssi_8g_tx_pcs_phase_compensation_fifo=="register_fifo")) }] {
      set legal_values [intersect $legal_values [list "disable_rdptr"]]
   } else {
      set legal_values [intersect $legal_values [list "enable_rdptr"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_phase_compensation_fifo { device_revision hssi_8g_tx_pcs_hip_mode hssi_8g_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx } {

   set legal_values [list "low_latency" "normal_latency" "pld_ctrl_low_latency" "pld_ctrl_normal_latency" "register_fifo"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fifo_tx") }] {
      set legal_values [intersect $legal_values [list "low_latency"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="reg_tx") }] {
         set legal_values [intersect $legal_values [list "register_fifo"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fastreg_tx") }] {
            set legal_values [intersect $legal_values [list "register_fifo"]]
         }
      }
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fifo_tx") }] {
      set legal_values [intersect $legal_values [list "low_latency"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="reg_tx") }] {
         set legal_values [intersect $legal_values [list "register_fifo"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fastreg_tx") }] {
            set legal_values [intersect $legal_values [list "register_fifo"]]
         }
      }
   }
   if [expr { ((($hssi_8g_tx_pcs_prot_mode=="cpri")||($hssi_8g_tx_pcs_prot_mode=="cpri_rx_tx"))||($hssi_8g_tx_pcs_hip_mode=="en_hip")) }] {
      set legal_values [intersect $legal_values [list "register_fifo"]]
   } else {
      if [expr { (($hssi_8g_tx_pcs_prot_mode=="basic")||($hssi_8g_tx_pcs_prot_mode=="gige_1588")) }] {
         set legal_values [intersect $legal_values [list "low_latency" "register_fifo"]]
      } else {
         set legal_values [intersect $legal_values [list "low_latency"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_phfifo_write_clk_sel { device_revision hssi_8g_tx_pcs_phase_compensation_fifo } {

   set legal_values [list "pld_tx_clk" "tx_clk"]

   if [expr { ($hssi_8g_tx_pcs_phase_compensation_fifo=="register_fifo") }] {
      set legal_values [intersect $legal_values [list "tx_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "pld_tx_clk"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_pma_dw { device_revision hssi_8g_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx } {

   set legal_values [list "eight_bit" "sixteen_bit" "ten_bit" "twenty_bit"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_8b_tx") }] {
      set legal_values [intersect $legal_values [list "eight_bit"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_10b_tx") }] {
         set legal_values [intersect $legal_values [list "ten_bit"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_16b_tx") }] {
            set legal_values [intersect $legal_values [list "sixteen_bit"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_20b_tx") }] {
               set legal_values [intersect $legal_values [list "twenty_bit"]]
            } else {
               set legal_values [intersect $legal_values [list "ten_bit"]]
            }
         }
      }
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_8b_tx") }] {
      set legal_values [intersect $legal_values [list "eight_bit"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_10b_tx") }] {
         set legal_values [intersect $legal_values [list "ten_bit"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_16b_tx") }] {
            set legal_values [intersect $legal_values [list "sixteen_bit"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_pma_dw_tx=="pma_20b_tx") }] {
               set legal_values [intersect $legal_values [list "twenty_bit"]]
            } else {
               set legal_values [intersect $legal_values [list "ten_bit"]]
            }
         }
      }
   }
   if [expr { ($hssi_8g_tx_pcs_prot_mode=="basic") }] {
      set legal_values [intersect $legal_values [list "eight_bit" "ten_bit" "sixteen_bit" "twenty_bit"]]
   } else {
      if [expr { (($hssi_8g_tx_pcs_prot_mode=="cpri")||($hssi_8g_tx_pcs_prot_mode=="cpri_rx_tx")) }] {
         set legal_values [intersect $legal_values [list "ten_bit" "twenty_bit"]]
      } else {
         set legal_values [intersect $legal_values [list "ten_bit"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_prot_mode { device_revision hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx } {

   set legal_values [list "basic" "cpri" "cpri_rx_tx" "disabled_prot_mode" "gige" "gige_1588" "pipe_g1" "pipe_g2" "pipe_g3"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g1_tx") }] {
      set legal_values [intersect $legal_values [list "pipe_g1"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g2_tx") }] {
         set legal_values [intersect $legal_values [list "pipe_g2"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g3_tx") }] {
            set legal_values [intersect $legal_values [list "pipe_g3"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_tx") }] {
               set legal_values [intersect $legal_values [list "cpri"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_rx_tx_tx") }] {
                  set legal_values [intersect $legal_values [list "cpri_rx_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="gige_tx") }] {
                     set legal_values [intersect $legal_values [list "gige"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="gige_1588_tx") }] {
                        set legal_values [intersect $legal_values [list "gige_1588"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="basic_tx") }] {
                           set legal_values [intersect $legal_values [list "basic"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="disabled_prot_mode_tx") }] {
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
   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g1_tx") }] {
      set legal_values [intersect $legal_values [list "pipe_g1"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g2_tx") }] {
         set legal_values [intersect $legal_values [list "pipe_g2"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="pipe_g3_tx") }] {
            set legal_values [intersect $legal_values [list "pipe_g3"]]
         } else {
            if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_tx") }] {
               set legal_values [intersect $legal_values [list "cpri"]]
            } else {
               if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="cpri_rx_tx_tx") }] {
                  set legal_values [intersect $legal_values [list "cpri_rx_tx"]]
               } else {
                  if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="gige_tx") }] {
                     set legal_values [intersect $legal_values [list "gige"]]
                  } else {
                     if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="gige_1588_tx") }] {
                        set legal_values [intersect $legal_values [list "gige_1588"]]
                     } else {
                        if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="basic_tx") }] {
                           set legal_values [intersect $legal_values [list "basic"]]
                        } else {
                           if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_prot_mode_tx=="disabled_prot_mode_tx") }] {
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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_refclk_b_clk_sel { device_revision hssi_8g_tx_pcs_sup_mode } {

   set legal_values [list "refclk_dig" "tx_pma_clock"]

   if [expr { ($hssi_8g_tx_pcs_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "refclk_dig" "tx_pma_clock"]]
   } else {
      set legal_values [intersect $legal_values [list "tx_pma_clock"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_revloop_back_rm { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_rev_loopback_rx_rm" "en_rev_loopback_rx_rm"]

   if [expr { ((($hssi_8g_tx_pcs_prot_mode=="pipe_g1")||($hssi_8g_tx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_tx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_rev_loopback_rx_rm"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_rev_loopback_rx_rm"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_8g_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "engineering_mode"]]
      }
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   } else {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_sup_mode=="engineering_mode") }] {
         set legal_values [intersect $legal_values [list "engineering_mode"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_symbol_swap { device_revision hssi_8g_tx_pcs_pma_dw hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_symbol_swap" "en_symbol_swap"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="basic")&&(($hssi_8g_tx_pcs_pma_dw=="sixteen_bit")||($hssi_8g_tx_pcs_pma_dw=="twenty_bit"))) }] {
      set legal_values [intersect $legal_values [list "dis_symbol_swap" "en_symbol_swap"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_symbol_swap"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_tx_bitslip { device_revision hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_tx_bitslip" "en_tx_bitslip"]

   if [expr { ($hssi_8g_tx_pcs_prot_mode=="cpri_rx_tx") }] {
      set legal_values [intersect $legal_values [list "en_tx_bitslip" "dis_tx_bitslip"]]
   } else {
      if [expr { ((((($hssi_8g_tx_pcs_prot_mode=="pipe_g1")||($hssi_8g_tx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_tx_pcs_prot_mode=="pipe_g3"))||($hssi_8g_tx_pcs_prot_mode=="gige"))||($hssi_8g_tx_pcs_prot_mode=="gige_1588")) }] {
         set legal_values [intersect $legal_values [list "dis_tx_bitslip"]]
      } else {
         if [expr { (($hssi_8g_tx_pcs_prot_mode=="basic")||($hssi_8g_tx_pcs_prot_mode=="cpri")) }] {
            set legal_values [intersect $legal_values [list "en_tx_bitslip" "dis_tx_bitslip"]]
         } else {
            set legal_values [intersect $legal_values [list "dis_tx_bitslip"]]
         }
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_tx_compliance_controlled_disparity { device_revision hssi_8g_tx_pcs_hip_mode hssi_8g_tx_pcs_prot_mode } {

   set legal_values [list "dis_txcompliance" "en_txcompliance_pipe2p0" "en_txcompliance_pipe3p0"]

   if [expr { (($hssi_8g_tx_pcs_prot_mode=="pipe_g3")||($hssi_8g_tx_pcs_hip_mode=="en_hip")) }] {
      set legal_values [intersect $legal_values [list "en_txcompliance_pipe3p0"]]
   } else {
      if [expr { (($hssi_8g_tx_pcs_prot_mode=="pipe_g1")||($hssi_8g_tx_pcs_prot_mode=="pipe_g2")) }] {
         set legal_values [intersect $legal_values [list "en_txcompliance_pipe2p0"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_txcompliance"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_tx_fast_pld_reg { device_revision hssi_8g_tx_pcs_hip_mode hssi_8g_tx_pcs_phase_compensation_fifo hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx } {

   set legal_values [list "dis_tx_fast_pld_reg" "en_tx_fast_pld_reg"]

   if [expr { !(($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fifo_tx")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="reg_tx") }] {
         set legal_values [intersect $legal_values [list "dis_tx_fast_pld_reg"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fastreg_tx") }] {
            set legal_values [intersect $legal_values [list "en_tx_fast_pld_reg"]]
         }
      }
   }
   if [expr { !(($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fifo_tx")) }] {
      if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="reg_tx") }] {
         set legal_values [intersect $legal_values [list "dis_tx_fast_pld_reg"]]
      } else {
         if [expr { ($hssi_tx_pld_pcs_interface_hd_8g_fifo_mode_tx=="fastreg_tx") }] {
            set legal_values [intersect $legal_values [list "en_tx_fast_pld_reg"]]
         }
      }
   }
   if [expr { ($hssi_8g_tx_pcs_hip_mode=="en_hip") }] {
      set legal_values [intersect $legal_values [list "dis_tx_fast_pld_reg"]]
   } else {
      if [expr { ($hssi_8g_tx_pcs_phase_compensation_fifo=="register_fifo") }] {
         set legal_values [intersect $legal_values [list "en_tx_fast_pld_reg" "dis_tx_fast_pld_reg"]]
      } else {
         set legal_values [intersect $legal_values [list "dis_tx_fast_pld_reg"]]
      }
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_txclk_freerun { device_revision } {

   set legal_values [list "dis_freerun_tx" "en_freerun_tx"]

   set legal_values [intersect $legal_values [list "en_freerun_tx"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_8g_tx_pcs_txpcs_urst { device_revision } {

   set legal_values [list "dis_txpcs_urst" "en_txpcs_urst"]

   set legal_values [intersect $legal_values [list "en_txpcs_urst"]]

   return $legal_values
}

