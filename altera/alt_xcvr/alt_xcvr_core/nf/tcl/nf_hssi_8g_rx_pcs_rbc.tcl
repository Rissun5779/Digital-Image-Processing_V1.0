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


proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_auto_error_replacement { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_auto_error_replacement hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_auto_error_replacement.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_auto_error_replacement $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_auto_error_replacement $hssi_8g_rx_pcs_auto_error_replacement $legal_values { hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_auto_speed_nego { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_auto_speed_nego hssi_8g_rx_pcs_ctrl_plane_bonding_consumption hssi_8g_rx_pcs_prot_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_auto_speed_nego.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_auto_speed_nego $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_auto_speed_nego $hssi_8g_rx_pcs_auto_speed_nego $legal_values { hssi_8g_rx_pcs_ctrl_plane_bonding_consumption hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_bit_reversal { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_bit_reversal hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_bit_reversal" "en_bit_reversal"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")) }] {
      set legal_values [intersect $legal_values [list "dis_bit_reversal" "en_bit_reversal"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_bit_reversal"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_bit_reversal.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_bit_reversal $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_bit_reversal $hssi_8g_rx_pcs_bit_reversal $legal_values { hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_bonding_dft_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_bonding_dft_en } {

   set legal_values [list "dft_dis" "dft_en"]

   set legal_values [intersect $legal_values [list "dft_dis"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_bonding_dft_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_bonding_dft_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_bonding_dft_en $hssi_8g_rx_pcs_bonding_dft_en $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_bonding_dft_val { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_bonding_dft_val } {

   set legal_values [list "dft_0" "dft_1"]

   set legal_values [intersect $legal_values [list "dft_0"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_bonding_dft_val.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_bonding_dft_val $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_bonding_dft_val $hssi_8g_rx_pcs_bonding_dft_val $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_bypass_pipeline_reg { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_bypass_pipeline_reg } {

   set legal_values [list "dis_bypass_pipeline" "en_bypass_pipeline"]

   set legal_values [intersect $legal_values [list "dis_bypass_pipeline"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_bypass_pipeline_reg.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_bypass_pipeline_reg $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_bypass_pipeline_reg $hssi_8g_rx_pcs_bypass_pipeline_reg $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_byte_deserializer { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_pipe_if_enable hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_byte_serializer hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_byte_deserializer.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_byte_deserializer $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_byte_deserializer $hssi_8g_rx_pcs_byte_deserializer $legal_values { hssi_8g_rx_pcs_pipe_if_enable hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_byte_serializer hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_cdr_ctrl_rxvalid_mask { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_cdr_ctrl_rxvalid_mask hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_rxvalid_mask" "en_rxvalid_mask"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_rxvalid_mask"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_rxvalid_mask"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_cdr_ctrl_rxvalid_mask.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_cdr_ctrl_rxvalid_mask $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_cdr_ctrl_rxvalid_mask $hssi_8g_rx_pcs_cdr_ctrl_rxvalid_mask $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clkcmp_pattern_n { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clkcmp_pattern_n hssi_8g_rx_pcs_rate_match } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_clkcmp_pattern_n.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_clkcmp_pattern_n $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_clkcmp_pattern_n $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_clkcmp_pattern_n $hssi_8g_rx_pcs_clkcmp_pattern_n $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clkcmp_pattern_p { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clkcmp_pattern_p hssi_8g_rx_pcs_rate_match } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_clkcmp_pattern_p.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_clkcmp_pattern_p $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_clkcmp_pattern_p $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_clkcmp_pattern_p $hssi_8g_rx_pcs_clkcmp_pattern_p $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_bds_dec_asn { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_bds_dec_asn hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_bds_dec_asn_clk_gating" "en_bds_dec_asn_clk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_bds_dec_asn_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_bds_dec_asn_clk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_bds_dec_asn.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_bds_dec_asn $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_bds_dec_asn $hssi_8g_rx_pcs_clock_gate_bds_dec_asn $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_cdr_eidle { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_cdr_eidle hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_cdr_eidle_clk_gating" "en_cdr_eidle_clk_gating"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode!="pipe_g1")&&($hssi_8g_rx_pcs_prot_mode!="pipe_g2"))&&($hssi_8g_rx_pcs_prot_mode!="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_cdr_eidle_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_cdr_eidle_clk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_cdr_eidle.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_cdr_eidle $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_cdr_eidle $hssi_8g_rx_pcs_clock_gate_cdr_eidle $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_dw_pc_wrclk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_dw_pc_wrclk hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_phase_compensation_fifo hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_dw_pc_wrclk_gating" "en_dw_pc_wrclk_gating"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode")||($hssi_8g_rx_pcs_phase_compensation_fifo=="register_fifo"))||((($hssi_8g_rx_pcs_pma_dw=="ten_bit")||($hssi_8g_rx_pcs_pma_dw=="eight_bit"))&&($hssi_8g_rx_pcs_byte_deserializer!="en_bds_by_4"))) }] {
      set legal_values [intersect $legal_values [list "en_dw_pc_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_pc_wrclk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_dw_pc_wrclk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_dw_pc_wrclk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_dw_pc_wrclk $hssi_8g_rx_pcs_clock_gate_dw_pc_wrclk $legal_values { hssi_8g_rx_pcs_byte_deserializer hssi_8g_rx_pcs_phase_compensation_fifo hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_dw_rm_rd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_dw_rm_rd hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_dw_rm_rdclk_gating" "en_dw_rm_rdclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match!="dw_basic_rm") }] {
      set legal_values [intersect $legal_values [list "en_dw_rm_rdclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_rm_rdclk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_dw_rm_rd.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_dw_rm_rd $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_dw_rm_rd $hssi_8g_rx_pcs_clock_gate_dw_rm_rd $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_dw_rm_wr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_dw_rm_wr hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_dw_rm_wrclk_gating" "en_dw_rm_wrclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match!="dw_basic_rm") }] {
      set legal_values [intersect $legal_values [list "en_dw_rm_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_rm_wrclk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_dw_rm_wr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_dw_rm_wr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_dw_rm_wr $hssi_8g_rx_pcs_clock_gate_dw_rm_wr $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_dw_wa { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_dw_wa hssi_8g_rx_pcs_pma_dw } {

   set legal_values [list "dis_dw_wa_clk_gating" "en_dw_wa_clk_gating"]

   if [expr { (($hssi_8g_rx_pcs_pma_dw=="eight_bit")||($hssi_8g_rx_pcs_pma_dw=="ten_bit")) }] {
      set legal_values [intersect $legal_values [list "en_dw_wa_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_dw_wa_clk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_dw_wa.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_dw_wa $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_dw_wa $hssi_8g_rx_pcs_clock_gate_dw_wa $legal_values { hssi_8g_rx_pcs_pma_dw }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_pc_rdclk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_pc_rdclk hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_pc_rdclk_gating" "en_pc_rdclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_pc_rdclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_pc_rdclk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_pc_rdclk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_pc_rdclk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_pc_rdclk $hssi_8g_rx_pcs_clock_gate_pc_rdclk $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_sw_pc_wrclk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_sw_pc_wrclk hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_sw_pc_wrclk_gating" "en_sw_pc_wrclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_sw_pc_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_pc_wrclk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_sw_pc_wrclk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_sw_pc_wrclk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_sw_pc_wrclk $hssi_8g_rx_pcs_clock_gate_sw_pc_wrclk $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_sw_rm_rd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_sw_rm_rd hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_sw_rm_rdclk_gating" "en_sw_rm_rdclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="dis_rm") }] {
      set legal_values [intersect $legal_values [list "en_sw_rm_rdclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_rm_rdclk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_sw_rm_rd.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_sw_rm_rd $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_sw_rm_rd $hssi_8g_rx_pcs_clock_gate_sw_rm_rd $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_sw_rm_wr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_sw_rm_wr hssi_8g_rx_pcs_rate_match } {

   set legal_values [list "dis_sw_rm_wrclk_gating" "en_sw_rm_wrclk_gating"]

   if [expr { ($hssi_8g_rx_pcs_rate_match=="dis_rm") }] {
      set legal_values [intersect $legal_values [list "en_sw_rm_wrclk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_rm_wrclk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_sw_rm_wr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_sw_rm_wr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_sw_rm_wr $hssi_8g_rx_pcs_clock_gate_sw_rm_wr $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_gate_sw_wa { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_gate_sw_wa hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_sw_wa_clk_gating" "en_sw_wa_clk_gating"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode") }] {
      set legal_values [intersect $legal_values [list "en_sw_wa_clk_gating"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_sw_wa_clk_gating"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_gate_sw_wa.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_gate_sw_wa $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_gate_sw_wa $hssi_8g_rx_pcs_clock_gate_sw_wa $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_clock_observation_in_pld_core { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_clock_observation_in_pld_core } {

   set legal_values [list "internal_cdr_eidle_clk" "internal_clk_2_b" "internal_dw_rm_rd_clk" "internal_dw_rm_wr_clk" "internal_dw_rx_wr_clk" "internal_dw_wa_clk" "internal_rx_pma_clk_gen3" "internal_rx_rcvd_clk_gen3" "internal_rx_rd_clk" "internal_sm_rm_wr_clk" "internal_sw_rm_rd_clk" "internal_sw_rx_wr_clk" "internal_sw_wa_clk"]

   set legal_values [intersect $legal_values [list "internal_sw_wa_clk"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_clock_observation_in_pld_core.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_clock_observation_in_pld_core $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_clock_observation_in_pld_core $hssi_8g_rx_pcs_clock_observation_in_pld_core $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_ctrl_plane_bonding_compensation { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_ctrl_plane_bonding_compensation hssi_8g_rx_pcs_byte_deserializer } {

   set legal_values [list "dis_compensation" "en_compensation"]

   if [expr { ($hssi_8g_rx_pcs_byte_deserializer=="en_bds_by_4") }] {
      set legal_values [intersect $legal_values [list "en_compensation"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_compensation"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_ctrl_plane_bonding_compensation.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_ctrl_plane_bonding_compensation $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_ctrl_plane_bonding_compensation $hssi_8g_rx_pcs_ctrl_plane_bonding_compensation $legal_values { hssi_8g_rx_pcs_byte_deserializer }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_ctrl_plane_bonding_consumption { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_ctrl_plane_bonding_consumption hssi_10g_rx_pcs_prot_mode hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_ctrl_plane_bonding_consumption.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_ctrl_plane_bonding_consumption $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_ctrl_plane_bonding_consumption $hssi_8g_rx_pcs_ctrl_plane_bonding_consumption $legal_values { hssi_10g_rx_pcs_prot_mode hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_ctrl_plane_bonding_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_ctrl_plane_bonding_distribution { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_ctrl_plane_bonding_distribution hssi_8g_rx_pcs_ctrl_plane_bonding_consumption } {

   set legal_values [list "master_chnl_distr" "not_master_chnl_distr"]

   if [expr { ($hssi_8g_rx_pcs_ctrl_plane_bonding_consumption=="bundled_master") }] {
      set legal_values [intersect $legal_values [list "master_chnl_distr"]]
   } else {
      set legal_values [intersect $legal_values [list "not_master_chnl_distr"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_ctrl_plane_bonding_distribution.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_ctrl_plane_bonding_distribution $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_ctrl_plane_bonding_distribution $hssi_8g_rx_pcs_ctrl_plane_bonding_distribution $legal_values { hssi_8g_rx_pcs_ctrl_plane_bonding_consumption }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_eidle_entry_eios { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_eidle_entry_eios hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_eidle_entry_eios.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_eidle_entry_eios $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_eidle_entry_eios $hssi_8g_rx_pcs_eidle_entry_eios $legal_values { hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_eidle_entry_iei { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_eidle_entry_iei hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_eidle_entry_iei.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_eidle_entry_iei $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_eidle_entry_iei $hssi_8g_rx_pcs_eidle_entry_iei $legal_values { hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_eidle_entry_sd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_eidle_entry_sd hssi_8g_rx_pcs_eidle_entry_iei hssi_8g_rx_pcs_hip_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_eidle_entry_sd.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_eidle_entry_sd $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_eidle_entry_sd $hssi_8g_rx_pcs_eidle_entry_sd $legal_values { hssi_8g_rx_pcs_eidle_entry_iei hssi_8g_rx_pcs_hip_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_eightb_tenb_decoder { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_eightb_tenb_encoder hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_eightb_tenb_decoder.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_eightb_tenb_decoder $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_eightb_tenb_decoder $hssi_8g_rx_pcs_eightb_tenb_decoder $legal_values { hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_eightb_tenb_encoder hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_err_flags_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_err_flags_sel hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "err_flags_8b10b" "err_flags_wa"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&($hssi_8g_rx_pcs_eightb_tenb_decoder=="en_8b10b_ibm")) }] {
      set legal_values [intersect $legal_values [list "err_flags_wa" "err_flags_8b10b"]]
   } else {
      set legal_values [intersect $legal_values [list "err_flags_wa"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_err_flags_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_err_flags_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_err_flags_sel $hssi_8g_rx_pcs_err_flags_sel $legal_values { hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_fixed_pat_det { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_fixed_pat_det hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_fixed_pat_det.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_fixed_pat_det $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_fixed_pat_det $hssi_8g_rx_pcs_fixed_pat_det $legal_values { hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_fixed_pat_num { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_fixed_pat_num hssi_8g_rx_pcs_fixed_pat_det } {

   set legal_values [list 0:15]

   if [expr { ($hssi_8g_rx_pcs_fixed_pat_det=="dis_fixed_patdet") }] {
      set legal_values [compare_eq $legal_values 0]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_fixed_pat_num.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_fixed_pat_num $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_fixed_pat_num $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_fixed_pat_num $hssi_8g_rx_pcs_fixed_pat_num $legal_values { hssi_8g_rx_pcs_fixed_pat_det }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_force_signal_detect { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_force_signal_detect } {

   set legal_values [list "dis_force_signal_detect" "en_force_signal_detect"]

   set legal_values [intersect $legal_values [list "en_force_signal_detect"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_force_signal_detect.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_force_signal_detect $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_force_signal_detect $hssi_8g_rx_pcs_force_signal_detect $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_gen3_clk_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_gen3_clk_en hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_gen3_clk_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_gen3_clk_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_gen3_clk_en $hssi_8g_rx_pcs_gen3_clk_en $legal_values { hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_gen3_rx_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_gen3_rx_clk_sel hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_gen3_rx_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_gen3_rx_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_gen3_rx_clk_sel $hssi_8g_rx_pcs_gen3_rx_clk_sel $legal_values { hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_gen3_tx_clk_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_gen3_tx_clk_sel hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_gen3_tx_clk_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_gen3_tx_clk_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_gen3_tx_clk_sel $hssi_8g_rx_pcs_gen3_tx_clk_sel $legal_values { hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_hip_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_hip_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_hip_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_hip_mode $hssi_8g_rx_pcs_hip_mode $legal_values { hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_hip_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_ibm_invalid_code { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_ibm_invalid_code } {

   set legal_values [list "dis_ibm_invalid_code" "en_ibm_invalid_code"]

   set legal_values [intersect $legal_values [list "dis_ibm_invalid_code"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_ibm_invalid_code.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_ibm_invalid_code $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_ibm_invalid_code $hssi_8g_rx_pcs_ibm_invalid_code $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_invalid_code_flag_only { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_invalid_code_flag_only hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_invalid_code_only" "en_invalid_code_only"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "dis_invalid_code_only" "en_invalid_code_only"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_invalid_code_only"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_invalid_code_flag_only.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_invalid_code_flag_only $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_invalid_code_flag_only $hssi_8g_rx_pcs_invalid_code_flag_only $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_pad_or_edb_error_replace { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_pad_or_edb_error_replace hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "replace_edb" "replace_edb_dynamic" "replace_pad"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "replace_edb_dynamic"]]
   } else {
      set legal_values [intersect $legal_values [list "replace_edb"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_pad_or_edb_error_replace.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_pad_or_edb_error_replace $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_pad_or_edb_error_replace $hssi_8g_rx_pcs_pad_or_edb_error_replace $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_pcs_bypass { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_pcs_bypass hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_pcs_bypass.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_pcs_bypass $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_pcs_bypass $hssi_8g_rx_pcs_pcs_bypass $legal_values { hssi_8g_rx_pcs_prot_mode hssi_8g_tx_pcs_pcs_bypass hssi_rx_pld_pcs_interface_hd_8g_channel_operation_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_phase_comp_rdptr { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_phase_comp_rdptr hssi_8g_rx_pcs_phase_compensation_fifo hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "disable_rdptr" "enable_rdptr"]

   if [expr { (($hssi_8g_rx_pcs_prot_mode=="disabled_prot_mode")||($hssi_8g_rx_pcs_phase_compensation_fifo=="register_fifo")) }] {
      set legal_values [intersect $legal_values [list "disable_rdptr"]]
   } else {
      set legal_values [intersect $legal_values [list "enable_rdptr"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_phase_comp_rdptr.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_phase_comp_rdptr $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_phase_comp_rdptr $hssi_8g_rx_pcs_phase_comp_rdptr $legal_values { hssi_8g_rx_pcs_phase_compensation_fifo hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_phase_compensation_fifo { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_phase_compensation_fifo hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_phase_compensation_fifo.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_phase_compensation_fifo $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_phase_compensation_fifo $hssi_8g_rx_pcs_phase_compensation_fifo $legal_values { hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_fifo_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_pipe_if_enable { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_pipe_if_enable hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_pipe_if_enable.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_pipe_if_enable $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_pipe_if_enable $hssi_8g_rx_pcs_pipe_if_enable $legal_values { hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_pma_dw { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_pma_dw.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_pma_dw $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_pma_dw $hssi_8g_rx_pcs_pma_dw $legal_values { hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_pma_dw_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_polinv_8b10b_dec { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_polinv_8b10b_dec hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_polinv_8b10b_dec" "en_polinv_8b10b_dec"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_polinv_8b10b_dec"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_polinv_8b10b_dec"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_polinv_8b10b_dec.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_polinv_8b10b_dec $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_polinv_8b10b_dec $hssi_8g_rx_pcs_polinv_8b10b_dec $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_prot_mode $hssi_8g_rx_pcs_prot_mode $legal_values { hssi_rx_pld_pcs_interface_hd_8g_prot_mode_rx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rate_match { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rate_match hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rate_match.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rate_match $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rate_match $hssi_8g_rx_pcs_rate_match $legal_values { hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rate_match_del_thres { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rate_match_del_thres hssi_8g_rx_pcs_rate_match } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rate_match_del_thres.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rate_match_del_thres $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rate_match_del_thres $hssi_8g_rx_pcs_rate_match_del_thres $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rate_match_empty_thres { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rate_match_empty_thres hssi_8g_rx_pcs_rate_match } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rate_match_empty_thres.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rate_match_empty_thres $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rate_match_empty_thres $hssi_8g_rx_pcs_rate_match_empty_thres $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rate_match_full_thres { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rate_match_full_thres hssi_8g_rx_pcs_rate_match } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rate_match_full_thres.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rate_match_full_thres $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rate_match_full_thres $hssi_8g_rx_pcs_rate_match_full_thres $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rate_match_ins_thres { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rate_match_ins_thres hssi_8g_rx_pcs_rate_match } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rate_match_ins_thres.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rate_match_ins_thres $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rate_match_ins_thres $hssi_8g_rx_pcs_rate_match_ins_thres $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rate_match_start_thres { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rate_match_start_thres hssi_8g_rx_pcs_rate_match } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rate_match_start_thres.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rate_match_start_thres $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rate_match_start_thres $hssi_8g_rx_pcs_rate_match_start_thres $legal_values { hssi_8g_rx_pcs_rate_match }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rx_clk2 { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rx_clk2 hssi_8g_rx_pcs_rate_match hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rx_clk2.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rx_clk2 $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rx_clk2 $hssi_8g_rx_pcs_rx_clk2 $legal_values { hssi_8g_rx_pcs_rate_match hssi_8g_rx_pcs_sup_mode hssi_8g_rx_pcs_tx_rx_parallel_loopback }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rx_clk_free_running { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rx_clk_free_running } {

   set legal_values [list "dis_rx_clk_free_run" "en_rx_clk_free_run"]

   set legal_values [intersect $legal_values [list "en_rx_clk_free_run"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rx_clk_free_running.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rx_clk_free_running $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rx_clk_free_running $hssi_8g_rx_pcs_rx_clk_free_running $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rx_pcs_urst { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rx_pcs_urst } {

   set legal_values [list "dis_rx_pcs_urst" "en_rx_pcs_urst"]

   set legal_values [intersect $legal_values [list "en_rx_pcs_urst"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rx_pcs_urst.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rx_pcs_urst $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rx_pcs_urst $hssi_8g_rx_pcs_rx_pcs_urst $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rx_rcvd_clk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rx_rcvd_clk hssi_8g_rx_pcs_tx_rx_parallel_loopback } {

   set legal_values [list "rcvd_clk_rcvd_clk" "tx_pma_clock_rcvd_clk"]

   if [expr { ($hssi_8g_rx_pcs_tx_rx_parallel_loopback=="en_plpbk") }] {
      set legal_values [intersect $legal_values [list "tx_pma_clock_rcvd_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "rcvd_clk_rcvd_clk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rx_rcvd_clk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rx_rcvd_clk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rx_rcvd_clk $hssi_8g_rx_pcs_rx_rcvd_clk $legal_values { hssi_8g_rx_pcs_tx_rx_parallel_loopback }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rx_rd_clk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rx_rd_clk hssi_8g_rx_pcs_phase_compensation_fifo } {

   set legal_values [list "pld_rx_clk" "rx_clk"]

   if [expr { ($hssi_8g_rx_pcs_phase_compensation_fifo=="register_fifo") }] {
      set legal_values [intersect $legal_values [list "rx_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "pld_rx_clk"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rx_rd_clk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rx_rd_clk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rx_rd_clk $hssi_8g_rx_pcs_rx_rd_clk $legal_values { hssi_8g_rx_pcs_phase_compensation_fifo }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rx_refclk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rx_refclk hssi_8g_rx_pcs_sup_mode } {

   set legal_values [list "dis_refclk_sel" "en_refclk_sel"]

   if [expr { ($hssi_8g_rx_pcs_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "dis_refclk_sel" "en_refclk_sel"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_refclk_sel"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rx_refclk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rx_refclk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rx_refclk $hssi_8g_rx_pcs_rx_refclk $legal_values { hssi_8g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_rx_wr_clk { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_rx_wr_clk hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "rx_clk2_div_1_2_4" "txfifo_rd_clk"]

   if [expr { (($hssi_8g_rx_pcs_hip_mode=="en_hip")||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "txfifo_rd_clk"]]
   } else {
      set legal_values [intersect $legal_values [list "rx_clk2_div_1_2_4"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_rx_wr_clk.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_rx_wr_clk $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_rx_wr_clk $hssi_8g_rx_pcs_rx_wr_clk $legal_values { hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_sup_mode hssi_rx_pld_pcs_interface_hd_8g_sup_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_sup_mode $hssi_8g_rx_pcs_sup_mode $legal_values { hssi_rx_pld_pcs_interface_hd_8g_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_symbol_swap { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_symbol_swap hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_symbol_swap" "en_symbol_swap"]

   if [expr { (((($hssi_8g_rx_pcs_prot_mode=="basic_rm_disable")||($hssi_8g_rx_pcs_prot_mode=="basic_rm_enable"))&&(($hssi_8g_rx_pcs_pma_dw=="sixteen_bit")||($hssi_8g_rx_pcs_pma_dw=="twenty_bit")))&&($hssi_8g_rx_pcs_pcs_bypass=="dis_pcs_bypass")) }] {
      set legal_values [intersect $legal_values [list "dis_symbol_swap" "en_symbol_swap"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_symbol_swap"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_symbol_swap.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_symbol_swap $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_symbol_swap $hssi_8g_rx_pcs_symbol_swap $legal_values { hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_sync_sm_idle_eios { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_sync_sm_idle_eios hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "dis_syncsm_idle" "en_syncsm_idle"]

   if [expr { ((($hssi_8g_rx_pcs_prot_mode=="pipe_g1")||($hssi_8g_rx_pcs_prot_mode=="pipe_g2"))||($hssi_8g_rx_pcs_prot_mode=="pipe_g3")) }] {
      set legal_values [intersect $legal_values [list "en_syncsm_idle"]]
   } else {
      set legal_values [intersect $legal_values [list "dis_syncsm_idle"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_sync_sm_idle_eios.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_sync_sm_idle_eios $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_sync_sm_idle_eios $hssi_8g_rx_pcs_sync_sm_idle_eios $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_test_bus_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_test_bus_sel hssi_8g_rx_pcs_sup_mode } {

   set legal_values [list "pcie_ctrl_testbus" "rm_testbus" "rx_ctrl_plane_testbus" "rx_ctrl_testbus" "tx_ctrl_plane_testbus" "tx_testbus" "wa_testbus"]

   if [expr { ($hssi_8g_rx_pcs_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "tx_testbus"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_test_bus_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_test_bus_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_test_bus_sel $hssi_8g_rx_pcs_test_bus_sel $legal_values { hssi_8g_rx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_tx_rx_parallel_loopback { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_tx_rx_parallel_loopback hssi_rx_pld_pcs_interface_hd_8g_lpbk_en } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_tx_rx_parallel_loopback.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_tx_rx_parallel_loopback $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_tx_rx_parallel_loopback $hssi_8g_rx_pcs_tx_rx_parallel_loopback $legal_values { hssi_rx_pld_pcs_interface_hd_8g_lpbk_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_boundary_lock_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_boundary_lock_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_boundary_lock_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_boundary_lock_ctrl $hssi_8g_rx_pcs_wa_boundary_lock_ctrl $legal_values { hssi_8g_rx_pcs_pcs_bypass hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_clk_slip_spacing { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_clk_slip_spacing hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list 0:1023]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
      set legal_values [compare_ge $legal_values 16]
   } else {
      set legal_values [compare_eq $legal_values 16]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wa_clk_slip_spacing.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wa_clk_slip_spacing $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wa_clk_slip_spacing $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wa_clk_slip_spacing $hssi_8g_rx_pcs_wa_clk_slip_spacing $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_det_latency_sync_status_beh { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_det_latency_sync_status_beh hssi_8g_rx_pcs_prot_mode } {

   set legal_values [list "assert_sync_status_imm" "assert_sync_status_non_imm" "dont_care_assert_sync"]

   if [expr { ($hssi_8g_rx_pcs_prot_mode=="cpri") }] {
      set legal_values [intersect $legal_values [list "assert_sync_status_imm" "assert_sync_status_non_imm"]]
   } else {
      set legal_values [intersect $legal_values [list "dont_care_assert_sync"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_det_latency_sync_status_beh.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $hssi_8g_rx_pcs_wa_det_latency_sync_status_beh $legal_values { hssi_8g_rx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_disp_err_flag { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_disp_err_flag hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_pd hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_disp_err_flag.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_disp_err_flag $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_disp_err_flag $hssi_8g_rx_pcs_wa_disp_err_flag $legal_values { hssi_8g_rx_pcs_eightb_tenb_decoder hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_pd hssi_8g_rx_pcs_wa_sync_sm_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_kchar { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_kchar } {

   set legal_values [list "dis_kchar" "en_kchar"]

   set legal_values [intersect $legal_values [list "dis_kchar"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_kchar.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_kchar $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_kchar $hssi_8g_rx_pcs_wa_kchar $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_pd { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_pd hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_pd.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_pd $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_pd $hssi_8g_rx_pcs_wa_pd $legal_values { hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_pd_data { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_pd_data hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_8g_rx_pcs_wa_pd } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wa_pd_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wa_pd_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wa_pd_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wa_pd_data $hssi_8g_rx_pcs_wa_pd_data $legal_values { hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl hssi_8g_rx_pcs_wa_pd }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_pd_polarity { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_pd_polarity hssi_8g_rx_pcs_pma_dw } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_pd_polarity.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_pd_polarity $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_pd_polarity $hssi_8g_rx_pcs_wa_pd_polarity $legal_values { hssi_8g_rx_pcs_pma_dw }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_pld_controlled { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_pld_controlled hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_pld_controlled.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_pld_controlled $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_pld_controlled $hssi_8g_rx_pcs_wa_pld_controlled $legal_values { hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_wa_boundary_lock_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_renumber_data { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_renumber_data hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:63]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 3]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 16]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wa_renumber_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wa_renumber_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wa_renumber_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wa_renumber_data $hssi_8g_rx_pcs_wa_renumber_data $legal_values { hssi_8g_rx_pcs_wa_sync_sm_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_rgnumber_data { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_rgnumber_data hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:255]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 3]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 15]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wa_rgnumber_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rgnumber_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rgnumber_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wa_rgnumber_data $hssi_8g_rx_pcs_wa_rgnumber_data $legal_values { hssi_8g_rx_pcs_wa_sync_sm_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_rknumber_data { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_rknumber_data hssi_8g_rx_pcs_wa_rosnumber_data hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wa_rknumber_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rknumber_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rknumber_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wa_rknumber_data $hssi_8g_rx_pcs_wa_rknumber_data $legal_values { hssi_8g_rx_pcs_wa_rosnumber_data hssi_8g_rx_pcs_wa_sync_sm_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_rosnumber_data { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_rosnumber_data hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

   set legal_values [list 0:3]

   if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="gige_sync_sm") }] {
      set legal_values [compare_eq $legal_values 1]
   } else {
      if [expr { ($hssi_8g_rx_pcs_wa_sync_sm_ctrl=="pipe_sync_sm") }] {
         set legal_values [compare_eq $legal_values 0]
      }
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wa_rosnumber_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rosnumber_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rosnumber_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wa_rosnumber_data $hssi_8g_rx_pcs_wa_rosnumber_data $legal_values { hssi_8g_rx_pcs_wa_sync_sm_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_rvnumber_data { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_rvnumber_data hssi_8g_rx_pcs_wa_sync_sm_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wa_rvnumber_data.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rvnumber_data $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wa_rvnumber_data $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wa_rvnumber_data $hssi_8g_rx_pcs_wa_rvnumber_data $legal_values { hssi_8g_rx_pcs_wa_sync_sm_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wa_sync_sm_ctrl { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wa_sync_sm_ctrl hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_8g_rx_pcs_wa_sync_sm_ctrl.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_8g_rx_pcs_wa_sync_sm_ctrl $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_8g_rx_pcs_wa_sync_sm_ctrl $hssi_8g_rx_pcs_wa_sync_sm_ctrl $legal_values { hssi_8g_rx_pcs_pma_dw hssi_8g_rx_pcs_prot_mode hssi_8g_rx_pcs_wa_boundary_lock_ctrl }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_8g_rx_pcs_wait_cnt { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_8g_rx_pcs_wait_cnt hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode } {

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

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         set value_range [split_range [lindex $legal_values 0]]
         set min [lindex $value_range 0]
         set max [lindex $value_range 1]

         ip_set "parameter.hssi_8g_rx_pcs_wait_cnt.value" $min
         if { $min != $max && $PROP_M_AUTOWARN } {
            auto_legal_range_warning_message hssi_8g_rx_pcs_wait_cnt $legal_values
         }
      }
      if { $len != 1 && $PROP_M_AUTOWARN } {
         auto_legal_range_warning_message hssi_8g_rx_pcs_wait_cnt $legal_values
      }
   } else {
      auto_value_out_of_range_message auto hssi_8g_rx_pcs_wait_cnt $hssi_8g_rx_pcs_wait_cnt $legal_values { hssi_8g_rx_pcs_hip_mode hssi_8g_rx_pcs_prot_mode }
   }
}

