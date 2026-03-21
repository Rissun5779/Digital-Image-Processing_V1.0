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


proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_burst_err { device_revision hssi_krfec_tx_pcs_prot_mode } {

   set legal_values [list "burst_err_dis" "burst_err_en"]

   if [expr { ($hssi_krfec_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "burst_err_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_burst_err_len { device_revision hssi_krfec_tx_pcs_burst_err } {

   set legal_values [list "burst_err_len1" "burst_err_len10" "burst_err_len11" "burst_err_len12" "burst_err_len13" "burst_err_len14" "burst_err_len15" "burst_err_len16" "burst_err_len2" "burst_err_len3" "burst_err_len4" "burst_err_len5" "burst_err_len6" "burst_err_len7" "burst_err_len8" "burst_err_len9"]

   if [expr { ($hssi_krfec_tx_pcs_burst_err=="burst_err_dis") }] {
      set legal_values [intersect $legal_values [list "burst_err_len1"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_ctrl_bit_reverse { device_revision } {

   set legal_values [list "ctrl_bit_reverse_dis" "ctrl_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "ctrl_bit_reverse_en"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_data_bit_reverse { device_revision } {

   set legal_values [list "data_bit_reverse_dis" "data_bit_reverse_en"]

   set legal_values [intersect $legal_values [list "data_bit_reverse_dis"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_enc_frame_query { device_revision hssi_krfec_tx_pcs_prot_mode } {

   set legal_values [list "enc_query_dis" "enc_query_en"]

   if [expr { ($hssi_krfec_tx_pcs_prot_mode=="teng_1588_basekr_mode") }] {
      set legal_values [intersect $legal_values [list "enc_query_dis" "enc_query_en"]]
   } else {
      set legal_values [intersect $legal_values [list "enc_query_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_low_latency_en { device_revision hssi_krfec_tx_pcs_prot_mode hssi_tx_pld_pcs_interface_hd_krfec_low_latency_en_tx } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_pipeln_encoder { device_revision } {

   set legal_values [list "disable" "enable"]

   set legal_values [intersect $legal_values [list "enable"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_pipeln_scrambler { device_revision hssi_krfec_tx_pcs_low_latency_en } {

   set legal_values [list "disable" "enable"]

   if [expr { ($hssi_krfec_tx_pcs_low_latency_en=="enable") }] {
      set legal_values [intersect $legal_values [list "disable"]]
   } else {
      set legal_values [intersect $legal_values [list "enable"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_prot_mode { device_revision hssi_krfec_tx_pcs_sup_mode hssi_tx_pld_pcs_interface_hd_krfec_prot_mode_tx } {

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

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_sup_mode { device_revision hssi_tx_pld_pcs_interface_hd_krfec_sup_mode } {

   set legal_values [list "engineering_mode" "user_mode"]

   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_sup_mode=="user_mode") }] {
      set legal_values [intersect $legal_values [list "user_mode"]]
   }
   if [expr { ($hssi_tx_pld_pcs_interface_hd_krfec_sup_mode=="engineering_mode") }] {
      set legal_values [intersect $legal_values [list "engineering_mode"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_transcode_err { device_revision hssi_krfec_tx_pcs_prot_mode hssi_krfec_tx_pcs_sup_mode } {

   set legal_values [list "trans_err_dis" "trans_err_en"]

   if [expr { (($hssi_krfec_tx_pcs_sup_mode=="engineering_mode")&&($hssi_krfec_tx_pcs_prot_mode!="disable_mode")) }] {
      set legal_values [intersect $legal_values [list "trans_err_dis" "trans_err_en"]]
   } else {
      set legal_values [intersect $legal_values [list "trans_err_dis"]]
   }

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_transmit_order { device_revision } {

   set legal_values [list "transmit_lsb" "transmit_msb"]

   set legal_values [intersect $legal_values [list "transmit_lsb"]]

   return $legal_values
}

proc ::nf_xcvr_native::parameters::getValue_hssi_krfec_tx_pcs_tx_testbus_sel { device_revision hssi_krfec_tx_pcs_prot_mode hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode } {

   set legal_values [list "encoder1" "encoder2" "gearbox" "overall" "scramble1" "scramble2" "scramble3"]

   if [expr { ($hssi_krfec_tx_pcs_prot_mode=="disable_mode") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }
   if [expr { ($hssi_rx_pld_pcs_interface_hd_krfec_test_bus_mode=="rx") }] {
      set legal_values [intersect $legal_values [list "overall"]]
   }

   return $legal_values
}

