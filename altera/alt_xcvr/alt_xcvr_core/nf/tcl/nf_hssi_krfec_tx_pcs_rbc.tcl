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


proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_burst_err { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_burst_err hssi_krfec_tx_pcs_prot_mode } {

   set legal_values [list "burst_err_dis" "burst_err_en"]

   if [expr { ($hssi_krfec_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "burst_err_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_burst_err.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_burst_err $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_burst_err $hssi_krfec_tx_pcs_burst_err $legal_values { hssi_krfec_tx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_burst_err_len { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_burst_err_len hssi_krfec_tx_pcs_burst_err } {

   set legal_values [list "burst_err_len1" "burst_err_len10" "burst_err_len11" "burst_err_len12" "burst_err_len13" "burst_err_len14" "burst_err_len15" "burst_err_len16" "burst_err_len2" "burst_err_len3" "burst_err_len4" "burst_err_len5" "burst_err_len6" "burst_err_len7" "burst_err_len8" "burst_err_len9"]

   if [expr { ($hssi_krfec_tx_pcs_burst_err=="burst_err_dis") }] {
      set legal_values [intersect $legal_values [list "burst_err_len1"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_burst_err_len.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_burst_err_len $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_burst_err_len $hssi_krfec_tx_pcs_burst_err_len $legal_values { hssi_krfec_tx_pcs_burst_err }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_ctrl_bit_reverse { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_ctrl_bit_reverse } {

   set legal_values [list "ctrl_bit_reverse_dis" "ctrl_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_ctrl_bit_reverse.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_ctrl_bit_reverse $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_ctrl_bit_reverse $hssi_krfec_tx_pcs_ctrl_bit_reverse $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_data_bit_reverse { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_data_bit_reverse } {

   set legal_values [list "data_bit_reverse_dis" "data_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_data_bit_reverse.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_data_bit_reverse $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_data_bit_reverse $hssi_krfec_tx_pcs_data_bit_reverse $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_enc_frame_query { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_enc_frame_query hssi_krfec_tx_pcs_prot_mode } {

   set legal_values [list "enc_query_dis" "enc_query_en"]

   if [expr { ($hssi_krfec_tx_pcs_prot_mode=="teng_1588_basekr_mode") }] {
      set legal_values [intersect $legal_values [list "enc_query_dis" "enc_query_en"]]
   } else {
      set legal_values [intersect $legal_values [list "enc_query_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_enc_frame_query.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_enc_frame_query $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_enc_frame_query $hssi_krfec_tx_pcs_enc_frame_query $legal_values { hssi_krfec_tx_pcs_prot_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_low_latency_en { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_low_latency_en hssi_krfec_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_krfec_low_latency_en_tx } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_low_latency_en_tx=="disable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_low_latency_en_tx=="enable") }] {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_low_latency_en.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_low_latency_en $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_low_latency_en $hssi_krfec_tx_pcs_low_latency_en $legal_values { hssi_krfec_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_krfec_low_latency_en_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_pipeln_encoder { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_pipeln_encoder } {

   set legal_values [list "disable" "enable"]

   set legal_values [intersect $legal_values [list "enable"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_pipeln_encoder.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_pipeln_encoder $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_pipeln_encoder $hssi_krfec_tx_pcs_pipeln_encoder $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_pipeln_scrambler { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_pipeln_scrambler hssi_krfec_tx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_tx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_pipeln_scrambler.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_pipeln_scrambler $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_pipeln_scrambler $hssi_krfec_tx_pcs_pipeln_scrambler $legal_values { hssi_krfec_tx_pcs_low_latency_en }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_prot_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_prot_mode hssi_krfec_tx_pcs_sup_mode hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx } {

   set legal_values [list "basic_mode" "disable_mode" "fortyg_basekr_mode" "teng_1588_basekr_mode" "teng_basekr_mode"]

   if [expr { ($hssi_krfec_tx_pcs_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "disable_mode" "teng_basekr_mode" "fortyg_basekr_mode" "teng_1588_basekr_mode" "basic_mode"]]
   } else {
      set legal_values [intersect $legal_values [list "disable_mode" "teng_basekr_mode" "fortyg_basekr_mode" "basic_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="teng_basekr_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_basekr_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="fortyg_basekr_mode_tx") }] {
      set legal_values [intersect $legal_values [list "fortyg_basekr_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="basic_mode_tx") }] {
      set legal_values [intersect $legal_values [list "basic_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="teng_1588_basekr_mode_tx") }] {
      set legal_values [intersect $legal_values [list "teng_1588_basekr_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx=="disabled_prot_mode_tx") }] {
      set legal_values [intersect $legal_values [list "disable_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_prot_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_prot_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_prot_mode $hssi_krfec_tx_pcs_prot_mode $legal_values { hssi_krfec_tx_pcs_sup_mode hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_sup_mode { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_sup_mode hssi_tx_pld_pcs_interface_hd_krfec_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_sup_mode.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_sup_mode $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_sup_mode $hssi_krfec_tx_pcs_sup_mode $legal_values { hssi_tx_pld_pcs_interface_hd_krfec_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_transcode_err { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_transcode_err hssi_krfec_tx_pcs_prot_mode hssi_krfec_tx_pcs_sup_mode } {

   set legal_values [list "trans_err_dis" "trans_err_en"]

   if [expr { (($hssi_krfec_tx_pcs_sup_mode=="engineering_mode")&&($hssi_krfec_tx_pcs_prot_mode!="disable_mode")) }] {
      set legal_values [intersect $legal_values [list "trans_err_dis" "trans_err_en"]]
   } else {
      set legal_values [intersect $legal_values [list "trans_err_dis"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_transcode_err.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_transcode_err $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_transcode_err $hssi_krfec_tx_pcs_transcode_err $legal_values { hssi_krfec_tx_pcs_prot_mode hssi_krfec_tx_pcs_sup_mode }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_transmit_order { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_transmit_order } {

   set legal_values [list "transmit_lsb" "transmit_msb"]

   set legal_values [intersect $legal_values [list "transmit_lsb"]]

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_transmit_order.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_transmit_order $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_transmit_order $hssi_krfec_tx_pcs_transmit_order $legal_values { }
   }
}

proc ::nf_xcvr_native::parameters::validate_hssi_krfec_tx_pcs_tx_testbus_sel { PROP_M_AUTOSET PROP_M_AUTOWARN device_revision hssi_krfec_tx_pcs_tx_testbus_sel hssi_krfec_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode } {

   set legal_values [list "encoder1" "encoder2" "gearbox" "overall" "scramble1" "scramble2" "scramble3"]

   if [expr { ($hssi_krfec_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode=="rx") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }

   if { $PROP_M_AUTOSET } {
      set len [llength $legal_values]
      if { $len > 0 } {
         ip_set "parameter.hssi_krfec_tx_pcs_tx_testbus_sel.value" [lindex $legal_values 0]
      }
      if { $len != 1 && $PROP_M_AUTOWARN} {
         auto_legal_value_warning_message hssi_krfec_tx_pcs_tx_testbus_sel $legal_values
      }
   } else {
      auto_invalid_value_message auto hssi_krfec_tx_pcs_tx_testbus_sel $hssi_krfec_tx_pcs_tx_testbus_sel $legal_values { hssi_krfec_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode }
   }
}

